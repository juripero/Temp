"""gfx1201 adapter for finalized OAI Triton MXFP4 MoE methods.

The global loader calls arm() once, after normal vLLM finalization. Both the
torch parameters and the Triton weight/scale wrappers are bound transactionally.
Graph replay is guarded at the source-pinned vLLM capture/replay entry points.
"""

from __future__ import annotations

from contextlib import contextmanager

import torch

from ..config import settings
from .triton_mxfp4_cache import TritonSlotCache
from .triton_mxfp4_layout import (
    clone_precision,
    expert_slab,
    scale_field,
    set_tensor,
    validate_precision,
    wrap_like,
)

ADAPTER_API = 2
BACKENDS = {"TRITON", "TRITON_UNFUSED"}
WEIGHTS = ("w13_weight", "w2_weight")
SCALES = ("w13_weight_scale", "w2_weight_scale")
PRECISIONS = ("w13_precision_config", "w2_precision_config")
BIASES = ("w13_bias", "w2_bias")


def matches(method) -> bool:
    return getattr(getattr(method, "mxfp4_backend", None), "name", None) in BACKENDS


def has_triton_storage(layer, method) -> bool:
    return any(
        getattr(layer, name + "_triton", None) is not None for name in WEIGHTS
    ) or any(getattr(method, name, None) is not None for name in PRECISIONS)


def _runtime_check(device):
    from vllm.utils.import_utils import get_triton_kernels_version

    if not torch.version.hip or device.type != "cuda":
        raise RuntimeError(
            "The Triton MXFP4 adapter requires ROCm accelerator/UVA tensors"
        )
    arch = torch.cuda.get_device_properties(device).gcnArchName.split(":")[0]
    if arch != "gfx1201":
        raise RuntimeError(f"This adapter was designed for gfx1201, got {arch}")
    if get_triton_kernels_version() not in {"3.5.1", "3.6", "3.8"}:
        raise RuntimeError("Unreviewed triton_kernels API; expected 3.5.1, 3.6 or 3.8")


def validate_layout(layer, method) -> list[str]:
    """Validate metadata after quantization, without allocation or cache arming."""
    if not matches(method):
        raise NotImplementedError("Expected the OAI TRITON or TRITON_UNFUSED backend")
    kernel = getattr(method, "moe_kernel", None)
    experts = getattr(kernel, "fused_experts", None)
    if method.is_monolithic or experts is None:
        raise NotImplementedError("A finalized modular MoE kernel is required")
    if type(experts).__name__ not in {"OAITritonExperts", "UnfusedOAITritonExperts"}:
        raise NotImplementedError("Unsupported experts implementation for this adapter")
    if layer.expert_map is not None:
        raise NotImplementedError("EP expert maps are not supported")
    if getattr(experts, "_lora_context", None) is not None:
        raise NotImplementedError("Slot remapping cannot be combined with expert LoRA")
    count = layer.global_num_experts
    names = [*WEIGHTS, *SCALES]
    names += [name for name in BIASES if getattr(layer, name, None) is not None]
    device = getattr(layer, WEIGHTS[0]).device
    _runtime_check(device)
    for name in names:
        tensor = getattr(layer, name, None)
        expert_slab(tensor, count)
        if tensor.device != device:
            raise ValueError(
                "All mirrored tensors must be accelerator-readable on one device"
            )
    for weight, scale, precision_name in zip(WEIGHTS, SCALES, PRECISIONS):
        wrapper = getattr(layer, weight + "_triton", None)
        if wrapper is None:
            raise ValueError(f"Missing {weight}_triton after quantization")
        precision = getattr(method, precision_name)
        validate_precision(precision)
        scale_wrapper = getattr(precision, scale_field(precision))
        for template, name in ((wrapper, weight), (scale_wrapper, scale)):
            data = getattr(layer, name)
            if template.shape[0] != count:
                raise ValueError(
                    "Triton logical expert dimension disagrees with the layer"
                )
            if tuple(template.storage.data.shape) != tuple(data.shape):
                raise ValueError(
                    "Registered parameter and Triton storage shapes disagree"
                )
            if tuple(template.storage.data.stride()) != tuple(data.stride()):
                raise ValueError(
                    "Offloading changed the physical layout of Triton storage"
                )
            if template.storage.data.dtype != data.dtype or data.element_size() != 1:
                raise ValueError("Expected byte-packed MXFP4 weights and E8M0 scales")
            wrap_like(template, data)
    # Unknown auxiliary scales must not stay indexed by global IDs during slot use.
    cfg = method.moe_quant_config
    for desc_name in ("_a1", "_a2", "_w1", "_w2"):
        desc = getattr(cfg, desc_name, None)
        for field in ("scale", "alpha_or_gscale", "zp", "bias"):
            value = getattr(desc, field, None)
            if value is None:
                continue
            if desc_name in ("_w1", "_w2") and field in ("scale", "bias"):
                continue
            if not isinstance(value, (int, float, bool)):
                raise NotImplementedError(
                    f"Unmapped quantization field {desc_name}.{field}"
                )
    return names


