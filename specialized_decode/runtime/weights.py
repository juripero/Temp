# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project
"""Zero-copy validated tensor views over row-major BF16 weights for Qwen3.8-27B."""

from __future__ import annotations

from dataclasses import dataclass

import torch

from .spec import HIDDEN_SIZE, INTERMEDIATE_SIZE, NUM_LAYERS


@dataclass(frozen=True)
class LayerWeights:
    """Native BF16 weight pointers for one Qwen3.8-27B dense MLP layer."""

    layer_idx: int
    post_norm: torch.Tensor  # bf16 (Gemma-style 1 + w)
    w13: torch.Tensor  # bf16 [34816, 5120] -> viewed as int32 [34816, 2560]
    w2: torch.Tensor  # bf16 [5120, 17408] -> viewed as int32 [5120, 8704]


def _as_bf16_i32_view(t: torch.Tensor, expected_shape: tuple[int, int], name: str) -> torch.Tensor:
    if not t.is_cuda or not t.is_contiguous():
        raise ValueError(f"{name} must be contiguous on GPU, got device={t.device}")
    if t.dtype != torch.bfloat16:
        raise ValueError(f"{name} must have dtype torch.bfloat16, got {t.dtype}")
    if tuple(t.shape) != expected_shape:
        raise ValueError(f"{name} expected shape {expected_shape}, got {tuple(t.shape)}")
    return t.view(torch.int32)


def bind_model_weights(model: torch.nn.Module) -> list[LayerWeights]:
    """Extract and validate zero-copy BF16 LayerWeights for all 64 layers of Qwen3.8-27B."""
    lm = getattr(model, "language_model", model)
    inner = getattr(lm, "model", lm)
    layers = getattr(inner, "layers", None)
    if layers is None or len(layers) != NUM_LAYERS:
        found = 0 if layers is None else len(layers)
        raise ValueError(f"Expected {NUM_LAYERS} decoder layers, found {found}")

    bound: list[LayerWeights] = []
    for idx, layer in enumerate(layers):
        post_norm = layer.post_attention_layernorm.weight
        if not post_norm.is_cuda or not post_norm.is_contiguous():
            raise ValueError(f"Layer {idx} post_attention_layernorm must be contiguous on GPU")
        if post_norm.dtype != torch.bfloat16 or tuple(post_norm.shape) != (HIDDEN_SIZE,):
            raise ValueError(
                f"Layer {idx} post_attention_layernorm expected bf16 ({HIDDEN_SIZE},), "
                f"got {post_norm.dtype} {tuple(post_norm.shape)}"
            )

        mlp = layer.mlp
        w13_raw = getattr(mlp.gate_up_proj, "weight", None)
        w2_raw = getattr(mlp.down_proj, "weight", None)
        if w13_raw is None or w2_raw is None:
            raise ValueError(f"Layer {idx} missing BF16 gate_up_proj.weight or down_proj.weight")

        w13 = _as_bf16_i32_view(w13_raw, (2 * INTERMEDIATE_SIZE, HIDDEN_SIZE), f"layer[{idx}].w13")
        w2 = _as_bf16_i32_view(w2_raw, (HIDDEN_SIZE, INTERMEDIATE_SIZE), f"layer[{idx}].w2")

        bound.append(
            LayerWeights(
                layer_idx=idx,
                post_norm=post_norm,
                w13=w13,
                w2=w2,
            )
        )
    return bound
