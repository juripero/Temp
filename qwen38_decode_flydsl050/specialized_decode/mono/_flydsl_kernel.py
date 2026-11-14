"""FlyDSL 0.5.0 device code. Import only after selecting the gfx1201 target.

The SSA atom call follows ROCm/FlyDSL v0.5.0's RDNA4 WMMA tests. The
ASTRewriter helper boundary follows vLLM's specialized_decode reference.
Both are deliberately version-pinned; no HIP/C++ extension is generated.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
from flydsl._mlir.dialects import fly
from flydsl.compiler.ast_rewriter import ASTRewriter
from flydsl.expr import math as fmath


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


def make_launcher(hidden, intermediate, blocks):
    @fx.struct
    class Lds:
        red: fx.Array[fx.Float32, 4, 4]
        inv: fx.Array[fx.Float32, 1, 4]
        ok: fx.Array[fx.Int32, 1, 4]

    @flyc.kernel(name=f"qwen_tp1_bf16_h{hidden}_i{intermediate}_b{blocks}",
                 known_block_size=[128, 1, 1])
    def ffn(a: fx.Pointer, residual: fx.Pointer, norm: fx.Pointer,
            w13: fx.Pointer, w2: fx.Pointer, out: fx.Pointer,
            resout: fx.Pointer, scratch: fx.Pointer, control: fx.Pointer,
            fault: fx.Pointer, rows: fx.Int32, eps: fx.Float32,
            max_spins: fx.Int32, drop_cta: fx.Int32):
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
                for row in range(bid, rows, blocks):
                    ssq = fx.Float32(0.0)
                    for col in range(tid, hidden, 128):
                        offset = row * hidden + col
                        summed = fx.generic_load(a + offset).to(fx.Float32) + \
                                 fx.generic_load(residual + offset).to(fx.Float32)
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
                        summed = fx.generic_load(a + offset).to(fx.Float32) + \
                                 fx.generic_load(residual + offset).to(fx.Float32)
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

    @flyc.jit
    def launch(a: fx.Pointer, residual: fx.Pointer, norm: fx.Pointer,
               w13: fx.Pointer, w2: fx.Pointer, out: fx.Pointer,
               resout: fx.Pointer, scratch: fx.Pointer, control: fx.Pointer,
               fault: fx.Pointer, rows: fx.Int32, eps: fx.Float32,
               max_spins: fx.Int32, drop_cta: fx.Int32, stream: fx.Stream):
        ffn(a, residual, norm, w13, w2, out, resout, scratch, control,
            fault, rows, eps, max_spins, drop_cta).launch(
                grid=(blocks, 1, 1), block=(128, 1, 1), stream=stream)

    return launch
