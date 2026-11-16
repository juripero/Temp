"""Python/Triton cache kernels. No libexpertcache.so or HIP extension required."""

import triton
import triton.language as tl


@triton.jit
def manage(
    IDS,
    OUT,
    TABLE,
    EXPERTS,
    SCORES,
    CLOCK,
    MISS,
    N_MISS,
    E: tl.constexpr,
    S: tl.constexpr,
    R: tl.constexpr,
    B: tl.constexpr,
    POLICY: tl.constexpr,
    DECAY: tl.constexpr,
):
    # One CTA owns all metadata. Protect every expert needed by this invocation
    # before selecting victims, including hits appearing late in the ID list.
    s = tl.arange(0, B)
    live = s < S
    experts = tl.load(EXPERTS + s, live, -1)
    scores = tl.load(SCORES + s, live, 0)
    clock = tl.load(CLOCK) + 1
    if POLICY == 1 and DECAY > 0:
        scores = tl.where(clock % DECAY == 0, scores // 2, scores)
    needed = tl.full((B,), False, tl.int1)
    for i in range(R):
        e = tl.load(IDS + i).to(tl.int32)
        valid = (e >= 0) & (e < E)
        needed = needed | (live & valid & (experts == e))
    if POLICY == 0:
        scores = tl.where(needed, clock, scores)
    else:
        scores = tl.where(needed, scores + 1, scores)
    misses = tl.full((B,), -1, tl.int32)
    n_miss = tl.full((), 0, tl.int32)
    for i in range(R):
        e = tl.load(IDS + i).to(tl.int32)
        valid = (e >= 0) & (e < E)
        present = tl.sum((live & (experts == e)).to(tl.int32), 0) > 0
        if valid & ~present:
            # Empty slots first; minimum index breaks all ties deterministically.
            priority = tl.where(experts < 0, -1, scores)
            candidate = live & ~needed
            best = tl.min(tl.where(candidate, priority, 0x7FFFFFFFFFFFFFFF), 0)
            victim = tl.min(tl.where(candidate & (priority == best), s, B), 0)
            old = tl.sum(tl.where(s == victim, experts, 0), 0)
            tl.store(TABLE + tl.maximum(old, 0), -1, old >= 0)
            tl.store(TABLE + e, victim)
            chosen = s == victim
            experts = tl.where(chosen, e, experts)
            scores = tl.where(chosen, clock if POLICY == 0 else 1, scores)
            needed = needed | chosen
            misses = tl.where(chosen, e, misses)
            n_miss += 1
        match = live & valid & (experts == e)
        slot = tl.max(tl.where(match, s, -1), 0)
        tl.store(OUT + i, slot)
    tl.store(EXPERTS + s, experts, live)
    tl.store(SCORES + s, scores, live)
    tl.store(MISS + s, misses, live)
    tl.store(N_MISS, n_miss)
    tl.store(CLOCK, clock)


@triton.jit
def gather(SRC, DST, MISS, SLAB: tl.constexpr, BLOCK: tl.constexpr):
    slot = tl.program_id(0)
    expert = tl.load(MISS + slot)
    if expert >= 0:
        offset = tl.program_id(1) * BLOCK + tl.arange(0, BLOCK)
        value = tl.load(SRC + expert.to(tl.int64) * SLAB + offset, offset < SLAB, 0)
        tl.store(DST + slot.to(tl.int64) * SLAB + offset, value, offset < SLAB)
