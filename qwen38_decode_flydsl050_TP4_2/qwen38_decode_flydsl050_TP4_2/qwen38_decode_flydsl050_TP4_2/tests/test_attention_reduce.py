"""Host semantics and protocol exploration, not GPU memory-order validation."""
from concurrent.futures import ThreadPoolExecutor
import copy
from dataclasses import replace
from types import SimpleNamespace
from unittest.mock import patch
import unittest

import torch
from torch import nn

from specialized_decode.integration import (attention_reduction_enabled,
                                            get_or_build_decode, run_decoder_layers)
from specialized_decode.mono.ffn import attention_sum_reference, reference_ffn, scratch_layout
from specialized_decode.mono.runner import FfnRunner
from specialized_decode.runtime.executor import FfnExecutor
from specialized_decode.runtime.peer import validate_topology
from specialized_decode.runtime.spec import DecodeConfig
from specialized_decode.runtime.weights import LayerWeights, shard_reference_weights, bind_model_weights
from test_cpu import Layer
from test_tp_simulation import SimulatedSumGroup, SimulatedRank


class PartialAttention(nn.Module):
    def __init__(self, rank):
        super().__init__()
        self.rank = rank

    def forward(self, hidden_states, positions=None):
        # Different BF16 contributions, so an omitted SUM cannot pass.
        return (hidden_states * ((self.rank + 1) * .09375)).bfloat16()


class ReducedMLP(nn.Module):
    def __init__(self, original, weights, collective):
        super().__init__()
        self.gate_up_proj = nn.Linear(32, weights.w13.shape[0], bias=False, dtype=torch.bfloat16)
        self.down_proj = nn.Linear(weights.w2.shape[1], 32, bias=False, dtype=torch.bfloat16)
        self.gate_up_proj.weight = nn.Parameter(weights.w13, requires_grad=False)
        self.down_proj.weight = nn.Parameter(weights.w2, requires_grad=False)
        self.act_fn = original.act_fn
        self.collective = collective

    def forward(self, x):
        return self.collective.all_reduce(self.down_proj(self.act_fn(self.gate_up_proj(x))))


