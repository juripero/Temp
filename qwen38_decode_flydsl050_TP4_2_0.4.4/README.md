# Qwen BF16 mono decode: fused attention and FFN-output reductions

Version **0.4.4**, FlyDSL **0.5.0**, target **gfx1201**, TP1/TP2/TP4.
Built on `juripero/Temp` commit **7fc6f18f31a072b127ada26bb64c9cd915ca872d**,
directory `qwen38_decode_flydsl050_TP4_2/qwen38_decode_flydsl050_TP4_2/qwen38_decode_flydsl050_TP4_2`.

New in 0.4.4: **`QWEN38_IPC_PROTOCOL=ll`** enables packed BF16/epoch words
for both fused reductions. The default `simple` retains 0.4.3's separate
READY/DONE protocol. See [LL_PACKING.md](LL_PACKING.md) for the design,
qualification commands, epoch rollover, and tradeoffs.

Set **`QWEN38_FFN_REDUCTION=ipc`** to absorb the FFN-output SUM into the
FlyDSL kernel. With `QWEN38_ATTENTION_INPUT=partial`, eligible decode runs
attention SUM, residual/RMSNorm, local W13/SwiGLU/W2, FFN-output SUM, and optional
attention/FFN layer scaling in **one persistent GPU launch per layer per rank**.
Stock attention computation and the once-per-forward fault check remain outside.

This is an extension of the HIP IPC package, not the separate RCCL variant.
The default `QWEN38_FFN_REDUCTION=collective` retains the preceding output
collective for controlled comparisons. No changes to checkpoint weights or
vLLM's existing TP sharding are required. Use one package variant at a time.

## Install and enable

Install the complete package in the Python environment used by the workers:

```bash
python -m pip install --no-deps -e .
python -m unittest discover -s tests -v
```

Keep your working `QWEN38_IPC_ALLOCATOR` and launch-time ROCr/HSA environment.
The new FFN mailbox uses the same allocator selection as the attention mailbox.
For the plain-hipMalloc path, the example is:

```bash
QWEN38_SPECIALIZED_DECODE=1 \
QWEN38_FFN_BACKEND=flydsl \
QWEN38_ATTENTION_INPUT=partial \
QWEN38_FFN_REDUCTION=ipc \
QWEN38_IPC_PROTOCOL=ll \
QWEN38_IPC_ALLOCATOR=hipmalloc \
  vllm serve /path/to/checkpoint --dtype bfloat16 \
  --tensor-parallel-size 2 --enforce-eager
```

Use `--tensor-parallel-size 4` for TP4. To return to the previous FFN collective,
restart all workers with `QWEN38_FFN_REDUCTION=collective`. Do not change modes
mid-run or use different modes on different ranks. Startup logs show the mode.
`QWEN38_FFN_BACKEND=torch` is a staged numerical reference; it does not fuse GPU
communication even when `ffn_reduction=ipc` is selected.

The vLLM installer is unchanged from 0.4.2. If that model integration is already
installed, update this package and restart workers. Otherwise the exact-source
installer targets vLLM commit `d64414d044a898c6db646dcecd122213accd1732`:

```bash
python install_vllm.py /path/to/vllm
python install_vllm.py /path/to/vllm --apply
```

Review the dry-run diff; the installer preserves backups and refuses unknown
source anchors. It disables only the attention output-projection reduction
when `partial` is selected. **Keep stock MLP reduction enabled**, because prefill
and ineligible decode still use it. Do not globally disable all collectives.
`ll_packing.patch` applies this update to the exact reviewed 0.4.3 Temp commit;
apply it from the Temp repository root, or install the supplied complete package.
The source patch omits generated validation artifacts and the hash manifest;
the downloadable package includes those files.
The older `ffn_reduction.patch` and `ipc_fix.patch` are historical patches.

## Supported model and execution

The original Qwen3.5-compatible dense 27B contract remains: model type
`qwen3_5_text`, 64 layers, hidden size 5120, intermediate size 17408, dense
SwiGLU, Gemma-style `1 + weight` RMSNorm and epsilon 1e-6. A checkpoint's name
alone does not establish compatibility; binding validates its configuration.

