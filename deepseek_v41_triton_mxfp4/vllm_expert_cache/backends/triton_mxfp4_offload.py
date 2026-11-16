"""Release stale converted GPU aliases immediately after each loading context.

This is storage-reference maintenance, not cache arming or quantization.
It is also installed when caching is disabled, so an uncached UVA baseline
uses the same correctly rebound full-expert tensors.
"""

import sys
from contextlib import contextmanager

import torch

from .triton_mxfp4 import PRECISIONS, SCALES, WEIGHTS, matches
from .triton_mxfp4_layout import scale_field

_installed = False


def rebind_sources(layer) -> None:
    """Repoint existing full wrappers; precision configs retain these objects."""
    method = getattr(layer, "quant_method", None)
    if not matches(method):
        return
    if not all(getattr(layer, name + "_triton", None) is not None for name in WEIGHTS):
        return  # a context used before conversion, not a finalized Triton layer
    pairs = [(getattr(layer, name + "_triton"), name) for name in WEIGHTS]
    for name, precision_name in zip(SCALES, PRECISIONS):
        precision = getattr(method, precision_name)
        pairs.append((getattr(precision, scale_field(precision)), name))
    for wrapper, name in pairs:
        current = getattr(layer, name)
        previous = wrapper.storage.data
        if not isinstance(current, torch.Tensor) or (
            tuple(current.shape) != tuple(previous.shape)
            or tuple(current.stride()) != tuple(previous.stride())
            or current.dtype != previous.dtype
        ):
            raise RuntimeError(
                f"Loading context changed the converted layout of {name}"
            )
    for wrapper, name in pairs:
        wrapper.storage.data = getattr(layer, name)


def install(logger) -> bool:
    global _installed
    if _installed:
        return True
    from vllm.model_executor.model_loader import utils as loader_utils

    original = loader_utils.device_loading_context

    @contextmanager
    def device_loading_context(module, target_device):
        with original(module, target_device):
            yield module
        if getattr(module, "_expert_cache_triton_sources", False):
            method = getattr(module, "quant_method", None)
            if (
                matches(method)
                and getattr(module, "w13_weight_triton", None) is not None
            ):
                if any(
                    getattr(module, name).device.type != "cuda"
                    for name in (*WEIGHTS, *SCALES)
                ):
                    raise RuntimeError(
                        "Triton MXFP4 host offload requires UVA accelerator views, not CPU tensors"
                    )
                rebind_sources(module)

    for module in list(sys.modules.values()):
        if (
            module is not None
            and getattr(module, "device_loading_context", None) is original
        ):
            module.device_loading_context = device_loading_context
    loader_utils.device_loading_context = device_loading_context
    _installed = True
    logger.info(
        "expert-cache: installed per-layer Triton storage rebinding after loading contexts"
    )
    return True
