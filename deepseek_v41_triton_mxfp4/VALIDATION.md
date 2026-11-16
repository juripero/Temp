# Validation record

## Completed locally

- Syntax compilation of every delivered Python file.
- 33 CPU/interpreter tests passed; three hardware-only cases were skipped.
- The real Triton tensor-wrapper APIs from release/3.6.x and release/3.8.x were
  exercised. Both old `weight_scale` and new `b_mx_scale` PrecisionConfig field
  forms are covered. Test precision objects use small dataclass fixtures; the
  full vLLM quantization classes were not imported into this CPU-only runtime.
- The core adapter/cache suite passed with Triton 3.6.0 and 3.8.0. The expanded
  model-hook/offload suite was run with Triton 3.8.0.
- Manager and gather compiled to `amdgcn` and `hsaco` for `gfx1201`, wave32,
  with Triton 3.6.0 and 3.8.0. The final 3.8 compilation also covers int64 routing
  IDs. `gfx1201_compile_report.json` records the final offline compilation.
- The LRU/LFU manager was compared against an independent Python oracle over
  repeated hits, cold misses, eviction churn, duplicate IDs, -1 masks, empty
  requests, and LFU decay. The same Triton source ran in interpreter mode.
- Byte gathers were checked on normal and transposed tensors with odd slab
  sizes, so no assumption of a 16-byte-aligned expert slab goes untested.
- Public plugin `arm`/`apply` calls were checked with actual Triton wrappers and
  CPU cache storage. Tests cover scale rebinding, optional biases, full-path
  fallback, idempotence, exception restoration, initial pointer relocation, and
  rejection of changed source storage after the first call.
- A loading-context relocation was emulated to verify all four stale weight/
  scale storage aliases are rebound without arming or reprocessing weights.
- Fingerprints of 32 upstream methods verify that their ASTs are unchanged,
  including the decoder's Mega-MHC post-load method. Constructor branches and
  new cache hooks have separate checks.
- Installer checks covered compatibility detection, byte-for-byte backup,
  repeat installation, and refusal to overwrite unknown edits.
- Ruff checks passed for new adapter code, scripts, and tests. The full model
  check excludes `RUF012` for two unchanged upstream mutable class attributes.

Example host command (point the environment variable at an installed or checked
out compatible `triton_kernels` Python package parent):

```bash
TRITON_INTERPRET=1 TRITON_KERNELS_SRC=/path/to/python/triton_kernels \
  /path/to/venv/bin/python -m pytest tests -q
```

## Not established by these results

There was no GPU in the validation environment. No gfx1201 kernel was executed,
no real host-mapped UVA gather was measured, and no full DeepSeek model was
loaded. TP1/2/4 numerical parity, actual ROCm stream behavior, checkpoint
loading memory peaks, real PrecisionConfig/factory integration, and performance
remain hardware qualification work.

The CPU adapter tests calculate an expert-dependent checksum from weights,
scales, and biases to detect binding mistakes. They are not a substitute for a
real BF16/MXFP4 MoE numerical comparison. `validate_vllm.py` supplies a real vLLM
generation comparison; run it on the checkpoint and devices you intend to use.

The raw graph-replay test is an experiment for the device kernels. Graph serving
is deliberately refused by this release, even if that isolated test passes.
Triton 3.5.1 is covered by the reviewed API shape, not by a local execution test.
