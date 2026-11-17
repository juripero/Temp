"""Byte offsets in each dedicated uncached HIP IPC allocation.

Each flag occupies a separate 128-byte region. A single data bank is safe
because every owner waits for all read-completion acknowledgements before
another launch may overwrite it. Epoch and flags are uint32, device-owned.
"""
READY = 0
DONE = 128
EPOCH = 256
FAILED = 384
DATA = 512


def arena_bytes(hidden, max_rows=16):
    return DATA + max_rows * hidden * 2