class Binding:
    """Two complete parameter/wrapper/config sets, sharing only immutable metadata."""

    def __init__(self, layer, method, cache):
        self.layer, self.method, self.cache = layer, method, cache
        self.experts = method.moe_kernel.fused_experts
        self.full_wrappers, self.slot_wrappers = {}, {}
        self.full_precisions, self.slot_precisions = {}, {}
        self.slot_params = {
            name: torch.nn.Parameter(value, requires_grad=False)
            if name in layer._parameters
            else value
            for name, value in cache.slots.items()
        }
        self.signatures = {
            name: self._signature(getattr(layer, name)) for name in cache.names
        }
        for weight, scale, precision_name in zip(WEIGHTS, SCALES, PRECISIONS):
            template = getattr(layer, weight + "_triton")
            self.full_wrappers[weight + "_triton"] = wrap_like(
                template, getattr(layer, weight)
            )
            self.slot_wrappers[weight + "_triton"] = wrap_like(
                template, cache.slots[weight]
            )
            precision = getattr(method, precision_name)
            template_scale = getattr(precision, scale_field(precision))
            self.full_precisions[precision_name] = clone_precision(
                precision, wrap_like(template_scale, getattr(layer, scale))
            )
            self.slot_precisions[precision_name] = clone_precision(
                precision, wrap_like(template_scale, cache.slots[scale])
            )
        # Build both configs with the method's own factory. Stage all changes so
        # construction failures leave the original method and layer untouched.
        with self._objects(self.full_wrappers, self.full_precisions, {}):
            self.full_cfg = method.get_fused_moe_quant_config(layer)
        with self._objects(self.slot_wrappers, self.slot_precisions, self.slot_params):
            self.slot_cfg = method.get_fused_moe_quant_config(layer)
        self._check_config(self.full_cfg, self.full_precisions, False)
        self._check_config(self.slot_cfg, self.slot_precisions, True)

    @staticmethod
    def _signature(tensor):
        return (
            tensor.data_ptr(),
            tuple(tensor.shape),
            tuple(tensor.stride()),
            tensor.dtype,
            tensor.device,
        )

    def _check_config(self, cfg, precisions, slot):
        if cfg is None:
            raise ValueError("MXFP4 quantization config cannot be None")
        for index, precision_name in enumerate(PRECISIONS, 1):
            if getattr(cfg, f"w{index}_precision") is not precisions[precision_name]:
                raise ValueError(
                    "Quantization factory did not use the rebound PrecisionConfig"
                )
            bias_name = BIASES[index - 1]
            expected = (
                self.slot_params.get(bias_name)
                if slot
                else getattr(self.layer, bias_name, None)
            )
            actual = getattr(cfg, f"w{index}_bias")
            if actual is not expected:
                raise ValueError(
                    "Quantization factory did not use the rebound expert bias"
                )

    @contextmanager
    def _objects(self, wrappers, precisions, params):
        saved_params = {name: getattr(self.layer, name) for name in params}
        saved_wrappers = {name: getattr(self.layer, name) for name in wrappers}
        saved_precisions = {name: getattr(self.method, name) for name in precisions}
        try:
            for name, value in params.items():
                set_tensor(self.layer, name, value)
            for name, value in wrappers.items():
                setattr(self.layer, name, value)
            for name, value in precisions.items():
                setattr(self.method, name, value)
            yield
        finally:
            for name, value in saved_params.items():
                set_tensor(self.layer, name, value)
            for name, value in saved_wrappers.items():
                setattr(self.layer, name, value)
            for name, value in saved_precisions.items():
                setattr(self.method, name, value)

    def install_full(self):
        for name, value in self.full_wrappers.items():
            setattr(self.layer, name, value)
        for name, value in self.full_precisions.items():
            setattr(self.method, name, value)
        self.method.moe_quant_config = self.full_cfg
        self.experts.quant_config = self.full_cfg

    def sync_sources(self):
        for name in self.cache.names:
            tensor = getattr(self.layer, name)
            signature = self._signature(tensor)
            previous = self.signatures[name]
            if signature == previous:
                continue
            if self.cache.started or signature[1:] != previous[1:]:
                raise RuntimeError(
                    "Expert storage changed after setup; restart the worker/cache"
                )
            # Initial UVA relocation is allowed before the first forward. Update
            # the wrapper objects already held by the full quantization config.
            if name in WEIGHTS:
                self.full_wrappers[name + "_triton"].storage.data = tensor
            elif name in SCALES:
                precision = self.full_precisions[PRECISIONS[SCALES.index(name)]]
                getattr(precision, scale_field(precision)).storage.data = tensor
            else:
                raise RuntimeError(
                    "Bias relocation after arming requires reloading the worker"
                )
            self.signatures[name] = signature

    def graph_tensors(self):
        tensors = [
            ("slot-param:" + name, value) for name, value in self.slot_params.items()
        ]
        for label, wrappers in (
            ("full-wrapper:", self.full_wrappers),
            ("slot-wrapper:", self.slot_wrappers),
        ):
            tensors += [
                (label + name, wrapper.storage.data)
                for name, wrapper in wrappers.items()
            ]
        for label, precisions in (
            ("full-scale:", self.full_precisions),
            ("slot-scale:", self.slot_precisions),
        ):
            tensors += [
                (label + name, getattr(precision, scale_field(precision)).storage.data)
                for name, precision in precisions.items()
            ]
        return tensors

    @contextmanager
    def slots_bound(self):
        saved = (
            self.layer.global_num_experts,
            self.method.moe_quant_config,
            self.experts.quant_config,
        )
        try:
            self.layer.global_num_experts = self.cache.S
            self.method.moe_quant_config = self.slot_cfg
            self.experts.quant_config = self.slot_cfg
            with self._objects(
                self.slot_wrappers, self.slot_precisions, self.slot_params
            ):
                yield
        finally:
            (
                self.layer.global_num_experts,
                self.method.moe_quant_config,
                self.experts.quant_config,
            ) = saved


