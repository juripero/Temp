"""Fixed-size device cache with same-stream manager, gathers, and MoE launches."""

from __future__ import annotations

from contextlib import contextmanager

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
        # These buffers are allocated before capture, outside graph-private pools.
        self.route_input = torch.empty(slots, dtype=torch.int32, **kw)
        self.route_output32 = torch.empty(slots, dtype=torch.int32, **kw)
        self.route_output64 = torch.empty(slots, dtype=torch.int64, **kw)
        self._source_bytes = {
            name: physical_bytes(getattr(owner, name)) for name in self.names
        }
        self._slot_bytes = {name: physical_bytes(t) for name, t in self.slots.items()}
        self._warm_keys = set()
        self.started = False
        self.failed = False
        from .triton_mxfp4_graph import register

        register(self)

    def fits(self, ids):
        return ids.numel() <= self.S

    @contextmanager
    def invocation(self):
        with torch.cuda.device(self.device), self.execution_lane.cache_call(self):
            yield
            # A first-call full-path fallback must freeze views too, before any
            # later graph records the cache's persistent-storage signature.
            self._prepare_sources()

    def _prepare_sources(self):
        if not self._source_bytes or not self.started:
            self._source_bytes = {
                name: physical_bytes(getattr(self.owner, name)) for name in self.names
            }

    @staticmethod
    def _signature(tensor):
        return (
            id(tensor),
            tensor.data_ptr(),
            tuple(tensor.shape),
            tuple(tensor.stride()),
            tensor.dtype,
            tensor.device,
        )

    def graph_signature(self):
        tensors = [(name, getattr(self.owner, name)) for name in self.names]
        tensors += [("slot:" + name, value) for name, value in self.slots.items()]
        tensors += [
            (name, getattr(self, name))
            for name in (
                "table",
                "slot_expert",
                "scores",
                "step",
                "miss",
                "n_miss",
                "route_input",
                "route_output32",
                "route_output64",
            )
        ]
        tensors += [
            ("source-view:" + name, value) for name, value in self._source_bytes.items()
        ]
        binding = getattr(self, "binding", None)
        if binding is not None:
            tensors += binding.graph_tensors()
        return tuple((name, self._signature(value)) for name, value in tensors)

    def refresh(self, ids):
        import triton

        from .triton_mxfp4_kernels import gather, manage

        if ids.device != self.device or ids.dtype not in (torch.int32, torch.int64):
            raise ValueError("Routing IDs must be int32/int64 on the weight device")
        if ids.ndim != 2 or not self.fits(ids):
            raise ValueError(
                "refresh requires a fitting [tokens, top_k] routing tensor"
            )
        key = (tuple(ids.shape), ids.dtype)
        capturing = torch.cuda.is_current_stream_capturing()
        if capturing and key not in self._warm_keys:
            raise RuntimeError(
                "Warm up the exact MoE routing shape once before capture; "
                "set cudagraph_num_of_warmups=1 for wrapper-based capture."
            )
        self._prepare_sources()
        source_ids = self.route_input[: ids.numel()].view(ids.shape)
        source_ids.copy_(ids)
        output = (
            self.route_output32 if ids.dtype == torch.int32 else self.route_output64
        )
        mapped = output[: ids.numel()].view(ids.shape)
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
            source = getattr(self.owner, name)
            slab = expert_slab(source, self.E) * source.element_size()
            gather[(self.S, triton.cdiv(slab, 4096))](
                self._source_bytes[name],
                self._slot_bytes[name],
                self.miss,
                slab,
                4096,
                num_warps=4,
            )
        if not capturing:
            self._warm_keys.add(key)
        return mapped
