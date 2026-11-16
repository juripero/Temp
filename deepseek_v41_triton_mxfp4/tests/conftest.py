import os
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
if os.getenv("TRITON_KERNELS_SRC"):
    sys.path.insert(0, os.environ["TRITON_KERNELS_SRC"])
