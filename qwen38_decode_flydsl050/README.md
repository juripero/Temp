# Qwen 27B TP1 BF16 FFN — FlyDSL 0.5.0 / gfx1201

This is the FlyDSL replacement for the previously supplied HIP implementation.
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

TP1, PP1, unquantized BF16, no LoRA/speculative decoding, and gfx1201 are required.
VRAM is assumed sufficient for the weights. Stock vLLM retains attention,
DeltaNet state, KV caches, embeddings, and final normalization. The vLLM adapter
requires **`--enforce-eager`**; full vLLM graph/Dynamo integration is not provided.

## Implementation

One persistent launch performs residual addition, post-attention RMSNorm,
gate/up projection, SwiGLU, and down projection for 1–16 physical rows. Attention
and layer-scale multiplications remain in the existing executor. The grid is
1–64 workgroups, each with 128 threads / four Wave32 waves; the default is 64.

| Release API | Use |
|---|---|
| `fx.rocdl.WMMA(16, 16, 16, fx.BFloat16, fx.Float32)` | Selects the gfx120x BF16 atom, with eight BF16 elements per operand per lane |
| `fx.make_mma_atom` | Constructs the architecture-specific MMA atom |
| `fly.mma_atom_call_ssa` | Issues WMMA on vector fragments, following the release's RDNA4 test |
| `fx.gpu.shuffle_down(..., 32)` / `fx.SharedAllocator` | Wave32 norm reduction and shared inverse RMS |
| `fx.generic_load/store`, `fx.atomic_add/cas`, `fx.memory_fence` | Device-scope acquire/release generation barriers and sticky faults |
| `flyc.compile` with null typed pointers | Compiles without an implicit launch or live GPU buffers |
| `CompiledFunction.max_blocks_per_cu()` | Checks the actual compiled kernel's residency before use |
| `fx.Stream` | Launches on the current PyTorch ROCm stream |

The atom's correct mappings are retained: A/B use feature/token `lane % 16`
and K positions `(lane // 16) * 8 + j`; C uses token `lane % 16` and feature
`tile * 16 + (lane // 16) * 8 + j`. Each wave owns distinct feature tiles.
Gate and up accumulators round separately to BF16 before FP32 SwiGLU, then
round to BF16 before the down projection. RMSNorm uses the unrounded FP32
residual sum; only the residual output is rounded separately.

`mono/_flydsl_kernel.py` contains device code; `mono/a16w16.py` contains the host
compiler/launcher. The low-level SSA atom wrapper and `ASTRewriter.transform`
are intentionally pinned internal interfaces, used in the release's examples
and vLLM reference respectively. They are not claimed as version-independent
public APIs. No AITER dependency is introduced.

## Validation actually performed

- **12 host tests passed**, including executor parity, refusal paths, installer
  idempotence, null compile placeholders, and all 32×8 BF16 lane coordinates
  checked against the installed FlyDSL 0.5.0 atom.
- Python source compilation and integration edits on temporary copies of the
  pinned vLLM model files passed.
- Real FlyDSL tracing, MLIR lowering, and LLVM gfx1201 **ISA generation passed**
  for `(H,I,blocks) = (32,64,4), (5120,17408,64), (5120,17408,1)`.
  Generated assembly and resource reports are in `validation/isa/`.
- The full-size default specialization reports 45 VGPRs, 36 SGPRs, 24 bytes of
  fixed LDS, and zero private-segment bytes. These are compiler metadata,
  **not measured occupancy or throughput**.
- **ELF linking is unverified**: full compilation reached the linker and failed
  because the creation environment has no `ld.lld`/ROCm toolkit.
- **GPU numerical parity, live occupancy, graph replay, synchronization, fault
  injection, loaded-model quality, and speed were not tested**: no AMD GPU was
  available. ISA generation does not establish these properties.

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

## vLLM integration

The source-checked installer targets vLLM commit
`d64414d044a898c6db646dcecd122213accd1732`. It preserves backups and refuses
unrecognized source anchors. Review the dry-run diff before applying:

```bash
python install_vllm.py /path/to/vllm
python install_vllm.py /path/to/vllm --apply
```

The integration hooks are unchanged from the previous corrected package; the
installer is idempotent if those exact hooks are already installed. Reinstall
this package into the environment imported by the worker and restart workers.
First check the staged reference with `QWEN38_FFN_BACKEND=torch`. After GPU and
loaded-model qualification, select FlyDSL:

```bash
QWEN38_SPECIALIZED_DECODE=1 QWEN38_FFN_BACKEND=flydsl \
  vllm serve /path/to/checkpoint --dtype bfloat16 \
  --tensor-parallel-size 1 --enforce-eager
```

The backend defaults to `torch`. With specialized decode disabled, unknown or
mixed/prefill metadata, or more than 16 physical rows, the adapter uses stock
layers. Static support refusals are logged. Compiler or occupancy failures are
errors, not silent fallbacks. `QWEN38_FFN_CACHE_DIR`, if set, selects the
process-wide `FLYDSL_RUNTIME_CACHE_DIR`; conflicting values are rejected.

## Synchronization and performance contracts

Each runner owns fixed-capacity scratch, control `[arrivals, generation]`, and
sticky fault `[failed, site, CTA, generation]` buffers. Both barriers are
device-owned and advance across graph replays; uint32 wrap uses equality tests.
Every writing thread releases before arrival publication; every consuming
thread acquires after the CTA barrier. Inactive token loads are actually
predicated. Completed work stores each output only after the full K reduction.

Warmup compiles, queries residency, allocates state, and performs a no-access
`rows=0` launch to initialize the runtime before capture. The runner then binds
to one execution stream. Never overlap graphs that share its workspace. Keep
weights and runner alive, and rebuild after replacing weight storage. The
standalone graph test does not imply support for vLLM's graph infrastructure.

The spin limit is an iteration bound, not a wall-clock timeout. A barrier fault
is permanent: discard the step and stop the worker; there is no clear/resume
operation. Occupancy checks resource capacity, not exclusive scheduling under
competing processes. Qualify on an otherwise idle gfx1201 device.

This implementation has no benchmark-selected tiling, weight preshuffle, or
explicit prefetch pipeline. It is not a demonstrated replacement for
hipBLASLt on performance. Measure 1/2/4/8/16-row FFNs and full decode latency
against the staged and stock paths, using the same eager-mode setting.

## References

- [FlyDSL v0.5.0](https://github.com/ROCm/FlyDSL/tree/v0.5.0)
- [Release RDNA4 WMMA test](https://github.com/ROCm/FlyDSL/blob/v0.5.0/tests/kernels/test_rdna4_integer_wmma_atom.py)
- [Release memory and atomic wrappers](https://github.com/ROCm/FlyDSL/blob/v0.5.0/python/flydsl/expr/llvm.py)
- [Release compiler and occupancy API](https://github.com/ROCm/FlyDSL/blob/v0.5.0/python/flydsl/compiler/jit_function.py)
- [Original implementation](https://github.com/juripero/Temp/tree/dfebe6d884eeb6912a6fca247755fc257f6097cc/specialized_decode)
- [MiniMax specialized-decode reference](https://github.com/vllm-project/vllm/tree/d64414d044a898c6db646dcecd122213accd1732/vllm/models/minimax_m3/amd/specialized_decode)
- [Qwen model integration reference](https://github.com/vllm-project/vllm/blob/d64414d044a898c6db646dcecd122213accd1732/vllm/model_executor/models/qwen3_5.py)
