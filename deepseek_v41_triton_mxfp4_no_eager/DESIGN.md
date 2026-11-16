# Adapter design

## Invariant

For every routed global expert `e` and its assigned slot `s`, all tensors used
by the two expert GEMMs must satisfy `slot[s] == full[e]` in their physical byte
layout. Routing weights stay unchanged. A global-to-slot ID rewrite is valid
only while both GEMM weights, both MX scales, any biases, and both precision
configs are bound to the same slot set.

The adapter handles finalized OAI Triton weight-only MXFP4 kernels on gfx1201.
It does not reinterpret CDNA scale swizzles, AITER layouts, or a W4A4 format as
the OAI W4A16 format. BF16 computation, activation/clamp behavior, routing-weight
placement, shared experts, and reductions remain the stock vLLM computation.

## Bindings

| Object read by vLLM | Full path | Cached path |
|---|---|---|
| `layer.w13_weight`, `w2_weight` | Final registered full parameters | Prebuilt slot parameters |
| `layer.w13_weight_triton`, `w2_weight_triton` | Full wrappers with logical expert size E | Slot wrappers with logical expert size S |
| Registered weight scales | Full E8M0 storage | Slot scale storage |
| `method.w13_precision_config`, `w2_precision_config` | Full MX scale wrappers | Cloned precision objects with slot MX scale wrappers |
| `method.moe_quant_config` | Factory-built full config | Factory-built slot config |
| `moe_kernel.fused_experts.quant_config` | Same full config | Same slot config |
| `layer.global_num_experts` | E | S |
| `topk_ids` | Global IDs | Slot IDs, preserving -1 |

PrecisionConfig uses `weight_scale` in the reviewed 3.5.1/3.6 API and
`b_mx_scale` in 3.8. Copying the precision dataclass preserves non-tensor
settings, including the microblock size and accumulation options. Unexpected
activation/output scale tensors or other unmapped quantization fields cause a
preflight failure.

For the usual unswizzled layout, with rank-local hidden/intermediate sizes H/I:

| Tensor | Physical torch shape after transpose | Logical Triton shape |
|---|---|---|
| W13 packed bytes | `[E, H/2, 2I]` | `[E, H, 2I]` |
| W2 packed bytes | `[E, I/2, H]` | `[E, I, H]` |
| W13 scales | `[E, H/32, 2I]` | Same |
| W2 scales | `[E, I/32, H]` | Same |

The implementation checks the actual converted tensors rather than assuming
these shapes. TP can change the local dimensions. Slot allocation preserves the
inner strides using `empty_strided`. Each expert must occupy a dense physical
slab, with no padding holes or overlapping experts. Gather copies raw bytes;
it does not dequantize or reswizzle. Odd slab lengths are masked correctly.
Wrapper reconstruction recomputes both `shape` and `shape_max` and rebuilds the
StridedLayout metadata for S experts.

## Load and invocation order

The existing global plugin loader is the only arming owner. vLLM first loads
and converts weights, then runs model hooks. The model hook validates the
adapter layout and records successful preflight. After vLLM finalization returns,
the global plugin dispatches to the adapter. No quantization pass is repeated.
Cache installation is idempotent; reload attempts invalidate caches and stop.

There is also a distinct, earlier storage-reference hook around
`device_loading_context`. Its action runs **after** the original context exits
and completes UVA relocation for a converted layer. It points the existing
weight and scale wrappers at the final registered parameters in place, keeping
all existing precision/config references coherent and releasing stale GPU
allocations before the next layer is processed. It never calls `arm` or a
quantization postprocessor. The model marks eligible routed-expert modules during
construction; unmarked modules are untouched. This maintenance also runs with
`EXPERT_CACHE_DISABLE=1` to make the UVA baseline valid.

On each fitting invocation:

1. Establish stream order and verify that source storage has not changed.
2. One CTA protects every currently needed resident expert, then assigns missing
   experts to free or least-priority unprotected slots. All metadata is on-device.
3. Gather missing physical slabs for weights, scales, and biases on the same stream.
4. Bind the complete slot object set, run the original quantization method with
   remapped IDs, and restore the full object set in `finally`.