def arm(layer, method, logger) -> bool:
    if settings.disabled:
        return False
    existing = getattr(layer, "_expert_cache", None)
    if existing is not None:
        if (
            getattr(existing, "adapter_api", None) == ADAPTER_API
            and existing.owner is layer
        ):
            return True
        raise RuntimeError("Another cache already owns this layer")
    experts = layer.global_num_experts
    slots = settings.slots_for(experts)
    if slots >= experts:
        return False
    if not getattr(layer, "_expert_cache_triton_preflight", False):
        raise RuntimeError(
            "Install the accompanying model.py; model preflight has not run"
        )
    names = validate_layout(layer, method)
    if getattr(layer, "_expert_cache_graph_enabled", False):
        from .triton_mxfp4_graph import install_vllm_hooks

        install_vllm_hooks(logger)
    with torch.cuda.device(getattr(layer, names[0]).device):
        cache = TritonSlotCache(layer, names, experts, slots)
        binding = Binding(layer, method, cache)
    original = method.apply

    def apply(
        layer, x, topk_weights, topk_ids, shared_experts=None, shared_experts_input=None
    ):
        if layer is not cache.owner:
            raise RuntimeError("A cached quantization method was shared across layers")
        if x.device != cache.table.device:
            raise ValueError("Input and expert cache are on different devices")
        with cache.invocation():
            binding.sync_sources()
            if not cache.fits(topk_ids):
                return original(
                    layer,
                    x,
                    topk_weights,
                    topk_ids,
                    shared_experts,
                    shared_experts_input,
                )
            mapped_ids = cache.refresh(topk_ids)
            with binding.slots_bound():
                return original(
                    layer,
                    x,
                    topk_weights,
                    mapped_ids,
                    shared_experts,
                    shared_experts_input,
                )

    binding.install_full()
    cache.adapter_api = ADAPTER_API
    cache.binding = binding
    method.apply = apply
    layer._expert_cache = cache
    logger.info(
        "expert-cache: gfx1201 Triton MXFP4 adapter, %d/%d experts, policy=%s, graph-capable",
        slots,
        experts,
        settings.policy,
    )
    return True
