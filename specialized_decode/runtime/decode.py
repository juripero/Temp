# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project
"""Top-level SpecializedDecode controller for Qwen3.8-27B BF16 TP1 on gfx1201."""

from __future__ import annotations

import logging
from typing import Any

import torch

from ..mono.runner import FfnRunner
from .executor import FfnExecutor, StepState
from .guards import check_static_support, decide_step
from .spec import DecodeConfig, RMS_NORM_EPS
from .weights import bind_model_weights

logger = logging.getLogger(__name__)


class SpecializedDecode:
    """Lifecycle manager: static validation, kernel compilation, per-step plan, and fail-stop."""

    def __init__(
        self,
        model: torch.nn.Module,
        vllm_config: Any,
        device: torch.device,
        config: DecodeConfig | None = None,
    ) -> None:
        self.config = config or DecodeConfig()
        self.device = device
        self.state = StepState()
        self.enabled = False
        self.refusal_reasons: list[str] = []
        self.runner: FfnRunner | None = None
        self.executor: FfnExecutor | None = None

        if not self.config.enabled:
            self.refusal_reasons = ["Disabled via DecodeConfig(enabled=False)."]
            return

        reasons = check_static_support(vllm_config=vllm_config, device=device)
        if reasons:
            self.refusal_reasons = reasons
            logger.warning(
                "Qwen3.8-27B gfx1201 BF16 specialized decode refused:\n  - %s",
                "\n  - ".join(reasons),
            )
            return

        layers_weights = bind_model_weights(model)
        self.runner = FfnRunner(
            device=device,
            max_rows=self.config.max_rows,
            eps=RMS_NORM_EPS,
            cache_dir=self.config.cache_dir,
        )
        self.executor = FfnExecutor(
            layers_weights=layers_weights,
            runner=self.runner,
            state=self.state,
        )
        self.executor.patch_model(model)
        self.enabled = True
        logger.info(
            "Enabled Qwen3.8-27B BF16 TP1 specialized decode on gfx1201 (64 CUs, max_rows=%d).",
            self.config.max_rows,
        )

    def warmup(self) -> None:
        """Pre-compile FlyDSL BF16 kernels for standard decode bucket widths before graph capture."""
        if self.enabled and self.runner is not None:
            self.runner.warmup()

    def plan(
        self,
        num_tokens: int,
        is_decode_only: bool = True,
        is_piecewise_cudagraph: bool = False,
    ) -> bool:
        """Configure step routing before the 64-layer forward loop begins."""
        if not self.enabled:
            self.state.active = False
            return False

        use_mono, width = decide_step(
            num_tokens=num_tokens,
            max_rows=self.config.max_rows,
            is_decode_only=is_decode_only,
            is_piecewise_cudagraph=is_piecewise_cudagraph,
        )
        self.state.active = use_mono
        self.state.num_rows = num_tokens if use_mono else 0
        self.state.graph_width = width
        return use_mono

    def after_step(self) -> None:
        """Device-side fail-stop assertion executed after the 64-layer loop, before logits."""
        if not self.enabled or self.runner is None:
            return
        torch._assert_async(self.runner.fault_word == 0)
