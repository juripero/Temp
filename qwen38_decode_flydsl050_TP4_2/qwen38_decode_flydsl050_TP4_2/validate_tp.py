"""TP2/TP4 qualification with real process-group collectives.

torchrun --standalone --nproc-per-node=2 validate_tp.py --small --graph --fault-test
torchrun --standalone --nproc-per-node=4 validate_tp.py --graph --fault-test
torchrun --standalone --nproc-per-node=4 validate_tp.py --cpu --small --tp-size=2

The last command tests two disjoint TP2 subgroups and catches accidental WORLD
reductions. CPU/Gloo tests validate sharding and host orchestration, not FlyDSL
GPU arithmetic, RCCL, or hardware synchronization. Run GPU faults in a disposable
process. Inconsistent rank participation is a job failure, not recoverable.
"""
from __future__ import annotations

import argparse
from contextlib import nullcontext
from datetime import timedelta
import json
import math
import os

import torch
import torch.distributed as dist

from specialized_decode.mono.ffn import reference_ffn, attention_sum_reference
from specialized_decode.mono.runner import FfnRunner
from specialized_decode.runtime.parallel import TorchTpCollective, setup_signature
from specialized_decode.runtime.spec import DecodeConfig
from specialized_decode.runtime.weights import LayerWeights, shard_reference_weights


