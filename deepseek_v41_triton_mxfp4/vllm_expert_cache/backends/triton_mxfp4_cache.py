"""Fixed-size device cache with same-stream manager, gathers, and MoE launches."""

from __future__ import annotations

from contextlib import contextmanager
from threading import Lock

import torch

from ..config import settings
from .triton_mxfp4_layout import empty_slots, expert_slab, physical_bytes


class TritonSlotCache:
    def __init__(self, owner, names, experts: int, slots: int):
        self.owner, self.names, self.E, self.S = owner, list(names), experts, slots
        if not 0 < slots < experts or slots > 4096:
            raise ValueError("Expected 0 < slots < experts and slots <= 4096")
        self.device = getattr(owner, self.names[0]).device
        self.slots = {
            name: empty_slots(getattr(owner, name), experts, slots)
            for name in self.names
        }
        kw = {"device": self.device}
        self.table = torch.full((experts,), -1, dtype=torch.int32, **kw)
        self.slot_expert = torch.full((slots,), -1, dtype=torch.int32, **kw)
        self.scores = torch.zeros(slots, dtype=torch.int64, **kw)
        self.step = torch.zeros((), dtype=torch.int64, **kw)
        self.miss = torch.full((slots,), -1, dtype=torch.int32, **kw)
        self.n_miss = torch.zeros((), dtype=torch.int32, **kw)
        if settings.policy not in ("lru", "lfu") or settings.decay < 0:
            raise ValueError("Expected policy lru/lfu and nonnegative decay")
        self.policy, self.decay = settings.policy_code, settings.decay
        self._lock = Lock()
        self._last_stream = torch.cuda.current_stream(self.device)
        self._handoff = torch.cuda.Event()
        self.started = False
        self.failed = False

    def fits(self, ids):
        return ids.numel() <= self.S

    @contextmanager
    def invocation(self):
        if not self._lock.acquire(blocking=False):
            raise RuntimeError("Concurrent/reentrant expert-cache invocation")
        try:
            if self.failed:
                raise RuntimeError(
                    "Expert-cache invocation failed earlier; restart worker"
                )
            with torch.cuda.device(self.device):
                if torch.cuda.is_current_stream_capturing():
                    raise RuntimeError("This adapter requires vLLM --enforce-eager")
                stream = torch.cuda.current_stream(self.device)
                if stream != self._last_stream:
                    self._handoff.record(self._last_stream)
                    stream.wait_event(self._handoff)
                try:
                    yield
                except BaseException:
                    self.failed = True
                    raise
                finally:
                    self._last_stream = stream
                    self.started = True
        finally:
            self._lock.release()

    def refresh(self, ids):
        import triton

        from .triton_mxfp4_kernels import gather, manage

        if ids.device != self.device or ids.dtype not in (torch.int32, torch.int64):
            raise ValueError("Routing IDs must be int32/int64 on the weight device")
        if ids.ndim != 2 or not self.fits(ids):
            raise ValueError(
                "refresh requires a fitting [tokens, top_k] routing tensor"
            )
        source_ids = ids.contiguous()
        mapped = torch.empty_like(source_ids)
        manage[(1,)](
            source_ids,
            mapped,
            self.table,
            self.slot_expert,
            self.scores,
            self.step,
            self.miss,
            self.n_miss,
            self.E,
            self.S,
            ids.numel(),
            triton.next_power_of_2(self.S),
            self.policy,
            self.decay,
            num_warps=4,
        )
        for name in self.names:
            source, destination = getattr(self.owner, name), self.slots[name]
            slab = expert_slab(source, self.E) * source.element_size()
            gather[(self.S, triton.cdiv(slab, 4096))](
                physical_bytes(source),
                physical_bytes(destination),
                self.miss,
                slab,
                4096,
                num_warps=4,
            )
        return mapped
