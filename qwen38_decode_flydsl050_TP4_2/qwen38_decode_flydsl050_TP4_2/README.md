# Qwen 27B TP1 / TP2 / TP4 — fused attention SUM + BF16 FFN

Package 0.4.2, FlyDSL 0.5.0, gfx1201.

For `hipIpcGetMemHandle failed: invalid argument`, see [IPC_TP2_FIX.md](IPC_TP2_FIX.md).
Version 0.4.2 adds **`QWEN38_IPC_ALLOCATOR=hipmalloc`**, using plain `hipMalloc`
and exporting its exact base. This is an explicit allocation-compatibility
option; the default remains `uncached`. Changing memory type does not by itself
qualify the persistent peer protocol's cache visibility. Run the supplied GPU
validator before using the option for serving. No GPU was available here.

This adds an opt-in attention all-reduce **inside the persistent FlyDSL kernel**
for TP2/TP4. vLLM computes each rank's attention output-projection partial; the
kernel sums it before residual addition and RMSNorm. TP1 and the previous
already-reduced attention mode remain supported. This is experimental code:
host tests and gfx1201 ISA generation passed; no GPU execution was available.
The GPU kernel is Python FlyDSL, with native RDNA4 BF16 WMMA. There is no embedded
HIP/C++ source, PyTorch extension loader, or custom HIP compilation step. FlyDSL
still uses ROCm's linker and HIP runtime to load and launch GPU code.

Pinned release: **ROCm/FlyDSL v0.5.0**, commit
`226cde8d2a84bc2687c8d69587607fddf0c16f2f`. Runtime compilation rejects other
FlyDSL versions and targets. This package replaces the old `specialized_decode`
package; install one variant at a time.

## Model contract

The requested “Qwen3.8 27B” keeps the Qwen3.5-compatible architecture assumed by
the original source: `qwen3_5_text`, 64 layers, hidden size 5120, intermediate size
17408, dense SwiGLU, and Gemma-style `1 + weight` RMSNorm with epsilon 1e-6.
The adapter checks these properties rather than treating the model name as a
guarantee. A different checkpoint layout requires another adapter.

TP1/TP2/TP4, PP1, unquantized BF16, no LoRA/speculative decoding, and gfx1201 are required.
VRAM is assumed sufficient for the weights. Stock vLLM retains attention,
DeltaNet state, KV caches, embeddings, and final normalization. The vLLM adapter
requires **`--enforce-eager`**; full vLLM graph/Dynamo integration is not provided.

## Implementation

With `QWEN38_ATTENTION_INPUT=partial`, one persistent launch per rank performs:

1. Publish BF16 attention partials into dedicated IPC peer buffers.
2. Wait for every TP rank, then sum peer partials in FP32 in TP-rank order.
3. Round attention to BF16 and apply optional attention layer scaling.
4. Add the replicated residual once, compute post-attention RMSNorm, and run
   the local gate/up, SwiGLU, and down projections.

The runner then enqueues the existing BF16 **FFN-output SUM** through the vLLM
TP group, followed by optional FFN layer scaling in the executor. That output
collective remains separate. The new path removes the separate attention
all-reduce launch for eligible decode steps; it does not eliminate its network
traffic or fuse both tensor-parallel reductions into one collective.

Attention computation, input norm, and caches remain in stock vLLM. The fused
path accepts 1–16 physical rows. The grid is 1–64 workgroups of 128 threads / four
Wave32 waves; the default is 64, subject to a live residency check.

| Release API | Use |
|---|---|
| `fx.rocdl.WMMA(16, 16, 16, fx.BFloat16, fx.Float32)` | Selects the gfx120x BF16 atom, with eight BF16 elements per operand per lane |
| `fx.make_mma_atom` | Constructs the architecture-specific MMA atom |
| `fly.mma_atom_call_ssa` | Issues WMMA on vector fragments, following the release's RDNA4 test |
| `fx.gpu.shuffle_down(..., 32)` / `fx.SharedAllocator` | Wave32 norm reduction and shared inverse RMS |
| `fx.generic_load/store`, `fx.atomic_add/cas`, `fx.memory_fence` | Device-scope grid barriers and sticky faults |
| `fx.SyncScope.System` with acquire/release loads, stores, and fences | Inter-GPU publication and retirement of IPC attention buffers |
| `flyc.compile` with null typed pointers | Compiles without an implicit launch or live GPU buffers |
| `CompiledFunction.max_blocks_per_cu()` | Checks the actual compiled kernel's residency before use |
| `fx.Stream` | Launches on the current PyTorch ROCm stream |