def run(args):
    local_rank = int(os.environ["LOCAL_RANK"])
    if args.cpu:
        if not args.small or args.graph:
            raise ValueError("CPU mode requires --small and does not support --graph")
        device, backend = torch.device("cpu"), "gloo"
        torch.set_num_threads(1)
    else:
        if torch.version.hip is None or not torch.cuda.is_available():
            raise RuntimeError("GPU tests require ROCm PyTorch and gfx1201 on every rank")
        torch.cuda.set_device(local_rank)
        device, backend = torch.device("cuda", local_rank), "nccl"
        arch = torch.cuda.get_device_properties(device).gcnArchName.split(":")[0]
        if arch != "gfx1201":
            raise RuntimeError(f"Rank {local_rank}: expected gfx1201, got {arch}")
    dist.init_process_group(backend, timeout=timedelta(seconds=args.timeout))
    world, global_rank = dist.get_world_size(), dist.get_rank()
    tp = args.tp_size or world
    if tp not in (2, 4) or world % tp:
        raise ValueError("World size must be a multiple of TP2 or TP4")
    # Every process creates subgroups in the same global order.
    group = host_group = None
    for start in range(0, world, tp):
        candidate = dist.new_group(list(range(start, start + tp)), backend=backend,
                                   timeout=timedelta(seconds=args.timeout))
        host_candidate = (candidate if args.cpu else dist.new_group(
            list(range(start, start + tp)), backend="gloo", timeout=timedelta(seconds=args.timeout)))
        if start <= global_rank < start + tp:
            group, host_group = candidate, host_candidate
    collective = TorchTpCollective(group, host_group)
    group_id, rank = global_rank // tp, collective.rank
    h, inter = (32, 64) if args.small else (5120, 17408)
    config = DecodeConfig(backend="torch" if args.cpu else "flydsl", hidden_size=h,
                          intermediate_size=inter, num_layers=1, tp_size=tp, tp_rank=rank,
                          blocks=args.blocks,
                          attention_input="partial" if args.attention_partials else "reduced")
    errors = collective.setup_agreement(setup_signature(config), None)
    if errors:
        raise AssertionError(errors)
    generator = torch.Generator().manual_seed(3719 + group_id * 1009)

    def rand(shape, scale=1.0):
        return (torch.randn(shape, generator=generator) * scale).bfloat16().to(device)

    full = LayerWeights(0, rand((h,), .1), rand((inter * 2, h), 1 / math.sqrt(h)),
                        rand((h, inter), 1 / math.sqrt(inter)), config.eps)
    local = shard_reference_weights(full, tp, rank)
    runner = FfnRunner(device, config, collective)
    error = None
    try:
        runner.warmup()
    except Exception as exc:
        error = f"{type(exc).__name__}: {exc}"
    errors = collective.setup_agreement(setup_signature(config), error)
    if errors:
        raise RuntimeError("; ".join(errors))
    stream = None if args.cpu else torch.cuda.Stream(device=device)
    if not args.cpu:
        torch.cuda.synchronize(device)
    records = []
    scale = rand((1, 1, h), .125) if args.attention_scale else None

    def local_attention(rows):
        value = rand((rows, h))
        return (value * ((rank + 1) / tp)).bfloat16() if args.attention_partials else value

    def reduced_attention(value):
        if not args.attention_partials:
            return value
        partials = [torch.empty_like(value) for _ in range(tp)]
        dist.all_gather(partials, value, group=group)
        return attention_sum_reference(partials, scale)

    def compare(name, actual, expected, *, exact=False):
        torch.testing.assert_close(actual, expected, atol=0 if exact else args.atol,
                                   rtol=0 if exact else args.rtol, equal_nan=True)
        delta = (actual.float() - expected.float()).abs()
        records.append({"test": name, "max_abs": delta.max().item()})

    context = nullcontext() if args.cpu else torch.cuda.stream(stream)
    with context, torch.no_grad():
        for rows in (1, 2, 3, 4, 7, 8, 15, 16):
            a, residual = local_attention(rows), rand((rows, h))
            attention = reduced_attention(a)
            partial, expected_res, expected_x, expected_mid = reference_ffn(
                attention, residual, local, return_stages=True)
            expected_tp = collective.all_reduce(partial)
            expected_tp1, _ = reference_ffn(attention, residual, full)
            actual, resout = runner.launch_layer(local, a, residual, attention_scale=scale)
            runner.check_health()  # Same collective order on every rank.
            if stream is not None:
                stream.synchronize()
            compare(f"rows={rows}/same-TP-reference", actual, expected_tp, exact=args.cpu)
            compare(f"rows={rows}/TP1-rounding-difference", actual, expected_tp1)
            compare(f"rows={rows}/residual-not-reduced", resout, expected_res, exact=True)
            replicas = [torch.empty_like(actual) for _ in range(tp)]
            dist.all_gather(replicas, actual, group=group)
            for replica in replicas:
                compare(f"rows={rows}/replicated-output", replica, actual, exact=True)
            if not args.cpu:
                if config.fused_attention_reduce:
                    offset = 16 * (h + config.local_intermediate_size)
                    compare(f"rows={rows}/attention-sum", runner.scratch[offset:offset + rows * h].view(rows, h),
                            attention, exact=True)
                compare(f"rows={rows}/norm", runner.scratch[:rows * h].view(rows, h), expected_x)
                local_i = config.local_intermediate_size
                compare(f"rows={rows}/local-SwiGLU",
                        runner.scratch[16 * h:16 * h + rows * local_i].view(rows, local_i), expected_mid)

        if not args.cpu:
            runner.control[1].fill_(-config.grid_barriers_per_launch)
            actual, resout = runner.launch_layer(local, a, residual, attention_scale=scale)
            runner.check_health()
            stream.synchronize()
            if runner.control.tolist() != [0, 0]:
                raise AssertionError("Device generation did not wrap")
            compare("generation-wrap", actual, expected_tp)
            if runner.peer_arena is not None:
                runner.peer_arena.debug_seed_epoch_collective(0xFFFFFFFE)
                for expected_epoch in (0xFFFFFFFF, 0, 1):
                    actual, _ = runner.launch_layer(local, a, residual, attention_scale=scale)
                    runner.check_health()
                    stream.synchronize()
                    if runner.peer_arena.debug_epoch() != expected_epoch:
                        raise AssertionError("Peer epoch did not wrap")
                    compare(f"peer-wrap/{expected_epoch}", actual, expected_tp)

        if args.graph:
            a, residual = local_attention(8), rand((8, h))
            for _ in range(3):
                runner.launch_layer(local, a, residual, attention_scale=scale)
                runner.check_health()
            stream.synchronize()
            dist.barrier(group=group)
            graph = torch.cuda.CUDAGraph()
            with torch.cuda.graph(graph, stream=stream):
                graph_out, graph_res = runner.launch_layer(local, a, residual, attention_scale=scale)
                runner.check_health()
            for iteration in range(16):
                valid = 1 + iteration % 8
                a.copy_(local_attention(8))
                residual.copy_(rand((8, h)))
                a[valid:].fill_(float("nan"))
                residual[valid:].fill_(float("nan"))
                attention = reduced_attention(a[:valid])
                partial, expected_res = reference_ffn(attention, residual[:valid], local)
                expected_tp = collective.all_reduce(partial)
                graph.replay()
                stream.synchronize()
                compare(f"graph/{iteration}", graph_out[:valid], expected_tp)
                compare(f"graph/{iteration}/residual", graph_res[:valid], expected_res, exact=True)

        if args.fault_test:
            if args.blocks < 2:
                raise ValueError("Fault injection requires blocks>=2")
            bad = FfnRunner(device, config, collective)
            bad.warmup()
            if args.cpu:
                if rank == 0:
                    bad.abort()
            elif rank == 0 or config.fused_attention_reduce:
                a = torch.zeros((1, h), device=device, dtype=torch.bfloat16)
                out, resout = torch.empty_like(a), torch.empty_like(a)
                bad._raw_launch(local, a, a, out, resout, 1, stream.cuda_stream,
                                drop_cta=0 if rank == 0 else -1, max_spins=10000)
            # Use the same propagation as production without triggering the
            # deliberate device assertion and poisoning the test context.
            bad.collect_faults()
            if stream is not None:
                stream.synchronize()
            first = bad.health()
            if first[0] != 1 or (not args.cpu and rank == 0 and first[1] != (3 if config.fused_attention_reduce else 1)):
                raise AssertionError(f"TP fault did not propagate: {first}")
            bad.collect_faults()
            if bad.health() != first:
                raise AssertionError("TP fault was not sticky")
            records.append({"test": "rank-0-fault-propagated-to-all-ranks", "passed": True})

    report = {"global_rank": global_rank, "tp_rank": rank, "tp_size": tp,
              "group": group_id, "backend": config.backend, "collective": backend,
              "attention_input": config.attention_input, "attention_scale": args.attention_scale,
              "local_w13": list(local.w13.shape), "local_w2": list(local.w2.shape),
              "checks_passed": len(records), "measurements": records}
    if args.report_dir:
        from pathlib import Path
        dest = Path(args.report_dir)
        dest.mkdir(parents=True, exist_ok=True)
        (dest / f"rank_{global_rank}.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({k: v for k, v in report.items() if k != "measurements"}), flush=True)
    dist.barrier()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cpu", action="store_true")
    parser.add_argument("--attention-partials", action="store_true")
    parser.add_argument("--attention-scale", action="store_true")
    parser.add_argument("--small", action="store_true")
    parser.add_argument("--graph", action="store_true")
    parser.add_argument("--fault-test", action="store_true")
    parser.add_argument("--tp-size", type=int)
    parser.add_argument("--blocks", type=int, default=64)
    parser.add_argument("--timeout", type=int, default=120)
    parser.add_argument("--atol", type=float, default=.03125)
    parser.add_argument("--rtol", type=float, default=.02)
    parser.add_argument("--report-dir")
    args = parser.parse_args()
    if args.attention_scale and not args.attention_partials:
        parser.error("--attention-scale requires --attention-partials")
    try:
        run(args)
    finally:
        if dist.is_initialized():
            dist.destroy_process_group()


if __name__ == "__main__":
    main()
