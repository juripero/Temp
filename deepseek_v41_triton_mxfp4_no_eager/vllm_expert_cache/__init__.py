"""Device-side expert cache for vLLM MoE models.

Keeps a bounded set of experts resident in VRAM and reads missing expert bytes
from the configured backing tensors. This fork adds an experimental graph-capable
gfx1201 OAI Triton MXFP4 adapter; its performance needs hardware measurement.

vLLM loads this automatically through the `vllm.general_plugins` entry point; installing
the package is enough. Set `EXPERT_CACHE_DISABLE=1` to turn it off without uninstalling.
"""

from __future__ import annotations

from .config import settings

__all__ = ["install", "settings"]
__version__ = "0.3.0+gfx1201"


def install() -> None:
    """Arm the cache for whatever MoE quantisation the model turns out to use."""
    # Name the logger inside vLLM's own tree. vLLM only attaches handlers to "vllm.*",
    # so a logger named anything else emits nothing in a real server and the plugin looks
    # inert even while it is working.
    try:
        from vllm.logger import init_logger
        logger = init_logger("vllm.expert_cache")
    except Exception:  # pragma: no cover - vLLM always provides this in practice
        import logging
        logger = logging.getLogger("vllm.expert_cache")

    from .backends import triton_mxfp4_offload

    # Keep the uncached UVA baseline correct too. This hook never arms caches.
    triton_mxfp4_offload.install(logger)

    if settings.disabled:
        logger.info("expert-cache: disabled by EXPERT_CACHE_DISABLE")
        return

    from .backends import generic

    if not generic.install(logger):
        logger.info("expert-cache: could not hook vLLM's MoE loader; staying out of the way")
