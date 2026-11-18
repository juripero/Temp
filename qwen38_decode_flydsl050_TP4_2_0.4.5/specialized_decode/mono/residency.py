from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class Residency:
    blocks_per_processor: int
    processor_count: int
    wave_size: int

    @property
    def capacity(self):
        return self.blocks_per_processor * self.processor_count


def checked_residency(module, blocks: int, properties) -> Residency:
    """Use FlyDSL 0.5.0's actual compiled-kernel occupancy query.

    The release implements max_blocks_per_cu() with HIP module occupancy.
    Pair it with ROCm PyTorch's multi_processor_count from the SAME device;
    never infer capacity from a marketing CU count or default unknown values.
    """
    try:
        result = Residency(int(module.max_blocks_per_cu()),
                           int(properties.multi_processor_count),
                           int(properties.warp_size))
    except (AttributeError, TypeError, ValueError) as exc:
        raise RuntimeError("Cannot establish persistent grid residency") from exc
    if result.blocks_per_processor <= 0 or result.processor_count <= 0:
        raise RuntimeError("Cannot establish persistent grid residency")
    if result.wave_size != 32 or result.capacity < blocks:
        raise RuntimeError(f"Grid {blocks} cannot reside: {result}")
    return result
