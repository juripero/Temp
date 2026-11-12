git clone --recursive https://github.com/ROCm/aiter.git
cd aiter

export GPU_ARCHS=gfx1201
export PYTORCH_ROCM_ARCH=gfx1201
export PREBUILD_KERNELS=0
export AITER_MAX_JOBS=8

# Keep the existing compatible Triton from your ROCm/vLLM environment.
export AITER_USE_SYSTEM_TRITON=1

python -m pip install setuptools wheel packaging setuptools-scm ninja
python -m pip install -r requirements.txt
python -m pip install --no-build-isolation -v -e .
