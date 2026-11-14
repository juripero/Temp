# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project
"""Query HIP driver occupancy to guarantee persistent grid residency on gfx1201."""

from __future__ import annotations

import ctypes
from typing import Any


def active_workgroups_per_cu(compiled_kernel: Any, symbol_name: str, threads_per_block: int) -> int:
    """Return max active CTAs per CU reported by HIP for the compiled FlyDSL module."""
    if hasattr(compiled_kernel, "max_active_blocks_per_multiprocessor"):
        return int(compiled_kernel.max_active_blocks_per_multiprocessor(threads_per_block))

    hip_fn = getattr(compiled_kernel, "hip_function", None) or getattr(compiled_kernel, "func", None)
    if hip_fn is None:
        return 1

    libhip = ctypes.CDLL("libamdhip64.so")
    num_blocks = ctypes.c_int(0)
    err = libhip.hipOccupancyMaxActiveBlocksPerMultiprocessor(
        ctypes.byref(num_blocks),
        ctypes.c_void_p(int(hip_fn)),
        ctypes.c_int(threads_per_block),
        ctypes.c_size_t(0),
    )
    if err != 0:
        raise RuntimeError(
            f"hipOccupancyMaxActiveBlocksPerMultiprocessor({symbol_name}) failed: {err}"
        )
    return int(num_blocks.value)
