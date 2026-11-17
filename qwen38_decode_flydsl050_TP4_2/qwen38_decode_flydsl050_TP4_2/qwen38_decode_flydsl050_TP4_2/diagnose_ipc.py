"""Probe local HIP IPC export before loading torch, vLLM, FlyDSL or a checkpoint.

Each case runs in a fresh Python process. Export success does not establish
peer import, GPU peer loads, or READY/DONE protocol correctness.
"""

from __future__ import annotations

import argparse
import ctypes
import importlib.util
import json
import os
from pathlib import Path
import platform
import subprocess
import sys

ENVIRONMENT_KEYS = (
    "HSA_ENABLE_IPC_MODE_LEGACY",
    "ROCM_PATH",
    "HIP_VISIBLE_DEVICES",
    "ROCR_VISIBLE_DEVICES",
    "CUDA_VISIBLE_DEVICES",
)


def load_wrapper():
    # Importing specialized_decode normally imports torch through __init__.
    # Load just this stdlib-only file so ROCr mode is fixed before initialization.
    path = Path(__file__).resolve().parent / "specialized_decode/runtime/_hip_ipc.py"
    spec = importlib.util.spec_from_file_location("qwen_ipc_probe_runtime", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def configure(lib, name, arguments):
    function = getattr(lib, name)
    function.restype = ctypes.c_int
    function.argtypes = arguments
    return function


def probe(device, size, allocator, runtime=None):
    result = {
        "device": device,
        "bytes": size,
        "allocator": allocator,
        "environment": {key: os.environ.get(key, "<unset>") for key in ENVIRONMENT_KEYS},
        "kernel": platform.release(),
        "stage": "load_runtime",
        "success": False,
    }
    pointer = 0
    try:
        runtime = runtime or load_wrapper().HipRuntime()
        lib = runtime.library()
        result["runtime_library"] = str(getattr(lib, "_name", "<unknown>"))
        for name in ("hipRuntimeGetVersion", "hipDriverGetVersion"):
            value = ctypes.c_int()
            runtime.check(configure(lib, name, [ctypes.POINTER(ctypes.c_int)])(ctypes.byref(value)), operation=name)
            result[name] = value.value
        result["stage"] = "select_device"
        runtime.set_device(device)
        result["stage"] = "allocate"
        if allocator == "uncached":
            pointer = runtime.allocate_uncached(size)
        else:
            pointer = runtime.allocate_device(size)
        result["stage"] = "synchronize"
        runtime.check(configure(lib, "hipDeviceSynchronize", [])(), operation="hipDeviceSynchronize")
        result["stage"] = "export"
        handle = runtime.get_ipc_handle(pointer)
        result["handle_bytes"] = len(handle)
        if len(handle) != 64:
            raise RuntimeError("Unexpected IPC handle size")
        # Do not print opaque handles or addresses. This process owns no imports.
        result["success"] = True
        result["stage"] = "complete"
    except Exception as error:
        result["error"] = str(error)
        result["hip_status"] = getattr(error, "code", None)
    finally:
        if pointer:
            try:
                runtime.free_device_memory(pointer)
            except Exception as error:
                result["cleanup_error"] = str(error)
                result["success"] = False
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--devices", default="0,1", help="HIP-visible device ordinals")
    parser.add_argument("--bytes", type=int, default=164352, help="Production mailbox bytes")
    parser.add_argument("--compare-modes", action="store_true", help="Test inherited, 0 and 1 in fresh processes")
    parser.add_argument("--timeout", type=float, default=30, help="Per-case process timeout in seconds")
    parser.add_argument("--production-allocator", choices=("malloc", "uncached"),
                        default="malloc" if os.environ.get("QWEN38_IPC_ALLOCATOR") == "hipmalloc" else "uncached")
    parser.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    parser.add_argument("--allocator", choices=("malloc", "uncached"), help=argparse.SUPPRESS)
    args = parser.parse_args()
    try:
        devices = [int(value) for value in args.devices.split(",")]
    except ValueError:
        parser.error("--devices must be comma-separated integer ordinals")
    if not devices or any(value < 0 for value in devices) or args.bytes <= 0 or args.timeout <= 0:
        parser.error("Use nonnegative devices and positive --bytes/--timeout")
    if args.worker:
        if len(devices) != 1 or args.allocator is None:
            parser.error("Internal worker requires one device and an allocator")
        print(json.dumps(probe(devices[0], args.bytes, args.allocator)))
        return
    cases = []
    for mode in ([None, "0", "1"] if args.compare_modes else [None]):
        env = dict(os.environ)
        if mode is not None:
            env["HSA_ENABLE_IPC_MODE_LEGACY"] = mode
        for device in devices:
            for allocator in ("malloc", "uncached"):
                command = [sys.executable, str(Path(__file__).resolve()), "--worker",
                           "--devices", str(device), "--bytes", str(args.bytes),
                           "--allocator", allocator]
                try:
                    completed = subprocess.run(command, env=env, text=True, capture_output=True,
                                               timeout=args.timeout, check=True)
                    record = json.loads(completed.stdout)
                except (subprocess.SubprocessError, ValueError) as error:
                    record = {"device": device, "allocator": allocator, "success": False,
                              "stage": "worker", "error": str(error)}
                record["mode_case"] = "inherited" if mode is None else mode
                cases.append(record)
                print(json.dumps(record), flush=True)
    # Matrix mode can succeed when mode 0 passes the selected allocation cases,
    # even if deliberately tested legacy mode fails. Inspect each printed case.
    production_mode = "0" if args.compare_modes else "inherited"
    passed = all(case["success"] for case in cases
                 if case["mode_case"] == production_mode and case["allocator"] == args.production_allocator)
    print(json.dumps({"exports_passed": passed, "allocator": args.production_allocator, "mode_case": production_mode,
                      "scope": "local export only; peer import/read and kernel execution NOT tested"}))
    raise SystemExit(0 if passed else 1)


if __name__ == "__main__":
    main()
