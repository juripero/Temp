# FFN-output reduction implementation, version 0.4.3

## Files and behavior

| File | Change |
|---|---|
| `runtime/spec.py` | `ffn_reduction=collective|ipc`; specialization agreement and barrier accounting |
| `integration.py` | Reads `QWEN38_FFN_REDUCTION` when constructing the controller |
| `runtime/peer.py` | Mailbox purpose checked during bootstrap; separate FFN arena uses existing allocator/IPC lifecycle |
| `mono/runner.py` | Creates FFN arena, forwards its table and FFN scale, suppresses duplicate output collective, exposes collective teardown |
| `mono/_flydsl_kernel.py` | Direct BF16 W2 publication and in-kernel global SUM/scaling |
| `mono/a16w16.py` | Revised launch ABI and specialization; distinct kernel name prevents stale ABI cache reuse |
| `runtime/executor.py` | Defers FFN scale into the active epilogue, preserves stock fallback scaling |
| `validate_tp.py` | Independent rank-order reference, dual epoch wrap, FFN-stage dropped-CTA test |
| `compile_smoke.py` | Covers old/new reduction combinations and first/last TP ranks |

The new kernel ABI has 14 pointers, seven scalar values and the stream object.
Use all files from this release together. The internal `drop_ffn_cta` argument
is only for qualification; serving always passes -1.

## Final-output boundary

For each output element on every TP rank:

```python
# Conceptual arithmetic, not additional host kernels:
local_partial = bf16(local_W2_accumulator)
# Publish local_partial in the FFN mailbox, synchronize all ranks.
reduced = bf16(sum_fp32_in_rank_order(peer_partial[r] for r in tp_ranks))
output = bf16(reduced * bf16(1 + bf16(ffn_scale))) if scale_enabled else reduced
```

W2 never publishes an incomplete K reduction. Every CTA enters the publication
barrier, including CTAs with no output tile. The peer SUM writes to the ordinary
output tensor; the mailbox contains local partials and is not overwritten with
the global output while peers still read it. The runner returns this output
without another FFN all-reduce. The residual output is kept unchanged.

## Failure sites

Existing attention and compute sites are preserved. Added sites are:

| Site | Stage |
|---:|---|
| 20 | All local W2 writers reached FFN publication barrier |
| 21 | Local broadcast after FFN READY exchange |
| 22 | All local FFN peer readers retired |
| 23 | Local broadcast after FFN DONE exchange |
| 30 | FFN READY peer wait |
| 31 | FFN DONE peer wait |

Flags are uint32 and compare exact epochs. Both arenas start at zero, advance
independently and wrap modulo 2^32. The hardware test seeds them differently
and executes across rollover to detect accidental aliasing. Host tests explore
all abstract interleavings of three attention/FFN invocation pairs for TP2/TP4.
That model assumes memory visibility and is not a hardware memory-model proof.

A failure from any phase is published to both enabled arenas before kernel
exit. Local waits are bounded by iterations, not wall-clock time. On a fault,
discard the step and stop all workers. There is no clear-and-resume operation.
The separate int32 health collective at the end of a forward remains necessary.

## Validation scope

The host tests exercise CPU numerical references, active/fallback transitions,
TP subgroups, layer-scale ordering, exact-base allocation diagnostics, and
mocked host dispatch proving that a fused result is not reduced a second time.
They do not execute peer loads. The staged torch backend uses FP32 collective
accumulation as a reference and should not be benchmarked as the mono kernel.

ISA generation confirms compiler compatibility and device-scope/system-scope
instructions, but does not test HIP IPC export, mappings, peer visibility or
launch residency. Full-size new variants report 45–46 VGPRs, 44–47 SGPRs,
24 bytes fixed LDS and zero private-segment bytes. These are compiler metadata,
not measured occupancy or speedup. GPU qualification commands are in README.md.

No real distributed test was rerun in this update: previous attempts in this
workspace failed during Gloo transport initialization with Operation not permitted.
All 61 current host tests use local CPU execution or mocks; all 32 compiler
cases use gfx1201 ISA output without a live GPU or ELF linking.
