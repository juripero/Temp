"""Dedicated uncached IPC mailboxes for same-host TP2/TP4 attention SUM.

Uses FlyDSL v0.5.0's vendored HIP host allocation/IPC wrapper. GPU code remains
FlyDSL. No PyTorch caching-allocator allocation is exported. Construction and
explicit teardown are collective; destruction never implicitly frees buffers.
"""
from __future__ import annotations

import ctypes
from pathlib import Path
import socket

import torch

from ._hip_ipc import HipRuntime
from ..mono.peer_layout import arena_bytes
from ..mono.peer_layout import READY, DONE, EPOCH


def validate_topology(records, tp, size):
    if len(records) != tp or sorted(r["rank"] for r in records) != list(range(tp)):
        raise RuntimeError("IPC bootstrap has inconsistent TP membership")
    if any(r.get("error") for r in records):
        raise RuntimeError("IPC allocation failed: " + "; ".join(
            f"rank {r['rank']}: {r['error']}" for r in records if r.get("error")))
    if any(r["host"] != records[0]["host"] for r in records):
        raise RuntimeError("Fused attention IPC requires all TP ranks on the same host")
    if len({r["bus"] for r in records}) != tp:
        raise RuntimeError("Fused attention IPC requires distinct GPUs")
    if any(r["size"] != size or r["protocol"] != 1 or len(r["handle"]) != 64 for r in records):
        raise RuntimeError("IPC mailbox layout or handle mismatch")


class PeerArena:
    def __init__(self, device, config, collective):
        self.device = torch.device(device)
        self.collective = collective
        self.own = 0
        self.opened = []
        self.table = None
        self.runtime = None
        self.closed = False
        if config.tp_size not in (2, 4):
            raise ValueError("PeerArena requires TP2 or TP4")
        self.size = arena_bytes(config.hidden_size)
        record = {"rank": config.tp_rank, "size": self.size, "protocol": 1, "error": None}
        try:
            self.runtime = HipRuntime()
            lib = self.runtime.library()
            lib.hipDeviceGetPCIBusId.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_int]
            lib.hipDeviceGetPCIBusId.restype = ctypes.c_int
            lib.hipDeviceGetByPCIBusId.argtypes = [ctypes.POINTER(ctypes.c_int), ctypes.c_char_p]
            lib.hipDeviceGetByPCIBusId.restype = ctypes.c_int
            lib.hipDeviceCanAccessPeer.argtypes = [ctypes.POINTER(ctypes.c_int), ctypes.c_int, ctypes.c_int]
            lib.hipDeviceCanAccessPeer.restype = ctypes.c_int
            bus = ctypes.create_string_buffer(64)
            self.runtime.check(lib.hipDeviceGetPCIBusId(bus, 64, self.device.index),
                               operation="hipDeviceGetPCIBusId")
            # Both identifiers must agree; cross-container differing identities
            # are refused rather than guessed to be the same physical host.
            record["host"] = (socket.gethostname(), Path("/proc/sys/kernel/random/boot_id").read_text().strip())
            record["bus"] = bus.value.decode()
            self.own = self.runtime.allocate_uncached(self.size)
            torch.cuda.synchronize(self.device)
            record["handle"] = self.runtime.get_ipc_handle(self.own)
        except Exception as exc:
            record["error"] = f"{type(exc).__name__}: {exc}"
        records = collective.gather_host(record)
        try:
            validate_topology(records, config.tp_size, self.size)
        except Exception:
            if self.own:
                self.runtime.free_device_memory(self.own)
                self.own = 0
            raise
        records = sorted(records, key=lambda x: x["rank"])
        error = None
        try:
            pointers = []
            for item in records:
                if item["rank"] == config.tp_rank:
                    pointers.append(self.own)
                    continue
                peer_device, supported = ctypes.c_int(), ctypes.c_int()
                self.runtime.check(lib.hipDeviceGetByPCIBusId(ctypes.byref(peer_device), item["bus"].encode()),
                                   operation="hipDeviceGetByPCIBusId (all TP GPUs must be visible)")
                self.runtime.check(lib.hipDeviceCanAccessPeer(ctypes.byref(supported),
                                                             self.device.index, peer_device.value),
                                   operation="hipDeviceCanAccessPeer")
                if not supported.value:
                    raise RuntimeError(f"No peer access to TP rank {item['rank']}")
                mapped = self.runtime.open_ipc_handle(item["handle"])
                self.opened.append(mapped)
                pointers.append(mapped)
            self.table = torch.tensor(pointers, dtype=torch.uint64, device=self.device)
            torch.cuda.synchronize(self.device)
        except Exception as exc:
            error = f"{type(exc).__name__}: {exc}"
        errors = collective.gather_host(error)
        if any(errors):
            self.close_collective()  # No kernel has used the mappings yet.
            raise RuntimeError("IPC peer mapping failed: " + "; ".join(e for e in errors if e))

    def close_collective(self):
        """Call on ALL ranks only after destroying every graph that uses this arena.

        Synchronize before unmapping, then confirm every import is closed before
        freeing any owner allocation. A failed cleanup leaves allocations alive
        until process exit. Never call from __del__ or exception unwinding on
        just one rank.
        """
        with torch.cuda.device(self.device):
            self._close_collective()

    def _close_collective(self):
        if self.closed:
            return
        error = None
        try:
            torch.cuda.synchronize(self.device)
        except Exception as exc:
            error = str(exc)
        errors = self.collective.gather_host(error)
        if any(errors):
            raise RuntimeError("Cannot safely retire IPC workspace; stop all workers")
        error = None
        try:
            for mapped in self.opened:
                self.runtime.close_ipc_handle(mapped)
            self.opened.clear()
        except Exception as exc:
            error = str(exc)
        errors = self.collective.gather_host(error)
        if any(errors):
            raise RuntimeError("IPC unmap failed; owner buffers retained until worker exit")
        if self.own:
            self.runtime.free_device_memory(self.own)
            self.own = 0
        self.table = None
        self.closed = True

    def debug_seed_epoch_collective(self, epoch):
        """Qualification only: all ranks quiescent, no live/replaying graphs.

        Seed READY/DONE and EPOCH together to test uint32 rollover. This does
        not reset fault state and must never be used to recover a failed run.
        """
        if not 0 <= epoch < 2**32:
            raise ValueError("Expected uint32 epoch")
        with torch.cuda.device(self.device):
            torch.cuda.synchronize(self.device)
            seeds = self.collective.gather_host(epoch)
            if any(value != epoch for value in seeds):
                raise RuntimeError("Epoch seed must agree on every TP rank")
            lib = self.runtime.library()
            lib.hipMemcpy.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_size_t, ctypes.c_int]
            lib.hipMemcpy.restype = ctypes.c_int
            word = ctypes.c_uint32(epoch)
            for offset in (READY, DONE, EPOCH):
                self.runtime.check(lib.hipMemcpy(self.own + offset, ctypes.byref(word), 4, 1),
                                   operation="qualification hipMemcpy H2D")
            torch.cuda.synchronize(self.device)
            self.collective.gather_host(None)

    def debug_epoch(self):
        """Qualification only; blocks the host until device work completes."""
        with torch.cuda.device(self.device):
            torch.cuda.synchronize(self.device)
            lib = self.runtime.library()
            lib.hipMemcpy.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_size_t, ctypes.c_int]
            lib.hipMemcpy.restype = ctypes.c_int
            word = ctypes.c_uint32()
            self.runtime.check(lib.hipMemcpy(ctypes.byref(word), self.own + EPOCH, 4, 2),
                               operation="qualification hipMemcpy D2H")
            return word.value
