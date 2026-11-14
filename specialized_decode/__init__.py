# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project
"""Specialized BF16 persistent decode for Qwen3.8-27B (TP1) on AMD gfx1201."""

from .runtime.decode import SpecializedDecode
from .runtime.spec import DecodeConfig

__all__ = ["DecodeConfig", "SpecializedDecode"]
