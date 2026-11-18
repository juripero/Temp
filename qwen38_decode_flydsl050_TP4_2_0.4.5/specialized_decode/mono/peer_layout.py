"""HIP IPC layouts. Simple and ll retain one data bank and owner READY/DONE.

ll_double reserves 512 bytes for per-CTA owner-only uint64 sequences, followed
by two packed banks. DONE/EPOCH are unused in that layout; READY is used only
for rare per-bank rollover scrubs. Headers/payload starts stay eight-byte aligned.
"""
READY = 0
DONE = 128
EPOCH = 256
FAILED = 384
DATA = 512
DB_SEQUENCE = 512  # 64 owner-only uint64 counters, one per CTA.
DB_DATA = 1024
DB_MAX_BLOCKS = 64
DB_TAG_MAX = 0xFFFFFFFF
DB_CYCLE = 2 * DB_TAG_MAX  # Even: bank alternation survives rollover.
DB_INITIAL_SEQUENCE = 2  # Fresh zeroed banks do not need a wrap scrub.


def double_location(sequence):
    """Host diagnostic mapping; sequence denotes the next participating call."""
    if not 0 <= sequence < DB_CYCLE:
        raise ValueError("Double-buffer sequence is out of range")
    return sequence & 1, (sequence >> 1) + 1



def protocol_id(protocol="simple"):
    if protocol not in ("simple", "ll", "ll_double"):
        raise ValueError("IPC protocol must be simple, ll or ll_double")
    return {"simple": 1, "ll": 2, "ll_double": 3}[protocol]


def arena_bytes(hidden, max_rows=16, protocol="simple"):
    protocol_id(protocol)
    if hidden <= 0 or hidden % 2 or not 1 <= max_rows <= 16:
        raise ValueError("Expected even hidden size and 1..16 rows")
    if protocol == "ll_double":
        return DB_DATA + 2 * max_rows * hidden * 4
    # LL: two BF16 values + uint32 epoch in each aligned uint64 word.
    return DATA + max_rows * hidden * (4 if protocol == "ll" else 2)
