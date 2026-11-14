# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project
"""Native BF16 x BF16 (A16W16) WMMA operands over row-major weights on gfx1201 (Wave32).

On gfx1201 (RDNA 4):
- Wavefront width is 32 lanes (Wave32).
- Matrix multiply uses `v_wmma_f32_16x16x16_bf16` (8 FP32 accumulators per lane).
- Each 16-row x 64-K sub-tile is 2048 bytes (512 dwords = 1024 BF16 elements).
- Across 32 lanes, each lane loads 64 bytes (16 dwords = 32 BF16 elements) via four
  128-bit (`vec_width=4`, `i32`) non-temporal VBUFFER loads, feeding four consecutive
  16x16x16 WMMA instructions per 64-wide K step.
"""

from __future__ import annotations

import flydsl.compiler as fx
from flydsl.compiler import T
from flydsl.expr import buffer_ops as bo
from flydsl.expr import rocdl
from flydsl.utils import range_constexpr

WAVE_SIZE = 32
STEP_K = 64  # Four 16x16x16 WMMA K-steps per 64-element tile
TH_NT = 3  # RDNA 4 temporal hint: streaming / non-temporal L1/L2 bypass


def rsrc(ptr):
    """Build an AMD VBUFFER resource descriptor from a raw device pointer."""
    return bo.create_buffer_resource(ptr)


def wmma_bf16(a_vec, b_vec, acc):
    """gfx1201 Wave32 16x16x16 BF16 -> FP32 WMMA intrinsic."""
    return fx.Vector(
        rocdl.wmma_f32_16x16x16_bf16(
            T.vec(8, T.f32),
            a_vec.ir_value(),
            b_vec.ir_value(),
            acc.ir_value(),
            False,
        )
    )


def weight_loads_bf16(w_i32_ptr, row_group: int, k: int, step_idx: int, th: int = TH_NT):
    """Load Wave32 lane's 64-byte slice (4 x 128-bit words) for a 16x64 BF16 weight tile.

    Weights are standard row-major `[N, K]` BF16 viewed as `[N, K // 2]` `int32`:
      - `lane % 16` selects the output row within `row_group` (0..15).
      - `lane // 16` selects the K-half (0: K=0..31, 1: K=32..63).
      - Each 128-bit load (`vec_width=4` i32) fetches 8 contiguous BF16 elements (16 bytes).
    """
    lane = fx.thread_idx.x % WAVE_SIZE
    row = row_group * 16 + (lane % 16)
    k_half = lane // 16
    k_dwords = k // 2

    # Offset in int32 dwords: row * (K / 2) + step_idx * 32 + k_half * 16
    base_dword = row * k_dwords + step_idx * (STEP_K // 2) + k_half * 16
    w_r = rsrc(w_i32_ptr)

    return [
        fx.Vector(
            bo.buffer_load(
                w_r,
                base_dword + d * 4,
                vec_width=4,
                dtype=T.i32,
                cache_modifier=th,
            )
        )
        for d in range_constexpr(4)
    ]


def step_wmma_bf16(acc, w_vecs, x_vecs):
    """Accumulate `acc += W_tile * X_tile` over one 64-wide K step (four 16x16x16 WMMAs)."""
    for d in range_constexpr(4):
        a = w_vecs[d].bitcast(fx.BFloat16)
        b = x_vecs[d].bitcast(fx.BFloat16)
        acc = wmma_bf16(a, b, acc)
    return acc
