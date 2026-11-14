# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project
"""Layer wrapper routing post-attention dense FFN execution to the gfx1201 BF16 kernel."""

from __future__ import annotations

from collections.abc import Callable
from dataclasses import dataclass

import torch

from ..mono.runner import FfnRunner
from .weights import LayerWeights


@dataclass
class StepState:
    """Mutable per-forward-step state shared across all 64 wrapped decoder layers."""

    active: bool = False
    num_rows: int = 0
    graph_width: int = 0


class FfnExecutor:
    """Binds post-load Qwen3.8-27B BF16 layers to `FfnRunner`."""

    def __init__(
        self,
        layers_weights: list[LayerWeights],
        runner: FfnRunner,
        state: StepState,
    ) -> None:
        self.layers_weights = layers_weights
        self.runner = runner
        self.state = state

    def patch_model(self, model: torch.nn.Module) -> None:
        """Install forward wrappers on each Qwen3.5 decoder layer."""
        lm = getattr(model, "language_model", model)
        inner = getattr(lm, "model", lm)
        layers = inner.layers

        for idx, layer in enumerate(layers):
            lw = self.layers_weights[idx]
            orig_forward = layer.forward
            layer.forward = self._make_layer_forward(layer, lw, orig_forward)

    def _make_layer_forward(
        self,
        layer: torch.nn.Module,
        lw: LayerWeights,
        orig_forward: Callable,
    ) -> Callable:
        executor = self

        def wrapped_forward(
            positions: torch.Tensor,
            hidden_states: torch.Tensor,
            residual: torch.Tensor | None,
            **kwargs,
        ):
            if not executor.state.active:
                return orig_forward(positions, hidden_states, residual, **kwargs)

            if residual is None:
                residual = hidden_states
                hidden_states = layer.input_layernorm(hidden_states)
            else:
                hidden_states, residual = layer.input_layernorm(hidden_states, residual)

            if hasattr(layer, "linear_attn") and layer.linear_attn is not None:
                attn_out = layer.linear_attn(
                    hidden_states=hidden_states,
                    positions=positions,
                    **kwargs,
                )
            else:
                attn_out = layer.self_attn(
                    positions=positions,
                    hidden_states=hidden_states,
                    **kwargs,
                )

            hidden_states, residual = executor.runner.launch_layer(
                layer=lw,
                attn_out=attn_out,
                residual=residual,
                num_rows=executor.state.num_rows,
                graph_width=executor.state.graph_width,
            )
            return hidden_states, residual

        return wrapped_forward
