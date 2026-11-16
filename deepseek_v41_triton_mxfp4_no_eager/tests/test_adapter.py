"""Test public arm/apply using real Triton tensor wrappers and CPU weight data.

Only the architecture check and GPU cache runtime are replaced. These tests
exercise parameter, scale, PrecisionConfig, quant-config, and ID rebinding.
"""

from contextlib import contextmanager, nullcontext
from dataclasses import dataclass
from types import SimpleNamespace as NS
from unittest.mock import Mock

import pytest
import torch

pytest.importorskip("triton_kernels")
from policy_reference import Policy
from triton_kernels.tensor import FP4, wrap_torch_tensor
from vllm_expert_cache.backends import generic
from vllm_expert_cache.backends import triton_mxfp4 as adapter
from vllm_expert_cache.backends.triton_mxfp4_layout import (
    empty_slots,
    expert_slab,
    scale_field,
)


@dataclass
class OldPrecision:
    weight_scale: object
    acc_scale: float = 1.0


@dataclass
class NewPrecision:
    b_mx_scale: object
    b_microblock_size: int = 32


class CPUCache:
    def __init__(self, owner, names, experts, slots):
        self.owner, self.names, self.E, self.S = owner, names, experts, slots
        self.slots = {
            name: empty_slots(getattr(owner, name), experts, slots) for name in names
        }
        self.table = torch.full((experts,), -1, dtype=torch.int32)
        self.ref = Policy(experts, slots)
        self.started = self.failed = False
        self.refreshes = 0

    def fits(self, ids):
        return ids.numel() <= self.S

    @contextmanager
    def invocation(self):
        if self.failed:
            raise RuntimeError("failed earlier")
        try:
            yield
        except BaseException:
            self.failed = True
            raise
        finally:
            self.started = True

    def refresh(self, ids):
        result, misses, table = self.ref.step(ids.flatten().tolist())
        self.table.copy_(torch.tensor(table, dtype=torch.int32))
        for slot, expert in enumerate(misses):
            if expert >= 0:
                for name in self.names:
                    self.slots[name][slot].copy_(getattr(self.owner, name)[expert])
        self.refreshes += 1
        return torch.tensor(result, dtype=ids.dtype).reshape_as(ids)


