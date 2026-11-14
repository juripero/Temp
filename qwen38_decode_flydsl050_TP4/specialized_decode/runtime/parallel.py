"""Explicit TP-group collectives; no peer-pointer or IPC assumptions.

All-reduce returns the SUM, never an average, and may allocate a new tensor.
The local BF16 down output is rounded before the collective, as in stock
vLLM RowParallelLinear. Norm/residual tensors are already replicated.
"""
from __future__ import annotations

from dataclasses import asdict

import torch
import torch.distributed as dist


class TpCollective:
    """Interface also usable by standalone tests and custom integrations.

    all_reduce must enqueue on / establish dependencies with the current
    PyTorch stream. setup_agreement is a startup-only host operation, called
    by every rank in the same order. No per-layer host synchronization occurs.
    """

    world_size: int
    rank: int

    def all_reduce(self, tensor: torch.Tensor) -> torch.Tensor:
        raise NotImplementedError

    def setup_agreement(self, signature: dict, error: str | None) -> list[str]:
        raise NotImplementedError


def setup_signature(config):
    signature = asdict(config)
    signature.pop("tp_rank")
    signature.pop("cache_dir")  # Local compiler-cache locations may differ.
    return signature


def _check_agreement(records, world_size):
    if sorted(r["rank"] for r in records) != list(range(world_size)):
        raise RuntimeError("TP startup ranks are inconsistent")
    if any(r["signature"] != records[0]["signature"] for r in records):
        raise RuntimeError("TP ranks disagree on specialized-decode configuration")
    return [f"TP rank {r['rank']}: {r['error']}" for r in records if r["error"]]


class VllmTpCollective(TpCollective):
    def __init__(self, group):
        self.group = group
        self.world_size = group.world_size
        self.rank = group.rank_in_group

    def all_reduce(self, tensor):
        # Match stock RowParallelLinear's group and selected communicator.
        # The return value is authoritative: vLLM normally reduces out-of-place.
        return self.group.all_reduce(tensor)

    def setup_agreement(self, signature, error):
        if self.world_size == 1:
            return [error] if error else []
        records = [None] * self.world_size
        dist.all_gather_object(records, {"rank": self.rank, "signature": signature,
                                        "error": error}, group=self.group.cpu_group)
        return _check_agreement(records, self.world_size)


class TorchTpCollective(TpCollective):
    """Standalone qualification; ROCm uses the torch 'nccl' backend (RCCL).

    Pass an explicit process group, including dist.group.WORLD when intended.
    The serving integration always uses VllmTpCollective and its TP subgroup.
    """

    def __init__(self, group):
        if group is None or not dist.is_initialized():
            raise ValueError("An initialized, explicit process group is required")
        self.group = group
        self.world_size = dist.get_world_size(group)
        self.rank = dist.get_rank(group)
        if self.world_size not in (1, 2, 4) or not 0 <= self.rank < self.world_size:
            raise ValueError("Expected membership in a TP1, TP2, or TP4 group")

    def all_reduce(self, tensor):
        result = tensor.clone()
        dist.all_reduce(result, op=dist.ReduceOp.SUM, group=self.group)
        return result

    def setup_agreement(self, signature, error):
        records = [None] * self.world_size
        dist.all_gather_object(records, {"rank": self.rank, "signature": signature,
                                        "error": error}, group=self.group)
        return _check_agreement(records, self.world_size)


def checked_sum(collective, tensor):
    result = collective.all_reduce(tensor)
    if (not isinstance(result, torch.Tensor) or result.shape != tensor.shape
            or result.dtype != tensor.dtype or result.device != tensor.device):
        raise RuntimeError("TP all-reduce returned an incompatible tensor")
    return result
