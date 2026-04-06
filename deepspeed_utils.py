# Copyright 2023-2024 SGLang Team
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
"""DeepSpeed utilities."""

import torch
import json
from copy import deepcopy 

_USE_ZERO_INFERENCE = False 
_DEEPSPEED_CONFIG_DICT = None 

ZERO_KEY = "zero_optimization"
STAGE_KEY = "stage"
OFFLOAD_KEY = "offload_param"

def _validate_zero_inference_config(ds_config_dict: dict, ds_config_file: str) -> None:
     assert ZERO_KEY in ds_config_dict, f"{ZERO_KEY} key is missing in {ds_config_file}"
     assert STAGE_KEY in ds_config_dict[ZERO_KEY], f"{STAGE_KEY} not defined in {ds_config_file}"
     assert ds_config_dict[ZERO_KEY][STAGE_KEY] == 3, f"ZeRO-Inference requires stage 3"


def set_zero_inference(ds_config: str) -> None:
    global _USE_ZERO_INFERENCE, _DEEPSPEED_CONFIG_DICT
    if ds_config != None:
        _USE_ZERO_INFERENCE = True
        with open(ds_config, 'r', encoding='utf-8') as config_file:
                    _DEEPSPEED_CONFIG_DICT = json.load(config_file)
                    _validate_zero_inference_config(_DEEPSPEED_CONFIG_DICT, config_file)


def is_zero_inference() -> bool:
    global _USE_ZERO_INFERENCE
    return _USE_ZERO_INFERENCE


def get_ds_config(model_dtype: torch.dtype, model_hidden_size: int, model_vocab_size: int):
    global _DEEPSPEED_CONFIG_DICT    

    ds_config = deepcopy(_DEEPSPEED_CONFIG_DICT)

    dtype_str = "bf16" if model_dtype == torch.bfloat16 else torch.float16
    ds_config[dtype_str] = dict(
        enabled=True
    )

    param_size = model_hidden_size * model_hidden_size
    embedding_size = model_hidden_size * model_vocab_size
    zero_replace_dict = {
         "stage3_prefetch_bucket_size": 2 * param_size,
        "stage3_param_persistence_threshold": model_hidden_size,
        "stage3_max_live_parameters": 2 * param_size,
    }
    for key, new_value in zero_replace_dict.items():
         if ds_config[ZERO_KEY][key] == "auto":
              ds_config[ZERO_KEY][key]= new_value

    offload_dict = ds_config[ZERO_KEY][OFFLOAD_KEY]
    if offload_dict["buffer_size"] == "auto":
         offload_dict["buffer_size"] = max(param_size, embedding_size)

    return ds_config

