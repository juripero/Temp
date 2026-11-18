"""Host compiler/launcher for the pinned FlyDSL 0.5.0 gfx1201 backend."""
from __future__ import annotations

import os
from importlib.metadata import version
from pathlib import Path


def _select_target(cache_dir):
    if version("flydsl") != "0.5.0":
        raise RuntimeError("This backend requires exactly flydsl==0.5.0")
    for key, expected in (("FLYDSL_GPU_ARCH", "gfx1201"),
                          ("FLYDSL_COMPILE_BACKEND", "rocm"),
                          ("FLYDSL_RUNTIME_KIND", "rocm")):
        value = os.environ.setdefault(key, expected)
        if value != expected:
            raise RuntimeError(f"{key}={value!r}; expected {expected!r}")
    if cache_dir:
        path = str(Path(cache_dir).expanduser().resolve())
        previous = os.environ.setdefault("FLYDSL_RUNTIME_CACHE_DIR", path)
        if previous != path:
            raise RuntimeError("Conflicting process-wide FLYDSL_RUNTIME_CACHE_DIR")
        Path(path).mkdir(parents=True, exist_ok=True)


class CompiledFfn:
    def __init__(self, compiled, hidden, intermediate, blocks):
        self.compiled = compiled
        self.hidden, self.intermediate, self.blocks = hidden, intermediate, blocks

    def max_blocks_per_cu(self):
        return self.compiled.max_blocks_per_cu()

    @staticmethod
    def arguments(addresses, rows, eps, max_spins, drop_cta, stream,
                  *, peers=0, attn_scale=0, has_attn_scale=0,
                  ffn_peers=0, ffn_scale=0, has_ffn_scale=0, drop_ffn_cta=-1):
        import flydsl.compiler as flyc
        import flydsl.expr as fx
        # The last two pointers are uint32 arrival/generation and fault state.
        ptrs = [flyc.from_c_void_p(fx.BFloat16 if i < 8 else fx.Uint32, address,
                                  assumed_align=2 if i < 8 else 4)
                for i, address in enumerate(addresses)]
        ptrs.extend((flyc.from_c_void_p(fx.Uint64, peers, assumed_align=8),
                     flyc.from_c_void_p(fx.BFloat16, attn_scale, assumed_align=2),
                     flyc.from_c_void_p(fx.Uint64, ffn_peers, assumed_align=8),
                     flyc.from_c_void_p(fx.BFloat16, ffn_scale, assumed_align=2)))
        return (*ptrs, rows, eps, max_spins, drop_cta, has_attn_scale,
                has_ffn_scale, drop_ffn_cta, fx.Stream(stream))

    def initialize_runtime(self, stream):
        # Force load/ABI setup outside graph capture. rows=0 dereferences nothing.
        self.compiled(*self.arguments([0] * 10, 0, 1e-6, 1, -1, stream))

    def ffn_launch(self, a, residual, norm, w13, w2, out, resout, scratch,
                   control, fault, rows, eps, blocks, max_spins, drop_cta, stream,
                   *, peers=0, attn_scale=0, has_attn_scale=0,
                  ffn_peers=0, ffn_scale=0, has_ffn_scale=0, drop_ffn_cta=-1):
        if blocks != self.blocks or not 1 <= rows <= 16:
            raise ValueError("Launch geometry differs from the compiled specialization")
        self.compiled(*self.arguments(
            (a, residual, norm, w13, w2, out, resout, scratch, control, fault),
            rows, eps, max_spins, drop_cta, stream, peers=peers,
            attn_scale=attn_scale, has_attn_scale=has_attn_scale, ffn_peers=ffn_peers,
            ffn_scale=ffn_scale, has_ffn_scale=has_ffn_scale, drop_ffn_cta=drop_ffn_cta))


def build_ffn(hidden, intermediate, cache_dir=None, *, blocks=64, tp=1, rank=0,
              attention_partial=False, ffn_reduce=False, ipc_protocol="simple"):
    if ipc_protocol not in ("simple", "ll"):
        raise ValueError("ipc_protocol must be simple or ll")
    if tp not in (1, 2, 4) or not 0 <= rank < tp:
        raise ValueError("Invalid TP size/rank")
    if any(d <= 0 or d % 16 for d in (hidden, intermediate)) or not 1 <= blocks <= 64:
        raise ValueError("Dimensions must be positive multiples of 16; blocks must be 1..64")
    _select_target(cache_dir)
    import flydsl.compiler as flyc
    from flydsl.compiler.backends import current_target
    from ._flydsl_kernel import make_launcher
    target = current_target()
    if target.arch != "gfx1201" or target.warp_size != 32:
        raise RuntimeError(f"Wrong FlyDSL target: {target}")
    launcher = make_launcher(hidden, intermediate, blocks, tp, rank, attention_partial, ffn_reduce, ipc_protocol)
    # Null typed pointers suppress compile()'s implicit launch and runtime init.
    # The same path works on a CPU-only build host, without COMPILE_ONLY=1.
    compiled = flyc.compile[{"fast_fp_math": False}](
        launcher, *CompiledFfn.arguments([0] * 10, 0, 1e-6, 1, -1, None))
    if compiled is None:
        raise RuntimeError("Unset COMPILE_ONLY; placeholder compilation already avoids execution")
    return CompiledFfn(compiled, hidden, intermediate, blocks)