def fixture(precision_type, bias=True):
    layer = torch.nn.Module()
    layer.global_num_experts, layer.expert_map = 8, None
    layer._expert_cache_triton_preflight = True
    for name, shape in (
        ("w13_weight", (8, 32, 16)),
        ("w2_weight", (8, 16, 16)),
        ("w13_weight_scale", (8, 32, 1)),
        ("w2_weight_scale", (8, 16, 1)),
    ):
        data = (
            torch.arange(torch.tensor(shape).prod().item()).reshape(shape) % 239
        ).to(torch.uint8)
        # Distinct expert scales are essential to catch stale nested configs.
        data = data + torch.arange(8, dtype=torch.uint8)[:, None, None]
        layer.register_parameter(
            name, torch.nn.Parameter(data.transpose(1, 2), requires_grad=False)
        )
    for name in adapter.BIASES:
        setattr(
            layer,
            name,
            torch.nn.Parameter(
                torch.arange(8 * 16).float().reshape(8, 16), requires_grad=False
            )
            if bias
            else None,
        )
    layer.w13_weight_triton = wrap_torch_tensor(layer.w13_weight, dtype=FP4)
    layer.w2_weight_triton = wrap_torch_tensor(layer.w2_weight, dtype=FP4)
    method = NS(is_monolithic=False, mxfp4_backend=NS(name="TRITON_UNFUSED"))
    method.w13_precision_config = precision_type(
        wrap_torch_tensor(layer.w13_weight_scale)
    )
    method.w2_precision_config = precision_type(
        wrap_torch_tensor(layer.w2_weight_scale)
    )

    def config(owner):
        p1, p2 = method.w13_precision_config, method.w2_precision_config
        b1, b2 = owner.w13_bias, owner.w2_bias
        return NS(
            w1_precision=p1,
            w2_precision=p2,
            w1_bias=b1,
            w2_bias=b2,
            _w1=NS(scale=p1, bias=b1),
            _w2=NS(scale=p2, bias=b2),
        )

    method.get_fused_moe_quant_config = config
    method.moe_quant_config = config(layer)
    experts_type = type("UnfusedOAITritonExperts", (), {})
    experts = experts_type()
    experts.quant_config = method.moe_quant_config
    method.moe_kernel = NS(fused_experts=experts)
    method.raise_in_apply = False

    def apply(
        layer, x, topk_weights, topk_ids, shared_experts=None, shared_experts_input=None
    ):
        if method.raise_in_apply:
            raise RuntimeError("injected MoE launch failure")
        cfg = experts.quant_config
        assert cfg is method.moe_quant_config
        output = torch.zeros(topk_ids.shape[0], dtype=torch.float64)
        for row in range(topk_ids.shape[0]):
            for j in range(topk_ids.shape[1]):
                expert = int(topk_ids[row, j])
                if expert < 0:
                    continue
                assert expert < layer.global_num_experts
                value = 0.0
                for index, weight in enumerate(adapter.WEIGHTS, 1):
                    wrapper = getattr(layer, weight + "_triton")
                    assert wrapper.shape[0] == layer.global_num_experts
                    assert (
                        wrapper.storage.data.data_ptr()
                        == getattr(layer, weight).data_ptr()
                    )
                    precision = getattr(cfg, f"w{index}_precision")
                    scale = getattr(precision, scale_field(precision))
                    assert scale.shape[0] == layer.global_num_experts
                    value += (
                        wrapper.storage.data[expert].double().sum()
                        * scale.storage.data[expert].double().sum()
                    )
                    bias_data = getattr(cfg, f"w{index}_bias")
                    if bias_data is not None:
                        value += bias_data[expert].double().sum()
                output[row] += value * topk_weights[row, j]
        return output

    method.apply = apply
    return layer, method


@pytest.fixture(autouse=True)
def runtime(monkeypatch):
    monkeypatch.setenv("EXPERT_CACHE_DISABLE", "0")
    monkeypatch.setenv("EXPERT_CACHE_SLOTS", "3")
    monkeypatch.setattr(adapter, "_runtime_check", lambda device: None)
    monkeypatch.setattr(adapter, "TritonSlotCache", CPUCache)
    monkeypatch.setattr(torch.cuda, "device", lambda device: nullcontext())


@pytest.mark.parametrize("precision_type", [OldPrecision, NewPrecision])
@pytest.mark.parametrize("bias", [True, False])
def test_arm_apply_matches_full_weights_through_evictions_and_prefill(
    precision_type, bias
):
    layer, method = fixture(precision_type, bias)
    original = method.apply
    parameters = dict(layer.named_parameters())
    ids_cases = [[[6, 2]], [[2, 6]], [[7, 1, 0]], [[-1, 7]], [[0, 1], [2, 3]], [[6, 5]]]
    expected = []
    for values in ids_cases:
        ids = torch.tensor(values, dtype=torch.int64)
        expected.append(
            original(layer, torch.ones(1), torch.ones_like(ids).float(), ids)
        )
    assert generic.arm(layer, method, Mock())
    wrapped_apply = method.apply
    assert generic.arm(layer, method, Mock())
    assert method.apply is wrapped_apply
    full_cfg = method.moe_quant_config
    for values, want in zip(ids_cases, expected):
        ids = torch.tensor(values, dtype=torch.int64)
        got = method.apply(
            layer=layer,
            x=torch.ones(1),
            topk_weights=torch.ones_like(ids).float(),
            topk_ids=ids,
        )
        torch.testing.assert_close(got, want, rtol=0, atol=0)
        assert layer.global_num_experts == 8
        assert method.moe_quant_config is full_cfg
        assert method.moe_kernel.fused_experts.quant_config is full_cfg
        for name, value in parameters.items():
            assert getattr(layer, name) is value
    assert layer._expert_cache.refreshes == 5


