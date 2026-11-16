# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2025 FlyDSL Project Contributors

"""HIP host allocation/IPC wrapper, adapted from FlyDSL v0.5.0.

Local changes: explicit hipMalloc base allocation, structured HIP errors,
explicit device selection, and contextual
IPC export diagnostics. Uncached allocation and the GPU protocol are unchanged.
"""

from __future__ import annotations

import ctypes
import os

HIP_IPC_HANDLE_BYTES = 64
HIP_IPC_MEM_LAZY_ENABLE_PEER_ACCESS = 0x1
HIP_DEVICE_MALLOC_UNCACHED = 0x3
_RANGE_START_ADDR = 11


class _HipIpcMemHandle(ctypes.Structure):
    _fields_ = [("reserved", ctypes.c_byte * HIP_IPC_HANDLE_BYTES)]


class HipError(RuntimeError):
    """A failed HIP host call, retaining its operation and numeric status."""

    def __init__(self, operation, code, message):
        self.operation, self.code = operation, int(code)
        super().__init__(f"{operation} failed: {message} (HIP status {self.code})")


def ipc_export_diagnostic(error, *, size, device, library, allocator="uncached"):
    """Do not change ROCr settings after runtime initialization."""
    mode = os.environ.get("HSA_ENABLE_IPC_MODE_LEGACY", "<unset>")
    detail = (
        f"{error}; exporting a dedicated {allocator} HIP allocation of {size} bytes "
        f"on device {device}, runtime={library!r}, HSA_ENABLE_IPC_MODE_LEGACY={mode}. "
        "This failed before any peer mapping or FlyDSL attention SUM. "
    )
    if getattr(error, "code", None) == 1:
        detail += (
            "On affected gfx1201/ROCm/Linux stacks, legacy IPC export returns "
            "hipErrorInvalidValue. Test HSA_ENABLE_IPC_MODE_LEGACY=0 in the "
            "launch environment, then restart every worker; changing it here "
            "is too late. Run diagnose_ipc.py --devices 0,1 --compare-modes "
            "to distinguish runtime-mode and allocation-type failures. "
        )
    return detail + (
        "The mailbox bypasses PyTorch's caching allocator; changing "
        "expandable_segments is not a fix for this allocation. If direct IPC "
        "is unsupported, restart with QWEN38_ATTENTION_INPUT=reduced so stock "
        "attention SUM remains enabled."
    )


