"""Host-only checks against the actual 0.5.0 compiler's gfx1201 layouts."""
import importlib.util
import os
import unittest
from unittest.mock import patch

from specialized_decode.mono.a16w16 import CompiledFfn, _select_target


class TargetTests(unittest.TestCase):
    def test_version_and_target_conflicts_are_rejected(self):
        with patch("specialized_decode.mono.a16w16.version", return_value="0.4.0"):
            with self.assertRaisesRegex(RuntimeError, "exactly"):
                _select_target(None)
        with patch("specialized_decode.mono.a16w16.version", return_value="0.5.0"):
            with patch.dict(os.environ, {"FLYDSL_GPU_ARCH": "gfx942"}):
                with self.assertRaisesRegex(RuntimeError, "FLYDSL_GPU_ARCH"):
                    _select_target(None)


@unittest.skipUnless(importlib.util.find_spec("flydsl"), "flydsl==0.5.0 is not installed")
class FlyDslContractTests(unittest.TestCase):
    def test_bf16_operand_and_output_maps_match_release_atom(self):
        import flydsl.expr as fx
        from flydsl._mlir import ir
        from flydsl.compiler.jit_function import _create_mlir_context
        with patch.dict(os.environ, {"FLYDSL_GPU_ARCH": "gfx1201", "ARCH": "gfx1201",
                                     "FLYDSL_COMPILE_BACKEND": "rocm"}):
            with _create_mlir_context(), ir.Location.unknown():
                module = ir.Module.create()
                with ir.InsertionPoint(module.body):
                    atom = fx.make_mma_atom(fx.rocdl.WMMA(
                        16, 16, 16, fx.BFloat16, fx.Float32))
                    self.assertIn("gfx120x.wmma", str(atom.type))
                    for lane in range(32):
                        lo, hi = lane % 16, lane // 16
                        for j in range(8):
                            # Atom uses column-major MxK / NxK and MxN coordinates.
                            operand = lo + (8 * hi + j) * 16
                            output = lo * 16 + 8 * hi + j
                            self.assertEqual(atom.layout_A_tv((lo, hi), j).get_static_leaf_int,
                                             operand)
                            self.assertEqual(atom.layout_B_tv((lo, hi), j).get_static_leaf_int,
                                             operand)
                            self.assertEqual(atom.layout_C_tv((lo, hi), j).get_static_leaf_int,
                                             output)

    def test_compile_arguments_are_null_placeholders_with_dynamic_scalars(self):
        from flydsl.compiler.jit_function import _is_compile_placeholder
        args = CompiledFfn.arguments([0] * 10, 0, 1e-6, 1, -1, None)
        self.assertEqual(len(args), 15)
        self.assertTrue(all(_is_compile_placeholder(p) for p in args[:10]))
        self.assertEqual(args[10:14], (0, 1e-6, 1, -1))
        self.assertIsNone(args[-1].value)


if __name__ == "__main__":
    unittest.main()
