"""Graph qualification through public adapter.apply and real cache kernels.

The consumer is a GPU checksum, not a substitute for real vLLM MoE numerics.
Use validate_vllm.py for the checkpoint-level comparison.
"""

import os
from unittest.mock import Mock

import pytest
import torch

pytestmark = pytest.mark.skipif(
    not torch.cuda.is_available()
    or not torch.version.hip
    or os.getenv("TRITON_INTERPRET") == "1",
    reason="Requires gfx1201, ROCm and compatible triton_kernels",
)


def make_adapter(monkeypatch):
    from test_adapter import NewPrecision, fixture
    from vllm_expert_cache.backends import triton_mxfp4 as adapter

    monkeypatch.setenv("EXPERT_CACHE_DISABLE", "0")
    monkeypatch.setenv("EXPERT_CACHE_SLOTS", "3")
    layer, method = fixture(NewPrecision, bias=True)
    layer.to("cuda")
    calls = []

    def checksum(
        layer, x, topk_weights, topk_ids, shared_experts=None, shared_experts_input=None
    ):
        calls.append(1)
        cfg = method.moe_kernel.fused_experts.quant_config
        values = torch.zeros(
            layer.global_num_experts, dtype=torch.float32, device=x.device
        )
        for index, name in enumerate(adapter.WEIGHTS, 1):
            weights = getattr(layer, name + "_triton").storage.data
            precision = getattr(cfg, f"w{index}_precision")
            scales = precision.b_mx_scale.storage.data
            values = values + weights.float().sum((1, 2)) * scales.float().sum((1, 2))
            bias = getattr(cfg, f"w{index}_bias")
            if bias is not None:
                values = values + bias.sum(1)
        valid = topk_ids >= 0
        return (values[topk_ids.clamp(min=0).long()] * topk_weights * valid).sum(1)

    method.apply = checksum
    assert adapter.arm(layer, method, Mock())
    return layer, method, checksum, calls


def test_adapter_replay_changes_routes_evicts_and_interleaves_full_fallback(
    monkeypatch,
):
    from vllm_expert_cache.backends.triton_mxfp4_graph import (
        capture_lease,
        replay_with_lease,
    )

    layer, method, original, calls = make_adapter(monkeypatch)
    device = torch.device("cuda", torch.cuda.current_device())
    x = torch.ones(1, device=device)
    graphs = []
    stream = torch.cuda.Stream()
    stream.wait_stream(torch.cuda.current_stream())
    with torch.cuda.stream(stream):
        # Capture an all-masked cold cache, then replay real experts. A second
        # descriptor exceeds S and captures the original full-weight fallback.
        for shape in ((1, 2), (2, 2)):
            ids = torch.full(shape, -1, device=device, dtype=torch.int64)
            weights = torch.ones(shape, device=device)
            method.apply(layer, x, weights, ids)
            graph = torch.cuda.CUDAGraph()
            with capture_lease(device) as lease:  # noqa: SIM117 - show ownership entry before nested capture/replay
                with torch.cuda.graph(graph, stream=stream):
                    output = method.apply(layer, x, weights, ids)
            graphs.append((graph, lease, ids, weights, output))
    torch.cuda.current_stream().wait_stream(stream)
    sequence = [
        (0, [[6, 7]]),
        (0, [[1, 2]]),
        (1, [[0, 3], [4, 5]]),
        (0, [[7, 1]]),
        (0, [[2, 2]]),
        (0, [[-1, 6]]),
    ]
    for which, values in sequence:
        graph, lease, ids, weights, output = graphs[which]
        ids.copy_(torch.tensor(values, device=device))
        count_before = len(calls)
        replay_with_lease(graph, lease, device)
        assert len(calls) == count_before, "replay unexpectedly executed Python apply"
        expected = original(layer, x, weights, ids)
        torch.testing.assert_close(output, expected, rtol=1e-6, atol=1.0)
    # An eager cached invocation must order correctly after graph replay.
    ids = torch.tensor([[3, 0]], device=device)
    weights = torch.ones_like(ids, dtype=torch.float32)
    got = method.apply(layer, x, weights, ids)
    torch.testing.assert_close(
        got, original(layer, x, weights, ids), rtol=1e-6, atol=1.0
    )
    assert layer.global_num_experts == 8


def test_graph_replay_rejects_source_relocation_before_launch(monkeypatch):
    from vllm_expert_cache.backends.triton_mxfp4_graph import (
        capture_lease,
        replay_with_lease,
    )

    layer, method, _, _ = make_adapter(monkeypatch)
    device = torch.device("cuda", torch.cuda.current_device())
    ids = torch.tensor([[1, 2]], device=device)
    x, weights = torch.ones(1, device=device), torch.ones((1, 2), device=device)
    stream = torch.cuda.Stream()
    stream.wait_stream(torch.cuda.current_stream())
    with torch.cuda.stream(stream):
        method.apply(layer, x, weights, ids)
        graph = torch.cuda.CUDAGraph()
        with capture_lease(device) as lease:  # noqa: SIM117 - show ownership entry before nested capture/replay
            with torch.cuda.graph(graph, stream=stream):
                method.apply(layer, x, weights, ids)
    torch.cuda.current_stream().wait_stream(stream)
    layer.w13_weight.data = layer.w13_weight.data.clone()
    with pytest.raises(RuntimeError, match="storage changed"):
        replay_with_lease(graph, lease, device)
    assert layer._expert_cache.failed
