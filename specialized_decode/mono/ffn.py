# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project
"""Persistent gfx1201 FlyDSL kernel for Qwen3.8-27B TP1 BF16 dense SwiGLU FFN.

Executes in a single persistent launch across 64 CUs (32 WGPs):
  1. Residual add:        res = residual + attn_out
  2. Gemma-style RMSNorm: x_norm = rmsnorm(res) * (1.0 + post_norm_w)
  3. Gate + Up BF16:      1088 16-row groups / 64 CTAs = 17 paired groups per CTA
  4. SwiGLU + barrier:    act_mid = silu(gate) * up -> scratch + grid_barrier
  5. Down BF16:           320 16-row groups / 64 CTAs = 5 groups per CTA -> out
"""

from __future__ import annotations

from dataclasses import dataclass

import flydsl.compiler as fx
from flydsl.compiler import T
from flydsl.expr import buffer_ops as bo
from flydsl.expr import rocdl
from flydsl.utils import range_constexpr

from .a16w16 import STEP_K, WAVE_SIZE, rsrc, step_wmma_bf16, weight_loads_bf16
from .sync import EPOCH_WORDS, ERROR_BYTES, grid_barrier

HIDDEN = 5120
INTERMEDIATE = 17408
BLOCKS = 64  # gfx1201 (Navi 48): 64 CUs (32 WGPs), 1 CTA per CU
THREADS = 128  # 4 Wave32 waves per CTA
WAVES = THREADS // WAVE_SIZE

GATE_ROW_GROUPS = INTERMEDIATE // 16  # 1088 -> exact 17 per CTA across 64 CTAs
DOWN_ROW_GROUPS = HIDDEN // 16  # 320  -> exact 5 per CTA across 64 CTAs
GATE_GROUPS_PER_CTA = GATE_ROW_GROUPS // BLOCKS  # 17
DOWN_GROUPS_PER_CTA = DOWN_ROW_GROUPS // BLOCKS  # 5


@dataclass(frozen=True)
class FfnBuild:
    """Compiled persistent BF16 dense FFN kernel artifact for a fixed `max_rows` width."""

    max_rows: int
    name: str
    compiled: object
    blocks: int = BLOCKS
    threads: int = THREADS


def kernel_name(max_rows: int) -> str:
    return f"qwen3_5_27b_tp1_gfx1201_bf16_dense_ffn_r{max_rows}"


def scratch_layout(max_rows: int) -> dict[str, tuple[int, int]]:
    """Byte (offset, size) layout of the per-width device scratch buffer."""
    x_norm_bytes = max_rows * HIDDEN * 2  # BF16 [max_rows, 5120]
    act_mid_bytes = max_rows * INTERMEDIATE * 2  # BF16 [max_rows, 17408]
    barrier_bytes = 64
    epoch_bytes = EPOCH_WORDS * 4
    fault_bytes = ERROR_BYTES

    off_x_norm = 0
    off_act_mid = off_x_norm + x_norm_bytes
    off_barrier = (off_act_mid + act_mid_bytes + 63) & ~63
    off_epoch = off_barrier + barrier_bytes
    off_fault = off_epoch + epoch_bytes
    total = (off_fault + fault_bytes + 63) & ~63

    return {
        "x_norm": (off_x_norm, x_norm_bytes),
        "act_mid": (off_act_mid, act_mid_bytes),
        "barrier": (off_barrier, barrier_bytes),
        "epoch": (off_epoch, epoch_bytes),
        "fault": (off_fault, fault_bytes),
        "total": (0, total),
    }


def scratch_bytes(max_rows: int) -> int:
    return scratch_layout(max_rows)["total"]