Unquantized BF16, TP1/2/4, PP1, and gfx1201 are required. LoRA, speculative
execution, and context parallelism are unsupported. We assume the weights fit
in VRAM. Stock vLLM retains attention/DeltaNet, KV/state caches, embeddings,
input normalization and final normalization. Eligible mono decode has 1–16
physical rows. This vLLM adapter still requires **`--enforce-eager`**.
Standalone graph qualification is supplied; vLLM graph/Dynamo integration is
not implemented. TP1 performs no peer communication, but the selected IPC
mode can still fuse FFN layer scaling into its local epilogue.

| Attention input | FFN reduction | Eligible FlyDSL decode | Fallback |
|---|---|---|---|
| `reduced` | `collective` | Local FFN, external FFN SUM | Stock layer |
| `partial` | `collective` | In-kernel attention SUM and local FFN, external FFN SUM | Explicit attention SUM, then stock norm/MLP |
| `reduced` | `ipc` | Local FFN and in-kernel FFN SUM | Stock layer |
| `partial` | `ipc` | Both SUMs and FFN inside one kernel | Explicit attention SUM, then stock norm/MLP |

Fallback rows, mixed/prefill metadata and unknown metadata are handled by the
existing executor. Partial attention always requires this adapter on every
forward; static refusal raises instead of passing unreduced attention to an
unmodified layer. Ineligible steps do not enter either peer protocol. Both
mailbox epochs advance once per eligible layer invocation, not per token.

## TP layout and numerical boundaries

| TP | Local intermediate | Local W13 `[gate_local; up_local]` | Local W2 |
|---|---:|---|---|
| 1 | 17408 | `[34816, 5120]` | `[5120, 17408]` |
| 2 | 8704 | `[17408, 5120]` | `[5120, 8704]` |
| 4 | 4352 | `[8704, 5120]` | `[5120, 4352]` |

Use vLLM's loaded shards directly. The test helper shards gate and up separately,
then concatenates the local portions; a contiguous split of global W13 is wrong.

For fused FFN reduction, each rank rounds its completed W2 result to BF16 before
publication. Every rank reads those BF16 partials in TP-rank order, accumulates
in FP32 and rounds the global SUM to BF16. Optional FFN scaling then applies
BF16 `(1 + scale)` with BF16 output rounding. It is not applied before the SUM
or repeated in the Python executor. The residual stays separate and replicated;
it is neither summed across ranks nor added again in the FFN epilogue.

FP32 rank-order accumulation can differ from stock RCCL's BF16 reduction tree,
especially at TP4. The GPU harness compares against that explicit reference
and reports TP1 differences separately. Compare loaded-model logits and quality;
bitwise identity to stock RCCL is not promised.

## Peer buffers and synchronization

The FFN mailbox is separate from the attention mailbox. Both have independent
READY/DONE/EPOCH/FAILED flags and independently exchanged pointer tables.
Each has a 512-byte header. At H=5120 and capacity 16:

| Protocol | Payload layout | Bytes per arena per GPU | Grid barriers with both reductions |
| --- | --- | ---: | ---: |
| `simple` (default) | BF16 array, separate READY flag | 164352 (160.5 KiB) | 10 |
| `ll` (opt-in) | Two BF16 values + uint32 epoch per uint64 | 328192 (320.5 KiB) | 6 normally |

Both arenas together use 641 KiB per GPU in LL mode and are reused across layers.
W2 writes directly into the FFN arena. In LL mode, each pair is stored with its
readiness epoch in a single aligned system-scope atomic uint64 operation.
Readers reduce the data from the accepted load, avoiding separate whole-buffer
READY publication. Every local reader still retires before DONE, and every owner
waits for all ranks' DONE before reusing its arena. The two compute grid barriers
also remain. LL reserves epoch zero; at rollover, a full-capacity scrub and a
wrap handshake add two grid barriers per wrapped arena before resuming at one.

Only owners write their payload/flags; peers use loads, not remote atomic RMWs.
The output collective is skipped only for the FlyDSL fused-FFN specialization;
the staged torch backend performs a reference FP32 collective instead.
Live kernel residency is checked before launch. GPU failures are sticky and
published to both active mailboxes; the model-forward fault collective remains.
Unexpected rank failure or transport failure requires stopping the TP group.

