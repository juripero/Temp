"""FlyDSL 0.5.0 device code. Import only after selecting the gfx1201 target.

The SSA atom call follows ROCm/FlyDSL v0.5.0's RDNA4 WMMA tests. The
ASTRewriter helper boundary follows vLLM's specialized_decode reference.
Both are deliberately version-pinned; no HIP/C++ extension is generated.

The intermediate dimension is rank-local (I/TP). Residual inputs are replicated; attention is reduced through IPC in partial
mode. With ffn_reduce enabled, W2 writes BF16 partials directly into a separate
IPC mailbox, and a device epilogue produces the global SUM. Otherwise the
host runner retains the output collective.
"""

import flydsl.compiler as flyc
import flydsl.expr as fx
from flydsl._mlir.dialects import fly
from flydsl.compiler.ast_rewriter import ASTRewriter
from flydsl.expr import math as fmath
from ._peer_kernel import acquire, release, flag_ptr, data_ptr, peer_phase
from .peer_layout import READY, DONE, EPOCH, FAILED
from ._ll_kernel import ll_ptr, publish_word, read_word, unpack_first, unpack_second


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
def scaled_bf16(value, col, scale, has_scale):
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
                value = scaled_bf16(value, index % hidden, scale, has_scale)
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


@ASTRewriter.transform
def reduce_ffn(out, peers, scale, has_scale, control, fault, ok,
               tid, bid, rows, hidden, blocks, max_spins, tp, rank):
    """All W2 writers participate, including CTAs with no assigned output tiles.

    W2 already wrote BF16 partials directly to this rank's FFN mailbox.
    Four grid barriers establish publication, readiness, retirement and reuse.
    FFN flags/epochs are disjoint from the attention mailbox.
    """
    own = fx.generic_load(peers + rank)
    epoch = acquire(flag_ptr(own, EPOCH)) + fx.Uint32(1)
    fx.memory_fence(syncscope=fx.SyncScope.System, ordering=fx.AtomicOrdering.Release)
    grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, 20)
    if fx.ptr_load(ok) != 0:
        if (bid == 0) & (tid == 0):
            peer_phase(peers, own, epoch, fault, tp, READY, max_spins, 30)
        grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, 21)
        fx.memory_fence(syncscope=fx.SyncScope.System, ordering=fx.AtomicOrdering.Acquire)
        if fx.ptr_load(ok) != 0:
            for index in range(bid * 128 + tid, rows * hidden, blocks * 128):
                total = fx.Float32(0.0)
                for peer in fx.range_constexpr(tp):
                    remote = data_ptr(fx.generic_load(peers + peer))
                    total = total + fx.generic_load(remote + index).to(fx.Float32)
                # Preserve local BF16 W2 boundaries, then round the global sum.
                value = total.to(fx.BFloat16).to(fx.Float32)
                value = scaled_bf16(value, index % hidden, scale, has_scale)
                fx.generic_store(out + index, value.to(fx.BFloat16))
            fx.memory_fence(syncscope=fx.SyncScope.System, ordering=fx.AtomicOrdering.AcqRel)
            grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, 22)
            if fx.ptr_load(ok) != 0:
                if (bid == 0) & (tid == 0):
                    peer_phase(peers, own, epoch, fault, tp, DONE, max_spins, 31)
                    if fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                                       syncscope="agent") == 0:
                        release(flag_ptr(own, EPOCH), epoch)
                grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, 23)


@ASTRewriter.transform
def ll_prepare(peers, control, fault, ok, tid, bid, hidden, blocks,
               max_spins, tp, rank, site):
    own = fx.generic_load(peers + rank)
    epoch = acquire(flag_ptr(own, EPOCH)) + fx.Uint32(1)
    if epoch == 0:
        # Reserve epoch zero as INVALID. At wrap, scrub ALL capacity to zero
        # and agree on a separate wrap generation before accepting epoch one.
        # This also invalidates inactive rows; zero is never a valid data tag.
        # READY is only used for this rare path.
        for index in range(bid * 128 + tid, 16 * hidden // 2, blocks * 128):
            release(ll_ptr(own) + index, fx.Uint64(0))
        fx.memory_fence(syncscope=fx.SyncScope.System, ordering=fx.AtomicOrdering.Release)
        grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, site + 5)
        if fx.ptr_load(ok) != 0:
            if (bid == 0) & (tid == 0):
                wrap_epoch = acquire(flag_ptr(own, READY)) + fx.Uint32(1)
                peer_phase(peers, own, wrap_epoch, fault, tp, READY, max_spins, site + 6)
            grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, site + 7)
        epoch = fx.Uint32(1)
    return epoch


