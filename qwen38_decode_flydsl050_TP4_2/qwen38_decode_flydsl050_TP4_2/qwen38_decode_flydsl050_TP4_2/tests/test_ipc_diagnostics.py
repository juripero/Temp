"""Host HIP ABI/cleanup tests; no GPU execution is simulated as a hardware pass."""

import ctypes
import os
from types import SimpleNamespace
import unittest
from unittest.mock import patch

from diagnose_ipc import probe
from specialized_decode.runtime._hip_ipc import HipError, HipRuntime, ipc_export_diagnostic
from specialized_decode.runtime.peer import PeerArena, validate_topology


class Function:
    def __init__(self, action):
        self.action = action

    def __call__(self, *args):
        return self.action(*args)


def value(item):
    return item.value if hasattr(item, "value") else item


class Library:
    _name = "/fake/libamdhip64.so"

    def __init__(self, export_status=0, memset_status=0):
        self.export_status, self.memset_status = export_status, memset_status
        self.calls = []
        for name in ("hipSetDevice", "hipIpcGetMemHandle", "hipIpcOpenMemHandle",
                     "hipIpcCloseMemHandle", "hipPointerGetAttribute", "hipExtMallocWithFlags",
                     "hipFree", "hipMemset", "hipDeviceGetPCIBusId", "hipDeviceGetByPCIBusId",
                     "hipDeviceCanAccessPeer", "hipRuntimeGetVersion", "hipDriverGetVersion",
                     "hipMalloc", "hipDeviceSynchronize"):
            setattr(self, name, Function(lambda *args, name=name: self.call(name, args)))
        self.hipGetErrorString = Function(lambda status: b"invalid argument" if status == 1 else b"test failure")

    def call(self, name, args):
        self.calls.append((name, args))
        if name in ("hipExtMallocWithFlags", "hipMalloc"):
            ctypes.cast(args[0], ctypes.POINTER(ctypes.c_void_p))[0] = 0x100000
        elif name == "hipIpcGetMemHandle":
            if self.export_status:
                return self.export_status
            ctypes.memset(args[0], 7, 64)
        elif name == "hipMemset":
            return self.memset_status
        elif name == "hipDeviceGetPCIBusId":
            args[0].value = b"0000:03:00.0"
        elif name in ("hipRuntimeGetVersion", "hipDriverGetVersion"):
            ctypes.cast(args[0], ctypes.POINTER(ctypes.c_int))[0] = 70200000
        return 0


