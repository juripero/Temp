"""Run on ROCm, or with TRITON_INTERPRET=1 to exercise the same kernels on CPU."""

import os
import random

import pytest
import torch
import triton
from policy_reference import Policy
from vllm_expert_cache.backends.triton_mxfp4_kernels import gather, manage
from vllm_expert_cache.backends.triton_mxfp4_layout import empty_slots, physical_bytes

INTERPRET = os.getenv("TRITON_INTERPRET") == "1"
pytestmark = pytest.mark.skipif(
    not INTERPRET and not torch.cuda.is_available(),
    reason="ROCm GPU or TRITON_INTERPRET=1 required",
)
DEVICE = "cpu" if INTERPRET else "cuda"


@pytest.mark.parametrize("policy,decay", [(0, 0), (1, 0), (1, 3)])
@pytest.mark.parametrize("dtype", [torch.int32, torch.int64])
def test_manager_matches_oracle_for_hits_evictions_duplicates_and_masks(
    policy, decay, dtype
):
    E, S = 13, 5
    state = [
        torch.full((E,), -1, dtype=torch.int32, device=DEVICE),
        torch.full((S,), -1, dtype=torch.int32, device=DEVICE),
        torch.zeros(S, dtype=torch.int64, device=DEVICE),
        torch.zeros((), dtype=torch.int64, device=DEVICE),
        torch.full((S,), -1, dtype=torch.int32, device=DEVICE),
        torch.zeros((), dtype=torch.int32, device=DEVICE),
    ]
    rng = random.Random(18)
    cases = [[5, 1, 5], [3, 4, 5, 1, 3], [12, 11, 10, 9, 8], [-1, 8], []]
    cases += [
        [rng.randrange(-1, E) for _ in range(rng.randrange(1, S + 1))]
        for _ in range(45)
    ]
    ref = Policy(E, S, policy, decay)
    for values in cases:
        ids = torch.tensor([values], device=DEVICE, dtype=dtype)
        result = torch.empty_like(ids)
        manage[(1,)](
            ids,
            result,
            *state,
            E,
            S,
            ids.numel(),
            triton.next_power_of_2(S),
            policy,
            decay,
            num_warps=4,
        )
        expected, misses, table = ref.step(values)
        assert result.cpu().flatten().tolist() == expected
        assert state[0].cpu().tolist() == table
        assert state[1].cpu().tolist() == ref.experts
        assert state[2].cpu().tolist() == ref.scores
        assert state[4].cpu().tolist() == misses
        assert state[5].item() == sum(e >= 0 for e in misses)


@pytest.mark.parametrize("transposed", [False, True])
def test_gather_copies_physical_layout_and_byte_tails(transposed):
    # An odd 39-byte slab catches assumptions inherited from the HIP 16-byte copy.
    source = (
        torch.arange(7 * 3 * 13, dtype=torch.int32, device=DEVICE)
        .to(torch.uint8)
        .reshape(7, 3, 13)
    )
    if transposed:
        source = source.transpose(1, 2)
    target = empty_slots(source, 7, 3)
    target.fill_(177)
    misses = torch.tensor([6, -1, 1], device=DEVICE, dtype=torch.int32)
    gather[(3, 2)](physical_bytes(source), physical_bytes(target), misses, 39, 32)
    torch.testing.assert_close(target[0], source[6])
    torch.testing.assert_close(target[2], source[1])
    assert bool((target[1] == 177).all())
    assert target.stride() == source.stride()


@pytest.mark.skipif(
    INTERPRET,
    reason="Raw kernel graph replay requires a GPU",
)
def test_raw_kernels_replay_with_changing_ids():
    E, S = 8, 3
    ids = torch.tensor([[1, 2]], device=DEVICE, dtype=torch.int32)
    output = torch.empty_like(ids)
    table = torch.full((E,), -1, device=DEVICE, dtype=torch.int32)
    experts = torch.full((S,), -1, device=DEVICE, dtype=torch.int32)
    score = torch.zeros(S, device=DEVICE, dtype=torch.int64)
    clock = torch.zeros((), device=DEVICE, dtype=torch.int64)
    miss = torch.empty(S, device=DEVICE, dtype=torch.int32)
    count = torch.zeros((), device=DEVICE, dtype=torch.int32)
    source = (
        torch.arange(E * 64, device=DEVICE, dtype=torch.int32)
        .to(torch.uint8)
        .reshape(E, 64)
    )
    target = torch.empty((S, 64), device=DEVICE, dtype=torch.uint8)

    def call():
        manage[(1,)](
            ids, output, table, experts, score, clock, miss, count, E, S, 2, 4, 0, 0
        )
        gather[(S, 1)](source, target, miss, 64, 64)

    stream = torch.cuda.Stream()
    stream.wait_stream(torch.cuda.current_stream())
    with torch.cuda.stream(stream):
        call()
    torch.cuda.current_stream().wait_stream(stream)
    graph = torch.cuda.CUDAGraph()
    with torch.cuda.graph(graph, stream=stream):
        call()
    for values in ([7, 6], [1, 7], [5, 0], [0, 0]):
        ids.copy_(torch.tensor([values], device=DEVICE, dtype=ids.dtype))
        graph.replay()
        torch.testing.assert_close(
            target[output.long()].cpu(), source[ids.long()].cpu()
        )