class HipRuntime:
    """Load HIP once and expose the host operations used by peer-memory wrappers."""

    def __init__(self, library=None) -> None:
        self._library = library
        self._configured_library = None

    def library(self):
        """Return the configured HIP ctypes library, loading it on first use."""

        if self._library is None:
            sonames = ("libamdhip64.so", "libamdhip64.so.7", "libamdhip64.so.6", "libamdhip64.so.5")
            candidates = []
            rocm_path = os.environ.get("ROCM_PATH")
            if rocm_path:
                candidates.extend(
                    os.path.join(rocm_path, lib_dir, name) for lib_dir in ("lib", "lib64") for name in sonames
                )
            candidates.extend(sonames)
            for name in candidates:
                try:
                    self._library = ctypes.CDLL(name)
                    break
                except OSError:
                    continue
            if self._library is None:
                raise RuntimeError("Failed to load HIP runtime library")
        self._configure(self._library)
        return self._library

    def _configure(self, library) -> None:
        if self._configured_library is library:
            return
        library.hipSetDevice.restype = ctypes.c_int
        library.hipSetDevice.argtypes = [ctypes.c_int]
        library.hipIpcGetMemHandle.restype = ctypes.c_int
        library.hipIpcGetMemHandle.argtypes = [ctypes.POINTER(_HipIpcMemHandle), ctypes.c_void_p]
        library.hipIpcOpenMemHandle.restype = ctypes.c_int
        library.hipIpcOpenMemHandle.argtypes = [ctypes.POINTER(ctypes.c_void_p), _HipIpcMemHandle, ctypes.c_uint]
        library.hipIpcCloseMemHandle.restype = ctypes.c_int
        library.hipIpcCloseMemHandle.argtypes = [ctypes.c_void_p]
        library.hipGetErrorString.restype = ctypes.c_char_p
        library.hipGetErrorString.argtypes = [ctypes.c_int]
        library.hipPointerGetAttribute.restype = ctypes.c_int
        library.hipPointerGetAttribute.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_void_p]
        library.hipMalloc.restype = ctypes.c_int
        library.hipMalloc.argtypes = [ctypes.POINTER(ctypes.c_void_p), ctypes.c_size_t]
        library.hipExtMallocWithFlags.restype = ctypes.c_int
        library.hipExtMallocWithFlags.argtypes = [ctypes.POINTER(ctypes.c_void_p), ctypes.c_size_t, ctypes.c_uint]
        library.hipFree.restype = ctypes.c_int
        library.hipFree.argtypes = [ctypes.c_void_p]
        library.hipMemset.restype = ctypes.c_int
        library.hipMemset.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_size_t]
        self._configured_library = library

    def check(self, error: int, *, operation: str) -> None:
        """Raise a descriptive exception when a HIP call fails."""

        if int(error) == 0:
            return
        try:
            value = self.library().hipGetErrorString(int(error))
            message = value.decode("utf-8", errors="replace") if value else f"hipError({error})"
        except Exception:
            message = f"hipError({error})"
        raise HipError(operation, error, message)

    def set_device(self, device: int) -> None:
        """Select the local visible GPU in the HIP runtime used by this wrapper."""
        self.check(self.library().hipSetDevice(int(device)), operation="hipSetDevice")

    def get_allocation_base(self, device_pointer: int) -> int:
        """Return the hipMalloc allocation base containing ``device_pointer``."""

        base = ctypes.c_void_p()
        error = self.library().hipPointerGetAttribute(
            ctypes.byref(base),
            ctypes.c_int(_RANGE_START_ADDR),
            ctypes.c_void_p(int(device_pointer)),
        )
        self.check(error, operation="hipPointerGetAttribute(RANGE_START_ADDR)")
        if base.value is None:
            raise RuntimeError("hipPointerGetAttribute(RANGE_START_ADDR) returned a null allocation base")
        return int(base.value)

    def get_ipc_handle(self, allocation_base: int) -> bytes:
        """Export a fixed-size HIP IPC handle for an allocation base pointer."""

        handle = _HipIpcMemHandle()
        error = self.library().hipIpcGetMemHandle(
            ctypes.byref(handle),
            ctypes.c_void_p(int(allocation_base)),
        )
        self.check(error, operation="hipIpcGetMemHandle")
        return bytes(ctypes.string_at(ctypes.byref(handle), HIP_IPC_HANDLE_BYTES))

    def open_ipc_handle(self, handle_bytes: bytes) -> int:
        """Map a peer allocation and return its local base pointer."""

        if len(handle_bytes) != HIP_IPC_HANDLE_BYTES:
            raise ValueError(f"expected a {HIP_IPC_HANDLE_BYTES}-byte HIP IPC handle, got {len(handle_bytes)} bytes")
        handle = _HipIpcMemHandle()
        ctypes.memmove(ctypes.byref(handle), bytes(handle_bytes), HIP_IPC_HANDLE_BYTES)
        mapped_base = ctypes.c_void_p()
        error = self.library().hipIpcOpenMemHandle(
            ctypes.byref(mapped_base),
            handle,
            ctypes.c_uint(HIP_IPC_MEM_LAZY_ENABLE_PEER_ACCESS),
        )
        self.check(error, operation="hipIpcOpenMemHandle")
        if mapped_base.value is None:
            raise RuntimeError("hipIpcOpenMemHandle returned a null mapped pointer")
        return int(mapped_base.value)

    def close_ipc_handle(self, mapped_base: int) -> None:
        """Close a peer mapping returned by :meth:`open_ipc_handle`."""

        error = self.library().hipIpcCloseMemHandle(ctypes.c_void_p(int(mapped_base)))
        self.check(error, operation="hipIpcCloseMemHandle")

    def allocate_device(self, size: int) -> int:
        """Allocate with plain hipMalloc; return its exact base, never a tensor view.

        The allocation is cached/default device memory. This method establishes
        the IPC allocation contract, not in-kernel inter-GPU coherence.
        """
        return self._allocate_zeroed(size, uncached=False)

    def allocate_uncached(self, size: int) -> int:
        """Preserve the original uncached allocation for qualified deployments."""
        return self._allocate_zeroed(size, uncached=True)

    def _allocate_zeroed(self, size: int, *, uncached: bool) -> int:
        if not isinstance(size, int) or isinstance(size, bool) or size <= 0:
            raise ValueError("Device allocation size must be a positive integer")
        buffer = ctypes.c_void_p()
        library = self.library()
        if uncached:
            operation = "hipExtMallocWithFlags"
            error = library.hipExtMallocWithFlags(
                ctypes.byref(buffer), ctypes.c_size_t(size),
                ctypes.c_uint(HIP_DEVICE_MALLOC_UNCACHED))
        else:
            operation = "hipMalloc"
            error = library.hipMalloc(ctypes.byref(buffer), ctypes.c_size_t(size))
        self.check(error, operation=operation)
        if buffer.value is None:
            raise RuntimeError(f"{operation} returned a null pointer")
        error = library.hipMemset(buffer, 0, ctypes.c_size_t(size))
        if int(error) != 0:
            cleanup_error = library.hipFree(buffer)
            try:
                self.check(error, operation="hipMemset")
            except RuntimeError as exc:
                if int(cleanup_error) != 0:
                    raise RuntimeError(f"{exc}; cleanup hipFree also failed with hipError({cleanup_error})") from exc
                raise
        return int(buffer.value)

    def free_device_memory(self, device_pointer: int) -> None:
        """Free a raw device allocation."""

        error = self.library().hipFree(ctypes.c_void_p(int(device_pointer)))
        self.check(error, operation="hipFree")


