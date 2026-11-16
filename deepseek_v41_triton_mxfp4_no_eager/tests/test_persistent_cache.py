"""Real cache buffers/kernels under Triton interpretation; capture state is mocked."""

import os
from contextlib import nullcontext
from unittest.mock import Mock

import pytest
import torch

pytest.importorskip("triton_kernels")
from test_adapter import NewPrecision, fixture
from test_graph_lifecycle import Ops
from vllm_expert_cache.backends import triton_mxfp4 as adapter
from vllm_expert_cache.backends import triton_mxfp4_graph as hooks

pytestmark = pytest.mark.skipif(
    os.getenv("TRITON_INTERPRET") != "1",
    reason="This CPU storage test requires TRITON_INTERPRET=1",
)


@pytest.fixture
def setup(monkeypatch):
    monkeypatch.setenv("EXPERT_CACHE_DISABLE", "0")
    monkeypatch.setenv("EXPERT_CACHE_SLOTS", "3")
    monkeypatch.setattr(adapter, "_runtime_check", lambda device: None)
    monkeypatch.setattr(torch.cuda, "device", lambda device: nullcontext())
    ops = Ops()
    lane = hooks.ExecutionLane(ops)
    monkeypatch.setattr(torch.cuda, "is_current_stream_capturing", ops.capturing)

    def register(cache):
        cache.execution_lane = lane
        lane.register(cache, ops.stream())

    monkeypatch.setattr(hooks, "register", register)
    layer, method = fixture(NewPrecision)
    original = method.apply
    assert adapter.arm(layer, method, Mock())
    return layer, method, original, ops, lane


@pytest.mark.parametrize("first_wide", [False, True])
def test_storage_survives_dtype_shape_and_cache_content_changes(setup, first_wide):
    layer, method, original, ops, lane = setup
    cache = layer._expert_cache
    x = torch.ones(1)

    def run(values, dtype=torch.int64):
        ids = torch.tensor(values, dtype=dtype)
        weights = torch.ones(ids.shape)
        expected = original(layer, x, weights, ids)
        got = method.apply(layer, x, weights, ids)
        torch.testing.assert_close(got, expected, rtol=0, atol=0)

    run([[0, 1], [2, 3]] if first_wide else [[-1, -1]])
    lease = hooks.GraphLease()
    lease.add(cache)
    lease.seal()
    # In particular, a first full-path call must not leave source views unfrozen.
    for values in ([[6, 7]], [[1, 2]], [[7, 1]], [[3, 0]], [[-1, 6]]):
        run(values)
        lease.validate()
    run([[2, 4]], dtype=torch.int32)
    lease.validate()
    # Exercise actual persistent remap buffers in a mocked managed capture.
    with lane.execution("capture", hooks.GraphLease()):
        ops.capture_active = True
        try:
            run([[2, 4]])
        finally:
            ops.capture_active = False
    lease.validate()
    layer.w13_weight.data = layer.w13_weight.data.clone()
    with pytest.raises(RuntimeError, match="storage changed"):
        lease.validate()


def test_capture_requires_shape_specific_warmup(setup):
    layer, method, _, ops, lane = setup
    ids = torch.tensor([[1, 2]])
    method.apply(layer, torch.ones(1), torch.ones_like(ids).float(), ids)
    with pytest.raises(RuntimeError, match="Warm up the exact"):  # noqa: SIM117 - show ownership entry before nested capture/replay
        with lane.execution("capture", hooks.GraphLease()):
            ops.capture_active = True
            try:
                ids = torch.tensor([[1, 2, 3]])
                method.apply(layer, torch.ones(1), torch.ones_like(ids).float(), ids)
            finally:
                ops.capture_active = False
    assert layer._expert_cache.failed
