from __future__ import annotations

from contextlib import nullcontext

import torch

from ..runtime.spec import DecodeConfig
from ..runtime.parallel import checked_sum, setup_signature
from ..runtime.weights import LayerWeights, check_tensor
from .a16w16 import build_ffn
from .ffn import MAX_ROWS, reference_ffn, scratch_bytes
from .residency import checked_residency
from .sync import CONTROL_WORDS, ERROR_WORDS


class FfnRunner:
    """One workspace, one serialized HIP stream, no host epoch counters.

    Call warmup before any capture. A graph may replay only with this runner
    kept alive and without overlapping another graph using this workspace.
    Physical row counts are captured constants; graph padding is processed
    independently, and cannot affect valid rows or any attention cache.
    """

    def __init__(self, device: torch.device, config: DecodeConfig, collective=None):
        self.device = torch.device(device)
        if self.device.type == "cuda" and self.device.index is None:
            self.device = torch.device("cuda", torch.cuda.current_device())
        if config.backend == "flydsl" and self.device.type != "cuda":
            raise ValueError("FlyDSL backend requires a GPU")
        self.config = config
        self.collective = collective
        if config.tp_size > 1 and collective is None:
            raise ValueError("TP2/TP4 require an explicit TP collective")
        if collective is not None and (collective.world_size != config.tp_size
                                        or collective.rank != config.tp_rank):
            raise ValueError("Collective group does not match the configured TP size/rank")
        self.peer_arena = None
        self.ffn_peer_arena = None
        self.module = None
        self.residency = None
        self.scratch = None
        self.control = None
        self.fault_word = torch.zeros(ERROR_WORDS, dtype=torch.int32, device=self.device)
        self._stream = None
        self._ready = False

    def _warmup_local(self):
        if self._ready:
            return
        if self.device.type == "cuda" and torch.cuda.is_current_stream_capturing():
            raise RuntimeError("warmup cannot run during graph capture")
        if self.config.backend == "flydsl":
            with torch.cuda.device(self.device):
                props = torch.cuda.get_device_properties(self.device)
                if torch.version.hip is None or props.gcnArchName.split(":")[0] != "gfx1201":
                    raise RuntimeError("FlyDSL FFN requires ROCm gfx1201")
                self.module = build_ffn(self.config.hidden_size,
                                        self.config.local_intermediate_size,
                                        self.config.cache_dir, blocks=self.config.blocks,
                                        tp=self.config.tp_size, rank=self.config.tp_rank,
                                        attention_partial=self.config.attention_input == "partial",
                                        ffn_reduce=self.config.fused_ffn_reduce)
                self.residency = checked_residency(self.module, self.config.blocks,
                                                   torch.cuda.get_device_properties(self.device))
                count = scratch_bytes(MAX_ROWS, self.config.hidden_size,
                                      self.config.local_intermediate_size,
                                      self.config.fused_attention_reduce) // 2
                self.scratch = torch.empty(count, dtype=torch.bfloat16, device=self.device)
                self.control = torch.zeros(CONTROL_WORDS, dtype=torch.int32, device=self.device)
                self.module.initialize_runtime(torch.cuda.current_stream(self.device).cuda_stream)
        if self.device.type == "cuda":
            # Complete fault/control initialization before binding a stream,
            # including the staged torch backend used for TP qualification.
            torch.cuda.synchronize(self.device)

    def warmup(self):
        if self._ready:
            return
        error = None
        try:
            self._warmup_local()
        except Exception as exc:
            error = f"{type(exc).__name__}: {exc}"
        peer_mode = (self.config.fused_attention_reduce or self.config.fused_ffn_reduce) and self.config.backend == "flydsl"
        errors = ([error] if error else [])
        if peer_mode:
            errors = self.collective.setup_agreement(
                {**setup_signature(self.config), "phase": "local_warmup"}, error)
        if errors:
            raise RuntimeError("Local FFN warmup failed: " + "; ".join(errors))
        if peer_mode:
            from ..runtime.peer import PeerArena
            with torch.cuda.device(self.device):
                if self.config.fused_attention_reduce:
                    self.peer_arena = PeerArena(self.device, self.config, self.collective)
                if self.config.fused_ffn_reduce:
                    self.ffn_peer_arena = PeerArena(self.device, self.config, self.collective,
                                                   purpose="ffn")
        self._ready = True

    def _check(self, layer, attn_out, residual):
        rows = attn_out.shape[0] if attn_out.ndim == 2 else 0
        if not 1 <= rows <= self.config.max_rows:
            raise ValueError("Expected 1..max_rows physical rows in a rank-2 activation")
        h, inter = self.config.hidden_size, self.config.local_intermediate_size
        gpu = self.config.backend == "flydsl"
        for tensor, shape, name in (
            (attn_out, (rows, h), "attn_out"), (residual, (rows, h), "residual"),
            (layer.post_norm, (h,), "post_norm"), (layer.w13, (2 * inter, h), "w13"),
            (layer.w2, (h, inter), "w2"),
        ):
            check_tensor(tensor, shape, name, self.device, require_cuda=gpu)
        if (layer.tp_size, layer.tp_rank) != (self.config.tp_size, self.config.tp_rank):
            raise ValueError("Layer shard does not belong to this TP rank")
        if layer.eps != self.config.eps:
            raise ValueError("Layer epsilon differs from runner epsilon")
        return rows

    @torch.no_grad()
    def launch_layer(self, layer: LayerWeights, attn_out: torch.Tensor,
                     residual: torch.Tensor, *, attention_scale=None, ffn_scale=None) -> tuple[torch.Tensor, torch.Tensor]:
        if not self._ready:
            raise RuntimeError("Call runner.warmup() before launching")
        rows = self._check(layer, attn_out, residual)
        scale = None
        if attention_scale is not None:
            if self.config.attention_input != "partial":
                raise ValueError("Only partial-attention mode accepts a deferred attention scale")
            if attention_scale.device != self.device or attention_scale.numel() != self.config.hidden_size:
                raise ValueError("Attention scale device/shape mismatch")
            scale = attention_scale.to(torch.bfloat16).reshape(-1).contiguous()
        output_scale = None
        if ffn_scale is not None:
            if self.config.ffn_reduction != "ipc":
                raise ValueError("Deferred FFN scale requires ffn_reduction=ipc")
            if ffn_scale.device != self.device or ffn_scale.numel() != self.config.hidden_size:
                raise ValueError("FFN scale device/shape mismatch")
            output_scale = ffn_scale.to(torch.bfloat16).reshape(-1).contiguous()
        context = torch.cuda.device(self.device) if self.device.type == "cuda" else nullcontext()
        with context:
            stream = self._bind_stream()
            if self.config.backend == "torch":
                attention = attn_out
                if self.config.fused_attention_reduce:
                    attention = checked_sum(self.collective, attention.float()).bfloat16()
                if scale is not None:
                    attention = attention * (scale + 1)
                out, resout = reference_ffn(attention, residual, layer)
            else:
                out = torch.empty_like(attn_out)
                resout = torch.empty_like(residual)
                self._raw_launch(layer, attn_out, residual, out, resout, rows, stream,
                                 attention_scale=scale, ffn_scale=output_scale)
            # Keep collective ordering inside the same device/stream context.
            out = self._reduce_output(out)
            if self.config.backend == "torch" and output_scale is not None:
                out = out * (output_scale + 1)
        return out, resout

    def _bind_stream(self):
        if self.device.type != "cuda":
            return None
        stream = torch.cuda.current_stream(self.device).cuda_stream
        if self._stream is None:
            self._stream = stream
        elif self._stream != stream:
            raise RuntimeError("Workspace is bound to a different HIP stream; use a separate runner")
        return stream

    def _reduce_output(self, partial):
        if self.config.tp_size == 1:
            return partial
        if self.config.fused_ffn_reduce:
            if self.config.backend == "flydsl":
                # The device epilogue already produced the global SUM.
                return partial
            # Staged numerical reference: BF16 local W2 -> FP32 SUM -> BF16.
            return checked_sum(self.collective, partial.float()).bfloat16()
        return checked_sum(self.collective, partial)

    def _raw_launch(self, layer, a, residual, out, resout, rows, stream,
                    *, drop_cta=-1, drop_ffn_cta=-1, max_spins=None, attention_scale=None, ffn_scale=None):
        """Internal entry used by fault-injection qualification, never fallback."""
        self.module.ffn_launch(
            a.data_ptr(), residual.data_ptr(), layer.post_norm.data_ptr(),
            layer.w13.data_ptr(), layer.w2.data_ptr(), out.data_ptr(),
            resout.data_ptr(), self.scratch.data_ptr(), self.control.data_ptr(),
            self.fault_word.data_ptr(), rows, layer.eps, self.config.blocks,
            self.config.max_spins if max_spins is None else max_spins,
            drop_cta, stream,
            peers=self.peer_arena.table.data_ptr() if self.peer_arena is not None else 0,
            attn_scale=attention_scale.data_ptr() if attention_scale is not None else 0,
            has_attn_scale=int(attention_scale is not None),
            ffn_peers=self.ffn_peer_arena.table.data_ptr() if self.ffn_peer_arena is not None else 0,
            ffn_scale=ffn_scale.data_ptr() if ffn_scale is not None else 0,
            has_ffn_scale=int(ffn_scale is not None), drop_ffn_cta=drop_ffn_cta,
        )

    def close_peers_collective(self):
        """All ranks, after destroying referencing graphs; never a destructor."""
        for arena in (self.ffn_peer_arena, self.peer_arena):
            if arena is not None:
                arena.close_collective()
        self._ready = False

    def collect_faults(self):
        """Enqueue a group-wide fault SUM; every TP rank must participate."""
        # One status SUM per integrated forward, including stock-only steps.
        # Propagate a completed kernel timeout to every member of the TP group.
        context = torch.cuda.device(self.device) if self.device.type == "cuda" else nullcontext()
        with context:
            self._bind_stream()
            if self.config.tp_size > 1:
                failed = checked_sum(self.collective, self.fault_word[:1])
                self.fault_word[:1].copy_(failed.clamp(max=1))
        return self.fault_word[0]

    def check_health(self):
        torch._assert_async(self.collect_faults() == 0,
                            "Qwen BF16 FFN failed; discard this step and stop the worker")

    def abort(self):
        self.fault_word[0].fill_(1)

    def health(self):
        """Explicit host synchronization for diagnostics, never in hot dispatch."""
        return tuple(self.fault_word.tolist())
