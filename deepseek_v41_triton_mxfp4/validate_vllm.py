"""Compare eager vLLM generations with cache off/on in separate processes.

Run once each with --tp 1, --tp 2, and --tp 4 on the target GPUs. This is a
qualification test, not a performance benchmark or a model-quality evaluation.
"""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


def worker(args):
    from vllm import LLM, SamplingParams

    extras = json.loads(args.engine_json)
    forbidden = {
        "model",
        "tensor_parallel_size",
        "enforce_eager",
        "kernel_config",
    } & extras.keys()
    if forbidden:
        raise ValueError(f"These validation settings cannot be overridden: {forbidden}")
    llm = LLM(
        model=args.model,
        tensor_parallel_size=args.tp,
        enforce_eager=True,
        kernel_config={"moe_backend": "triton_unfused"},
        **extras,
    )
    prompts = [
        "Explain why matrix multiplication is useful in machine learning.",
        "Write a Python function that computes a running mean.",
        "What is the difference between a cache hit and a cache miss?",
        "The following proof uses induction on the number of vertices:",
    ]
    if args.prompts:
        prompts = json.loads(args.prompts.read_text())
    records = []
    params = SamplingParams(temperature=0, max_tokens=args.tokens, logprobs=1, seed=17)
    # Sequential requests ensure small decode batches fit the cache. Repeat the
    # set to cover warm hits and longer-lived replacement state across requests.
    for prompt in prompts * 2:
        output = llm.generate([prompt], params, use_tqdm=False)[0].outputs[0]
        records.append(
            {
                "token_ids": list(output.token_ids),
                "logprobs": [
                    entry[token].logprob
                    for entry, token in zip(output.logprobs, output.token_ids)
                ],
            }
        )
    args.output.write_text(json.dumps(records, indent=2))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--model", required=True)
    parser.add_argument("--tp", type=int, choices=[1, 2, 4], default=1)
    parser.add_argument("--slots", type=int, default=64)
    parser.add_argument("--tokens", type=int, default=24)
    parser.add_argument("--logprob-atol", type=float, default=0.03)
    parser.add_argument(
        "--engine-json",
        default='{"max_model_len":2048,"max_num_seqs":1,"enable_prefix_caching":false,"seed":17}',
    )
    parser.add_argument("--prompts", type=Path)
    parser.add_argument("--results-dir", type=Path, default=Path("validation-results"))
    parser.add_argument("--worker", action="store_true", help=argparse.SUPPRESS)
    parser.add_argument("--output", type=Path, help=argparse.SUPPRESS)
    args = parser.parse_args()
    if args.worker:
        worker(args)
        return
    args.results_dir.mkdir(parents=True, exist_ok=True)
    paths = []
    for disabled in (True, False):
        label = "baseline" if disabled else "cached"
        path = args.results_dir / f"tp{args.tp}-{label}.json"
        log = path.with_suffix(".log")
        env = dict(os.environ)
        env["EXPERT_CACHE_DISABLE"] = "1" if disabled else "0"
        env["EXPERT_CACHE_SLOTS"] = str(args.slots)
        env["VLLM_ROCM_USE_AITER_FUSION_SHARED_EXPERTS"] = "0"
        command = [
            sys.executable,
            str(Path(__file__).resolve()),
            "--worker",
            "--model",
            args.model,
            "--tp",
            str(args.tp),
            "--tokens",
            str(args.tokens),
            "--engine-json",
            args.engine_json,
            "--output",
            str(path.resolve()),
        ]
        if args.prompts:
            command += ["--prompts", str(args.prompts.resolve())]
        with log.open("w") as stream:
            subprocess.run(
                command, env=env, stdout=stream, stderr=subprocess.STDOUT, check=True
            )
        if not disabled and "gfx1201 Triton MXFP4 adapter" not in log.read_text():
            raise RuntimeError(
                f"No adapter activation evidence in {log}; this would be a vacuous comparison"
            )
        paths.append(path)
    baseline, cached = (json.loads(path.read_text()) for path in paths)
    if len(baseline) != len(cached):
        raise AssertionError("Different request counts")
    maximum = 0.0
    for index, (a, b) in enumerate(zip(baseline, cached)):
        if a["token_ids"] != b["token_ids"]:
            raise AssertionError(
                f"Greedy token mismatch at request {index}; inspect logits before use"
            )
        if len(a["logprobs"]) != len(b["logprobs"]):
            raise AssertionError("Different logprob counts")
        maximum = max(
            maximum,
            max(
                (abs(x - y) for x, y in zip(a["logprobs"], b["logprobs"])), default=0.0
            ),
        )
    if maximum > args.logprob_atol:
        raise AssertionError(
            f"Maximum chosen-token logprob error {maximum} exceeds {args.logprob_atol}"
        )
    print(
        json.dumps(
            {
                "tp": args.tp,
                "requests": len(baseline),
                "max_logprob_error": maximum,
                "passed": True,
                "scope": "greedy tokens and chosen-token logprobs",
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
