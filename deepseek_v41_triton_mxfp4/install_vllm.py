"""Install the model integration into a reviewed vLLM source checkout."""

import argparse
import hashlib
import os
import shutil
import tempfile
from pathlib import Path

RELATIVE = Path("vllm/models/deepseek_v41/amd/model.py")
REVIEWED = {
    "b6b173415841ced1f3a27468287843d5b1a77a1950565bb4137148683ea383fc",
    "c38e993e4641d004cb20be9ca1d1777537f0938b3d871937489e4c99131743a3",
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--vllm-root", type=Path, required=True)
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Write the file; otherwise only check compatibility",
    )
    args = parser.parse_args()
    source = Path(__file__).resolve().parent / "integration" / RELATIVE
    target = args.vllm_root.resolve() / RELATIVE
    if not target.is_file():
        parser.error(f"Missing target: {target}")
    current, replacement = target.read_bytes(), source.read_bytes()
    if current == replacement:
        print(f"Already installed: {target}")
        return
    if hashlib.sha256(current).hexdigest() not in REVIEWED:
        parser.error(
            "Target differs from the reviewed upstream/prior model.py; merge the changes manually instead of overwriting it"
        )
    compile(replacement, str(target), "exec")
    if not args.apply:
        print(f"Compatible target: {target}. Re-run with --apply to install.")
        return
    backup = target.with_name("model.py.before-triton-mxfp4-cache")
    if backup.exists() and backup.read_bytes() != current:
        parser.error(f"Refusing to overwrite an existing different backup: {backup}")
    if not backup.exists():
        shutil.copy2(target, backup)
    descriptor, name = tempfile.mkstemp(
        dir=target.parent, prefix="model-cache-", suffix=".py"
    )
    try:
        with os.fdopen(descriptor, "wb") as stream:
            stream.write(replacement)
        shutil.copymode(target, name)
        os.replace(name, target)
    finally:
        Path(name).unlink(missing_ok=True)
    print(f"Installed {target}\nBackup: {backup}")


if __name__ == "__main__":
    main()
