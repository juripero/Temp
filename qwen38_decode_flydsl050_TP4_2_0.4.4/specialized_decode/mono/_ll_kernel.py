"""LL word primitives for FlyDSL 0.5.0/gfx1201.

One aligned uint64 contains BF16 bits [15:0], BF16 bits [31:16], and
epoch [63:32]. Access the entire word atomically at system scope. Never
poll a separate epoch field or reload payload after accepting a word.
These are loads/stores, not remote atomic RMWs. Hardware qualification is
still required for the actual ROCm allocation/P2P mapping/topology.
"""
import flydsl.expr as fx
from flydsl.compiler.ast_rewriter import ASTRewriter

from ._peer_kernel import acquire, flag_ptr, mark_fault, release
from .peer_layout import DATA, FAILED


def ll_ptr(base):
    return fx.inttoptr(fx.PointerType.get(fx.Uint64.ir_type, fx.AddressSpace.Global, 8),
                      base + fx.Uint64(DATA))


def pack_word(first, second, epoch):
    lo = first.bitcast(fx.Uint16).to(fx.Uint64)
    hi = second.bitcast(fx.Uint16).to(fx.Uint64)
    return lo | (hi << 16) | (epoch.to(fx.Uint64) << 32)


def unpack_first(word):
    return word.to(fx.Uint16).bitcast(fx.BFloat16).to(fx.Float32)


def unpack_second(word):
    return (word >> 16).to(fx.Uint16).bitcast(fx.BFloat16).to(fx.Float32)


def publish_word(ptr, first, second, epoch):
    release(ptr, pack_word(first, second, epoch))


@ASTRewriter.transform
def read_word(remote, own, index, epoch, fault, max_spins, site):
    word = fx.Uint64(0)
    waiting = fx.Int32(1)
    spins = fx.Int32(0)
    failed = fx.Uint32(0)
    while (waiting != 0) & (spins < max_spins) & (failed == 0):
        word = acquire(ll_ptr(remote) + index)
        waiting = fx.Int32((word >> 32).to(fx.Uint32) != epoch)
        failed = acquire(flag_ptr(remote, FAILED)) | fx.generic_load(
            fault, memory_order=fx.AtomicOrdering.Acquire, syncscope="agent")
        spins = spins + 1
    if (waiting != 0) | (failed != 0):
        mark_fault(fault, site, epoch)
        release(flag_ptr(own, FAILED), fx.Uint32(1))
        word = fx.Uint64(0)  # Invalid step is discarded through sticky fault.
    return word
