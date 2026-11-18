"""LL configuration, code-generation contract and abstract protocol tests.

The state exploration assumes atomic visible words. It is not a GPU/PCIe test;
validate_tp.py --ll-stress exercises that premise on real hardware.
"""
from dataclasses import replace
import importlib.util
import os
import unittest
from unittest.mock import patch

from specialized_decode.mono.peer_layout import DATA, arena_bytes, protocol_id
from specialized_decode.runtime.parallel import _check_agreement, setup_signature
from specialized_decode.runtime.peer import validate_topology
from specialized_decode.runtime.spec import DecodeConfig


class LlProtocolTests(unittest.TestCase):
    def test_sizes_alignment_and_mixed_protocol_refusal(self):
        self.assertEqual(DATA % 8, 0)
        self.assertEqual(arena_bytes(5120), 164352)
        self.assertEqual(arena_bytes(5120, protocol="ll"), 328192)
        for protocol in ("simple", "ll"):
            size = arena_bytes(5120, protocol=protocol)
            records = [dict(rank=r, size=size, protocol=protocol_id(protocol), error=None,
                            host=("node", "boot"), bus=str(r), handle=bytes(64)) for r in range(2)]
            validate_topology(records, 2, size, protocol=protocol)
            records[1]["protocol"] = 3 - protocol_id(protocol)
            with self.assertRaisesRegex(RuntimeError, "layout"):
                validate_topology(records, 2, size, protocol=protocol)
        with self.assertRaises(ValueError):
            DecodeConfig(ipc_protocol="LL128")

    def test_barrier_counts_and_rank_agreement(self):
        for tp in (1, 2, 4):
            for attention in ("reduced", "partial"):
                for ffn in ("collective", "ipc"):
                    c = DecodeConfig(tp_size=tp, attention_input=attention, ffn_reduction=ffn)
                    ll = replace(c, ipc_protocol="ll")
                    phases = int(ll.fused_attention_reduce) + int(ll.fused_ffn_reduce)
                    self.assertEqual(c.grid_barriers_per_launch, 2 + 4 * phases)
                    self.assertEqual(ll.grid_barriers_per_launch, 2 + 2 * phases)
        c = DecodeConfig(tp_size=2)
        records = [dict(rank=0, signature=setup_signature(c), error=None),
                   dict(rank=1, signature=setup_signature(replace(c, ipc_protocol="ll")), error=None)]
        with self.assertRaisesRegex(RuntimeError, "disagree"):
            _check_agreement(records, 2)

    def test_word_producers_and_consumers_can_interleave_without_ready_barrier(self):
        # Two independent word-producing CTAs per rank. Each can publish and
        # consume before the other's publication. Explore all enabled events,
        # including a fast owner attempting reuse while another rank is reading.
        # Per rank: (iteration, word0 phase, word1 phase, published DONE).
        # Each word: 0=not published; 1=published; 2=all peer reads retired.
        for tp in (2, 4):
            start = tuple((0, 0, 0, 0) for _ in range(tp))
            seen, stack, completed = set(), [start], 0
            while stack:
                state = stack.pop()
                if state in seen:
                    continue
                seen.add(state)
                if all(s[0] == 3 for s in state):
                    completed += 1
                    continue
                choices = []
                for rank, (step, p0, p1, done) in enumerate(state):
                    if step == 3:
                        continue
                    for word, phase in enumerate((p0, p1)):
                        if phase == 0:
                            # Reusing a word is legal only after every rank
                            # has retired all reads for the previous iteration.
                            self.assertTrue(all(s[0] >= step or (s[0] == step - 1 and s[3])
                                                for s in state))
                        elif phase == 1:
                            tags = [s[0] + int(s[word + 1] >= 1) for s in state]
                            if not all(tag == step + 1 for tag in tags):
                                continue
                        else:
                            continue
                        nxt = list(state[rank]); nxt[word + 1] += 1
                        choices.append((rank, tuple(nxt)))
                    if p0 == p1 == 2 and not done:
                        choices.append((rank, (step, p0, p1, 1)))
                    elif done and all(s[0] + s[3] == step + 1 for s in state):
                        choices.append((rank, (step + 1, 0, 0, 0)))
                self.assertTrue(choices, f"Deadlocked LL state: {state}")
                for rank, nxt in choices:
                    new = list(state); new[rank] = nxt
                    stack.append(tuple(new))
            self.assertEqual(completed, 1)


@unittest.skipUnless(importlib.util.find_spec("flydsl"), "flydsl==0.5.0 is not installed")
class LlCompilerContractTests(unittest.TestCase):
    def test_packing_preserves_special_bf16_bits_and_unsigned_epoch(self):
        import flydsl.expr as fx
        from flydsl._mlir import ir
        from flydsl._mlir.passmanager import PassManager
        from flydsl.compiler.jit_function import _create_mlir_context
        from specialized_decode.mono._ll_kernel import ll_ptr, publish_word
        patterns = (0, 1, 0x8000, 0x007F, 0x0080, 0x7F80, 0xFF80, 0x7FC1, 0xFFFF)
        with patch.dict(os.environ, {"FLYDSL_GPU_ARCH": "gfx1201", "ARCH": "gfx1201",
                                     "FLYDSL_COMPILE_BACKEND": "rocm"}):
            with _create_mlir_context(), ir.Location.unknown():
                module = ir.Module.create()
                expected = []
                with ir.InsertionPoint(module.body):
                    ptr = ll_ptr(fx.Uint64(4096))
                    for first, second in zip(patterns, reversed(patterns)):
                        publish_word(ptr, fx.Uint16(first).bitcast(fx.BFloat16),
                                     fx.Uint16(second).bitcast(fx.BFloat16), fx.Uint32(0xFEDCBA98))
                        expected.append(first | (second << 16) | (0xFEDCBA98 << 32))
                PassManager.parse("builtin.module(canonicalize)").run(module.operation)
                actual = [int(ir.IntegerAttr(op.operands[0].owner.attributes["value"]).value)
                          & 0xFFFFFFFFFFFFFFFF for op in module.body.operations
                          if op.operation.name == "llvm.store"]
                self.assertEqual(actual, expected)

    def test_word_accesses_are_aligned_system_atomic_i64_not_vector_or_split(self):
        import flydsl.expr as fx
        from flydsl._mlir import ir
        from flydsl.compiler.jit_function import _create_mlir_context
        from specialized_decode.mono._ll_kernel import ll_ptr, publish_word
        from specialized_decode.mono._peer_kernel import acquire
        with patch.dict(os.environ, {"FLYDSL_GPU_ARCH": "gfx1201", "ARCH": "gfx1201",
                                     "FLYDSL_COMPILE_BACKEND": "rocm"}):
            with _create_mlir_context(), ir.Location.unknown():
                module = ir.Module.create()
                with ir.InsertionPoint(module.body):
                    ptr = ll_ptr(fx.Uint64(4096))
                    self.assertEqual(ptr.alignment, 8)
                    publish_word(ptr, fx.BFloat16(1.0), fx.BFloat16(-2.0), fx.Uint32(7))
                    acquire(ptr)
                text = str(module)
                self.assertRegex(text, r'llvm.store[^\n]*atomic syncscope\(""\) release[^\n]*: i64,')
                self.assertRegex(text, r'llvm.load[^\n]*atomic syncscope\(""\) acquire[^\n]*-> i64')
                self.assertIn('alignment = 8', text)
                self.assertNotIn('vector<', text)


if __name__ == "__main__":
    unittest.main()
