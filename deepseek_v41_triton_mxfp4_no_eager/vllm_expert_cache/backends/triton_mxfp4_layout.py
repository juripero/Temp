"""Physical-layout checks and wrapper rebinding for gfx1201 MXFP4.

Only expert-major, dense StridedLayout storage is admitted. An expert's
inner axes may be transposed; copying its physical slab preserves that order.
"""

from __future__ import annotations

from copy import copy
from dataclasses import fields, is_dataclass, replace
from math import prod

import torch


def expert_slab(tensor: torch.Tensor, experts: int) -> int:
    """Return dense elements per expert, rejecting holes and overlapping axes."""
    if (
        not isinstance(tensor, torch.Tensor)
        or tensor.layout != torch.strided
        or tensor.ndim < 2
        or tensor.shape[0] != experts
        or experts < 1
        or any(size < 1 for size in tensor.shape)
    ):
        raise ValueError("Expected a nonempty expert-major strided tensor")
    extent = 1
    axes = sorted(zip(tensor.stride()[1:], tensor.shape[1:]))
    for stride, size in axes:
        if size == 1:
            continue
        if stride != extent:
            raise ValueError("Expert storage has holes or overlapping inner axes")
        extent *= size
    if tensor.stride(0) != extent or extent != prod(tensor.shape[1:]):
        raise ValueError("Experts must occupy separate, consecutive physical slabs")
    return extent


def empty_slots(source: torch.Tensor, experts: int, slots: int) -> torch.Tensor:
    expert_slab(source, experts)
    return torch.empty_strided(
        (slots, *source.shape[1:]),
        source.stride(),
        dtype=source.dtype,
        device=source.device,
    )


def physical_bytes(tensor: torch.Tensor) -> torch.Tensor:
    """Expose bytes in physical order, without a logical contiguous() copy."""
    expert_slab(tensor, tensor.shape[0])
    return tensor.as_strided((tensor.numel(),), (1,)).view(torch.uint8)


def scale_field(precision) -> str:
    candidates = [
        name
        for name in ("b_mx_scale", "weight_scale")
        if getattr(precision, name, None) is not None
    ]
    if len(candidates) != 1:
        raise ValueError("Expected exactly one MX weight-scale field")
    return candidates[0]


def wrap_like(template, data: torch.Tensor):
    """Recreate metadata for S experts; never copy an E-shaped layout object."""
    from triton_kernels.tensor import wrap_torch_tensor
    from triton_kernels.tensor_details.layout import StridedLayout

    if type(template.storage.layout) is not StridedLayout:
        raise ValueError(
            "Only gfx1201 StridedLayout is supported, not swizzled layouts"
        )
    if len(template.shape) != 3 or not all(type(n) is int for n in template.shape):
        raise ValueError("Expected a static three-dimensional Triton tensor")
    expert_slab(data, data.shape[0])
    wrapped = wrap_torch_tensor(data, dtype=template.dtype)
    expected = [data.shape[0], *template.shape[1:]]
    if list(wrapped.shape) != expected or list(wrapped.shape_max) != expected:
        raise ValueError("Packed-axis interpretation changed while rebinding storage")
    if wrapped.storage.data.data_ptr() != data.data_ptr():
        raise ValueError("Wrapping unexpectedly copied storage")
    return wrapped


def clone_precision(precision, scale):
    key = scale_field(precision)
    if is_dataclass(precision):
        return replace(precision, **{key: scale})
    cloned = copy(precision)
    setattr(cloned, key, scale)
    return cloned


def _tensor_leaves(value, seen=None):
    """Inspect dataclasses including FlexCtx; do not traverse arbitrary objects."""
    seen = set() if seen is None else seen
    if id(value) in seen:
        return
    seen.add(id(value))
    if isinstance(value, torch.Tensor):
        yield value
    elif hasattr(value, "storage") and isinstance(
        getattr(value.storage, "data", None), torch.Tensor
    ):
        yield value.storage.data
    elif is_dataclass(value) and not isinstance(value, type):
        for field in fields(value):
            yield from _tensor_leaves(getattr(value, field.name), seen)
    elif isinstance(value, dict):
        for item in value.values():
            yield from _tensor_leaves(item, seen)
    elif isinstance(value, (list, tuple)):
        for item in value:
            yield from _tensor_leaves(item, seen)


def validate_precision(precision) -> None:
    """Weight-only MXFP4: no other dynamic activation/output scale tensors."""
    key = scale_field(precision)
    if not is_dataclass(precision):
        raise ValueError("Unsupported non-dataclass PrecisionConfig API")
    for field in fields(precision):
        if field.name == key:
            continue
        if any(True for _ in _tensor_leaves(getattr(precision, field.name))):
            raise ValueError(f"Unsupported tensor in PrecisionConfig.{field.name}")


def set_tensor(owner, name: str, value: torch.Tensor) -> None:
    if name in owner._parameters:
        owner._parameters[name] = value
    elif name in owner._buffers:
        owner._buffers[name] = value
    else:
        setattr(owner, name, value)
