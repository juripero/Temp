"""Compile without a GPU: full code object (default), or assembly only.

python compile_smoke.py
python compile_smoke.py --isa-only

Full compilation needs the ROCm linker/toolkit. --isa-only exercises the same
tracing, MLIR lowering, and LLVM gfx1201 code generation, but deliberately skips
ELF linking. It does not produce a launchable kernel or test GPU execution.
Run this utility in its own process, never inside a running vLLM worker.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
from unittest.mock import patch

from specialized_decode.mono.a16w16 import build_ffn


def _objects(compiled):
    # Validation-only introspection of the pinned 0.5.0 artifact. The serving
    # launcher uses CompiledFunction's public call and occupancy interfaces.
    from flydsl.compiler.jit_function import _create_mlir_context
    from flydsl._mlir import ir
    from flydsl._mlir.dialects import gpu
    found = []
    with _create_mlir_context():
        module = ir.Module.parse(compiled._keepalive.ir)

        def visit(op):
            if op.name == "gpu.binary":
                for attr in ir.ArrayAttr(op.attributes["objects"]):
                    found.append(gpu.ObjectAttr(attr).object)
            return ir.WalkResult.ADVANCE

        module.operation.walk(visit)
    if len(found) != 1:
        raise AssertionError(f"Expected one device image; found {len(found)}")
    return found[0]


def compile_one(hidden, intermediate, blocks, output, isa_only, tp=1, rank=0, partial=False, ffn_reduce=False):
    module = build_ffn(hidden, intermediate, blocks=blocks, tp=tp, rank=rank, attention_partial=partial, ffn_reduce=ffn_reduce)
    if module.compiled._runtime_ready:
        raise AssertionError("Placeholder compilation initialized a device runtime")
    obj = _objects(module.compiled)
    blob = obj.encode() if isinstance(obj, str) else bytes(obj)
    stem = f"h{hidden}_i{intermediate}_b{blocks}_tp{tp}r{rank}_a{int(partial)}_f{int(ffn_reduce)}"
    result = {"hidden": hidden, "intermediate": intermediate, "blocks": blocks,
              "flydsl": "0.5.0", "target": "gfx1201", "executed_on_gpu": False,
              "tp_size": tp, "tp_rank": rank, "attention_partial": partial, "ffn_reduce": ffn_reduce}
    if isa_only:
        assembly = blob.decode()
        for marker in ("gfx1201", "v_wmma_f32_16x16x16_bf16",
                       ".amdhsa_wavefront_size32 1", "global_atomic_add_u32",
                       "global_atomic_cmpswap_b32", "scope:SCOPE_DEV"):
            if marker not in assembly:
                raise AssertionError(f"Missing ISA marker: {marker}")
        if (partial or ffn_reduce) and tp > 1 and "scope:SCOPE_SYS" not in assembly:
            raise AssertionError("Missing system-scope peer ordering in ISA")
        for key in ("next_free_vgpr", "next_free_sgpr", "group_segment_fixed_size",
                    "private_segment_fixed_size"):
            match = re.search(r"\.amdhsa_" + key + r"\s+(\d+)", assembly)
            if not match:
                raise AssertionError(f"Missing resource metadata: {key}")
            result[key] = int(match.group(1))
        result["wmma_instructions_in_static_assembly"] = assembly.count("v_wmma_f32_16x16x16_bf16")
        result["status"] = "ISA code generation passed; ELF linking not tested"
        path = output / (stem + ".s")
    else:
        if not blob.startswith(b"\x7fELF"):
            raise AssertionError("Compiler did not produce an ELF code object")
        result["status"] = "ELF compilation/linking passed; GPU execution not tested"
        path = output / (stem + ".hsaco")
    path.write_bytes(blob)
    result["artifact"] = path.name
    result["sha256"] = hashlib.sha256(blob).hexdigest()
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--isa-only", action="store_true")
    parser.add_argument("--output", type=Path, default=Path("build/flydsl050"))
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    os.environ.setdefault("FLYDSL_GPU_ARCH", "gfx1201")
    # Diagnostic assembly must not be persisted as a serving cache artifact.
    os.environ["FLYDSL_RUNTIME_ENABLE_CACHE"] = "0"

    def run():
        cases = [(h, global_i // tp, blocks, tp, rank, partial, ffn_reduce)
                 for h, global_i, blocks in ((32, 64, 4), (5120, 17408, 64))
                 for tp in (1, 2, 4)
                 for partial in (False, True)
                 for ffn_reduce in ((False, True) if tp > 1 else (False,))
                 for rank in ((0, tp - 1) if (partial or ffn_reduce) and tp > 1 else (0,))]
        return [compile_one(h, i, b, args.output, args.isa_only, tp, rank, partial, ffn_reduce)
                for h, i, b, tp, rank, partial, ffn_reduce in cases]

    if args.isa_only:
        from flydsl.compiler.backends.rocm import RocmBackend
        original = RocmBackend.pipeline_fragments

        def assembly_pipeline(self, *, compile_hints):
            # Same format=isa pass used by FlyDSL 0.5.0's own ISA dumper.
            # Only this diagnostic process substitutes the final output format.
            parts = original(self, compile_hints=compile_hints)
            if sum("format=fatbin" in p for p in parts) != 1:
                raise AssertionError("Unexpected FlyDSL compiler pipeline")
            return [p.replace("format=fatbin", "format=isa") for p in parts]

        with patch.object(RocmBackend, "pipeline_fragments", assembly_pipeline):
            results = run()
    else:
        results = run()
    report = {"mode": "isa_only" if args.isa_only else "elf", "results": results}
    (args.output / "compile_report.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
