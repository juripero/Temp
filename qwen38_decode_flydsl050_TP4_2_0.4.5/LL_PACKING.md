# Single-bank LL packing introduced in 0.4.4

This protocol remains selectable as `QWEN38_IPC_PROTOCOL=ll` in 0.4.5.
For two banks without normal-path DONE, use `ll_double` and read
[DOUBLE_BUFFER.md](DOUBLE_BUFFER.md). The counts below describe the 0.4.4 baseline.

This extends the linked 0.4.3 source at Temp commit
`7fc6f18f31a072b127ada26bb64c9cd915ca872d`. Both reductions remain direct peer-read,
one-shot SUMs inside the same FlyDSL kernel. LL changes their transport protocol;
it does not introduce a ring or call RCCL for their payload reductions.

## Enable

Install this complete package, then restart every TP worker with:

```bash
export QWEN38_SPECIALIZED_DECODE=1
export QWEN38_FFN_BACKEND=flydsl
export QWEN38_ATTENTION_INPUT=partial
export QWEN38_FFN_REDUCTION=ipc
export QWEN38_IPC_PROTOCOL=ll
export QWEN38_IPC_ALLOCATOR=hipmalloc
```

Keep the allocator and HSA environment that work on your machine; `hipmalloc`
above matches the explicit-base allocation option. TP2 and TP4 use the same
setting. `QWEN38_IPC_PROTOCOL=simple` restores the 0.4.3 transport at restart.
This is a package-specific switch; `NCCL_PROTO=LL` does not select this kernel.
Startup checks reject mismatched protocol/layouts. Never change the mode while
workers or captured graphs are alive. The default stays `simple` pending hardware
qualification and comparison on your topology.

The existing vLLM integration still requires `--enforce-eager`. The standalone
runner's graph qualification remains available; this update does not remove
the integration guard. Stock attention, prefill, ineligible decode and the
once-per-forward fault collective retain their existing execution paths.

## Word layout and execution

| Bits | Meaning |
| --- | --- |
| 0–15 | First BF16 value, raw bits |
| 16–31 | Second BF16 value, raw bits |
| 32–63 | uint32 epoch; zero is invalid |

The arena data area and every word are aligned to eight bytes. Producers use
an atomic scalar uint64 store with release ordering and system scope. Consumers
poll with atomic scalar uint64 acquire loads at system scope, checking the
upper half and using the lower half from that exact accepted load. They do not
reload payload separately. No remote atomic read-modify-write is used.

Attention partials are packed from the existing input tensor. The W2 epilogue
packs two adjacent accumulator results after BF16 rounding and writes them
directly to the FFN arena. Each lane owns these adjacent features in the pinned
gfx1201 WMMA layout. No separate packing kernel or W2 staging copy is added.
Consumers sum ranks in fixed rank order in FP32, round the sum to BF16, and
apply optional layer scaling once afterward, as in 0.4.3. Residuals are separate.

Publication requires no whole-buffer READY handshake on the normal path.
Different resident CTAs may reach their read loops at different times. All CTAs
must fit concurrently; the existing occupancy check remains mandatory. W2 is
still tiled as before: this is not a new per-tile compute/communication pipeline.

## Retirement and rollover

After reducing their words, all readers execute a system fence and local grid
barrier. CTA0 publishes DONE and waits for every rank's DONE. It then advances
the local epoch, followed by a second grid barrier. These acknowledgments are
essential: inline flags alone do not protect a slow reader against overwrite.

A fast rank cannot overwrite a DONE value before a slow rank observes it:
publishing the next DONE requires consuming next-epoch payload from every rank,
including the slow rank, which cannot publish that payload before leaving its
previous DONE wait. This depends on all ranks issuing the same nonempty sequence
of reductions with the same physical row counts. A violated participation
contract is a job failure, not a recoverable fallback.

