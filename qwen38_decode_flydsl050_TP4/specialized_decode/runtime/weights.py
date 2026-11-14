from __future__ import annotations

from dataclasses import dataclass

import torch

from .spec import DecodeConfig


@dataclass(frozen=True)
class LayerWeights:
    layer_idx: int
    post_norm: torch.Tensor
    w13: torch.Tensor
    w2: torch.Tensor
    eps: float
    tp_size: int = 1
    tp_rank: int = 0

    @property
    def hidden_size(self):
        return self.w13.shape[1]

    @property
    def intermediate_size(self):
        return self.w2.shape[1]


def inner_model(model):
    lm = getattr(model, "language_model", model)
    return getattr(lm, "model", lm)


def check_tensor(t, shape, name, device, *, require_cuda=True):
    if not isinstance(t, torch.Tensor):
        raise ValueError(f"{name} is not a tensor")
    if t.dtype != torch.bfloat16 or tuple(t.shape) != tuple(shape):
        raise ValueError(f"{name}: expected contiguous BF16 {shape}, got {t.dtype} {tuple(t.shape)}")
    if t.device != device or not t.is_contiguous():
        raise ValueError(f"{name}: wrong device or noncontiguous storage")
    if require_cuda and not t.is_cuda:
        raise ValueError(f"{name}: GPU storage required")
    if t.data_ptr() % 16:
        raise ValueError(f"{name}: storage must be 16-byte aligned")


def bind_model_weights(model, config: DecodeConfig, *, require_cuda=True):
    layers = inner_model(model).layers
    if len(layers) != config.num_layers:
        raise ValueError(f"Expected {config.num_layers} local decoder layers")
    result = []
    for i, layer in enumerate(layers):
        if getattr(layer, "layer_type", None) not in ("linear_attention", "full_attention"):
            raise ValueError(f"Layer {i}: unsupported attention type")
        if getattr(layer, "use_attn_reduce_scatter_for_moe", False):
            raise ValueError("Sequence-parallel MoE is unsupported")
        norm = layer.post_attention_layernorm
        mlp = layer.mlp
        if "Gemma" not in type(norm).__name__ and "Qwen3_5RMSNorm" not in type(norm).__name__:
            raise ValueError(f"Layer {i}: expected Gemma-style (1+w) RMSNorm")
        if getattr(mlp, "expert_gate", None) is not None:
            raise ValueError("Expert-gated MLP is unsupported")
        if config.tp_size > 1:
            check_parallel_layer(layer, config)
        w13 = mlp.gate_up_proj.weight
        w2 = mlp.down_proj.weight
        device = w13.device
        for proj in (mlp.gate_up_proj, mlp.down_proj):
            if getattr(proj, "bias", None) is not None:
                raise ValueError(f"Layer {i}: FFN bias is unsupported")
            method = getattr(proj, "quant_method", None)
            if method is not None and type(method).__name__ != "UnquantizedLinearMethod":
                raise ValueError(f"Layer {i}: unsupported projection method {type(method).__name__}")
        if type(mlp.act_fn).__name__ != "SiluAndMul":
            raise ValueError(f"Layer {i}: expected SiluAndMul")
        eps = getattr(norm, "variance_epsilon", None)
        if eps != config.eps:
            raise ValueError(f"Layer {i}: normalization epsilon mismatch")
        for t, shape, name in (
            (norm.weight, (config.hidden_size,), "post_norm"),
            (w13, (2 * config.local_intermediate_size, config.hidden_size), "w13"),
            (w2, (config.hidden_size, config.local_intermediate_size), "w2"),
        ):
            check_tensor(t, shape, f"layer[{i}].{name}", device,
                         require_cuda=require_cuda)
        # Keep original BF16 storage; the FlyDSL kernel reads it without repacking.
        result.append(LayerWeights(i, norm.weight, w13, w2, eps, config.tp_size, config.tp_rank))
    return result


def check_parallel_layer(layer, config):
    """Require stock dense TP layout and a fully reduced attention result."""
    gate, down = layer.mlp.gate_up_proj, layer.mlp.down_proj
    attn = layer.linear_attn if layer.layer_type == "linear_attention" else layer.self_attn
    projection = getattr(attn, "out_proj" if layer.layer_type == "linear_attention" else "o_proj", None)
    for name, proj in (("gate_up_proj", gate), ("down_proj", down), ("attention output", projection)):
        if (proj is None or getattr(proj, "tp_size", None) != config.tp_size
                or getattr(proj, "tp_rank", None) != config.tp_rank):
            raise ValueError(f"{name}: TP size/rank mismatch or missing metadata")
    if getattr(gate, "gather_output", None) is not False:
        raise ValueError("gate_up_proj must retain its column-parallel shard")
    if list(getattr(gate, "output_sizes", [])) != [config.intermediate_size] * 2:
        raise ValueError("gate_up_proj must contain separately sharded [gate, up] projections")
    if getattr(gate, "padding_size", 0):
        raise ValueError("Padded gate/up projections are unsupported")
    if getattr(down, "input_is_parallel", None) is not True:
        raise ValueError("down_proj must consume the local intermediate shard")
    if getattr(down, "reduce_results", None) is not True:
        raise ValueError("Stock down_proj must use an output all-reduce")
    if getattr(projection, "reduce_results", None) is not True:
        raise ValueError("Attention output must already be all-reduced before RMSNorm")


def shard_reference_weights(full, tp_size, tp_rank):
    """Validation helper only; production binds vLLM's loaded shards zero-copy.

    Never split a fused [gate; up] tensor into contiguous 2I/TP chunks: each
    rank needs its matching I/TP rows from BOTH projections, plus W2 columns.
    """
    if full.tp_size != 1 or tp_size not in (1, 2, 4) or not 0 <= tp_rank < tp_size:
        raise ValueError("Expected full TP1 weights and a valid destination TP rank")
    inter = full.intermediate_size
    if inter % (16 * tp_size):
        raise ValueError("Intermediate shards must be multiples of 16")
    local = inter // tp_size
    start, end = tp_rank * local, (tp_rank + 1) * local
    w13 = torch.cat((full.w13[start:end], full.w13[inter + start:inter + end]), dim=0)
    w2 = full.w2[:, start:end].contiguous()
    return LayerWeights(full.layer_idx, full.post_norm, w13, w2, full.eps, tp_size, tp_rank)
