# Exact-base hipMalloc IPC allocation option — introduced in 0.4.2

Reviewed `juripero/Temp` commit `efe05e2a28d35c844d34b52f20d3aebc349f5b9c`,
directory `qwen38_decode_flydsl050_TP4_2`.

This guide describes the allocator change retained in version 0.4.3. For the
new fused FFN reduction, installation and current validation, use README.md and
FFN_REDUCTION.md. The historical `ipc_fix.patch` is against the older reviewed
commit; the current patch is `ffn_reduction.patch` against commit aeda0e4.

## Diagnosis

The export at `runtime/peer.py` already receives `self.own`, the unmodified
allocation base. Its source allocator is `hipExtMallocWithFlags` with
`hipDeviceMallocUncached`, rather than plain `hipMalloc`. There is no torch
caching-allocator pointer or tensor-view offset in this path.

AMD documents `hipIpcGetMemHandle` for the base of a `hipMalloc` allocation.
Using that documented path is a reasonable allocation-compatibility fix to test.
The documentation does not establish that every extension allocation fails:
AMD AITER itself exports uncached metadata allocations. The reported error alone
cannot distinguish allocation type, ROCr IPC mode, or a runtime/driver defect.
The supplied diagnostic compares both allocators in fresh processes.

## Code changes

- `runtime/_hip_ipc.py` binds `hipMalloc(void **, size_t)` and adds
  `HipRuntime.allocate_device(size)`. The exact returned base is zeroed and
  returned. Failed zeroing frees that same base. Errors include the HIP operation
  and status; allocation failure does not fall back to another allocator.
- `runtime/peer.py` accepts `QWEN38_IPC_ALLOCATOR=hipmalloc|uncached`. It selects
  the correct local GPU, allocates, synchronizes initialization, and passes
  `self.own` unchanged to `get_ipc_handle`. All ranks must agree on allocator and
  IPC mode before any peer imports. Mailbox offsets are used only after export.
- The original collective teardown closes every peer import before freeing
  owners. Import pointers are closed with `hipIpcCloseMemHandle`, never `hipFree`.
- `diagnose_ipc.py` uses this same new allocation method. Its exit status can
  target the selected allocator using `--production-allocator malloc`.

The important code path is:

```python
allocate = (self.runtime.allocate_device if self.allocator == "hipmalloc"
            else self.runtime.allocate_uncached)
self.own = allocate(self.size)
torch.cuda.synchronize(self.device)
record["handle"] = self.runtime.get_ipc_handle(self.own)
```

## Installation and local export test

Install this complete package in the workers' Python environment and restart
all workers. The 0.4.2 allocator update left the model patch and GPU kernel unchanged from 0.4.1.
Version 0.4.3 changes the GPU kernel; install the complete current package.
If that model integration is installed, it does not need to be reapplied.

```bash
python -m pip install --no-deps -e .
python -m unittest discover -s tests -v
python diagnose_ipc.py --devices 0,1 --compare-modes --production-allocator malloc
```

`malloc` in probe output means plain `hipMalloc`; `uncached` means the extension
allocator. Each case starts before torch/vLLM/FlyDSL initialization. It tests
local allocation/export/cleanup only, without model weights. The default size
164352 bytes matches the full mailbox. Matrix-mode exit status checks all
requested GPUs using mode 0 and the chosen production allocator; deliberate
mode 1 failures may still appear. `--production-allocator` defaults to `malloc`
when `QWEN38_IPC_ALLOCATOR=hipmalloc`, otherwise `uncached`.

| Probe result | Interpretation |
|---|---|
| malloc passes, uncached fails in the same mode | Supports an allocator compatibility problem on this stack. |
| Both pass in mode 0 and fail in mode 1 | Supports a legacy IPC-mode limitation. |
| Both fail in mode 0 | Investigate HIP/ROCr/driver and device configuration; plain hipMalloc is insufficient. |
| Export passes, peer import later fails | Separate mapping/topology problem; export success is not a peer-access test. |

Set `HSA_ENABLE_IPC_MODE_LEGACY` before starting Python. A change inside an
already initialized worker is too late. Mode 0 is a diagnostic candidate based
on gfx1201 issue reports, not a universal fix or an automatically changed setting.

## Required peer-protocol qualification

The existing mailbox combines attention data and READY/DONE/EPOCH/FAILED flags.
Plain `hipMalloc` changes its memory type from the original uncached allocation.
The kernel retains its system-scope acquire/release operations, but successful
export and ISA generation do not prove live cross-GPU cache visibility. This
release therefore keeps `uncached` as the default and requires explicit opt-in.
It makes no claim that switching allocators alone fixes full TP execution.

After export succeeds, run on an otherwise idle gfx1201 machine:

```bash
QWEN38_IPC_ALLOCATOR=hipmalloc HSA_ENABLE_IPC_MODE_LEGACY=0 \
  torchrun --standalone --nproc-per-node=2 validate_tp.py \
  --attention-partials --attention-scale --small

# Full dimensions, repeated replay, epoch wrap, and fault propagation:
QWEN38_IPC_ALLOCATOR=hipmalloc HSA_ENABLE_IPC_MODE_LEGACY=0 \
  torchrun --standalone --nproc-per-node=2 validate_tp.py \
  --attention-partials --attention-scale --graph --fault-test
```

Repeat with 4 processes for TP4. The validator checks different attention
partials, replicated residuals, intermediate/output parity, repeated reuse,
uint32 peer-epoch rollover, and sticky faults. Test actual-model logits and
long-running decode as well. Stop the whole worker group on a fault; do not
clear flags and resume. Keep all TP devices visible to every worker.

Only after hardware qualification, enable the option in serving:

```bash
QWEN38_IPC_ALLOCATOR=hipmalloc HSA_ENABLE_IPC_MODE_LEGACY=0 \
QWEN38_SPECIALIZED_DECODE=1 QWEN38_ATTENTION_INPUT=partial \
QWEN38_FFN_BACKEND=flydsl \
  vllm serve /path/to/checkpoint --dtype bfloat16 \
  --tensor-parallel-size 2 --enforce-eager
```

## RCCL alternative

The separate RCCL package removes this custom mailbox and peer polling entirely.
It enqueues attention SUM, then the local FlyDSL FFN, then FFN-output SUM on the
same stream. That is the preferred alternative when direct peer IPC or the
memory-order assumptions cannot be qualified. Install one package variant at a
time. RCCL may itself use HIP IPC internally, so it is not a promise that the
underlying stack needs no IPC support.

## Validation here

48 host tests passed, including 15 fake-HIP ABI/error/cleanup cases and existing
CPU numerical simulations. Python syntax passed. GPU source is unchanged;
`validation/isa` is inherited compiler-only evidence, not a new GPU test.
No AMD GPU was available: export, peer mappings, numerical parity on GPU,
cache visibility, graph replay and performance are unverified.
`ipc_fix.patch` is against the reviewed Temp commit and can be applied at its root.

## Sources

- [HIP IPC contract](https://rocm.docs.amd.com/projects/HIP/en/latest/reference/hip_runtime_api/modules/device_management.html)
- [HIP memory management and coherence](https://rocm.docs.amd.com/projects/HIP/en/latest/how-to/hip_runtime_api/memory_management/host_memory.html)
- [AITER metadata and data allocation](https://github.com/ROCm/aiter/blob/main/csrc/kernels/custom_all_reduce.cu)
- [gfx1201 legacy IPC export report](https://github.com/ROCm/rocm-systems/issues/2209)