The atom's correct mappings are retained: A/B use feature/token `lane % 16`
and K positions `(lane // 16) * 8 + j`; C uses token `lane % 16` and feature
`tile * 16 + (lane // 16) * 8 + j`. Each wave owns distinct feature tiles.
Gate and up accumulators round separately to BF16 before FP32 SwiGLU, then
round to BF16 before the down projection. RMSNorm uses the unrounded FP32
residual sum; only the residual output is rounded separately.

`mono/_flydsl_kernel.py` and `mono/_peer_kernel.py` contain GPU code;
`mono/a16w16.py` contains the compiler/launcher; `runtime/peer.py` owns IPC setup;
`runtime/parallel.py` contains the standard collective adapters. The low-level SSA atom wrapper and `ASTRewriter.transform`
are intentionally pinned internal interfaces, used in the release's examples
and vLLM reference respectively. They are not claimed as version-independent
public APIs. No AITER dependency is introduced.

## Tensor-parallel layout and ordering

`DecodeConfig.intermediate_size` remains the global size. Its
`local_intermediate_size` property is `intermediate_size // tp_size`.
The vLLM adapter obtains TP size and rank from `get_tp_group()` automatically.
Do not shard loaded vLLM tensors again: production binding is zero-copy.

| Mode | Local intermediate | Local W13 `[gate_local; up_local]` | Local W2 |
|---|---:|---|---|
| TP1 | 17408 | `[34816, 5120]` | `[5120, 17408]` |
| TP2 | 8704 | `[17408, 5120]` | `[5120, 8704]` |
| TP4 | 4352 | `[8704, 5120]` | `[5120, 4352]` |

For rank `r`, take its `I/TP` rows from **each** gate/up projection and its
matching columns of W2. Splitting the fused global `[gate; up]` matrix into
contiguous `2I/TP` chunks is incorrect. `shard_reference_weights()` demonstrates
the correct split for validation; production uses vLLM's existing shards.

There are two explicit input contracts:

| Setting | vLLM attention projection | Decode boundary | Prefill / ineligible step |
|---|---|---|---|
| `QWEN38_ATTENTION_INPUT=reduced` (default) | SUM enabled | Previous local FFN kernel | Original stock layer |
| `QWEN38_ATTENTION_INPUT=partial` | SUM disabled | Fused IPC attention SUM + local FFN | Explicit TP SUM, then stock post norm and MLP |

Post-attention RMSNorm weights and residuals stay replicated. Each rank adds
the residual exactly once; residual outputs are never reduced or divided by
TP. The local down output rounds to BF16 before its standard SUM. The returned
all-reduce tensor is authoritative because vLLM can reduce out-of-place.

The attention sum is **rank-ordered FP32 accumulation of BF16 partials**, rounded
to BF16 before scaling/norm. The staged torch backend and prefill fallback use a
standard FP32 TP SUM followed by BF16 rounding; their collective ordering can
differ from the fused kernel. Neither is guaranteed bitwise identical to a
stock RCCL BF16 reduction tree. Validate actual-model logits and quality.

Fused attention requires all TP GPUs on one host with full directed peer access,
working HIP IPC, and a qualified allocation/memory-order combination.
The original path uses uncached device allocations; the explicit `hipmalloc`
option changes that assumption and requires separate hardware qualification. Every process must see all TP
GPUs, with a distinct physical PCI bus ID per rank. Startup checks these
conditions, matching host/boot identities, and handle/layout consistency. An
unsupported IPC topology raises an error. It does not silently resume with
unreduced attention. Cross-node fused attention is not supported. No XGMI
assumption is made; PCIe functionality and performance need hardware testing.

`runtime/_hip_ipc.py` is adapted from the HIP **host** allocation/IPC wrapper in
FlyDSL v0.5.0 (see `NOTICE.txt` and `LICENSE_FLYDSL`), with local error diagnostics
and explicit device selection. It uses ctypes for setup,
not HIP/C++ GPU kernels. The release's gfx942-specific custom-all-reduce assembly
is not used. LLVM lowers generic FlyDSL system-scope operations for gfx1201.

