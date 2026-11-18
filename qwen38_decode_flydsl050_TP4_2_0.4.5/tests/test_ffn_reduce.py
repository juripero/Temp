"""Host routing and abstract protocol checks, not GPU coherence validation."""
from dataclasses import replace
from types import SimpleNamespace
import unittest
from unittest.mock import patch
import torch

from specialized_decode.mono.runner import FfnRunner
from specialized_decode.runtime.parallel import setup_signature, _check_agreement
from specialized_decode.runtime.peer import validate_topology
from specialized_decode.runtime.spec import DecodeConfig


class FfnReductionTests(unittest.TestCase):
    def config(self, **kw):
        return DecodeConfig(hidden_size=32, intermediate_size=64, num_layers=1,
                            tp_size=2, ffn_reduction="ipc", **kw)

    def test_flydsl_result_is_not_reduced_or_scaled_again_on_host(self):
        def forbidden(*args):
            self.fail("Fused FFN output must not enter another collective")
        collective = SimpleNamespace(world_size=2, rank=0, all_reduce=forbidden)
        runner = FfnRunner("cpu", self.config(), collective)
        runner.warmup()
        runner.config = replace(runner.config, backend="flydsl")
        a, residual = torch.ones(3, 32).bfloat16(), torch.full((3, 32), 7).bfloat16()
        scale = torch.full((1, 1, 32), .5).bfloat16()
        def device_epilogue(layer, attention, res, out, resout, rows, stream, **kw):
            self.assertIsNotNone(kw["ffn_scale"])
            out.fill_(6)  # Pretend kernel has produced the final global/scaled output.
            resout.copy_(res)
        with patch.object(runner, "_check", return_value=3), \
             patch.object(runner, "_raw_launch", side_effect=device_epilogue) as launch:
            out, res = runner.launch_layer(None, a, residual, ffn_scale=scale)
        self.assertEqual(launch.call_count, 1)
        torch.testing.assert_close(out, torch.full_like(out, 6), atol=0, rtol=0)
        torch.testing.assert_close(res, residual, atol=0, rtol=0)

    def test_torch_reference_reduces_fp32_but_old_mode_still_reduces_bf16(self):
        calls = []
        collective = SimpleNamespace(world_size=2, rank=0,
                                     all_reduce=lambda x: calls.append(x.dtype) or x * 2)
        runner = FfnRunner("cpu", self.config(), collective)
        value = torch.ones(3, 32, dtype=torch.bfloat16)
        torch.testing.assert_close(runner._reduce_output(value), value * 2, atol=0, rtol=0)
        runner.config = replace(runner.config, ffn_reduction="collective")
        runner._reduce_output(value)
        self.assertEqual(calls, [torch.float32, torch.bfloat16])

    def test_no_reduction_in_tp1(self):
        runner = FfnRunner("cpu", DecodeConfig(ffn_reduction="ipc"))
        value = torch.ones(1, 5120, dtype=torch.bfloat16)
        self.assertIs(runner._reduce_output(value), value)
        self.assertFalse(runner.config.fused_ffn_reduce)

    def test_config_and_generation_account_for_both_peer_phases(self):
        self.assertEqual(self.config().grid_barriers_per_launch, 6)
        self.assertEqual(self.config(attention_input="partial").grid_barriers_per_launch, 10)
        self.assertEqual(replace(self.config(), ffn_reduction="collective").grid_barriers_per_launch, 2)
        with self.assertRaises(ValueError):
            DecodeConfig(ffn_reduction="rccl")
        signatures = [setup_signature(self.config()),
                      setup_signature(replace(self.config(), ffn_reduction="collective"))]
        records = [dict(rank=r, signature=s, error=None) for r, s in enumerate(signatures)]
        with self.assertRaisesRegex(RuntimeError, "disagree"):
            _check_agreement(records, 2)

    def test_mailbox_roles_cannot_be_exchanged(self):
        records = [dict(rank=r, error=None, purpose=p) for r,p in enumerate(("attention", "ffn"))]
        with self.assertRaisesRegex(RuntimeError, "purpose"):
            validate_topology(records, 2, 164352, "ffn")

    def test_explicit_retirement_closes_both_mailboxes(self):
        calls = []
        runner = FfnRunner("cpu", DecodeConfig())
        runner.warmup()
        runner.peer_arena = SimpleNamespace(close_collective=lambda: calls.append("attention"))
        runner.ffn_peer_arena = SimpleNamespace(close_collective=lambda: calls.append("ffn"))
        runner.close_peers_collective()
        self.assertEqual(calls, ["ffn", "attention"])
        self.assertFalse(runner._ready)

    def test_two_mailbox_interleavings_through_independent_epoch_wrap(self):
        # Sequential attention/FFN phases over three invocations. Each bank has
        # independent READY/DONE flags. Assumes acquire/release visibility.
        for tp in (2, 4):
            seen, stack, completed = set(), [tuple((0, 0) for _ in range(tp))], 0
            seeds = (0xFFFFFFFE, 0xFFFFFFFD)
            def counter(step, phase, bank, threshold):
                count = (step + 1 - bank) // 2
                count += int(step < 6 and step % 2 == bank and phase >= threshold)
                return (seeds[bank] + count) & 0xFFFFFFFF
            while stack:
                state = stack.pop()
                if state in seen:
                    continue
                seen.add(state)
                if all(step == 6 for step, _ in state):
                    completed += 1
                    continue
                choices = 0
                for rank, (step, phase) in enumerate(state):
                    if step == 6:
                        continue
                    bank = step % 2
                    epoch = (seeds[bank] + step // 2 + 1) & 0xFFFFFFFF
                    ready = [counter(s,p,bank,1) for s,p in state]
                    done = [counter(s,p,bank,3) for s,p in state]
                    if phase == 0:
                        self.assertFalse(any(s < step and s % 2 == bank and p == 2 for s,p in state))
                        nxt = (step, 1)
                    elif phase == 1:
                        if not all(v == epoch for v in ready):
                            continue
                        nxt = (step, 2)
                    elif phase == 2:
                        # No owner has recycled this bank while readers are active.
                        self.assertEqual(ready, [epoch] * tp)
                        nxt = (step, 3)
                    else:
                        if not all(v == epoch for v in done):
                            continue
                        nxt = (step + 1, 0)
                    choices += 1
                    next_state = list(state)
                    next_state[rank] = nxt
                    stack.append(tuple(next_state))
                self.assertGreater(choices, 0, f"Deadlocked abstract state: {state}")
            self.assertEqual(completed, 1)


if __name__ == "__main__":
    unittest.main()
