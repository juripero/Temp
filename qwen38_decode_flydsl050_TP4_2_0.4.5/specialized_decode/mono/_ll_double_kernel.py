"""Owner-local state for two LL banks. No peer DONE or credit publication.

Every CTA snapshots its own counter before using it. Counter advancement is
not a completion signal: the next call may read it only in a later kernel on
the same stream, after ALL blocks of this kernel have completed.
"""
import flydsl.expr as fx
from flydsl.compiler.ast_rewriter import ASTRewriter

from .peer_layout import DB_SEQUENCE, DB_CYCLE


def sequence_ptr(base, bid):
    return fx.inttoptr(fx.PointerType.get(fx.Uint64.ir_type, fx.AddressSpace.Global, 8),
                      base + fx.Uint64(DB_SEQUENCE)) + bid


@ASTRewriter.transform
def snapshot_sequence(own, slot, tid, bid):
    if tid == 0:
        value = fx.generic_load(sequence_ptr(own, bid), memory_order=fx.AtomicOrdering.Acquire,
                                syncscope="agent")
        fx.ptr_store(value, slot)
    fx.gpu.barrier()
    return fx.ptr_load(slot)


def sequence_tag(sequence):
    return (sequence >> 1).to(fx.Uint32) + fx.Uint32(1)


def sequence_offset(sequence, hidden):
    return (sequence & fx.Uint64(1)).to(fx.Int32) * (16 * hidden // 2)


@ASTRewriter.transform
def advance_sequence(own, sequence, tid, bid):
    if tid == 0:
        following = sequence + fx.Uint64(1)
        if following == fx.Uint64(DB_CYCLE):
            following = fx.Uint64(0)
        fx.generic_store(sequence_ptr(own, bid), following,
                         memory_order=fx.AtomicOrdering.Release, syncscope="agent")