@ASTRewriter.transform
def ll_retire(peers, epoch, control, fault, ok, tid, bid, blocks, max_spins, tp, rank, site):
    own = fx.generic_load(peers + rank)
    # Keep retirement: LL does not grant a producer permission to overwrite
    # a word while another rank still needs it. Every local reader finishes.
    fx.memory_fence(syncscope=fx.SyncScope.System, ordering=fx.AtomicOrdering.AcqRel)
    grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, site + 2)
    if fx.ptr_load(ok) != 0:
        if (bid == 0) & (tid == 0):
            peer_phase(peers, own, epoch, fault, tp, DONE, max_spins, site + 4)
            if fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                               syncscope="agent") == 0:
                release(flag_ptr(own, EPOCH), epoch)
        grid_barrier(control, fault, ok, tid, bid, blocks, max_spins, site + 3)


@ASTRewriter.transform
def ll_reduce(out, peers, epoch, scale, has_scale, control, fault, ok,
              tid, bid, rows, hidden, blocks, max_spins, tp, rank, site):
    own = fx.generic_load(peers + rank)
    # Each word carries its own readiness. All producer CTAs must be resident
    # (checked at warmup); no whole-buffer READY/grid barrier is necessary.
    for index in range(bid * 128 + tid, rows * hidden // 2, blocks * 128):
        first = fx.Float32(0.0)
        second = fx.Float32(0.0)
        for peer in fx.range_constexpr(tp):
            remote = fx.generic_load(peers + peer)
            word = read_word(remote, own, index, epoch, fault, max_spins, site)
            first = first + unpack_first(word)
            second = second + unpack_second(word)
        col = (index * 2) % hidden
        first = scaled_bf16(first.to(fx.BFloat16).to(fx.Float32), col, scale, has_scale)
        second = scaled_bf16(second.to(fx.BFloat16).to(fx.Float32), col + 1, scale, has_scale)
        fx.generic_store(out + index * 2, first.to(fx.BFloat16))
        fx.generic_store(out + index * 2 + 1, second.to(fx.BFloat16))
    ll_retire(peers, epoch, control, fault, ok, tid, bid, blocks, max_spins, tp, rank, site)


@ASTRewriter.transform
def reduce_attention_ll(a, reduced, peers, scale, has_scale, control, fault, ok,
                        tid, bid, rows, hidden, blocks, max_spins, tp, rank):
    epoch = ll_prepare(peers, control, fault, ok, tid, bid, hidden, blocks,
                       max_spins, tp, rank, 50)
    if fx.ptr_load(ok) != 0:
        own = fx.generic_load(peers + rank)
        for index in range(bid * 128 + tid, rows * hidden // 2, blocks * 128):
            publish_word(ll_ptr(own) + index, fx.generic_load(a + index * 2),
                         fx.generic_load(a + index * 2 + 1), epoch)
        ll_reduce(reduced, peers, epoch, scale, has_scale, control, fault, ok,
                  tid, bid, rows, hidden, blocks, max_spins, tp, rank, 50)


def make_launcher(hidden, intermediate, blocks, tp=1, rank=0, attention_partial=False,
                  ffn_reduce=False, ipc_protocol="simple"):
    peer_mode = attention_partial and tp > 1
    ffn_peer_mode = ffn_reduce and tp > 1
    ll_mode = ipc_protocol == "ll"
    @fx.struct
    class Lds:
        red: fx.Array[fx.Float32, 4, 4]
        inv: fx.Array[fx.Float32, 1, 4]
        ok: fx.Array[fx.Int32, 1, 4]

    @flyc.kernel(name=f"qwen_bf16_ffnar_v2_h{hidden}_i{intermediate}_b{blocks}_tp{tp}r{rank}_a{int(attention_partial)}_f{int(ffn_reduce)}_p{ipc_protocol}",
                 known_block_size=[128, 1, 1])
    def ffn(a: fx.Pointer, residual: fx.Pointer, norm: fx.Pointer,
            w13: fx.Pointer, w2: fx.Pointer, out: fx.Pointer,
            resout: fx.Pointer, scratch: fx.Pointer, control: fx.Pointer,
            fault: fx.Pointer, peers: fx.Pointer, attn_scale: fx.Pointer,
            ffn_peers: fx.Pointer, ffn_scale: fx.Pointer,
            rows: fx.Int32, eps: fx.Float32,
            max_spins: fx.Int32, drop_cta: fx.Int32, has_attn_scale: fx.Int32,
            has_ffn_scale: fx.Int32, drop_ffn_cta: fx.Int32):
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
                    if fx.const_expr(ll_mode):
                        reduce_attention_ll(a, attention, peers, attn_scale, has_attn_scale,
                                            control, fault, lds.ok.ptr, tid, bid, rows,
                                            hidden, blocks, max_spins, tp, rank)
                    else:
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
                                attention_value = scaled_bf16(attention_value, col, attn_scale, has_attn_scale)
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
                                attention_value = scaled_bf16(attention_value, col, attn_scale, has_attn_scale)
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
                            down_output = out
                            ffn_epoch = fx.Uint32(0)
                            if fx.const_expr(ffn_peer_mode):
                                down_output = data_ptr(fx.generic_load(ffn_peers + rank))
                                if fx.const_expr(ll_mode):
                                    ffn_epoch = ll_prepare(ffn_peers, control, fault, lds.ok.ptr,
                                                           tid, bid, hidden, blocks, max_spins,
                                                           tp, rank, 60)
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
                                    if fx.const_expr(ffn_peer_mode and ll_mode):
                                        if (bid != drop_ffn_cta) & (fx.ptr_load(lds.ok.ptr) != 0):
                                            # Adjacent accumulator features belong to the same
                                            # lane; no shuffle or intermediate BF16 copy.
                                            for j in fx.range_constexpr(4):
                                                feature = tile * 16 + khalf + j * 2
                                                published = ll_ptr(fx.generic_load(ffn_peers + rank))
                                                publish_word(published + (token * hidden + feature) // 2,
                                                             acc[j * 2].to(fx.BFloat16),
                                                             acc[j * 2 + 1].to(fx.BFloat16), ffn_epoch)
                                    else:
                                        for j in fx.range_constexpr(8):
                                            feature = tile * 16 + khalf + j
                                            value = acc[j].to(fx.BFloat16).to(fx.Float32)
                                            if fx.const_expr(not ffn_peer_mode):
                                                value = scaled_bf16(value, feature, ffn_scale, has_ffn_scale)
                                            fx.generic_store(down_output + token * hidden + feature,
                                                             value.to(fx.BFloat16))
                            if fx.const_expr(ffn_peer_mode):
                                # Qualification-only fault: omit one CTA from the FFN publication barrier.
                                if bid != drop_ffn_cta:
                                    if fx.const_expr(ll_mode):
                                        ll_reduce(out, ffn_peers, ffn_epoch, ffn_scale, has_ffn_scale,
                                                  control, fault, lds.ok.ptr, tid, bid, rows,
                                                  hidden, blocks, max_spins, tp, rank, 60)
                                    else:
                                        reduce_ffn(out, ffn_peers, ffn_scale, has_ffn_scale,
                                                   control, fault, lds.ok.ptr, tid, bid, rows,
                                                   hidden, blocks, max_spins, tp, rank)

            if fx.const_expr(peer_mode):
                # Also publish local-grid failures when CTA0 was dropped.
                if tid == 0:
                    failed = fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                                             syncscope="agent")
                    if failed != 0:
                        release(flag_ptr(fx.generic_load(peers + rank), FAILED), fx.Uint32(1))

            if fx.const_expr(ffn_peer_mode):
                # Publish any attention/compute/FFN failure to FFN waiters as well.
                if tid == 0:
                    failed = fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                                             syncscope="agent")
                    if failed != 0:
                        release(flag_ptr(fx.generic_load(ffn_peers + rank), FAILED), fx.Uint32(1))

    @flyc.jit
    def launch(a: fx.Pointer, residual: fx.Pointer, norm: fx.Pointer,
               w13: fx.Pointer, w2: fx.Pointer, out: fx.Pointer,
               resout: fx.Pointer, scratch: fx.Pointer, control: fx.Pointer,
               fault: fx.Pointer, peers: fx.Pointer, attn_scale: fx.Pointer,
            ffn_peers: fx.Pointer, ffn_scale: fx.Pointer,
            rows: fx.Int32, eps: fx.Float32,
               max_spins: fx.Int32, drop_cta: fx.Int32, has_attn_scale: fx.Int32,
               has_ffn_scale: fx.Int32, drop_ffn_cta: fx.Int32, stream: fx.Stream):
        ffn(a, residual, norm, w13, w2, out, resout, scratch, control,
            fault, peers, attn_scale, ffn_peers, ffn_scale, rows, eps, max_spins, drop_cta,
            has_attn_scale, has_ffn_scale, drop_ffn_cta).launch(
                grid=(blocks, 1, 1), block=(128, 1, 1), stream=stream)

    return launch
