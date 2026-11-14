# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project
"""Architectural constants and runtime configuration for Qwen3.8-27B BF16 TP1 on gfx1201."""

from __future__ import annotations

from dataclasses import dataclass

# Qwen3.8-27B (Qwen3_5ForConditionalGeneration / qwen3_5) architecture constants
MODEL_ARCHITECTURES = ("Qwen3_5ForConditionalGeneration", "Qwen3_5ForCausalLM")
NUM_LAYERS = 64
FULL_ATTENTION_INTERVAL = 4  # 48 linear_attention (DeltaNet) + 16 full_attention layers
HIDDEN_SIZE = 5120
INTERMEDIATE_SIZE = 17408
RMS_NORM_EPS = 1e-6

# Hardware & execution bounds for gfx1201 (RDNA 4 / Navi 48) in BF16
EXPECTED_ARCH = "gfx1201"
EXPECTED_TP_SIZE = 1
EXPECTED_CU_COUNT = 64
MAX_DECODE_TOKENS = 16
REQUIRED_VRAM_GIB = 64.0  # ~54 GiB BF16 weights + KV/DeltaNet cache + scratch


@dataclass(frozen=True)
class DecodeConfig:
    """Configuration for Qwen3.8-27B BF16 specialized persistent decode on gfx1201."""

    enabled: bool = True
    max_rows: int = MAX_DECODE_TOKENS
    cache_dir: str | None = None
    strict_residency: bool = True