def test_exception_restores_all_full_bindings():
    layer, method = fixture(OldPrecision)
    generic.arm(layer, method, Mock())
    cfg, wrapper = method.moe_quant_config, layer.w13_weight_triton
    params = dict(layer.named_parameters())
    method.raise_in_apply = True
    with pytest.raises(RuntimeError, match="injected"):
        method.apply(layer, torch.ones(1), torch.ones((1, 2)), torch.tensor([[6, 7]]))
    assert method.moe_quant_config is cfg
    assert method.moe_kernel.fused_experts.quant_config is cfg
    assert layer.w13_weight_triton is wrapper
    assert layer.global_num_experts == 8
    assert all(getattr(layer, n) is p for n, p in params.items())
    assert layer._expert_cache.failed


def test_initial_parameter_relocation_rebinds_nested_scale_wrappers():
    layer, method = fixture(NewPrecision, bias=False)
    generic.arm(layer, method, Mock())
    for name in (*adapter.WEIGHTS, *adapter.SCALES):
        getattr(layer, name).data = getattr(layer, name).data.clone()
    method.apply(layer, torch.ones(1), torch.ones((1, 2)), torch.tensor([[3, 7]]))
    assert layer.w13_weight_triton.data_ptr() == layer.w13_weight.data_ptr()
    assert (
        method.w13_precision_config.b_mx_scale.data_ptr()
        == layer.w13_weight_scale.data_ptr()
    )
    layer.w13_weight.data = layer.w13_weight.data.clone()
    with pytest.raises(RuntimeError, match="storage changed"):
        method.apply(layer, torch.ones(1), torch.ones((1, 2)), torch.tensor([[3, 7]]))


def test_holey_storage_and_unknown_backend_are_rejected():
    with pytest.raises(ValueError, match="holes|consecutive"):
        expert_slab(torch.empty((8, 8, 8))[:, :, ::2], 8)
    layer, method = fixture(OldPrecision)
    method.mxfp4_backend.name = "AITER_TRITON_MXFP4_BF16"
    with pytest.raises(NotImplementedError, match="No cache adapter"):
        generic.arm(layer, method, Mock())


def test_disabled_or_full_budget_leaves_apply_untouched(monkeypatch):
    layer, method = fixture(OldPrecision)
    original = method.apply
    monkeypatch.setenv("EXPERT_CACHE_DISABLE", "1")
    assert not generic.arm(layer, method, Mock())
    monkeypatch.setenv("EXPERT_CACHE_DISABLE", "0")
    monkeypatch.setenv("EXPERT_CACHE_SLOTS", "8")
    assert not generic.arm(layer, method, Mock())
    assert method.apply is original


def test_post_conversion_rebinding_releases_all_four_stale_storage_aliases():
    from vllm_expert_cache.backends.triton_mxfp4_offload import rebind_sources

    layer, method = fixture(NewPrecision, bias=False)
    layer.quant_method = method
    # Emulate the upstream converter storing Tensor views, then the loading
    # context replacing parameter data. The original wrapper remains stale.
    wrappers = [
        layer.w13_weight_triton,
        layer.w2_weight_triton,
        method.w13_precision_config.b_mx_scale,
        method.w2_precision_config.b_mx_scale,
    ]
    names = [*adapter.WEIGHTS, *adapter.SCALES]
    for wrapper, name in zip(wrappers, names):
        wrapper.storage.data = getattr(layer, name).data
        getattr(layer, name).data = getattr(layer, name).data.clone()
        assert wrapper.data_ptr() != getattr(layer, name).data_ptr()
    original_cfg = method.moe_quant_config
    original_apply = method.apply
    rebind_sources(layer)
    for wrapper, name in zip(wrappers, names):
        assert wrapper.data_ptr() == getattr(layer, name).data_ptr()
    assert method.moe_quant_config is original_cfg
    assert method.apply is original_apply
    assert not hasattr(layer, "_expert_cache")
