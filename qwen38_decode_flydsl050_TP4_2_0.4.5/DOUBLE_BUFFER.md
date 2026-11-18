# Double-buffer LL protocol, version 0.4.5

This builds on the delivered 0.4.4 package. Select the new implementation with
`QWEN38_IPC_PROTOCOL=ll_double` on every worker. The existing `ll` and `simple`
protocols retain their preceding behavior; `simple` remains the default.

## Enable and qualify

Install the complete package in the worker environment and restart all ranks:

```bash
python -m pip install --no-deps -e .

export QWEN38_SPECIALIZED_DECODE=1
export QWEN38_FFN_BACKEND=flydsl
export QWEN38_ATTENTION_INPUT=partial
export QWEN38_FFN_REDUCTION=ipc
export QWEN38_IPC_PROTOCOL=ll_double
export QWEN38_IPC_ALLOCATOR=hipmalloc
```

Keep the allocator and HSA settings that work on your system; the example uses
the explicit-base hipMalloc option. TP2 and TP4 use the same protocol setting.
`NCCL_PROTO` does not select this custom FlyDSL path. No new HIP/C++ kernel or
runtime collective is introduced. The existing vLLM installation hooks and
`--enforce-eager` integration guard remain. Standalone graph replay is supported
by the design and must be qualified on your hardware.

```bash
python -m unittest discover -s tests -v
python compile_smoke.py --isa-only --protocol all

QWEN38_IPC_ALLOCATOR=hipmalloc \
torchrun --standalone --nproc-per-node=2 validate_tp.py \
  --ipc-protocol ll_double --attention-partials --attention-scale \
  --ffn-reduction ipc --ffn-scale --small --ll-stress 100 --ll-skew-ms 1

QWEN38_IPC_ALLOCATOR=hipmalloc \
torchrun --standalone --nproc-per-node=2 validate_tp.py \
  --ipc-protocol ll_double --attention-partials --attention-scale \
  --ffn-reduction ipc --ffn-scale --ll-stress 1000 --ll-skew-ms 1 \
  --graph --fault-test
```

Repeat with four processes. Test attention-only and FFN-only configurations as
well. Compare with `--ipc-protocol ll`, then `simple` (omit LL stress options for
simple). ELF compilation with the local ROCm linker is available by omitting
`--isa-only`. The standalone validator uses real process groups for references.

## Buffer lifetime proof

Each reduction owns two IPC payload banks. Successive participating mono calls
alternate banks. A rank may begin invocation k+1 only after its complete local
kernel for k has finished, including all its peer reads. A rank can complete
k+1 only after consuming fresh k+1 words from every peer. Those words prove that
each peer has finished its own kernel k. Therefore, when any rank begins k+2,
every peer has retired reads of k's bank, and that bank can be overwritten.

This removes the explicit DONE acknowledgment; it does not assume equal GPU
speed. A fast rank may publish one invocation ahead into the other bank, but
LL polling prevents completion until the slow ranks advance. Buffer reuse is
protected by this dependency, not by the per-CTA counters described below.

Required execution contract:

- One serialized stream and no overlapping kernels/graphs on a workspace.
- Identical ordered, nonempty participating invocations and physical row counts
  across the TP group. Ineligible steps bypass the mono path on all ranks.
- Every invocation consumes every peer's active payload before local kernel
  completion. One invocation per arena per kernel; no independent CTA loops
  that advance into subsequent invocations inside the same kernel.
- Sticky failures stop the group. An incomplete call does not grant permission
  to recover or switch protocols while buffers remain live.

Graph replay preserves this contract only when replays sharing the runner are
serialized. The runner retains its stream-binding check. Explicit teardown
still synchronizes every rank, closes all imports, then frees owners; no buffer
is freed merely because one rank has returned from its kernel.

## State and memory layout

The new bootstrap layout ID is 3. Mixed old/new layouts are rejected.

| Byte offset | Contents |
| ---: | --- |
| 0 | Owner READY counter, used only by the rollover handshake |
| 128 | Reserved DONE; remains zero |
| 256 | Reserved legacy EPOCH; unused |
| 384 | Sticky FAILED flag |
| 512–1023 | 64 owner-local uint64 sequence counters, one per possible CTA |
| 1024 onward | Two packed payload banks, each with capacity 16 rows |

Each packed uint64 remains two BF16 values in the low 32 bits and a uint32 tag
in the upper 32 bits. All accesses are aligned and use system-scope atomic
release stores/acquire loads. Accepted payload comes from the same loaded word
as its tag. There are no remote atomic read-modify-write operations.