class AttentionReduceTests(unittest.TestCase):
    def simulate(self, tp, ffn_reduction="collective"):
        torch.manual_seed(622)
        torch.set_num_threads(1)
        base = DecodeConfig(hidden_size=32, intermediate_size=64, num_layers=1,
                            attention_input="partial", ffn_reduction=ffn_reduction)
        for kind in ("linear_attention", "full_attention"):
            template = Layer(kind, base, scale=True)
            full = LayerWeights(0, template.post_attention_layernorm.weight,
                                template.mlp.gate_up_proj.weight,
                                template.mlp.down_proj.weight, base.eps)
            shards = [shard_reference_weights(full, tp, r) for r in range(tp)]
            group = SimulatedSumGroup(tp)
            jobs = []
            samples = []
            with torch.no_grad():
                for rows, active in ((1, True), (3, True), (16, True), (17, False), (33, False)):
                    for first in (True, False):
                        h = torch.randn(rows, 32).bfloat16()
                        residual = None if first else torch.randn_like(h)
                        if first:
                            norm, incoming = template.input_layernorm(h), h
                        else:
                            norm, incoming = template.input_layernorm(h, residual)
                        attention = attention_sum_reference(
                            [PartialAttention(r)(norm) for r in range(tp)], template.attn_layer_scale)
                        outs = [reference_ffn(attention, incoming, w) for w in shards]
                        expected = torch.stack([o[0] for o in outs]).float().sum(0).bfloat16()
                        expected = FfnExecutor._scale(expected, template.ffn_layer_scale)
                        samples.append((h, residual, active, expected, outs[0][1]))
                for rank in range(tp):
                    config = replace(base, tp_size=tp, tp_rank=rank)
                    collective = SimulatedRank(group, rank)
                    runner = FfnRunner("cpu", config, collective)
                    runner.warmup()
                    layer = copy.deepcopy(template)
                    if kind == "linear_attention":
                        layer.linear_attn = PartialAttention(rank)
                    else:
                        layer.self_attn = PartialAttention(rank)
                    layer.mlp = ReducedMLP(template.mlp, shards[rank], collective)
                    # A call to the unmodified original fallback is always wrong.
                    layer.forward = lambda **kw: (_ for _ in ()).throw(AssertionError("unsafe stock fallback"))
                    jobs.append(FfnExecutor([layer], [shards[rank]], runner))

            def worker(executor):
                with torch.no_grad():
                    for h, residual, active, expected, expected_res in samples:
                        result, resout = executor.run_layer(0, torch.arange(h.shape[0]), h, residual, active=active)
                        executor.runner.check_health()
                        torch.testing.assert_close(result, expected, atol=0, rtol=0)
                        torch.testing.assert_close(resout, expected_res, atol=0, rtol=0)
            with ThreadPoolExecutor(max_workers=tp) as pool:
                list(pool.map(worker, jobs))

    def test_tp2_decode_and_prefill_scale_order_and_single_residual(self):
        self.simulate(2)

    def test_tp1_deferred_scale_and_prefill(self):
        self.simulate(1)

    def test_tp4_decode_and_prefill_scale_order_and_single_residual(self):
        self.simulate(4)

    def test_tp1_ipc_mode_defers_ffn_scale_without_collective(self):
        self.simulate(1, "ipc")

    def test_tp2_ipc_ffn_decode_and_prefill_scale_order(self):
        self.simulate(2, "ipc")

    def test_tp4_ipc_ffn_decode_and_prefill_scale_order(self):
        self.simulate(4, "ipc")

    def test_partial_mode_requires_installed_enabled_adapter(self):
        with patch.dict("os.environ", {"QWEN38_ATTENTION_INPUT": "partial", "QWEN38_SPECIALIZED_DECODE": "0"}):
            with self.assertRaisesRegex(RuntimeError, "requires"):
                attention_reduction_enabled()
        with patch.dict("os.environ", {"QWEN38_ATTENTION_INPUT": "partial", "QWEN38_SPECIALIZED_DECODE": "1"}):
            self.assertFalse(attention_reduction_enabled())
            with self.assertRaisesRegex(RuntimeError, "adapter"):
                get_or_build_decode(SimpleNamespace())
        with self.assertRaises(ValueError):
            DecodeConfig(attention_input="unknown")

    def test_partial_prefill_model_loop_always_uses_executor(self):
        calls = []
        executor = SimpleNamespace(run_layer=lambda i, p, h, r, active: (calls.append(active) or h, r))
        controller = SimpleNamespace(config=DecodeConfig(attention_input="partial"), executor=executor,
                                     plan=lambda *a: SimpleNamespace(use_mono=False),
                                     after_step=lambda failure: self.assertIsNone(failure))
        inner = SimpleNamespace(start_layer=0, end_layer=1, layers=[None],
                                _maybe_add_hidden_state=lambda *a: None)
        with patch("specialized_decode.integration.get_or_build_decode", return_value=controller):
            run_decoder_layers(inner, torch.arange(32), torch.ones(32, 32), None, None, [])
        self.assertEqual(calls, [False])

    def test_partial_binding_rejects_double_attention_sum_and_bias(self):
        config = DecodeConfig(hidden_size=32, intermediate_size=64, num_layers=1, attention_input="partial")
        for kind in ("linear_attention", "full_attention"):
            layer = Layer(kind, config)
            attention = layer.linear_attn if kind == "linear_attention" else layer.self_attn
            projection = SimpleNamespace(reduce_results=False, bias=None)
            setattr(attention, "out_proj" if kind == "linear_attention" else "o_proj", projection)
            model = SimpleNamespace(layers=nn.ModuleList([layer]))
            bind_model_weights(model, config, require_cuda=False)
            projection.reduce_results = True
            with self.assertRaises(ValueError):
                bind_model_weights(model, config, require_cuda=False)
            projection.reduce_results, projection.bias = False, torch.ones(32)
            with self.assertRaises(ValueError):
                bind_model_weights(model, config, require_cuda=False)

    def test_attention_scratch_is_disjoint(self):
        layout = scratch_layout(16, 5120, 4352, True)
        self.assertEqual(layout["attention_sum"], (2 * 16 * (5120 + 4352), 2 * 16 * 5120))
        offset, size = layout["act_mid"]
        self.assertEqual(offset + size, layout["attention_sum"][0])
        offset, size = layout["attention_sum"]
        self.assertEqual(offset + size, layout["total"][1])

    def test_ipc_topology_refuses_unsupported_layouts(self):
        records = [dict(rank=r, size=2048, protocol=1, error=None, host=("node", "boot"),
                        bus=f"0000:{r:02x}:00.0", handle=bytes(64)) for r in range(4)]
        validate_topology(records, 4, 2048)
        for index, key, value in ((1, "host", ("other", "boot")), (1, "bus", records[0]["bus"]),
                                  (1, "rank", 0), (1, "handle", bytes(63)), (1, "error", "no memory"),
                                  (1, "size", 4096), (1, "protocol", 2)):
            bad = copy.deepcopy(records)
            bad[index][key] = value
            with self.assertRaises(RuntimeError):
                validate_topology(bad, 4, 2048)

    def test_ready_done_all_interleavings_across_uint32_wrap(self):
        # Abstract protocol under its acquire/release premise. This proves no
        # protocol-level overwrite/deadlock in these finite traces, not that
        # gfx1201/PCIe implements the memory-order premise on a given platform.
        for tp in (2, 4):
            completed, seen, stack = 0, set(), [tuple((0, 0) for _ in range(tp))]
            epoch = lambda step: (0xFFFFFFFE + step) & 0xFFFFFFFF
            while stack:
                state = stack.pop()
                if state in seen:
                    continue
                seen.add(state)
                if all(i == 3 for i, phase in state):
                    completed += 1
                    continue
                ready = [epoch(i + int(phase >= 1)) for i, phase in state]
                done = [epoch(i + int(phase >= 3)) for i, phase in state]
                writes = [i + int(phase >= 1) for i, phase in state]
                choices = 0
                for rank, (i, phase) in enumerate(state):
                    if i == 3:
                        continue
                    if phase == 0:
                        self.assertFalse(any(other_i < i and other_phase == 2
                                             for other_i, other_phase in state))
                        next_value = (i, 1)
                    elif phase == 1:
                        if not all(value == epoch(i + 1) for value in ready):
                            continue
                        next_value = (i, 2)
                    elif phase == 2:
                        self.assertEqual(writes, [i + 1] * tp)
                        next_value = (i, 3)
                    else:
                        if not all(value == epoch(i + 1) for value in done):
                            continue
                        next_value = (i + 1, 0)
                    choices += 1
                    nxt = list(state)
                    nxt[rank] = next_value
                    stack.append(tuple(nxt))
                self.assertGreater(choices, 0, f"Protocol deadlock in {state}")
            self.assertEqual(completed, 1)


if __name__ == "__main__":
    unittest.main()
