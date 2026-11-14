# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project
"""Bounded on-device grid synchronization and sticky error word for gfx1201."""

from __future__ import annotations

import flydsl.compiler as fx
from flydsl.compiler import T
from flydsl.expr import buffer_ops as bo
from flydsl.expr import rocdl

EPOCH_WORDS = 4
ERROR_WORDS = 4
ERROR_BYTES = ERROR_WORDS * 4
# ~10 seconds bound on gfx1201 s_memtime (100 MHz RT clock -> 1e9 ticks)
TIMEOUT_TICKS = 1_000_000_000


def record_fault(fault_ptr, site_code: int, epoch_val) -> None:
    """Publish sticky failure word [1, rank=0, site_code, epoch] so post-step assert traps."""
    f_rsrc = bo.create_buffer_resource(fault_ptr)
    bo.buffer_store(fx.Int32(1), f_rsrc, fx.Int32(0), dtype=T.i32)
    bo.buffer_store(fx.Int32(0), f_rsrc, fx.Int32(1), dtype=T.i32)
    bo.buffer_store(fx.Int32(site_code), f_rsrc, fx.Int32(2), dtype=T.i32)
    bo.buffer_store(fx.Int32(epoch_val), f_rsrc, fx.Int32(3), dtype=T.i32)


def grid_barrier(barrier_ptr, fault_ptr, blocks: int, tag_val, site_code: int = 1) -> None:
    """Bounded grid barrier across `blocks` resident CTAs on gfx1201."""
    fx.gpu.barrier()
    tid = fx.thread_idx.x
    if tid == 0:
        rocdl.s_waitcnt(0)
        b_rsrc = bo.create_buffer_resource(barrier_ptr)
        f_rsrc = bo.create_buffer_resource(fault_ptr)

        bo.buffer_atomic_add(fx.Int32(1), b_rsrc, fx.Int32(0), dtype=T.i32)
        t0 = rocdl.s_memtime()

        while True:
            err = bo.buffer_load(f_rsrc, fx.Int32(0), vec_width=1, dtype=T.i32, cache_modifier=3)
            if err != 0:
                break
            arrived = bo.buffer_load(b_rsrc, fx.Int32(0), vec_width=1, dtype=T.i32, cache_modifier=3)
            if arrived >= fx.Int32(blocks):
                break
            now = rocdl.s_memtime()
            if (now - t0) > fx.Int64(TIMEOUT_TICKS):
                record_fault(fault_ptr, site_code, tag_val)
                break
            rocdl.s_sleep(1)

    fx.gpu.barrier()