class IpcDiagnosticsTests(unittest.TestCase):
    def test_status_operation_and_base_pointer_are_preserved(self):
        lib = Library(export_status=1)
        runtime = HipRuntime(lib)
        with self.assertRaises(HipError) as caught:
            runtime.get_ipc_handle(0x12340000)
        self.assertEqual(caught.exception.code, 1)
        self.assertEqual(caught.exception.operation, "hipIpcGetMemHandle")
        self.assertIn("HIP status 1", str(caught.exception))
        self.assertEqual(value(lib.calls[-1][1][1]), 0x12340000)

    def test_exact_binary_handle_size(self):
        self.assertEqual(HipRuntime(Library()).get_ipc_handle(0x100000), bytes([7]) * 64)

    def test_mailbox_remains_uncached(self):
        lib = Library()
        pointer = HipRuntime(lib).allocate_uncached(164352)
        self.assertEqual(pointer, 0x100000)
        name, args = lib.calls[0]
        self.assertEqual(name, "hipExtMallocWithFlags")
        self.assertEqual((value(args[1]), value(args[2])), (164352, 3))

    def test_zero_failure_frees_owner(self):
        lib = Library(memset_status=1)
        with self.assertRaises(HipError):
            HipRuntime(lib).allocate_uncached(164352)
        self.assertEqual([name for name, _ in lib.calls], ["hipExtMallocWithFlags", "hipMemset", "hipFree"])

    def test_diagnostic_does_not_mutate_runtime_mode(self):
        with patch.dict(os.environ, {"HSA_ENABLE_IPC_MODE_LEGACY": "1"}):
            message = ipc_export_diagnostic(HipError("hipIpcGetMemHandle", 1, "invalid argument"),
                                            size=164352, device=1, library="hip")
            self.assertIn("HSA_ENABLE_IPC_MODE_LEGACY=0", message)
            self.assertIn("restart every worker", message)
            self.assertIn("bypasses PyTorch", message)
            self.assertEqual(os.environ["HSA_ENABLE_IPC_MODE_LEGACY"], "1")

    def test_other_status_is_not_misdiagnosed_as_invalid_value(self):
        message = ipc_export_diagnostic(HipError("hipIpcGetMemHandle", 2, "out of memory"),
                                        size=164352, device=0, library="hip")
        self.assertNotIn("legacy IPC export returns", message)
        self.assertIn("out of memory", message)

    def test_modes_must_match_across_ranks(self):
        records = [dict(rank=r, error=None, host=("host", "boot"), bus=str(r), size=164352,
                        protocol=1, handle=bytes(64), ipc_mode=str(r)) for r in range(2)]
        with self.assertRaisesRegex(RuntimeError, "different HSA_ENABLE"):
            validate_topology(records, 2, 164352)
        records[1]["ipc_mode"] = "0"
        validate_topology(records, 2, 164352)

    def test_export_failure_selects_device_frees_allocation_and_never_maps(self):
        lib = Library(export_status=1)
        runtime = HipRuntime(lib)
        collective = SimpleNamespace(gather_host=lambda record: [record, {**record, "rank": 1}])
        config = SimpleNamespace(tp_size=2, tp_rank=0, hidden_size=5120)
        with patch("specialized_decode.runtime.peer.HipRuntime", return_value=runtime), \
             patch("torch.cuda.synchronize"):
            with self.assertRaisesRegex(RuntimeError, "IPC handle export.*HIP status 1"):
                PeerArena("cuda:1", config, collective)
        names = [name for name, _ in lib.calls]
        self.assertLess(names.index("hipSetDevice"), names.index("hipExtMallocWithFlags"))
        self.assertEqual(value(lib.calls[names.index("hipSetDevice")][1][0]), 1)
        self.assertEqual(names.count("hipFree"), 1)
        self.assertNotIn("hipIpcOpenMemHandle", names)

    def test_probe_reports_export_stage_and_cleans_up(self):
        lib = Library(export_status=1)
        result = probe(0, 164352, "uncached", HipRuntime(lib))
        self.assertFalse(result["success"])
        self.assertEqual(result["stage"], "export")
        self.assertEqual(result["hip_status"], 1)
        self.assertEqual(lib.calls[-1][0], "hipFree")

    def test_probe_compares_raw_malloc_and_uncached_without_torch_allocations(self):
        for allocator, call in (("malloc", "hipMalloc"), ("uncached", "hipExtMallocWithFlags")):
            lib = Library()
            result = probe(0, 164352, allocator, HipRuntime(lib))
            self.assertTrue(result["success"])
            self.assertEqual(result["handle_bytes"], 64)
            self.assertIn(call, [name for name, _ in lib.calls])
            self.assertNotIn("handle", result)

    def test_plain_malloc_returns_and_exports_exact_base(self):
        lib = Library()
        runtime = HipRuntime(lib)
        pointer = runtime.allocate_device(164352)
        runtime.get_ipc_handle(pointer)
        runtime.free_device_memory(pointer)
        self.assertEqual([n for n, _ in lib.calls],
                         ["hipMalloc", "hipMemset", "hipIpcGetMemHandle", "hipFree"])
        self.assertEqual(value(lib.calls[0][1][1]), 164352)
        self.assertEqual(value(lib.calls[2][1][1]), 0x100000)
        self.assertEqual(value(lib.calls[3][1][0]), 0x100000)

    def test_plain_malloc_zero_failure_frees_base(self):
        lib = Library(memset_status=1)
        with self.assertRaisesRegex(HipError, "hipMemset"):
            HipRuntime(lib).allocate_device(164352)
        self.assertEqual([n for n, _ in lib.calls], ["hipMalloc", "hipMemset", "hipFree"])

    def test_invalid_allocation_sizes_do_not_call_hip(self):
        lib = Library()
        for size in (0, -1, True, 1.5):
            with self.assertRaises(ValueError):
                HipRuntime(lib).allocate_device(size)
        self.assertEqual(lib.calls, [])

    def test_allocators_must_agree(self):
        records = [dict(rank=r, error=None, allocator=a)
                   for r, a in enumerate(("hipmalloc", "uncached"))]
        with self.assertRaisesRegex(RuntimeError, "QWEN38_IPC_ALLOCATOR"):
            validate_topology(records, 2, 164352)

    def test_peer_uses_plain_malloc_and_never_silently_retries(self):
        lib = Library(export_status=1)
        runtime = HipRuntime(lib)
        collective = SimpleNamespace(gather_host=lambda record: [record, {**record, "rank": 1}])
        config = SimpleNamespace(tp_size=2, tp_rank=0, hidden_size=5120)
        with patch.dict(os.environ, {"QWEN38_IPC_ALLOCATOR": "hipmalloc"}), \
             patch("specialized_decode.runtime.peer.HipRuntime", return_value=runtime), \
             patch("torch.cuda.synchronize"):
            with self.assertRaisesRegex(RuntimeError, "dedicated hipmalloc"):
                PeerArena("cuda:1", config, collective)
        names = [name for name, _ in lib.calls]
        self.assertIn("hipMalloc", names)
        self.assertNotIn("hipExtMallocWithFlags", names)
        self.assertNotIn("hipIpcOpenMemHandle", names)
        self.assertEqual(names.count("hipFree"), 1)
        self.assertEqual(value(lib.calls[names.index("hipIpcGetMemHandle")][1][1]), 0x100000)


if __name__ == "__main__":
    unittest.main()
