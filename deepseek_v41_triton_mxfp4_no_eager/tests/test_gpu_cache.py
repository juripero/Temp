"""Hardware qualification for the actual cache runtime, including mapped host reads."""

import pytest
import torch
from vllm_expert_cache.backends.triton_mxfp4_cache import TritonSlotCache

pytestmark = pytest.mark.skipif(
    not torch.cuda.is_available() or not torch.version.hip,
    reason="Requires a ROCm GPU; CPU interpreter checks do not qualify this test",
)


@pytest.mark.parametrize("uva", [False, True])
def test_runtime_gathers_transposed_experts_across_stream_handoffs(uva, monkeypatch):
    monkeypatch.setenv("EXPERT_CACHE_POLICY", "lfu")
    monkeypatch.setenv("EXPERT_CACHE_DECAY", "3")
    if uva:
        from vllm.utils.platform_utils import is_uva_available
        from vllm.utils.torch_utils import get_accelerator_view_from_cpu_tensor

        if not is_uva_available():
            pytest.skip("UVA is unavailable; host-offload mode remains unqualified")
    layer = torch.nn.Module()
    expected, pinned = {}, []
    for index, name in enumerate(
        ("w13_weight", "w2_weight", "w13_weight_scale", "w2_weight_scale")
    ):
        full = (
            (torch.arange(13 * 7 * 33).reshape(13, 7, 33) + index * 11)
            .to(torch.uint8)
            .transpose(1, 2)
        )
        expected[name] = full
        if uva:
            host = torch.empty_strided(
                full.shape, full.stride(), dtype=full.dtype, pin_memory=True
            )
            host.copy_(full)
            pinned.append(host)
            device_data = get_accelerator_view_from_cpu_tensor(host)
        else:
            device_data = full.to("cuda")
        layer.register_parameter(
            name, torch.nn.Parameter(device_data, requires_grad=False)
        )
    cache = TritonSlotCache(layer, list(expected), 13, 5)
    streams = [torch.cuda.current_stream(), torch.cuda.Stream()]
    cases = [[12, 1, 7], [7, 2, 12], [8, 9, 10], [1, 12, 1], [0, 2, 3]]
    for index, values in enumerate(cases):
        with torch.cuda.stream(streams[index % 2]):
            ids = torch.tensor([values], device="cuda", dtype=torch.int64)
            with cache.invocation():
                mapped = cache.refresh(ids)
            # Synchronize only in the test, after the cache invocation.
            torch.cuda.current_stream().synchronize()
            mapping = mapped.cpu().flatten().tolist()
            for name, full in expected.items():
                for expert, slot in zip(values, mapping):
                    torch.testing.assert_close(
                        cache.slots[name][slot].cpu(), full[expert]
                    )
    assert not cache.failed
