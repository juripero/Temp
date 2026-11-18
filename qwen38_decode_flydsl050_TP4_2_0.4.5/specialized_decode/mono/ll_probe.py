"""GPU-only bit-pattern qualification using the serving LL primitives.

Tests every payload bit (including BF16 NaN/Inf/sign/subnormal encodings)
without floating-point arithmetic hiding torn or stale reads. No vLLM import.
Compilation alone does not qualify a peer-memory topology.
"""
from .a16w16 import _select_target


def probe_arguments(peers=0, control=0, fault=0, rows=0, max_spins=1, salt=0, stream=None):
    import flydsl.compiler as flyc
    import flydsl.expr as fx
    return (flyc.from_c_void_p(fx.Uint64, peers, assumed_align=8),
            flyc.from_c_void_p(fx.Uint32, control, assumed_align=4),
            flyc.from_c_void_p(fx.Uint32, fault, assumed_align=4),
            rows, max_spins, salt, fx.Stream(stream))


def build_probe(hidden, blocks, tp, rank, ipc_protocol="ll"):
    _select_target(None)
    if ipc_protocol not in ("ll", "ll_double"):
        raise ValueError("Probe requires an LL protocol")
    double_mode = ipc_protocol == "ll_double"
    if tp not in (2, 4) or not 0 <= rank < tp or hidden <= 0 or hidden % 16 or not 1 <= blocks <= 64:
        raise ValueError("Invalid LL probe specialization")
    import flydsl.compiler as flyc
    import flydsl.expr as fx
    from ._flydsl_kernel import ll_prepare, ll_retire, db_prepare
    from ._ll_double_kernel import sequence_tag, sequence_offset, advance_sequence
    from ._ll_kernel import ll_ptr, publish_word, read_word
    from ._peer_kernel import mark_fault, release, flag_ptr
    from .peer_layout import FAILED, DATA, DB_DATA

    @fx.struct
    class Lds:
        ok: fx.Array[fx.Int32, 1, 4]
        sequence: fx.Array[fx.Uint64, 1, 8]

    @flyc.kernel(name=f"qwen_ll_probe_v2_h{hidden}_b{blocks}_tp{tp}r{rank}_p{ipc_protocol}",
                 known_block_size=[128, 1, 1])
    def probe(peers: fx.Pointer, control: fx.Pointer, fault: fx.Pointer,
              rows: fx.Int32, max_spins: fx.Int32, salt: fx.Int32):
        if rows > 0:
            tid, bid = fx.thread_idx.x, fx.block_idx.x
            lds = fx.SharedAllocator().allocate(Lds).peek()
            if tid == 0:
                failed = fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                                         syncscope="agent")
                fx.ptr_store(fx.Int32(failed == 0), lds.ok.ptr)
            fx.gpu.barrier()
            if fx.ptr_load(lds.ok.ptr) != 0:
                own = fx.generic_load(peers + rank)
                sequence = fx.Uint64(0)
                offset = fx.Int32(0)
                epoch = fx.Uint32(0)
                if fx.const_expr(double_mode):
                    sequence = db_prepare(peers, lds.sequence.ptr, control, fault, lds.ok.ptr,
                                          tid, bid, hidden, blocks, max_spins, tp, rank, 70)
                    offset = sequence_offset(sequence, hidden)
                    epoch = sequence_tag(sequence)
                else:
                    epoch = ll_prepare(peers, control, fault, lds.ok.ptr, tid, bid, hidden,
                                       blocks, max_spins, tp, rank, 70)
                if fx.ptr_load(lds.ok.ptr) != 0:
                    for index in range(bid * 128 + tid, rows * hidden // 2, blocks * 128):
                        bits = (fx.Int32(index).to(fx.Uint32) * fx.Uint32(0x9E3779B9)
                                ^ salt.to(fx.Uint32) * fx.Uint32(0x85EBCA6B)
                                ^ epoch * fx.Uint32(0xC2B2AE35) ^ fx.Uint32(rank * 0x27D4EB2F))
                        first = bits.to(fx.Uint16).bitcast(fx.BFloat16)
                        second = (bits >> 16).to(fx.Uint16).bitcast(fx.BFloat16)
                        publish_word(ll_ptr(own, DB_DATA if double_mode else DATA) + offset + index, first, second, epoch)
                    for index in range(bid * 128 + tid, rows * hidden // 2, blocks * 128):
                        for peer in fx.range_constexpr(tp):
                            remote = fx.generic_load(peers + peer)
                            observed = read_word(remote, own, index, epoch, fault, max_spins, 70,
                                                 offset, DB_DATA if double_mode else DATA)
                            bits = (fx.Int32(index).to(fx.Uint32) * fx.Uint32(0x9E3779B9)
                                    ^ salt.to(fx.Uint32) * fx.Uint32(0x85EBCA6B)
                                    ^ epoch * fx.Uint32(0xC2B2AE35) ^ fx.Uint32(peer * 0x27D4EB2F))
                            # Independent integer expectation also detects pack/bitcast errors.
                            expected = bits.to(fx.Uint64) | (epoch.to(fx.Uint64) << 32)
                            if observed != expected:
                                mark_fault(fault, 71, epoch)
                                release(flag_ptr(own, FAILED), fx.Uint32(1))
                    if fx.const_expr(double_mode):
                        advance_sequence(own, sequence, tid, bid)
                    else:
                        ll_retire(peers, epoch, control, fault, lds.ok.ptr, tid, bid, blocks,
                                  max_spins, tp, rank, 70)
            if tid == 0:
                if fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                                   syncscope="agent") != 0:
                    release(flag_ptr(fx.generic_load(peers + rank), FAILED), fx.Uint32(1))

    @flyc.jit
    def launch(peers: fx.Pointer, control: fx.Pointer, fault: fx.Pointer,
               rows: fx.Int32, max_spins: fx.Int32, salt: fx.Int32, stream: fx.Stream):
        probe(peers, control, fault, rows, max_spins, salt).launch(
            grid=(blocks, 1, 1), block=(128, 1, 1), stream=stream)

    return flyc.compile[{"fast_fp_math": False}](launch, *probe_arguments())
