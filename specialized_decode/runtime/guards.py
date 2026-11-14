# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project
"""Static startup refusals and per-step eligibility checks for gfx1201 BF16 decode."""

from __future__ import annotations

from typing import Any

import torch

from .spec import (
    EXPECTED_ARCH,
    EXPECTED_CU_COUNT,
    EXPECTED_TP_SIZE,
    HIDDEN_SIZE,
    INTERMEDIATE_SIZE,
    MAX_DECODE_TOKENS,
    MODEL_ARCHITECTURES,
    NUM_LAYERS,
    REQUIRED_VRAM_GIB,
)


def check_static_support(
    vllm_config: Any,
    device: torch.device,
) -> list[str]:
    """Return all static refusal reasons; empty list means gfx1201 TP1 BF16 mono-decode is valid."""
    reasons: list[str] = []

    if torch.version.hip is None:
        reasons.append("ROCm/HIP runtime is required (torch.version.hip is None).")
        return reasons

    if not torch.cuda.is_available():
        reasons.append("No HIP/CUDA device is available.")
        return reasons

    props = torch.cuda.get_device_properties(device)
    arch = getattr(props, "gcnArchName", "")
    if EXPECTED_ARCH not in arch:
        reasons.append(f"Requires {EXPECTED_ARCH} (RDNA 4), found gcnArchName='{arch}'.")

    cu_count = getattr(props, "multi_processor_count", 0)
    if cu_count != EXPECTED_CU_COUNT:
        reasons.append(
            f"Requires unpartitioned {EXPECTED_ARCH} with {EXPECTED_CU_COUNT} CUs, "
            f"found {cu_count} CUs."
        )

    total_vram_gib = getattr(props, "total_memory", 0) / (1024**3)
    if total_vram_gib < REQUIRED_VRAM_GIB:
        reasons.append(
            f"Requires >= {REQUIRED_VRAM_GIB:.1f} GiB VRAM to hold Qwen3.8-27B BF16 weights, "
            f"found {total_vram_gib:.1f} GiB."
        )

    parallel_cfg = getattr(vllm_config, "parallel_config", None)
    tp_size = getattr(parallel_cfg, "tensor_parallel_size", 1)
    if tp_size != EXPECTED_TP_SIZE:
        reasons.append(f"TP1 specialized decode requires tensor_parallel_size=1, got {tp_size}.")

    model_cfg = getattr(vllm_config, "model_config", None)
    dtype = getattr(model_cfg, "dtype", None)
    if dtype is not None and dtype != torch.bfloat16:
        reasons.append(f"BF16 specialized decode requires model_config.dtype=bfloat16, got {dtype}.")

    hf_cfg = getattr(model_cfg, "hf_config", None)
    text_cfg = getattr(hf_cfg, "text_config", hf_cfg)

    archs = tuple(getattr(hf_cfg, "architectures", ()) or ())
    if archs and not any(a in MODEL_ARCHITECTURES for a in archs):
        reasons.append(f"Unsupported architecture {archs}; expected one of {MODEL_ARCHITECTURES}.")

    if text_cfg is not None:
        n_layers = getattr(text_cfg, "num_hidden_layers", NUM_LAYERS)
        h_size = getattr(text_cfg, "hidden_size", HIDDEN_SIZE)
        i_size = getattr(text_cfg, "intermediate_size", INTERMEDIATE_SIZE)
        if (n_layers, h_size, i_size) != (NUM_LAYERS, HIDDEN_SIZE, INTERMEDIATE_SIZE):
            reasons.append(
                f"Expected Qwen3.8-27B dims ({NUM_LAYERS}, {HIDDEN_SIZE}, {INTERMEDIATE_SIZE}), "
                f"got ({n_layers}, {h_size}, {i_size})."
            )

    return reasons


def decide_step(
    num_tokens: int,
    max_rows: int = MAX_DECODE_TOKENS,
    is_decode_only: bool = True,
    is_piecewise_cudagraph: bool = False,
) -> tuple[bool, int]:
    """Return `(use_monokernel, graph_width)` for the active forward step."""
    if not is_decode_only or is_piecewise_cudagraph:
        return False, 0
    if num_tokens < 1 or num_tokens > max_rows:
        return False, 0

    width = 1
    while width < num_tokens:
        width <<= 1
    return True, min(width, max_rows)
