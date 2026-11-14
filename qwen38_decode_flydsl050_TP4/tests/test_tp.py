from dataclasses import replace
from types import SimpleNamespace
import unittest
from unittest.mock import patch

import torch
from torch import nn

from specialized_decode.mono.ffn import reference_ffn
from specialized_decode.mono.runner import FfnRunner
from specialized_decode.runtime.parallel import _check_agreement, setup_signature, VllmTpCollective
from specialized_decode.runtime.guards import check_static_support
from specialized_decode.runtime.spec import DecodeConfig
from specialized_decode.runtime.weights import LayerWeights, bind_model_weights, shard_reference_weights
from test_cpu import Layer


class TpTests(unittest.TestCase):
    def setUp(self):
        torch.manual_seed(7)
        self.full = LayerWeights(0, torch.randn(32).bfloat16() * .1,
                                 torch.randn(128, 32).bfloat16() * .1,
                                 torch.randn(32, 64).bfloat16() * .1, 1e-6)

    def config(self, tp, rank=0):
        return DecodeConfig(hidden_size=32, intermediate_size=64, num_layers=1,
                            tp_size=tp, tp_rank=rank)

    def test_local_dimensions_and_invalid_tp_are_checked(self):
        self.assertEqual(DecodeConfig(tp_size=2).local_intermediate_size, 8704)
        self.assertEqual(DecodeConfig(tp_size=4).local_intermediate_size, 4352)
        for options in ({"tp_size": 3}, {"tp_size": 2, "tp_rank": 2},
                        {"tp_size": 4, "intermediate_size": 48}, {"tp_rank": -1}):
            with self.assertRaises(ValueError):
                DecodeConfig(**options)

    def test_gate_up_are_sharded_separately_and_down_columns_match(self):
        for tp in (1, 2, 4):
            shards = [shard_reference_weights(self.full, tp, rank) for rank in range(tp)]
            width = 64 // tp
            gate = torch.cat([s.w13[:width] for s in shards])
            up = torch.cat([s.w13[width:] for s in shards])
            torch.testing.assert_close(torch.cat((gate, up)), self.full.w13, atol=0, rtol=0)
            torch.testing.assert_close(torch.cat([s.w2 for s in shards], dim=1),
                                       self.full.w2, atol=0, rtol=0)
            for rank, shard in enumerate(shards):
                self.assertEqual((shard.tp_size, shard.tp_rank), (tp, rank))
                self.assertIs(shard.post_norm, self.full.post_norm)
                self.assertTrue(shard.w13.is_contiguous() and shard.w2.is_contiguous())

    def test_out_of_place_sum_is_used_and_residual_is_not_reduced(self):
        for tp in (2, 4):
            config = self.config(tp, 1)
            shard = shard_reference_weights(self.full, tp, 1)
            calls = []

            def reduce(partial):
                calls.append(partial.clone())
                return partial + 3  # New storage; simulates remote contributions.

            collective = SimpleNamespace(world_size=tp, rank=1, all_reduce=reduce)
            runner = FfnRunner("cpu", config, collective)
            runner.warmup()
            a, r = torch.randn(3, 32).bfloat16(), torch.randn(3, 32).bfloat16()
            partial, expected_res = reference_ffn(a, r, shard)
            actual, resout = runner.launch_layer(shard, a, r)
            torch.testing.assert_close(actual, partial + 3, atol=0, rtol=0)
            torch.testing.assert_close(resout, expected_res, atol=0, rtol=0)
            self.assertEqual(len(calls), 1)
            torch.testing.assert_close(calls[0], partial, atol=0, rtol=0)

    def test_missing_or_wrong_group_and_wrong_layer_rank_are_rejected(self):
        config = self.config(2)
        with self.assertRaisesRegex(ValueError, "explicit"):
            FfnRunner("cpu", config)
        for size, rank in ((4, 0), (2, 1)):
            with self.assertRaisesRegex(ValueError, "Collective"):
                FfnRunner("cpu", config, SimpleNamespace(world_size=size, rank=rank))
        runner = FfnRunner("cpu", config, SimpleNamespace(world_size=2, rank=0))
        runner.warmup()
        a = torch.zeros(1, 32, dtype=torch.bfloat16)
        with self.assertRaisesRegex(ValueError, "this TP rank"):
            runner.launch_layer(shard_reference_weights(self.full, 2, 1), a, a)

    def test_remote_failure_becomes_locally_sticky(self):
        peer_failed = [True]
        collective = SimpleNamespace(world_size=2, rank=0,
                                     all_reduce=lambda x: x.clone() + int(peer_failed[0]))
        runner = FfnRunner("cpu", self.config(2), collective)
        runner.collect_faults()
        peer_failed[0] = False
        self.assertEqual(runner.health()[0], 1)
        with self.assertRaises(RuntimeError):
            runner.check_health()
        self.assertEqual(runner.health()[0], 1)

    def test_production_binding_is_zero_copy_and_requires_reduced_attention(self):
        for tp in (2, 4):
            config = self.config(tp, 1)
            layer = Layer("linear_attention", config)
            shard = shard_reference_weights(self.full, tp, 1)
            layer.mlp.gate_up_proj.weight = nn.Parameter(shard.w13)
            layer.mlp.down_proj.weight = nn.Parameter(shard.w2)
            for proj in (layer.mlp.gate_up_proj, layer.mlp.down_proj):
                proj.tp_size, proj.tp_rank = tp, 1
            layer.mlp.gate_up_proj.gather_output = False
            layer.mlp.gate_up_proj.output_sizes = [64, 64]
            layer.mlp.down_proj.input_is_parallel = True
            layer.mlp.down_proj.reduce_results = True
            layer.linear_attn.out_proj = SimpleNamespace(tp_size=tp, tp_rank=1,
                                                        reduce_results=True)
            model = SimpleNamespace(layers=nn.ModuleList([layer]))
            bound = bind_model_weights(model, config, require_cuda=False)[0]
            self.assertIs(bound.w13, layer.mlp.gate_up_proj.weight)
            self.assertIs(bound.w2, layer.mlp.down_proj.weight)
            layer.linear_attn.out_proj.reduce_results = False
            with self.assertRaisesRegex(ValueError, "already be all-reduced"):
                bind_model_weights(model, config, require_cuda=False)
            layer.linear_attn.out_proj.reduce_results = True
            layer.mlp.gate_up_proj.gather_output = True
            with self.assertRaisesRegex(ValueError, "column-parallel"):
                bind_model_weights(model, config, require_cuda=False)

    def test_startup_agreement_excludes_local_rank_and_local_cache_path(self):
        a = self.config(2)
        b = replace(a, tp_rank=1, cache_dir="/another/local/cache")
        self.assertEqual(setup_signature(a), setup_signature(b))
        records = [{"rank": 0, "signature": setup_signature(a), "error": None},
                   {"rank": 1, "signature": setup_signature(b), "error": "bad shard"}]
        self.assertEqual(_check_agreement(records, 2), ["TP rank 1: bad shard"])
        records[1]["signature"]["backend"] = "flydsl"
        with self.assertRaisesRegex(RuntimeError, "disagree"):
            _check_agreement(records, 2)

    def test_vllm_adapter_reduces_on_the_supplied_tp_subgroup(self):
        calls = []

        def sum_on_group(x):
            calls.append(x)
            return x + 7

        group = SimpleNamespace(world_size=2, rank_in_group=1, all_reduce=sum_on_group)
        collective = VllmTpCollective(group)
        x = torch.ones(3, 32, dtype=torch.bfloat16)
        torch.testing.assert_close(collective.all_reduce(x), x + 7, atol=0, rtol=0)
        self.assertEqual((collective.world_size, collective.rank), (2, 1))
        self.assertIs(calls[0], x)

    def test_static_guard_accepts_tp2_tp4_but_rejects_context_parallel(self):
        for tp in (2, 4):
            config = self.config(tp)
            hf = SimpleNamespace(hidden_size=32, intermediate_size=64, num_hidden_layers=1,
                                 hidden_act="silu", model_type="qwen3_5_text", rms_norm_eps=1e-6)
            parallel = SimpleNamespace(tensor_parallel_size=tp)
            vconfig = SimpleNamespace(parallel_config=parallel,
                                      model_config=SimpleNamespace(dtype=torch.bfloat16,
                                                                   hf_text_config=hf,
                                                                   enforce_eager=True))
            with patch.object(torch.version, "hip", "test"), \
                 patch("torch.cuda.is_available", return_value=True), \
                 patch("torch.cuda.get_device_properties", return_value=SimpleNamespace(gcnArchName="gfx1201")):
                self.assertEqual(check_static_support(vconfig, torch.device("cuda:0"), config), [])
                parallel.decode_context_parallel_size = 2
                self.assertTrue(any("decode_context_parallel" in reason
                                    for reason in check_static_support(vconfig, torch.device("cuda:0"), config)))


if __name__ == "__main__":
    unittest.main()
