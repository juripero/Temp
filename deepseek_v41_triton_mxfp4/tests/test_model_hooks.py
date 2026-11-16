"""CPU checks for the source-pinned model hooks, independent of vLLM imports."""

import ast
import hashlib
import json
from pathlib import Path
from types import SimpleNamespace as NS
from unittest.mock import Mock

import pytest

ROOT = Path(__file__).resolve().parents[1]
TREE = ast.parse((ROOT / "integration/vllm/models/deepseek_v41/amd/model.py").read_text())


def test_unmodified_upstream_methods_include_mega_mhc_postload():
    expected = json.loads((ROOT / "tests/upstream_method_hashes.json").read_text())
    actual = {
        cls.name + "." + method.name: hashlib.sha256(
            ast.dump(method).encode()
        ).hexdigest()
        for cls in TREE.body
        if isinstance(cls, ast.ClassDef)
        for method in cls.body
        if isinstance(method, ast.FunctionDef)
    }
    assert all(actual[key] == digest for key, digest in expected.items())
    assert "DeepseekV4DecoderLayer.process_weights_after_loading" in expected


def load_function(name):
    function = next(
        node
        for node in TREE.body
        if isinstance(node, ast.FunctionDef) and node.name == name
    )
    namespace = {}
    exec(  # noqa: S102 - execute an AST node from our local source fixture
        compile(ast.Module(body=[function], type_ignores=[]), "<config-guard>", "exec"),
        namespace,
    )
    return namespace[name]


def config():
    return NS(
        model_config=NS(enforce_eager=True),
        speculative_config=None,
        kernel_config=NS(monokernel=False, moe_backend="triton_unfused"),
        parallel_config=NS(),
        lora_config=None,
    )


@pytest.mark.parametrize(
    "section,name,value",
    [
        ("model_config", "enforce_eager", False),
        ("kernel_config", "monokernel", "decode"),
        ("kernel_config", "moe_backend", "aiter_mega_moe"),
        ("parallel_config", "enable_expert_parallel", True),
        ("parallel_config", "enable_eplb", True),
        ("parallel_config", "enable_dbo", True),
        ("parallel_config", "use_ubatching", True),
        ("parallel_config", "data_parallel_size", 2),
        ("parallel_config", "prefill_context_parallel_size", 2),
        ("parallel_config", "decode_context_parallel_size", 2),
    ],
)
def test_conflicting_modes_fail_during_construction(section, name, value):
    cfg = config()
    setattr(getattr(cfg, section), name, value)
    with pytest.raises(ValueError):
        load_function("_validate_expert_cache_config")(cfg)


@pytest.mark.parametrize("tp", [1, 2, 4])
def test_serialized_tp_is_not_rejected(tp):
    cfg = config()
    cfg.parallel_config.tensor_parallel_size = tp
    load_function("_validate_expert_cache_config")(cfg)


def test_mono_is_skipped_before_creation_and_reduction_is_preserved():
    decoder = next(
        n
        for n in TREE.body
        if isinstance(n, ast.ClassDef) and n.name == "DeepseekV4DecoderLayer"
    )
    init = next(
        n
        for n in decoder.body
        if isinstance(n, ast.FunctionDef) and n.name == "__init__"
    )
    index = next(
        i
        for i, node in enumerate(init.body)
        if isinstance(node, ast.Assign)
        and any(isinstance(t, ast.Attribute) and t.attr == "mono" for t in node.targets)
    )
    chunk = ast.Module(body=init.body[index : index + 2], type_ignores=[])
    for prior in (False, True):
        owner = NS(
            ffn=NS(_expert_cache_requested=True), attn=NS(wo_b=NS(reduce_results=prior))
        )
        create = Mock()
        exec(  # noqa: S102 - execute the local constructor branch in isolation
            compile(chunk, "<mono-selection>", "exec"),
            {
                "self": owner,
                "vllm_config": config(),
                "MonoDecodeLayer": NS(create=create),
            },
        )
        create.assert_not_called()
        assert owner.mono is None
        assert owner.attn.wo_b.reduce_results is prior


def test_model_never_arms_or_reprocesses_quantization_methods():
    moe = next(
        n
        for n in TREE.body
        if isinstance(n, ast.ClassDef) and n.name == "DeepseekV4MoE"
    )
    for node in ast.walk(moe):
        if isinstance(node, ast.Call) and isinstance(node.func, ast.Attribute):
            assert node.func.attr not in {"arm", "process_weights_after_loading"}