For a sequence s in `[0, 2 * 0xffffffff)`:

```python
bank = s & 1
tag = (s >> 1) + 1
next_sequence = (s + 1) % (2 * 0xffffffff)
```

Zero is never a valid payload tag. The cycle length is even, so bank alternation
continues correctly across rollover. Fresh arenas initialize every CTA counter
to 2: zero-filled banks can immediately use bank 0/tag 2, then bank 1/tag 2,
without performing an unnecessary startup scrub.

Thread 0 snapshots its CTA's counter into LDS, followed by a CTA-local barrier.
All threads then use that immutable snapshot. Thread 0 advances only its own
counter; other CTAs neither read it nor treat it as completion. All active CTAs
advance, including CTAs with no assigned tiles or payload words. The next kernel
cannot read these counters until every block of the current kernel has exited.
Attention and FFN have independent counters. No host sequence is captured into
a graph, and zero-row warmup does not access or advance these states.

At H=5120, each arena occupies `1024 + 2 * 16 * 5120 * 4 = 656384` bytes.
Both arenas use **1312768 bytes (1282 KiB) per GPU**. This doubles storage relative
to single-bank LL, but does not double its per-invocation transfer volume.

## Rollover without touching active readers

At sequence 0 or 1, the corresponding bank's tag wraps to one. Every owner
scrubs the full 16-row capacity of **that selected bank only**, then completes
a wrap-generation handshake before any consumer accepts tag one. Two local grid
barriers surround that rare handshake. The ordinary reuse proof already makes
this selected bank safe to scrub; the other bank may still be read by a peer.

The following invocation scrubs the other bank when it becomes safe. Clearing
both banks together would violate the lifetime proof. Clearing only active rows
would leave stale tags that could match future generations after row expansion.

## Synchronization and arithmetic

| Local grid barrier purpose | Single-bank LL | Double-buffer LL |
| --- | ---: | ---: |
| Attention reduction / result availability | 2 | 1 |
| Normalized inputs before W13 | 1 | 1 |
| SwiGLU results before W2 | 1 | 1 |
| FFN reduction completion / reuse | 2 | 0 |
| Both reductions enabled, normal path | 6 | 3 |

The remaining attention barrier makes the reduced scratch rows available to
RMSNorm across CTAs. After FFN reduction, ordinary kernel completion supplies
the local completion boundary. FFN-only double buffering has two normal grid
barriers; attention-only has three. Rollover adds two per wrapping arena.
There is no normal-path READY/DONE exchange. LL polling, CTA barriers, local
sequence loads/stores, and the once-per-forward fault collective still exist.

W2 publishes packed BF16 results directly into the selected bank. Rank-ordered
FP32 summation, BF16 rounding, layer-scale placement and separate residuals are
unchanged. This remains one-shot all-reduce. Neither reduction adds a kernel
launch. No performance improvement is claimed without measurements.

## Validation and diagnostics

74 host tests passed, including exhaustive finite TP2/TP4 models with variable
row counts, independently progressing word producers, reuse and two tag wraps.
Negative variants demonstrate overwrite with one bank, overwrite when both
banks are scrubbed together, and stale acceptance without rollover scrubbing. These models assume coherent atomic words and
whole-kernel stream order; they are not hardware proofs.

112 gfx1201 ISA-generation variants passed: 32 FFN variants for each of three
protocols and eight bit-pattern probes for each LL protocol. The generated
packed accesses use system-scope 64-bit loads/stores. New FFN variants show no
private-memory spills in the inspected metadata. ELF linking, GPU numerics,
IPC coherence, live occupancy, replay, fault injection and latency remain
**unverified here because no AMD GPU is available**.

The GPU stress test alternates bank usage and row counts, inserts zero-row
launches, delays different ranks, verifies every active CTA's next sequence,
and checks that DONE remains zero. Rollover tests poison both banks with stale
tags, including rows inactive during each scrub. The numerical and graph tests
retain the independent reference and padding checks. FFN fault injection drops
one CTA's packed publication while retaining its reader to detect the timeout.

Diagnostic sites: attention LL polling 50, local result barrier 52, rollover
55–57; FFN LL polling 60, rollover 65–67; transport probe 70–77, with 71 indicating
a bit-pattern mismatch. Existing computation barriers retain sites 1 and 2.

See `VALIDATION.json`, `validation/double_host_tests.txt` and
`validation/double_isa/compile_report.json`. `ll_double.patch` is a portable
source/docs patch against the extracted 0.4.4 package root; the ZIP also includes
the generated validation evidence and refreshed hash manifest.