LL epoch sequence is `1 … 0xffffffff, 1 …`; zero is never published as ready.
At rollover, every owner clears **all 16 rows of capacity**, including inactive
rows, to zero words. Two additional grid barriers and a cross-rank handshake
on an independent READY wrap-generation counter ensure all scrubs finish before
any rank accepts epoch one. Clearing only current rows, or using a sentinel
that is also a valid future epoch, would allow stale data to appear ready.
Simple mode retains its original modulo-2^32 epoch sequence.

| Configuration | Simple grid barriers | LL normal grid barriers |
| --- | ---: | ---: |
| TP1 / neither fused reduction | 2 | 2 |
| One fused reduction | 6 | 4 |
| Both fused reductions | 10 | 6 |

Rollover adds two barriers per wrapped LL arena. Attention and FFN arenas have
independent payloads, epochs, wrap counters and pointer tables.

## Hardware qualification and tradeoffs

Generated gfx1201 ISA is checked for `global_load_b64` and `global_store_b64`
with `scope:SCOPE_SYS`. The source uses FlyDSL 0.5.0's LLVM atomic APIs, following
the [LLVM AMDGPU memory model](https://llvm.org/docs/AMDGPUUsage.html#memory-model).
This avoids assuming that a normal vector store is atomic. Compiler output is
not a substitute for confirming atomic visibility through your actual IPC
mapping, allocation type, ROCm driver and PCIe topology.

Classic LL uses half its word for flags. At H=5120, a single row has 10 KiB of
BF16 payload and 20 KiB of packed words. Each full-capacity arena uses 320.5 KiB
including its header; two arenas use 641 KiB per GPU. Polling retries add traffic.
Per-word acquire/release ordering also has a cost. Fewer global barriers may
help small decode messages, but no latency improvement has been measured here.
Compare `simple` and `ll` with the same batch size, allocator, eager settings
and topology. This update changes synchronization, not the number of mono launches.

Run first on TP2, then repeat with four processes:

```bash
python -m unittest discover -s tests -v
python compile_smoke.py --isa-only --protocol both

QWEN38_IPC_ALLOCATOR=hipmalloc \
torchrun --standalone --nproc-per-node=2 validate_tp.py \
  --ipc-protocol ll --attention-partials --attention-scale \
  --ffn-reduction ipc --ffn-scale --small --ll-stress 100

QWEN38_IPC_ALLOCATOR=hipmalloc \
torchrun --standalone --nproc-per-node=2 validate_tp.py \
  --ipc-protocol ll --attention-partials --attention-scale \
  --ffn-reduction ipc --ffn-scale --ll-stress 1000 --graph --fault-test
```

Also qualify attention-only and FFN-only combinations. `--ll-stress` uses the
serving publication/polling/retirement primitives to transfer epoch-, rank- and
index-dependent raw BF16 bit patterns. It checks both halves without floating
point arithmetic, varies row counts, and deliberately seeds stale tags across
rollover. The numerical tests cover rank order, scaling, residual handling and
graph padding. Fault injection drops a producer CTA; all steps after a failure
must be discarded and the worker group stopped. There is no automatic protocol
switch after a failed launch.

Diagnostic sites: attention LL polling 50, retirement 52, reuse barrier 53,
DONE wait 54, wrap barriers/wait 55–57; FFN uses 60/62/63/64/65–67; the bit-pattern
probe uses 70–77 (71 means a payload mismatch). Which site wins on a failure
can depend on scheduling. The first fault is sticky.

## Files and evidence

`mono/_ll_kernel.py` supplies word packing and polling; `mono/_flydsl_kernel.py`
integrates both reductions and rollover; `runtime/peer.py` allocates and agrees
on the expanded layout; configuration, integration and launcher code propagate
the protocol. `mono/ll_probe.py`, `validate_tp.py`, `tests/test_ll.py` and
`compile_smoke.py` provide qualification support.

66 host tests and 72 ISA-generation variants passed. No AMD GPU was available:
GPU numerics, IPC coherence, graph execution, fault injection, ELF linking and
performance are **not validated**. See `VALIDATION.json` for exact evidence.