Each rank allocates 512 header bytes plus `16 * 5120 * 2` data bytes = **164352
bytes** of IPC storage, plus 160 KiB of private attention scratch. Peer imports
map existing storage. Only the owner writes its flags; remote operations are
loads, with no remote atomic read-modify-write. The attention payload and FFN
output payload are each 10–160 KiB per rank, not total interconnect traffic.

At startup, participating ranks compare specialization settings and aggregate
support/binding/compilation errors. All workers must receive the same enable
flag/backend and execute the same layer/collective sequence. Configuration
disagreement fails; a static support refusal is shared by the TP group. At the
end of every integrated forward, one additional int32 SUM propagates completed
kernel faults to the whole TP group. A remote fault becomes locally sticky;
its local diagnostic site may remain zero. Unexpected rank exceptions, killed
workers, and transport failures require termination of the whole TP worker
group; bounded local grid waits do not provide distributed failure recovery.

## Validation actually performed

- **48 host tests passed** in version 0.4.2: 15 IPC diagnostics/cleanup cases plus
  the 33 existing tests, including TP tests and attention SUM,
  residual, layer-scale, prefill, double-reduction guard, topology-refusal, and
  installer tests. TP1/TP2/TP4 use real CPU tensor math with threaded simulated
  collectives, not Gloo/RCCL or GPUs.
- An abstract READY/DONE protocol test explores all interleavings of three
  epochs for TP2 and TP4 across uint32 rollover. It checks publication, no
  premature overwrite, and progress assuming acquire/release ordering. It
  does not validate the GPU/interconnect memory model.
- All Python sources compiled. Installer application, AST validity, and
  idempotence passed on temporary copies of the pinned vLLM sources, both
  fresh and upgraded from the preceding model-loop patch.
- Real FlyDSL tracing, MLIR lowering, and LLVM **gfx1201 ISA generation passed
  for 16 variants**: small/full dimensions, TP1/2/4, reduced/partial inputs,
  and first/last peer ranks for partial TP2/4. Peer variants contain
  `scope:SCOPE_SYS` operations. See `validation/isa/compile_report.json`.
- Full-size fused-peer variants report 45 VGPRs, 36 SGPRs, 24 fixed LDS bytes,
  and zero private-segment bytes. These are compiler metadata, not measured
  occupancy or throughput.
- Real CPU/Gloo validation in the preceding TP work was blocked at socket
  initialization (`Operation not permitted`). No distributed pass is claimed.
- **ELF linking, HIP IPC mappings, GPU numerical parity, live residency,
  multi-GPU memory ordering, graph replay, fault injection, loaded-model quality,
  and performance remain unverified**. No AMD GPU or ROCm linker was available.
  ISA generation cannot establish those properties.

## Install and qualify

Use your existing ROCm PyTorch/vLLM environment and ROCm development toolkit
(including `ld.lld`). Keep your ROCm torch installation:

```bash
python -m pip install --no-deps flydsl==0.5.0
python -m pip install -e . --no-deps
python -m unittest discover -s tests -v
python compile_smoke.py
python validate.py --small --graph --fault-test
python validate.py --graph --fault-test

# One process per GPU; ROCm PyTorch calls its RCCL backend "nccl".
torchrun --standalone --nproc-per-node=2 validate_tp.py --attention-partials --attention-scale --small --graph --fault-test
torchrun --standalone --nproc-per-node=4 validate_tp.py --attention-partials --attention-scale --small --graph --fault-test
torchrun --standalone --nproc-per-node=2 validate_tp.py --attention-partials --attention-scale --graph --fault-test
torchrun --standalone --nproc-per-node=4 validate_tp.py --attention-partials --attention-scale --graph --fault-test
```

`compile_smoke.py` defaults to full ELF compilation without a GPU and fails
nonzero on a linker/compiler error. For a host without the ROCm linker:

```bash
python compile_smoke.py --isa-only
```

The latter uses the compiler's assembly output mode in a separate diagnostic
process, disables disk caching, and never executes or installs the resulting
assembly. It is not a substitute for full compilation and GPU qualification.
Do not set `COMPILE_ONLY=1`; typed null pointers already suppress execution.

