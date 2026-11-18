"""Adapter called by the exact-source vLLM patch in install_vllm.py.

It leaves original attention, cache handling, embeddings, final norm, and
auxiliary-hidden-state collection in place. Use --enforce-eager with this
adapter; standalone HIP graph qualification is provided by validate.py.
"""
from __future__ import annotations

import os

from .runtime.decode import SpecializedDecode
from .runtime.spec import DecodeConfig


def attention_reduction_enabled():
    mode = os.environ.get("QWEN38_ATTENTION_INPUT", "reduced")
    if mode not in ("reduced", "partial"):
        raise ValueError("QWEN38_ATTENTION_INPUT must be reduced or partial")
    if mode == "partial" and os.environ.get("QWEN38_SPECIALIZED_DECODE", "0") != "1":
        raise RuntimeError("Partial attention requires QWEN38_SPECIALIZED_DECODE=1 on every worker")
    return mode == "reduced"


def get_or_build_decode(inner):
    attention_reduction_enabled()  # Validate the contract before any fallback.
    config = getattr(inner, "_qwen38_vllm_config", None)
    if config is None and os.environ.get("QWEN38_ATTENTION_INPUT", "reduced") == "partial":
        raise RuntimeError("Partial attention requires the installed model adapter and vLLM config")
    if config is None or os.environ.get("QWEN38_SPECIALIZED_DECODE", "0") != "1":
        return None
    controller = getattr(inner, "_qwen38_decode_controller", None)
    if controller is None:
        from vllm.distributed import get_tp_group
        group = get_tp_group()
        device = next(inner.parameters()).device
        decode_config = DecodeConfig(
            tp_size=group.world_size, tp_rank=group.rank_in_group,
            attention_input=os.environ.get("QWEN38_ATTENTION_INPUT", "reduced"),
            ffn_reduction=os.environ.get("QWEN38_FFN_REDUCTION", "collective"),
            ipc_protocol=os.environ.get("QWEN38_IPC_PROTOCOL", "simple"),
            backend=os.environ.get("QWEN38_FFN_BACKEND", "torch"),
            cache_dir=os.environ.get("QWEN38_FFN_CACHE_DIR"),
        )
        controller = SpecializedDecode(inner, config, device, decode_config)
        inner._qwen38_decode_controller = controller
    return controller


def run_decoder_layers(inner, positions, hidden_states, residual,
                       intermediate_tensors, aux_hidden_states):
    controller = get_or_build_decode(inner)
    decision = controller.plan(positions, intermediate_tensors) if controller else None
    failure = None
    try:
        for layer_idx in range(inner.start_layer, inner.end_layer):
            deferred = (controller is not None and
                        getattr(getattr(controller, "config", None), "attention_input", "reduced") == "partial")
            if decision is not None and (decision.use_mono or deferred):
                hidden_states, residual = controller.executor.run_layer(
                    layer_idx, positions, hidden_states, residual, active=decision.use_mono)
            else:
                hidden_states, residual = inner.layers[layer_idx](
                    positions=positions, hidden_states=hidden_states, residual=residual)
            inner._maybe_add_hidden_state(
                aux_hidden_states, layer_idx + 1, hidden_states, residual)
    except Exception as error:
        failure = error
    if controller is not None:
        controller.after_step(failure)
    elif failure is not None:
        raise failure
    return hidden_states, residual
