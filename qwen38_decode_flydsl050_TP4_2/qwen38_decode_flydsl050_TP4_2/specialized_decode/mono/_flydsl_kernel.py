"""FlyDSL 0.5.0 device code. Import only after selecting the gfx1201 target.

The SSA atom call follows ROCm/FlyDSL v0.5.0's RDNA4 WMMA tests. The
ASTRewriter helper boundary follows vLLM's specialized_decode reference.
Both are deliberately version-pinned; no HIP/C++ extension is generated.

The intermediate dimension is rank-local (I/TP). Residual inputs are replicated; attention is reduced through IPC in partial
mode. The output is this rank's BF16 down-projection partial; its SUM is
performed by the host runner through the TP collective.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
from flydsl._mlir.dialects import fly
from flydsl.compiler.ast_rewriter import ASTRewriter
from flydsl.expr import math as fmath
from ._peer_kernel import acquire, release, flag_ptr, data_ptr, peer_phase
from .peer_layout import READY, DONE, EPOCH, FAILED


def wmma(atom, a, b, c):
    return fx.Vector(fly.mma_atom_call_ssa(
        [fx.Vector.make_type(8, fx.Float32)], atom,
        a.ir_value(), b.ir_value(), c.ir_value()))


@ASTRewriter.transform
def grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, site):
    # Every writer releases, not just the CTA's arrival-counter thread.
    fx.memory_fence(syncscope="agent", ordering=fx.AtomicOrdering.Release)
    fx.gpu.barrier()
    if tid == 0:
        generation = fx.generic_load(control + 1, memory_order=fx.AtomicOrdering.Acquire,
                                     syncscope="agent")
        ticket = fx.atomic_add(control, fx.Uint32(1), syncscope="agent",
                               ordering=fx.AtomicOrdering.AcqRel)
        if ticket == fx.Uint32(blocks - 1):
            fx.generic_store(control, fx.Uint32(0),
                             memory_order=fx.AtomicOrdering.Monotonic, syncscope="agent")
            fx.generic_store(control + 1, generation + fx.Uint32(1),
                             memory_order=fx.AtomicOrdering.Release, syncscope="agent")
        else:
            spins = fx.Int32(0)
            waiting = fx.Int32(1)
            while (waiting != 0) & (spins < max_spins):
                observed = fx.generic_load(control + 1,
                                           memory_order=fx.AtomicOrdering.Acquire,
                                           syncscope="agent")
                failed = fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                                         syncscope="agent")
                waiting = fx.Int32((observed == generation) & (failed == 0))
                spins = spins + 1
            if waiting != 0:
                old, won = fx.atomic_cas(fault, fx.Uint32(0), fx.Uint32(1),
                                        syncscope="agent",
                                        success_ordering=fx.AtomicOrdering.AcqRel,
                                        failure_ordering=fx.AtomicOrdering.Acquire)
                if won:
                    fx.generic_store(fault + 1, fx.Uint32(site))
                    fx.generic_store(fault + 2, bid.to(fx.Uint32))
                    fx.generic_store(fault + 3, generation)
        failed = fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                                 syncscope="agent")
        fx.ptr_store(fx.Int32(failed == 0), ok)
    fx.gpu.barrier()
    fx.memory_fence(syncscope="agent", ordering=fx.AtomicOrdering.Acquire)


@ASTRewriter.transform
def scaled_attention(value, col, scale, has_scale):
    if has_scale != 0:
        # Stock semantics: BF16(scale), BF16(1 + scale), BF16(attention * factor).
        factor = (fx.generic_load(scale + col).to(fx.Float32) + 1.0).to(fx.BFloat16).to(fx.Float32)
        value = (value * factor).to(fx.BFloat16).to(fx.Float32)
    return value


@ASTRewriter.transform
def reduce_attention(a, reduced, peers, scale, has_scale, control, fault, ok,
                     tid, bid, rows, hidden, blocks, max_spins, tp, rank):
    own = fx.generic_load(peers + rank)
    epoch = acquire(flag_ptr(own, EPOCH)) + fx.Uint32(1)
    published = data_ptr(own)
    for index in range(bid * 128 + tid, rows * hidden, blocks * 128):
        fx.generic_store(published + index, fx.generic_load(a + index))
    # All writers complete system-visible stores before READY publication.
    fx.memory_fence(syncscope=fx.SyncScope.System, ordering=fx.AtomicOrdering.Release)
    grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, 3)
    if fx.ptr_load(ok) != 0:
        if (bid == 0) & (tid == 0):
            peer_phase(peers, own, epoch, fault, tp, READY, max_spins, 10)
        grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, 4)
        fx.memory_fence(syncscope=fx.SyncScope.System, ordering=fx.AtomicOrdering.Acquire)
        if fx.ptr_load(ok) != 0:
            for index in range(bid * 128 + tid, rows * hidden, blocks * 128):
                total = fx.Float32(0.0)
                for peer in fx.range_constexpr(tp):
                    remote = data_ptr(fx.generic_load(peers + peer))
                    total = total + fx.generic_load(remote + index).to(fx.Float32)
                value = total.to(fx.BFloat16).to(fx.Float32)
                value = scaled_attention(value, index % hidden, scale, has_scale)
                fx.generic_store(reduced + index, value.to(fx.BFloat16))
            # Retire every thread's peer reads before declaring DONE.
            fx.memory_fence(syncscope=fx.SyncScope.System, ordering=fx.AtomicOrdering.AcqRel)
            grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, 5)
            if fx.ptr_load(ok) != 0:
                if (bid == 0) & (tid == 0):
                    peer_phase(peers, own, epoch, fault, tp, DONE, max_spins, 11)
                    if fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                                       syncscope="agent") == 0:
                        release(flag_ptr(own, EPOCH), epoch)
                grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, 6)


def make_launcher(hidden, intermediate, blocks, tp=1, rank=0, attention_partial=False):
    peer_mode = attention_partial and tp > 1
    @fx.struct
    class Lds:
        red: fx.Array[fx.Float32, 4, 4]
        inv: fx.Array[fx.Float32, 1, 4]
        ok: fx.Array[fx.Int32, 1, 4]

    @flyc.kernel(name=f"qwen_bf16_h{hidden}_i{intermediate}_b{blocks}_tp{tp}r{rank}_a{int(attention_partial)}",
                 known_block_size=[128, 1, 1])
    def ffn(a: fx.Pointer, residual: fx.Pointer, norm: fx.Pointer,
            w13: fx.Pointer, w2: fx.Pointer, out: fx.Pointer,
            resout: fx.Pointer, scratch: fx.Pointer, control: fx.Pointer,
            fault: fx.Pointer, peers: fx.Pointer, attn_scale: fx.Pointer,
            rows: fx.Int32, eps: fx.Float32,
            max_spins: fx.Int32, drop_cta: fx.Int32, has_attn_scale: fx.Int32):
        # rows=0 is a no-dereference warmup launch to initialize the runtime.
        if rows > 0:
            tid = fx.thread_idx.x
            bid = fx.block_idx.x
            lane = tid % 32
            wave = tid // 32
            lds = fx.SharedAllocator().allocate(Lds).peek()
            if tid == 0:
                failed = fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                                         syncscope="agent")
                fx.ptr_store(fx.Int32((failed == 0) & (bid != drop_cta)), lds.ok.ptr)
            fx.gpu.barrier()
            if fx.ptr_load(lds.ok.ptr) != 0:
                xnorm = scratch
                mid = scratch + 16 * hidden
                attention = a
                if fx.const_expr(peer_mode):
                    attention = scratch + 16 * (hidden + intermediate)
                    reduce_attention(a, attention, peers, attn_scale, has_attn_scale,
                                     control, fault, lds.ok.ptr, tid, bid, rows,
                                     hidden, blocks, max_spins, tp, rank)
                if fx.ptr_load(lds.ok.ptr) != 0:
                    for row in range(bid, rows, blocks):
                        ssq = fx.Float32(0.0)
                        for col in range(tid, hidden, 128):
                            offset = row * hidden + col
                            attention_value = fx.generic_load(attention + offset).to(fx.Float32)
                            if fx.const_expr(not peer_mode):
                                attention_value = scaled_attention(attention_value, col, attn_scale, has_attn_scale)
                            summed = attention_value + fx.generic_load(residual + offset).to(fx.Float32)
                            fx.generic_store(resout + offset, summed.to(fx.BFloat16))
                            ssq = ssq + summed * summed
                        for delta in fx.range_constexpr(5):
                            ssq = ssq + fx.gpu.shuffle_down(ssq, 16 >> delta, 32)
                        if lane == 0:
                            fx.ptr_store(ssq, lds.red.ptr + wave)
                        fx.gpu.barrier()
                        if tid == 0:
                            total = fx.Float32(0.0)
                            for j in fx.range_constexpr(4):
                                total = total + fx.ptr_load(lds.red.ptr + j)
                            fx.ptr_store(fmath.rsqrt(total / hidden + eps), lds.inv.ptr)
                        fx.gpu.barrier()
                        inv = fx.ptr_load(lds.inv.ptr)
                        for col in range(tid, hidden, 128):
                            offset = row * hidden + col
                            attention_value = fx.generic_load(attention + offset).to(fx.Float32)
                            if fx.const_expr(not peer_mode):
                                attention_value = scaled_attention(attention_value, col, attn_scale, has_attn_scale)
                            summed = attention_value + fx.generic_load(residual + offset).to(fx.Float32)
                            scale = fx.generic_load(norm + col).to(fx.Float32) + 1.0
                            fx.generic_store(xnorm + offset,
                                             ((summed * inv) * scale).to(fx.BFloat16))
                        # Keep lds.inv alive until every thread finishes this row.
                        fx.gpu.barrier()

                    grid_barrier(control, fault, lds.ok.ptr, tid, bid,
                                 blocks, max_spins, 1)
                    if fx.ptr_load(lds.ok.ptr) != 0:
                        atom = fx.make_mma_atom(fx.rocdl.WMMA(
                            16, 16, 16, fx.BFloat16, fx.Float32))
                        token = lane % 16
                        khalf = (lane // 16) * 8
                        for tile in range(bid * 4 + wave, intermediate // 16, blocks * 4):
                            gate = fx.Vector.filled(8, 0.0, fx.Float32)
                            up = fx.Vector.filled(8, 0.0, fx.Float32)
                            for k in range(0, hidden, 16):
                                x = fx.Vector.filled(8, 0.0, fx.BFloat16)
                                if token < rows:
                                    x = fx.generic_load(xnorm + token * hidden + k + khalf,
                                                        count=8)
                                wi = (tile * 16 + token) * hidden + k + khalf
                                wg = fx.generic_load(w13 + wi, count=8)
                                wu = fx.generic_load(w13 + intermediate * hidden + wi, count=8)
                                gate = wmma(atom, wg, x, gate)
                                up = wmma(atom, wu, x, up)
                            if token < rows:
                                for j in fx.range_constexpr(8):
                                    # Match BF16 linear-output rounding before SwiGLU.
                                    g = gate[j].to(fx.BFloat16).to(fx.Float32)
                                    u = up[j].to(fx.BFloat16).to(fx.Float32)
                                    value = (g / (1.0 + fmath.exp(-g))) * u
                                    feature = tile * 16 + khalf + j
                                    fx.generic_store(mid + token * intermediate + feature,
                                                     value.to(fx.BFloat16))
                        grid_barrier(control, fault, lds.ok.ptr, tid, bid,
                                     blocks, max_spins, 2)
                        if fx.ptr_load(lds.ok.ptr) != 0:
                            for tile in range(bid * 4 + wave, hidden // 16, blocks * 4):
                                acc = fx.Vector.filled(8, 0.0, fx.Float32)
                                for k in range(0, intermediate, 16):
                                    x = fx.Vector.filled(8, 0.0, fx.BFloat16)
                                    if token < rows:
                                        x = fx.generic_load(mid + token * intermediate + k + khalf,
                                                            count=8)
                                    wi = (tile * 16 + token) * intermediate + k + khalf
                                    w = fx.generic_load(w2 + wi, count=8)
                                    acc = wmma(atom, w, x, acc)
                                if token < rows:
                                    for j in fx.range_constexpr(8):
                                        feature = tile * 16 + khalf + j
                                        fx.generic_store(out + token * hidden + feature,
                                                         acc[j].to(fx.BFloat16))

            if fx.const_expr(peer_mode):
                # Also publish local-grid failures when CTA0 was dropped.
                if tid == 0:
                    failed = fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                                             syncscope="agent")
                    if failed != 0:
                        release(flag_ptr(fx.generic_load(peers + rank), FAILED), fx.Uint32(1))

    @flyc.jit
    def launch(a: fx.Pointer, residual: fx.Pointer, norm: fx.Pointer,
               w13: fx.Pointer, w2: fx.Pointer, out: fx.Pointer,
               resout: fx.Pointer, scratch: fx.Pointer, control: fx.Pointer,
               fault: fx.Pointer, peers: fx.Pointer, attn_scale: fx.Pointer,
            rows: fx.Int32, eps: fx.Float32,
               max_spins: fx.Int32, drop_cta: fx.Int32, has_attn_scale: fx.Int32, stream: fx.Stream):
        ffn(a, residual, norm, w13, w2, out, resout, scratch, control,
            fault, peers, attn_scale, rows, eps, max_spins, drop_cta, has_attn_scale).launch(
                grid=(blocks, 1, 1), block=(128, 1, 1), stream=stream)

    return launch