GPU validation checks residuals, norm scratch, SwiGLU scratch, and output at
1/2/3/4/7/8/15/16 rows, generation wrap, repeated standalone graph replay with
poisoned padding, and a dropped-CTA timeout. Default comparison thresholds are
`atol=0.03125`, `rtol=0.02`; residual outputs must match exactly. Diagnose
mismatches rather than simply increasing tolerances. Also compare actual-model
layer outputs, logits, deterministic generations, and evaluation quality.

`validate.py` remains the TP1 GPU test. `validate_tp.py` compares against both
an identical-TP staged reference and the unsharded TP1 result (allowing BF16
partition/reduction differences). It checks all-reduced outputs on every rank,
residuals, local scratch, generation wrap, optional graph replay, and propagation
of a rank-zero injected timeout. `--attention-partials` supplies different
partials on each rank and checks the summed attention scratch. It also seeds
peer epochs at `0xFFFFFFFE` and runs through `0xFFFFFFFF`, `0`, and `1`.
`--attention-scale` checks deferred attention scaling. In partial GPU mode,
all ranks enter the fault-injected kernel, exercising peer failure waits too. TP graph support remains unqualified until
these tests pass on your ROCm/RCCL stack; vLLM serving remains eager.

For actual CPU/Gloo checks on a machine that permits local sockets:

```bash
torchrun --standalone --nproc-per-node=2 validate_tp.py --attention-partials --attention-scale --cpu --small --fault-test
torchrun --standalone --nproc-per-node=4 validate_tp.py --attention-partials --attention-scale --cpu --small --fault-test
# Two independent TP2 groups; tests subgroup isolation.
torchrun --standalone --nproc-per-node=4 validate_tp.py --attention-partials --attention-scale --cpu --small --tp-size=2 --fault-test
```

The CPU simulation is included in `python -m unittest discover -s tests -v`.
It does not exercise Gloo or RCCL. Standalone callers must pass an initialized,
explicit `TorchTpCollective(group, host_group)` to `FfnRunner` for TP2/TP4 and put the
corresponding `tp_size` and `tp_rank` in both config and `LayerWeights`.
The IPC host group must be Gloo with the same membership/order as the device
TP group. The validator constructs both. Also run validation without
`--attention-partials` to qualify the original reduced-input path.

## vLLM integration

The source-checked installer targets vLLM commit
`d64414d044a898c6db646dcecd122213accd1732`. It preserves backups and refuses
unrecognized source anchors. Review the dry-run diff before applying:

```bash
python install_vllm.py /path/to/vllm
python install_vllm.py /path/to/vllm --apply
```

The installer now also controls both Gated DeltaNet `out_proj` and full-attention
`o_proj` reduction through their constructors. It adds `.qwen38.v4.bak` backups,
leaving previous `.qwen38.bak` backups intact, and is idempotent. Re-run it even
if the earlier model-loop patch is already installed. Reinstall this package
into the environment imported by the worker and restart all workers.
First check the staged reference with `QWEN38_FFN_BACKEND=torch`. After GPU and
loaded-model qualification, select FlyDSL:

```bash
QWEN38_SPECIALIZED_DECODE=1 QWEN38_ATTENTION_INPUT=partial \
QWEN38_FFN_BACKEND=flydsl \
  vllm serve /path/to/checkpoint --dtype bfloat16 \
  --tensor-parallel-size 2 --enforce-eager
```

Use `--tensor-parallel-size 4` for TP4 or `1` for TP1; no other TP-specific
environment setting is needed beyond the partial-input opt-in above. Set the specialized-decode enable/backend flags
consistently on every worker. The integration does not create process groups;
vLLM initializes and owns them.

The backend defaults to `torch`. With `partial` selected, the adapter must run
on **every** forward. Unknown/mixed/prefill metadata and >16 rows use the explicit
fallback that restores attention SUM before stock norm/MLP. Disabling the adapter,
missing its model config, or refusing static support raises an error in partial
mode. Calling the original unmodified layer after disabling attention SUM would
be incorrect. Reduced mode retains the previous stock-layer fallback behavior.

Use the supplied `QWEN38_ATTENTION_INPUT` setting, not a global “disable all
reduces” switch. Keep the MLP down-projection reduction enabled for fallback,
and keep other model collectives enabled. Binding checks attention projection
`reduce_results` and rejects attention output bias in partial mode. Every
worker must agree on settings before construction; do not change them mid-run. Compiler or occupancy failures are
errors, not silent fallbacks. `QWEN38_FFN_CACHE_DIR`, if set, selects the
process-wide `FLYDSL_RUNTIME_CACHE_DIR`; conflicting values are rejected.

