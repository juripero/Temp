#### 7. `vllm/models/qwen3_5/amd/specialized_decode/mono/runner.py`
```python
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: Copyright contributors to the vLLM project
"""Host launcher, scratch workspace, and epoch lifecycle for gfx1201 BF16 persistent FFN."""

from __future__ import annotations

import os
from pathlib import Path
from typing import TYPE_CHECKING

import torch

from .ffn import BLOCKS, FfnBuild, THREADS, build_ffn, scratch_bytes, scratch_layout
from .residency import active_workgroups_per_cu

if TYPE_CHECKING:
    from ..runtime.weights import LayerWeights


class FfnRunner:
    """Owns compiled gfx1201 FlyDSL BF16 binaries, per-width scratch buffers, and fault word."""

    def __init__(
        self,
        device: torch.device,
        max_rows: int = 16,
        eps: float = 1e-6,
        cache_dir: str | None = None,
    ) -> None:
        self.device = device
        self.max_rows = max_rows
        self.eps = eps
        self._epoch = 0
        self._builds: dict[int, FfnBuild] = {}
        self._scratches: dict[int, torch.Tensor] = {}

        if cache_dir is not None:
            Path(cache_dir).mkdir(parents=True, exist_ok=True)
            os.environ.setdefault("FLYDSL_CACHE_DIR", cache_dir)

        self.fault_word = torch.zeros(4, dtype=torch.int32, device=device)

    def _get_build(self, width: int) -> FfnBuild:
        if width not in self._builds:
            build = build_ffn(max_rows=width, eps=self.eps)
            active = active_workgroups_per_cu(build.compiled, build.name, build.threads)
            if active < 1:
                raise RuntimeError(
                    f"Persistent kernel {build.name} requires >= 1 active CTA/CU on gfx1201, "
                    f"got {active}."
                )
            self._builds[width] = build
        return self._builds[width]

    def _get_scratch(self, width: int) -> torch.Tensor:
        if width not in self._scratches:
            nbytes = scratch_bytes(width)
            self._scratches[width] = torch.zeros(nbytes // 4, dtype=torch.int32, device=self.device)
        return self._scratches[width]

    def warmup(self, widths: tuple[int, ...] = (1, 2, 4, 8, 16)) -> None:
        """Pre-compile and verify CU residency for standard CUDA graph capture widths."""
        for w in widths:
            if w <= self.max_rows:
                self._get_build(w)
                self._get_scratch(w)

    def launch_layer(
        self,
        layer: LayerWeights,
        attn_out: torch.Tensor,
        residual: torch.Tensor,
        num_rows: int,
        graph_width: int,
    ) -> tuple[torch.Tensor, torch.Tensor]:
        """Launch one persistent gfx1201 BF16 FFN kernel for a single decoder layer."""
        build = self._get_build(graph_width)
        scratch = self._get_scratch(graph_width)

        layout = scratch_layout(graph_width)
        fault_off_i32 = layout["fault"] // 4

        out = torch.empty_like(attn_out)
        res_out = torch.empty_like(residual)

        self._epoch = (self._epoch + 1) & 0x7FFF_FFFF
        build.compiled.launch(
            grid=(BLOCKS, 1, 1),
            block=(THREADS, 1, 1),
            args=(
                attn_out.data_ptr(),
                residual.data_ptr(),
                layer.post_norm.data_ptr(),
                layer.w13.data_ptr(),
                layer.w2.data_ptr(),
                out.data_ptr(),
                res_out.data_ptr(),
                scratch.data_ptr(),
                int(num_rows),
                int(self._epoch),
            ),
        )

        self.fault_word.bitwise_or_(scratch[fault_off_i32 : fault_off_i32 + 4])
        return out, res_out

    def clear_fault(self) -> None:
        self.fault_word.zero_()