_DEFAULT_RUNTIME = HipRuntime()


def get_allocation_base(device_pointer: int) -> int:
    """Return the base of the HIP allocation containing ``device_pointer``."""

    return _DEFAULT_RUNTIME.get_allocation_base(device_pointer)


def get_ipc_handle(allocation_base: int) -> bytes:
    """Export an IPC handle for ``allocation_base``."""

    return _DEFAULT_RUNTIME.get_ipc_handle(allocation_base)


def open_ipc_handle(handle_bytes: bytes) -> int:
    """Open a peer IPC handle and return its mapped base pointer."""

    return _DEFAULT_RUNTIME.open_ipc_handle(handle_bytes)


def close_ipc_handle(mapped_base: int) -> None:
    """Close a peer mapping returned by :func:`open_ipc_handle`."""

    _DEFAULT_RUNTIME.close_ipc_handle(mapped_base)


def allocate_device(size: int) -> int:
    """Allocate zeroed device memory with plain hipMalloc."""
    return _DEFAULT_RUNTIME.allocate_device(size)


def allocate_uncached(size: int) -> int:
    """Allocate and zero uncached HIP device memory."""

    return _DEFAULT_RUNTIME.allocate_uncached(size)


def free_device_memory(device_pointer: int) -> None:
    """Free a raw HIP device allocation."""

    _DEFAULT_RUNTIME.free_device_memory(device_pointer)


def load_runtime():
    """Return the process-wide configured HIP ctypes library."""

    return _DEFAULT_RUNTIME.library()


def check_hip_error(error: int, *, operation: str) -> None:
    """Validate a HIP status with the process-wide runtime."""

    _DEFAULT_RUNTIME.check(error, operation=operation)


__all__ = [
    "HIP_DEVICE_MALLOC_UNCACHED",
    "HIP_IPC_HANDLE_BYTES",
    "HIP_IPC_MEM_LAZY_ENABLE_PEER_ACCESS",
    "HipRuntime",
    "HipError",
    "allocate_device",
    "ipc_export_diagnostic",
    "allocate_uncached",
    "check_hip_error",
    "close_ipc_handle",
    "free_device_memory",
    "get_allocation_base",
    "get_ipc_handle",
    "load_runtime",
    "open_ipc_handle",
]
