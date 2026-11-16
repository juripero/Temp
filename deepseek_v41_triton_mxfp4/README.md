# DeepSeek V4.1 gfx1201 Triton MXFP4 expert-cache adapter

This is a runnable **experimental eager-mode implementation**, not just adapter
pseudocode. It adds OAI `TRITON_UNFUSED` / `TRITON` MXFP4 handling to
`davetha/vllm-expert-cache` and includes the complete updated AMD `model.py`.
For DeepSeek V4.1, select `triton_unfused`; the fused OAI backend supports a
narrower activation set and must not be forced for an incompatible checkpoint.

The cache manager and gathers are Python/Triton kernels. This MXFP4 path does
**not** call `libexpertcache.so`. The copied upstream generic fallback still
needs its original HIP extension for other quantization formats.

Source baselines:

- [vLLM 9a6032d](https://github.com/vllm-project/vllm/tree/9a6032dbeebd8d78addcc8573119edfaf9daf3d9)
- [vllm-expert-cache 813b97f](https://github.com/davetha/vllm-expert-cache/tree/813b97ffc8c7646dc7a790a6ef956efcd45f9ece)
- Triton kernel tensor APIs reviewed for 3.5.1, 3.6, and 3.8. The 3.6 and 3.8
  wrapper APIs and cache kernels were checked locally; see `VALIDATION.md`.

## Included files

| File | Purpose |
|---|---|
| `vllm_expert_cache/backends/triton_mxfp4.py` | Layout preflight, full/slot wrapper and PrecisionConfig binding, apply interception |
| `triton_mxfp4_layout.py` in the same directory | Physical slab validation, layout-preserving slot allocation, version-compatible wrappers |
| `triton_mxfp4_cache.py` in the same directory | Device buffers, eager stream ordering, failure state |
| `triton_mxfp4_kernels.py` in the same directory | Deterministic LRU/LFU manager, remapping, byte gathers |
| `triton_mxfp4_offload.py` in the same directory | Repairs full wrapper references immediately after each layer's loading context exits |
| `vllm_expert_cache/backends/generic.py` | Dispatches MXFP4 to this adapter; retains upstream handling for other formats |
| `integration/vllm/models/deepseek_v41/amd/model.py` | Complete model integration; preserves upstream post-load/Mega-MHC methods |
| `install_vllm.py` | Hash-checked model installation with backup |
| `compile_gfx1201.py` | Offline AMDGPU compilation smoke test |
| `validate_vllm.py` | Separate-process cache-off/on generation comparison for TP1/2/4 |
| `tests/` | CPU/interpreter behavior checks and GPU/UVA qualification tests |

The remaining package files come from the reviewed upstream plugin. This is a
complete Python package; do not install two different copies of
`vllm_expert_cache` into the same interpreter.

## Install

Use the existing ROCm vLLM environment, with a Triton/triton_kernels pair that
already runs the uncached model on gfx1201. This archive does not replace the
attention backend, install a ROCm stack, or add missing upstream model support.

From this extracted directory, using that environment's Python:

```bash
uv pip install --python /path/to/venv/bin/python --no-deps -e .
/path/to/venv/bin/python install_vllm.py --vllm-root /path/to/vllm --apply
```

The installer accepts the reviewed upstream model or the previously supplied
guarded `model.py`. It refuses unknown edits. If your vLLM revision differs,
merge the hooks rather than replacing an unrelated revision's complete model.
Ensure the vLLM checkout you patch is the one imported by the serving interpreter.

Start with:

```bash
export EXPERT_CACHE_DISABLE=0
export EXPERT_CACHE_SLOTS=64
export EXPERT_CACHE_POLICY=lfu
export EXPERT_CACHE_DECAY=64
export VLLM_ROCM_USE_AITER_FUSION_SHARED_EXPERTS=0

vllm serve /path/to/DeepSeek-V4.1-Flash-MXFP4 \
  --tensor-parallel-size 1 \
  --enforce-eager \
  --kernel-config '{"moe_backend":"triton_unfused"}'
```

Use TP2 or TP4 by changing `--tensor-parallel-size`. Keep the model's existing
attention and MoE reductions enabled. This cache adapter does not implement or
take ownership of collectives. If `VLLM_PLUGINS` is restricted, its selected
plugin names must include `expert_cache`.

`EXPERT_CACHE_SLOTS` is **per MoE layer, per rank**, not a global model-wide
budget. It must be at least the model's top-k and smaller than its expert count
to activate caching. The model rejects graph serving, speculative decoding,
EP/EPLB, DP/context parallelism, DBO/ubatching, LoRA, fused shared-expert slots,
and MonoDecode/MegaMoE while caching is requested. Separate shared experts keep
their stock path. In-process weight reload/refit and sleep/wake relocation are
not supported; restart the worker when changing weights or storage placement.

## Host offloading and memory

Caching alone does not move full weights out of VRAM. With resident sources it
adds slot memory. To reclaim VRAM, use vLLM's **UVA offloader** and select the
four routed-expert parameter names:

```bash
--offload-backend uva --cpu-offload-gb <per-rank-budget> \
--cpu-offload-params w13_weight w2_weight w13_weight_scale w2_weight_scale
```

Confirm those flags against the pinned vLLM environment. Parameters must remain
GPU-readable CUDA/HIP views of pinned host storage; ordinary CPU tensors and
functional-call/prefetch offloading are rejected. Keep UVA enabled. Some layers
may remain GPU-resident if the offload budget is partial.

The loader can relocate parameters after MXFP4 conversion. The adapter rebuilds
full wrappers from the final registered parameter storage, including scales.
An earlier reference-maintenance hook also refreshes existing wrappers after
each layer's loading context exits, so stale GPU aliases do not accumulate
through the entire model load. This hook runs for the uncached UVA baseline too;
it neither arms a cache nor repeats quantization.
It never copies a stale wrapper's earlier GPU storage into cache slots. All
references and cached contents require a fixed source after the first forward.

Approximate extra slot memory is `S/E` times each layer's local converted routed
weights, scales, and any biases, plus small metadata. Loading still needs the
upstream per-layer conversion workspace. Large prefill batches use the original
full-expert path, which can be slow when sources live in host memory.

## Validation on the target machine

```bash
/path/to/venv/bin/python -m pytest tests -q
/path/to/venv/bin/python compile_gfx1201.py
/path/to/venv/bin/python validate_vllm.py --model /path/to/checkpoint --tp 1
/path/to/venv/bin/python validate_vllm.py --model /path/to/checkpoint --tp 2
/path/to/venv/bin/python validate_vllm.py --model /path/to/checkpoint --tp 4
```

Add the same offload settings for both sides with `--engine-json`, for example
`{"max_model_len":2048,"max_num_seqs":1,"enable_prefix_caching":false,"seed":17,"offload_backend":"uva","cpu_offload_gb":32,"cpu_offload_params":["w13_weight","w2_weight","w13_weight_scale","w2_weight_scale"]}`.
Choose the memory budget for your actual model and hardware. Tests intentionally
fail if the cached subprocess never reports adapter activation.

The end-to-end script compares greedy tokens and chosen-token log probabilities;
it does not measure full-logit agreement, model quality, or speed. Run longer
workloads and your model evaluations before relying on the adapter. A raw-kernel
graph replay experiment is included, but passing it does not enable graph serving.

See `DESIGN.md` for storage bindings, cache policy, TP behavior, and graph work.