## Synchronization and performance contracts

Each runner owns fixed-capacity scratch, control `[arrivals, generation]`, and
sticky fault `[failed, site, CTA, generation]` buffers. The two compute barriers,
plus four peer-phase grid barriers in partial TP2/4 mode, are device-owned
and advance across graph replays; uint32 wrap uses equality tests.
Every writing thread releases before arrival publication; every consuming
thread acquires after the CTA barrier. Inactive token loads are actually
predicated. Completed work stores each output only after the full K reduction.

Peer synchronization uses owner-written uint32 READY, DONE, EPOCH, and FAILED
words on separate 128-byte boundaries. Every producer finishes system-visible
stores before READY. Every consumer retires its peer reads before DONE. All
ranks acknowledge DONE before a later epoch can overwrite the one-bank mailbox.
Equality comparisons plus this two-phase protocol permit uint32 wrap without
host resets. A per-runner epoch advances per **layer invocation**, including
replays, not merely per token. All ranks must enter the same layer order with
the same physical row count and branch decision. There is no per-step host
metadata consensus; mismatched participation is a job failure.

Warmup compiles, queries residency, allocates state, and performs a no-access
`rows=0` launch to initialize the runtime before capture. The runner then binds
to one execution stream. Never overlap graphs that share its workspace. Keep
weights and runner alive, and rebuild after replacing weight storage. The
standalone graph test does not imply support for vLLM's graph infrastructure.
IPC memory has no destructor that could free storage while a graph references
it. Normally keep the runner/arena alive until worker exit. For explicit teardown,
destroy every referencing graph and call `runner.peer_arena.close_collective()`
on **all TP ranks**; it synchronizes, unmaps all imports, confirms retirement,
and only then frees owner allocations. Never call on just one rank.

The spin limit is an iteration bound, not a wall-clock timeout. A barrier fault
is permanent: discard the step and stop the worker; there is no clear/resume
operation. Occupancy checks resource capacity, not exclusive scheduling under
competing processes. Qualify on an otherwise idle gfx1201 device.

This implementation has no benchmark-selected tiling, weight preshuffle, or
explicit prefetch pipeline. It is not a demonstrated replacement for
hipBLASLt on performance. Measure 1/2/4/8/16-row FFNs and full decode latency
against the staged and stock paths, using the same eager-mode setting. Include
attention communication and the complete decoder layer in the measurement.
The mailbox copy, peer reads, six grid barriers, and system fences have real
costs. Saving a launch does not guarantee lower latency, especially on PCIe.

## References

- [FlyDSL v0.5.0](https://github.com/ROCm/FlyDSL/tree/v0.5.0)
- [Release RDNA4 WMMA test](https://github.com/ROCm/FlyDSL/blob/v0.5.0/tests/kernels/test_rdna4_integer_wmma_atom.py)
- [Release memory and atomic wrappers](https://github.com/ROCm/FlyDSL/blob/v0.5.0/python/flydsl/expr/llvm.py)
- [Release HIP host IPC wrapper](https://github.com/ROCm/FlyDSL/blob/v0.5.0/kernels/monokernel/ipc.py)
- [Release compiler and occupancy API](https://github.com/ROCm/FlyDSL/blob/v0.5.0/python/flydsl/compiler/jit_function.py)
- [Original implementation](https://github.com/juripero/Temp/tree/dfebe6d884eeb6912a6fca247755fc257f6097cc/specialized_decode)
- [MiniMax specialized-decode reference](https://github.com/vllm-project/vllm/tree/d64414d044a898c6db646dcecd122213accd1732/vllm/models/minimax_m3/amd/specialized_decode)
- [Qwen model integration reference](https://github.com/vllm-project/vllm/blob/d64414d044a898c6db646dcecd122213accd1732/vllm/model_executor/models/qwen3_5.py)

- [vLLM TP collectives](https://github.com/vllm-project/vllm/blob/d64414d044a898c6db646dcecd122213accd1732/vllm/distributed/communication_op.py)
- [vLLM TP linear layers](https://github.com/vllm-project/vllm/blob/d64414d044a898c6db646dcecd122213accd1732/vllm/model_executor/layers/linear.py)