A step fits when `tokens * top_k <= S`. This is a conservative host-metadata
decision: no GPU readback is needed, but a larger batch with few unique experts
can still fall back. Full-path calls always receive full wrappers and global IDs.
The policy state is updated only for cached invocations, not full-path prefill.

LRU gives all experts used in one invocation the same timestamp. LFU increments
once per distinct hit per cached invocation; optional periodic halving ages old
counts. Free slots win before eviction; slot index resolves ties. Duplicate IDs
do not cause extra loads. Needed residents cannot be evicted during that step.

## TP and synchronization

With EP disabled, every TP rank has all global expert IDs but only its weight
shards. Each rank caches those local shards. Cache tables do not have to be
identical between ranks: every local table only needs to preserve its own
`global expert -> correct local weight shard` relation. The adapter adds no
collective and changes none of vLLM's reductions.

A per-device submission lane orders all eager and captured calls sharing caches.
Concurrent host submissions are rejected. On stream changes, the lane inserts
event dependencies outside capture. A managed capture or replay scope holds the
lane across all enclosed MoE work, including eager breaks in breakable graphs.
This does not support DBO, overlapping microbatches or concurrent replay. Input
staging and graph output ownership remain the caller's/vLLM's responsibility;
custom callers must order their own input writes before replay.

## Graph capture and replay

`triton_mxfp4_graph.py` installs guards on three source-pinned entry points:

| vLLM path | Guarded boundary |
|---|---|
| `CUDAGraphWrapper` | `__call__`, with per-descriptor graph identity |
| `BreakableCUDAGraphWrapper` | `_capture` / `_replay`, including eager segments |
| `CudaGraphManager` | Factory/capture and direct `run_fullgraph` |

The last path is essential: the new GPU runner captures FULL graphs directly,
with runtime mode NONE inside capture, and does not replay them through the
ordinary wrapper. The manager hook adopts its actual capture stream outside
capture, then records resources when the returned forward function is captured.
Nested graph replay contributes its resource references to the parent capture.

Each capture lease retains the touched cache objects and snapshots the identity,
address, dtype, shape and strides of their source, slot, scale and scratch
tensors. Before each replay it validates those signatures and failure flags.
Reload attempts invalidate the cache; sleep and prefetch offloading are rejected
in model configuration. In-place weight edits are unsupported too: signatures
cannot detect arbitrary content writes. Graph clearing releases the associated
leases, but preserves live cache contents. A failed submission invalidates every
cache touched by that scope and requires restarting the worker.

Route conversion and both int32/int64 remap outputs use persistent buffers of S
elements each, allocated when arming, outside graph-private pools (16*S bytes
per layer). Physical source and destination byte views also persist. Stock
vLLM/Triton owns captured MoE workspaces and outputs in its graph pools. These
resources must remain alive with their graphs. Exact fitting route shapes and
dtypes are warmed before capture so manager/gather specialization is ready.

Replay executes the manager, route copy/remap and gathers again; on-device
policy state survives between invocations. A cold capture with masked experts
can therefore replay with new experts and real misses. `R <= S` is a static
shape decision: a wider descriptor captures the original full-weight path. Its
lease still protects source lifetimes and serializes with cached invocations.
There is no host readback of routing IDs, misses, or cache policy state.

The ordinary event fences and locks are not captured as GPU graph nodes. A
custom caller must enter `capture_lease(device)` before `torch.cuda.graph`, on
the actual capture stream, and replay through `replay_with_lease`. Unmanaged
capture is rejected. Normal vLLM serving uses the installed hooks automatically.

## Performance expectations to measure

Graphs may reduce host dispatch and kernel launch overhead for small decode
batches; dynamic expert caching itself does not require eager execution. They
do not reduce the bytes fetched on misses. Compare cached eager against cached
graph execution with identical routes, slots, placement and TP configuration,
separately for warm hits and sustained eviction. Measure time per output token,
p50/p99 latency, host dispatch, gather traffic and TP collective time.

The manager intentionally uses one CTA with loops over the routing list. Each
mirrored tensor has a separate gather launch. Graph replay does not fuse these
kernels. Per-replay host storage validation also has a cost that needs profiling.
Larger-batch distinct-count fitting and asynchronous prefetch remain separate
work. No graph speedup or actual gfx1201 graph correctness has been established
by the CPU and offline compilation checks supplied with this release.
