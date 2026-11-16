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

Python reentrancy is rejected. GPU work stays ordered on one stream; a stream
change inserts an event dependency on the previous stream. This applies to both
cached calls and full-path fallback, so a later invocation cannot overwrite a
slot still read by a previous invocation. Failed calls invalidate the runtime.
This is not support for DBO or concurrent graph replays.

## Graph extension boundary

Production integration requires `--enforce-eager` and refuses capture. The raw
manager/gather kernels contain no device-to-host reads and have a separate graph
replay test, but that alone does not establish vLLM graph correctness.

A later graph implementation needs fixed source and destination lifetimes,
capture-safe remap/workspace ownership, explicit serialization of all replay
streams that share a layer cache, correct interaction with graph-private pools,
and numerical parity while routing and cache misses change between replays.
It must also prevent reload/sleep/wake operations from invalidating captured
pointers. Removing the eager guard alone would not provide those guarantees.

## Performance expectations to measure

The manager intentionally uses a single CTA with loops over the small routing
list. This is simple and deterministic, but may become a bottleneck for large S
or larger cached batches. Each mirrored tensor has its own gather launch. A
later optimization can fuse gathers after measuring launch overhead and PCIe
miss costs. Wide-batch distinct-count fitting, asynchronous prefetch, and graph
serving are separate work. No speedup has been measured for this implementation.
