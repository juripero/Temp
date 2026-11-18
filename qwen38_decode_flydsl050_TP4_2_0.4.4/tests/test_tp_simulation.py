"""Local threaded TP simulation; explicitly NOT a Gloo/RCCL/GPU test."""
from concurrent.futures import ThreadPoolExecutor
import threading
import unittest

import torch

from specialized_decode.mono.ffn import reference_ffn
from specialized_decode.mono.runner import FfnRunner
from specialized_decode.runtime.spec import DecodeConfig
from specialized_decode.runtime.weights import LayerWeights, shard_reference_weights


class SimulatedSumGroup:
    def __init__(self, size):
        self.size = size
        self.condition = threading.Condition()
        self.rounds = {}

    def sum(self, sequence, rank, value):
        with self.condition:
            state = self.rounds.setdefault(sequence, {"inputs": {}, "readers": 0})
            if rank in state["inputs"]:
                raise AssertionError("A rank entered the same reduction twice")
            state["inputs"][rank] = value.clone()
            if len(state["inputs"]) == self.size:
                values = [state["inputs"][r] for r in range(self.size)]
                if any(v.shape != value.shape or v.dtype != value.dtype for v in values):
                    raise AssertionError("Mismatched collective payloads")
                dtype = torch.float32 if value.is_floating_point() else torch.int64
                state["result"] = torch.stack(values).sum(0, dtype=dtype).to(value.dtype)
                self.condition.notify_all()
            if not self.condition.wait_for(lambda: "result" in state, timeout=20):
                raise RuntimeError("Simulated collective participation mismatch")
            result = state["result"].clone()
            state["readers"] += 1
            if state["readers"] == self.size:
                del self.rounds[sequence]
            return result


class SimulatedRank:
    def __init__(self, group, rank):
        self.group, self.rank, self.world_size = group, rank, group.size
        self.sequence = 0

    def all_reduce(self, value):
        sequence = self.sequence
        self.sequence += 1
        return self.group.sum(sequence, self.rank, value)


class TpSimulationTests(unittest.TestCase):
    def simulate(self, tp, groups, ffn_reduction="collective"):
        torch.set_num_threads(1)
        tasks = []
        for group_id in range(groups):
            rng = torch.Generator().manual_seed(821 + group_id * 79)

            def rand(shape):
                return (torch.randn(shape, generator=rng) * .125).bfloat16()

            full = LayerWeights(0, rand((32,)), rand((128, 32)), rand((32, 64)), 1e-6)
            local = [shard_reference_weights(full, tp, rank) for rank in range(tp)]
            samples = []
            for rows in (1, 2, 3, 4, 7, 8, 15, 16):
                a, residual = rand((rows, 32)), rand((rows, 32))
                partials = [reference_ffn(a, residual, w)[0] for w in local]
                expected = torch.stack(partials).float().sum(0).bfloat16()
                dense, expected_res = reference_ffn(a, residual, full)
                torch.testing.assert_close(expected, dense, atol=.03125, rtol=.02)
                samples.append((a, residual, expected, expected_res))
            group = SimulatedSumGroup(tp)
            for rank in range(tp):
                config = DecodeConfig(hidden_size=32, intermediate_size=64, num_layers=1,
                                      tp_size=tp, tp_rank=rank, ffn_reduction=ffn_reduction)
                runner = FfnRunner("cpu", config, SimulatedRank(group, rank))
                runner.warmup()
                tasks.append((runner, local[rank], samples))

        def worker(task):
            runner, weights, samples = task
            for a, residual, expected, expected_res in samples:
                out, res = runner.launch_layer(weights, a, residual)
                runner.check_health()
                torch.testing.assert_close(out, expected, atol=0, rtol=0)
                torch.testing.assert_close(res, expected_res, atol=0, rtol=0)
            if runner.config.tp_rank == 0:
                runner.abort()
            runner.collect_faults()
            self.assertEqual(runner.health()[0], 1)
            with self.assertRaises(RuntimeError):
                runner.check_health()
            return len(samples)

        with ThreadPoolExecutor(max_workers=tp * groups) as pool:
            counts = list(pool.map(worker, tasks))
        self.assertEqual(counts, [8] * (tp * groups))

    def test_tp2_all_widths_sum_residual_and_faults(self):
        self.simulate(2, 1)

    def test_tp4_all_widths_sum_residual_and_faults(self):
        self.simulate(4, 1)

    def test_tp2_ipc_ffn_with_already_reduced_attention(self):
        self.simulate(2, 1, "ipc")

    def test_tp4_ipc_ffn_with_already_reduced_attention(self):
        self.simulate(4, 1, "ipc")

    def test_ipc_ffn_subgroups_do_not_mix_results(self):
        self.simulate(2, 2, "ipc")

    def test_two_independent_tp2_groups_do_not_mix_results(self):
        self.simulate(2, 2)


if __name__ == "__main__":
    unittest.main()