def build_ffn(max_rows: int, eps: float = 1e-6) -> FfnBuild:
    """Compile the gfx1201 persistent BF16 dense SwiGLU FFN kernel for `max_rows` (<= 16)."""
    if not (1 <= max_rows <= 16):
        raise ValueError(f"max_rows must be in, got {max_rows}")

    name = kernel_name(max_rows)
    layout = scratch_layout(max_rows)
    off_x_norm_bf16 = layout["x_norm"] // 2
    off_act_mid_bf16 = layout["act_mid"] // 2
    off_x_norm_i32 = layout["x_norm"] // 4
    off_act_mid_i32 = layout["act_mid"] // 4
    off_barrier = layout["barrier"] // 4
    off_fault = layout["fault"] // 4

    @fx.kernel(name=name)
    def dense_ffn_bf16_kernel(
        attn_out_ptr: fx.Pointer[T.bf16],
        residual_ptr: fx.Pointer[T.bf16],
        post_norm_w_ptr: fx.Pointer[T.bf16],
        w13_ptr: fx.Pointer[T.i32],
        w2_ptr: fx.Pointer[T.i32],
        out_ptr: fx.Pointer[T.bf16],
        res_out_ptr: fx.Pointer[T.bf16],
        scratch_ptr: fx.Pointer[T.i32],
        num_rows: fx.Int32,
        epoch_tag: fx.Int32,
    ):
        bid = fx.block_idx.x
        tid = fx.thread_idx.x
        wid = tid // WAVE_SIZE
        lane = tid % WAVE_SIZE

        attn_r = rsrc(attn_out_ptr)
        res_r = rsrc(residual_ptr)
        nw_r = rsrc(post_norm_w_ptr)
        out_r = rsrc(out_ptr)
        res_out_r = rsrc(res_out_ptr)
        scratch_bf16_r = rsrc(scratch_ptr.bitcast(T.bf16))
        scratch_i32_r = rsrc(scratch_ptr)

        barrier_ptr = scratch_ptr + off_barrier
        fault_ptr = scratch_ptr + off_fault

        # ------------------------------------------------------------------
        # Stage 1: Residual add + Gemma-style (1 + w) RMSNorm
        # ------------------------------------------------------------------
        if bid == 0:
            lds_red = fx.shared_memory(T.f32, size=WAVES)
            for r in range(max_rows):
                if r < num_rows:
                    row_off = r * HIDDEN
                    sq_sum = fx.Float32(0.0)
                    for idx in range(tid, HIDDEN, THREADS):
                        a_val = bo.buffer_load(attn_r, row_off + idx, vec_width=1, dtype=T.bf16)
                        r_val = bo.buffer_load(res_r, row_off + idx, vec_width=1, dtype=T.bf16)
                        sum_f32 = a_val.cast(T.f32) + r_val.cast(T.f32)
                        bo.buffer_store(
                            sum_f32.cast(T.bf16), res_out_r, row_off + idx, dtype=T.bf16
                        )
                        sq_sum = sq_sum + sum_f32 * sum_f32

                    for offset in (16, 8, 4, 2, 1):
                        sq_sum = sq_sum + rocdl.ds_swizzle(sq_sum, offset)
                    if lane == 0:
                        lds_red[wid] = sq_sum
                    fx.gpu.barrier()

                    if tid == 0:
                        tot = fx.Float32(0.0)
                        for w_i in range_constexpr(WAVES):
                            tot = tot + lds_red[w_i]
                        lds_red = rocdl.rsq(tot / fx.Float32(HIDDEN) + fx.Float32(eps))
                    fx.gpu.barrier()

                    inv_rms = lds_red
                    for idx in range(tid, HIDDEN, THREADS):
                        res_v = bo.buffer_load(
                            res_out_r, row_off + idx, vec_width=1, dtype=T.bf16
                        ).cast(T.f32)
                        nw_v = bo.buffer_load(nw_r, idx, vec_width=1, dtype=T.bf16).cast(T.f32)
                        normed = res_v * inv_rms * (fx.Float32(1.0) + nw_v)
                        bo.buffer_store(
                            normed.cast(T.bf16),
                            scratch_bf16_r,
                            off_x_norm_bf16 + row_off + idx,
                            dtype=T.bf16,
                        )
                    fx.gpu.barrier()

        grid_barrier(barrier_ptr, fault_ptr, BLOCKS, epoch_tag, site_code=1)

        # ------------------------------------------------------------------
        # Stage 2: Gate + Up BF16 GEMM + SwiGLU -> scratch act_mid
        # 17 paired (gate, up) 16-row groups per CTA across 64 CUs
        # ------------------------------------------------------------------
        k_steps_13 = HIDDEN // STEP_K  # 5120 / 64 = 80 steps
        hidden_dwords = HIDDEN // 2

        for local_g in range_constexpr(GATE_GROUPS_PER_CTA):
            rg_gate = bid * GATE_GROUPS_PER_CTA + local_g
            rg_up = GATE_ROW_GROUPS + rg_gate
            acc_gate = fx.Vector.splat(8, fx.Float32(0.0))
            acc_up = fx.Vector.splat(8, fx.Float32(0.0))

            for st in range(k_steps_13):
                wg = weight_loads_bf16(w13_ptr, rg_gate, HIDDEN, st)
                wu = weight_loads_bf16(w13_ptr, rg_up, HIDDEN, st)

                # Load activation tile [16 rows x 64 K] (32 dwords per row)
                col = lane % 16
                k_half = lane // 16
                xs = []
                for d in range_constexpr(4):
                    dword_off = st * 32 + k_half * 16 + d * 4
                    x_elem = fx.where(
                        col < num_rows,
                        bo.buffer_load(
                            scratch_i32_r,
                            off_x_norm_i32 + col * hidden_dwords + dword_off,
                            vec_width=4,
                            dtype=T.i32,
                        ),
                        fx.Vector.splat(4, fx.Int32(0)),
                    )
                    xs.append(x_elem)

                acc_gate = step_wmma_bf16(acc_gate, wg, xs)
                acc_up = step_wmma_bf16(acc_up, wu, xs)

            for i in range_constexpr(8):
                row_idx = (lane // 16) * 8 + i
                col_idx = rg_gate * 16 + (lane % 16)
                if row_idx < num_rows:
                    g_val = acc_gate[i]
                    u_val = acc_up[i]
                    sig = fx.Float32(1.0) / (fx.Float32(1.0) + rocdl.exp(-g_val))
                    act = (g_val * sig * u_val).cast(T.bf16)
                    bo.buffer_store(
                        act,
                        scratch_bf16_r,
                        off_act_mid_bf16 + row_idx * INTERMEDIATE + col_idx,
                        dtype=T.bf16,
                    )

        grid_barrier(barrier_ptr, fault_ptr, BLOCKS, epoch_tag, site_code=2)

        # ------------------------------------------------------------------
        # Stage 3: Down BF16 GEMM -> out_ptr
        # 5 output 16-row groups per CTA across 64 CUs
        # ------------------------------------------------------------------
        k_steps_2 = INTERMEDIATE // STEP_K  # 17408 / 64 = 272 steps
        inter_dwords = INTERMEDIATE // 2

        for local_g in range_constexpr(DOWN_GROUPS_PER_CTA):
            rg_down = bid * DOWN_GROUPS_PER_CTA + local_g
            acc_down = fx.Vector.splat(8, fx.Float32(0.0))

            for st in range(k_steps_2):
                wd = weight_loads_bf16(w2_ptr, rg_down, INTERMEDIATE, st)

                col = lane % 16
                k_half = lane // 16
                xs = []
                for d in range_constexpr(4):
                    dword_off = st * 32 + k_half * 16 + d * 4
                    x_elem = fx.where(
                          col < num_rows,
                          bo.buffer_load(
                                 scratch_i32_r,
                                 off_act_mid_i32 + col * inter_dwords + dword_off,
                                 vec_width=4,
                                 dtype=T.i32,
                          ),
                          fx.Vector.splat(4, fx.Int32(0)),
                    )
                xs.append(x_elem)
                acc_down = step_wmma_bf16(acc_down, wd, xs)
                for i in range_constexpr(8):
                     row_idx = (lane // 16) * 8 + i
                     col_idx = rg_down * 16 + (lane % 16)
                     if row_idx < num_rows:
                          bo.buffer_store(
                                 acc_down[i].cast(T.bf16),
                                 out_r,
                                 row_idx * HIDDEN + col_idx,
                                 dtype=T.bf16,
                          )
                     if (bid == 0) & (tid == 0):
                          bo.buffer_store(fx.Int32(0), rsrc(barrier_ptr), fx.Int32(0), dtype=T.i32)
                          compiled = fx.compile(dense_ffn_bf16_kernel, target="gfx1201")
        return FfnBuild(max_rows=max_rows, name=name, compiled=compiled)
