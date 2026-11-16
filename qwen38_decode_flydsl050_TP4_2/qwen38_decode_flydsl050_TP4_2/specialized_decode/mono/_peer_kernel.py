"""FlyDSL peer-memory helpers; no gfx942-specific cache instructions.

Only the owner writes its IPC flags. Remote operations are loads, not remote
atomic RMWs. System acquire/release ordering is lowered for gfx1201 by LLVM.
"""
import flydsl.expr as fx
from flydsl.compiler.ast_rewriter import ASTRewriter

from .peer_layout import READY, DONE, EPOCH, FAILED, DATA


def flag_ptr(base, offset):
    return fx.inttoptr(fx.PointerType.get(fx.Uint32.ir_type, fx.AddressSpace.Global, 4),
                      base + fx.Uint64(offset))


def data_ptr(base):
    return fx.inttoptr(fx.PointerType.get(fx.BFloat16.ir_type, fx.AddressSpace.Global, 2),
                      base + fx.Uint64(DATA))


def acquire(ptr):
    return fx.generic_load(ptr, memory_order=fx.AtomicOrdering.Acquire,
                           syncscope=fx.SyncScope.System)


def release(ptr, value):
    fx.generic_store(ptr, value, memory_order=fx.AtomicOrdering.Release,
                     syncscope=fx.SyncScope.System)


@ASTRewriter.transform
def mark_fault(fault, site, epoch):
    old, won = fx.atomic_cas(fault, fx.Uint32(0), fx.Uint32(1), syncscope="agent",
                            success_ordering=fx.AtomicOrdering.AcqRel,
                            failure_ordering=fx.AtomicOrdering.Acquire)
    if won:
        fx.generic_store(fault + 1, fx.Uint32(site))
        fx.generic_store(fault + 2, fx.Uint32(0))
        fx.generic_store(fault + 3, epoch)


@ASTRewriter.transform
def peer_phase(peers, own, epoch, fault, tp, offset, max_spins, site):
    """Called by CTA0/thread0 after an all-writer/all-reader local grid barrier.

    READY guards publication, DONE guards retirement. Equality survives wrap:
    the next DONE cannot be published until every rank has left this DONE wait
    and published its next READY. There is no reset or host-managed epoch.
    """
    release(flag_ptr(own, offset), epoch)
    for rank in fx.range_constexpr(tp):
        remote = fx.generic_load(peers + rank)
        spins = fx.Int32(0)
        waiting = fx.Int32(1)
        failed = fx.Uint32(0)
        while (waiting != 0) & (spins < max_spins) & (failed == 0):
            seen = acquire(flag_ptr(remote, offset))
            remote_fault = acquire(flag_ptr(remote, FAILED))
            local_fault = fx.generic_load(fault, memory_order=fx.AtomicOrdering.Acquire,
                                          syncscope="agent")
            failed = remote_fault | local_fault
            waiting = fx.Int32(seen != epoch)
            spins = spins + 1
        if (waiting != 0) | (failed != 0):
            mark_fault(fault, site, epoch)
            release(flag_ptr(own, FAILED), fx.Uint32(1))