`QWEN38_IPC_ALLOCATOR=hipmalloc` uses exact-base `hipMalloc` export; the default
remains `uncached`. Both must support the required peer visibility on your
ROCm/driver/PCIe stack. Prior successful TP2 operation is useful evidence for
that setup, but the new direct W2 publication phase needs GPU qualification.
All ranks must reside on one host, use distinct GPUs, have directed peer access,
and see every TP GPU. Allocation and IPC mode settings must agree across ranks.

Keep the runner and weights alive while any graph references them. One runner
is bound to one serialized stream. Do not overlap graphs sharing its workspace.
Normal lifetime is until worker exit. For explicit teardown, destroy all such
graphs, then call `runner.close_peers_collective()` on **every TP rank**. It
retires FFN and attention imports before freeing their owner allocations.

## Validation and qualification

**66 host tests passed**. FlyDSL 0.5.0 tracing, MLIR lowering and LLVM
**gfx1201 ISA generation passed for 72 variants**: 64 FFN specializations
(32 per protocol) and 8 LL bit-pattern probe specializations. LL variants were
checked for system-scope 64-bit load/store instructions. Python syntax and
undefined-name checks passed. See `VALIDATION.json`, `validation/ll_host_tests.txt`,
and `validation/ll_isa/compile_report.json`. Earlier validation directories are
historical evidence and are not new GPU results.

No AMD GPU is available in the build environment. **ELF linking, GPU execution,
peer memory ordering, numerical parity on GPU, live occupancy, graph replay,
hardware fault injection, full-model quality and performance remain unverified.**
The host protocol model assumes acquire/release visibility; it does not prove
that hardware supplies it. See [FFN_REDUCTION.md](FFN_REDUCTION.md) for the
implementation map and diagnostic sites.

Run in your working ROCm environment, retaining its allocator/HSA settings:

```bash
python compile_smoke.py
# Or compiler-only ISA diagnostics without the ROCm linker:
python compile_smoke.py --isa-only

# First: TP2, small dimensions, both reductions and both scales.
QWEN38_IPC_ALLOCATOR=hipmalloc \
  torchrun --standalone --nproc-per-node=2 validate_tp.py \
  --attention-partials --attention-scale --ffn-reduction ipc --ffn-scale --small \
  --ipc-protocol ll --ll-stress 100

# Then: actual dimensions, replay, independent epoch wrap, and faults.
QWEN38_IPC_ALLOCATOR=hipmalloc \
  torchrun --standalone --nproc-per-node=2 validate_tp.py \
  --attention-partials --attention-scale --ffn-reduction ipc --ffn-scale \
  --ipc-protocol ll --ll-stress 1000 --graph --fault-test
```

Repeat with four processes for TP4 and compare with `--ipc-protocol simple`
(omit `--ll-stress` for simple). Also test `--ffn-reduction ipc` without
`--attention-partials`/`--attention-scale`, and the old `--ffn-reduction collective`
path without `--ffn-scale`. `validate.py` remains the original TP1 harness.
The standalone TP validator uses explicit process groups and their host groups;
serving uses vLLM's TP subgroup. CPU/Gloo subgroup qualification is available:

```bash
torchrun --standalone --nproc-per-node=4 validate_tp.py --cpu --small \
  --attention-partials --attention-scale --ffn-reduction ipc --ffn-scale \
  --tp-size=2 --fault-test
```

This removes approximately one separate FFN collective launch per eligible
layer, plus normally two pointwise launches if FFN layer scaling was enabled.
It does not eliminate communication traffic. Additional barriers, fences and
peer reads can outweigh launch savings; measure full decode latency against
`ffn_reduction=collective` with identical eager-mode and batch settings.

## Sources

- [Reviewed package](https://github.com/juripero/Temp/tree/7fc6f18f31a072b127ada26bb64c9cd915ca872d/qwen38_decode_flydsl050_TP4_2/qwen38_decode_flydsl050_TP4_2/qwen38_decode_flydsl050_TP4_2)
- [FlyDSL v0.5.0](https://github.com/ROCm/FlyDSL/tree/v0.5.0), commit `226cde8d2a84bc2687c8d69587607fddf0c16f2f`
- [HIP IPC contract](https://rocm.docs.amd.com/projects/HIP/en/latest/reference/hip_runtime_api/modules/device_management.html)
- [Pinned vLLM Qwen integration](https://github.com/vllm-project/vllm/blob/d64414d044a898c6db646dcecd122213accd1732/vllm/model_executor/models/qwen3_5.py)
