"""Compile cache kernels to gfx1201 code without requiring a live GPU."""

import json

import triton
from triton.backends.compiler import GPUTarget
from triton.compiler import ASTSource
from vllm_expert_cache.backends.triton_mxfp4_kernels import gather, manage


def main():
    target = GPUTarget("hip", "gfx1201", 32)
    results = []
    for policy, slots, count, id_type in (
        (0, 3, 3, "*i32"),
        (1, 128, 8, "*i32"),
        (1, 5, 0, "*i32"),
        (0, 128, 8, "*i64"),
    ):
        signature = dict(
            zip(
                manage.arg_names[:8],
                [id_type, id_type, "*i32", "*i32", "*i64", "*i64", "*i32", "*i32"],
            )
        )
        # Eight pointer arguments; all dimensions/policy values are constexpr.
        source = ASTSource(
            manage,
            signature=signature,
            constexprs={
                "E": 256,
                "S": slots,
                "R": count,
                "B": triton.next_power_of_2(slots),
                "POLICY": policy,
                "DECAY": 64,
            },
        )
        compiled = triton.compile(source, target=target, options={"num_warps": 4})
        results.append(
            {
                "kernel": "manage",
                "policy": policy,
                "slots": slots,
                "ids": count,
                "id_type": id_type,
                "assembly": sorted(compiled.asm),
            }
        )
    source = ASTSource(
        gather,
        signature={"SRC": "*u8", "DST": "*u8", "MISS": "*i32"},
        constexprs={"SLAB": 4099, "BLOCK": 4096},
    )
    compiled = triton.compile(source, target=target, options={"num_warps": 4})
    results.append({"kernel": "gather", "assembly": sorted(compiled.asm)})
    print(
        json.dumps(
            {
                "target": "gfx1201",
                "triton_version": triton.__version__,
                "compiled": results,
                "executed_on_gpu": False,
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
