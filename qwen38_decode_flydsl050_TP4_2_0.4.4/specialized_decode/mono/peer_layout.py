"""Byte offsets in each dedicated HIP IPC allocation.

Each flag occupies a separate 128-byte region. A single data bank is safe
because every owner waits for all read-completion acknowledgements before
another launch may overwrite it. Epoch and flags are uint32, device-owned. Simple stores plain BF16; LL stores
aligned uint64 payload/tag words. LL reserves zero and scrubs all rows at wrap.
"""
READY = 0
DONE = 128
EPOCH = 256
FAILED = 384
DATA = 512


def protocol_id(protocol="simple"):
    if protocol not in ("simple", "ll"):
        raise ValueError("IPC protocol must be simple or ll")
    return 2 if protocol == "ll" else 1


def arena_bytes(hidden, max_rows=16, protocol="simple"):
    protocol_id(protocol)
    if hidden <= 0 or hidden % 2 or not 1 <= max_rows <= 16:
        raise ValueError("Expected even hidden size and 1..16 rows")
    # LL: two BF16 values + uint32 epoch in each aligned uint64 word.
    return DATA + max_rows * hidden * (4 if protocol == "ll" else 2)
