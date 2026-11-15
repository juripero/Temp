class DeepseekV4MoE(DeepseekV4MoEBase):
    # ... existing __init__ code ...

    def arm_expert_cache(self, arm_fn: Callable[[nn.Module, typing.Any, typing.Any], bool]) -> bool:
        """Hook the inner FusedMoE layer after weights are loaded and processed."""
        if self.use_mega_moe:
            logger.warning("Skipping expert cache on %s: MegaMoE is active.", self)
            return False

        # In vLLM's DeepseekV4MoE, the FusedMoE module lives at `self.experts`
        experts_layer = getattr(self, "experts", None)
        if experts_layer is None:
            return False

        quant_method = getattr(experts_layer, "quant_method", None)
        if quant_method is None:
            return False

        # Ensure `FusedMoEMethodBase.process_weights_after_loading` has already run
        # on `experts_layer` before wrapping `quant_method.apply`.
        if hasattr(quant_method, "process_weights_after_loading"):
            quant_method.process_weights_after_loading(experts_layer)
            # Prevent the global loader loop from running it a second time
            quant_method.process_weights_after_loading = lambda *args, **kwargs: None

        return arm_fn(experts_layer, quant_method, logger)

class DeepseekV4DecoderLayer(nn.Module):
    # ... existing __init__ and forward code ...

    def process_weights_after_loading(self) -> None:
        # 1. Import your arming function (e.g., from vllm_expert_cache.backends.generic)
        try:
            from vllm_expert_cache.backends.generic import arm as arm_expert_cache_fn
        except ImportError:
            arm_expert_cache_fn = None

        cache_armed = False
        if arm_expert_cache_fn is not None and isinstance(self.ffn, DeepseekV4MoE):
            cache_armed = self.ffn.arm_expert_cache(arm_expert_cache_fn)

        # 2. Coordinate with MonoDecodeLayer:
        # MonoDecodeLayer captures raw weight pointers and bypasses `self.ffn.forward()`
        # during decode steps. If expert weights are dynamically swapped per step,
        # disable `self.mono` so execution routes through `self.ffn` -> `quant_method.apply`.
        if cache_armed and self.mono is not None:
            logger.info_once(
                "Disabling MonoDecodeLayer so dynamic MoE expert caching can intercept forward()."
            )
            self.mono = None
            # Restore TP reduction on `wo_b` if `mono.ffn_only` had disabled it in __init__
            self.attn.wo_b.reduce_results = True

        # 3. Build MonoDecodeLayer runner only if it remains active
        if self.mono is not None:
            self.mono.build_runner(self.attn_norm.weight.device)
