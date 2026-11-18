"""Host configuration and exhaustive finite double-buffer protocol models.

Models assume coherent atomic words and one kernel at a time per workspace.
They do not validate GPU memory ordering. Negative variants must exhibit an
overwrite or stale-tag error, so the model is not merely a happy-path trace.
"""
from dataclasses import replace
import ctypes
import struct
from types import SimpleNamespace
import unittest
from unittest.mock import Mock

from specialized_decode.mono.peer_layout import (
    DB_SEQUENCE, DB_DATA, DB_MAX_BLOCKS, DB_CYCLE, DB_INITIAL_SEQUENCE,
    arena_bytes, double_location, protocol_id,
)
from specialized_decode.runtime.parallel import setup_signature, _check_agreement
from specialized_decode.runtime.peer import PeerArena, validate_topology
from specialized_decode.runtime.spec import DecodeConfig


def explore(tp, active, *, banks=2, scrub=True, scrub_both=False):
    # Tiny two-tag cycle forces real reuse and rollover within eight calls.
    rounds = len(active)
    def location(step):
        seq = (2 + step) % 4
        return step % banks, seq // 2 + 1, seq < 2

    def entry(step):
        if step == rounds:
            return (step, 2, 0, 0)
        return (step, 0 if location(step)[2] and scrub else 2,
                0, 0 if active[step] == 2 else 2)

    def visible(rank_state, bank, word):
        step, phase, p0, p1 = rank_state
        last_write, last_clear = -1, -1
        for previous in range(min(step + 1, rounds)):
            b, tag, wrap = location(previous)
            entered = previous < step or phase >= 1
            if scrub and wrap and entered and (b == bank or scrub_both):
                last_clear = previous
            if b != bank:
                continue
            published = previous < step or (phase == 2 and (p0, p1)[word] >= 1)
            if word < active[previous] and published:
                last_write = previous
        if last_write < 0 or last_write < last_clear:
            return 0, None
        return location(last_write)[1], last_write

    initial = tuple(entry(0) for _ in range(tp))
    stack, seen, completed, reuses = [initial], set(), 0, 0
    while stack:
        state = stack.pop()
        if state in seen:
            continue
        seen.add(state)
        if all(s[0] == rounds for s in state):
            completed += 1
            continue
        choices = []
        for rank, (step, phase, p0, p1) in enumerate(state):
            if step == rounds:
                continue
            bank, expected, _ = location(step)
            if phase == 0:
                if step >= banks:
                    assert all(s[0] > step - banks for s in state), ("overwrite during scrub", state)
                if scrub_both and step >= 1:
                    assert all(s[0] >= step for s in state), ("overwrite other bank", state)
                choices.append((rank, (step, 1, p0, p1)))
            elif phase == 1:
                if all(s[0] > step or (s[0] == step and s[1] >= 1) for s in state):
                    choices.append((rank, (step, 2, p0, p1)))
            else:
                for word, status in enumerate((p0, p1)):
                    if word >= active[step] or status == 2:
                        continue
                    if status == 0:
                        if step >= banks:
                            assert all(s[0] > step - banks for s in state), ("overwrite", state)
                            reuses += 1
                    else:
                        payloads = [visible(s, bank, word) for s in state]
                        if not all(tag == expected for tag, _ in payloads):
                            continue
                        assert all(source == step for _, source in payloads), ("stale tag", state)
                    nxt = list(state[rank]); nxt[word + 2] += 1
                    choices.append((rank, tuple(nxt)))
                if p0 == p1 == 2:
                    # Whole local kernel completion, not an independently
                    # advancing CTA or a host enqueue, permits the next call.
                    choices.append((rank, entry(step + 1)))
        assert choices, ("deadlock", state)
        for rank, nxt in choices:
            new = list(state); new[rank] = nxt; stack.append(tuple(new))
    assert completed == 1
    return len(seen), reuses


class DoubleBufferTests(unittest.TestCase):
    def test_host_initialization_sets_every_cta_counter_without_touching_banks(self):
        transfers = []
        memcpy = Mock(side_effect=lambda dst, src, size, kind:
                      transfers.append((dst, ctypes.string_at(src, size), kind)) or 0)
        runtime = SimpleNamespace(library=lambda: SimpleNamespace(hipMemcpy=memcpy),
                                  check=lambda status, **kw: self.assertEqual(status, 0))
        arena = object.__new__(PeerArena)
        arena.runtime, arena.own = runtime, 0x100000
        arena._write_sequences(DB_INITIAL_SEQUENCE)
        self.assertEqual(transfers, [(0x100000 + DB_SEQUENCE,
                                     struct.pack("<64Q", *([2] * 64)), 1)])

    def test_layout_counters_and_banks_are_disjoint(self):
        self.assertEqual(DB_SEQUENCE + DB_MAX_BLOCKS * 8, DB_DATA)
        self.assertEqual(DB_DATA % 8, 0)
        self.assertEqual(arena_bytes(5120, protocol="ll_double"), 656384)
        self.assertEqual(protocol_id("ll_double"), 3)
        self.assertEqual(double_location(DB_INITIAL_SEQUENCE), (0, 2))
        self.assertEqual([double_location(s) for s in (DB_CYCLE-2, DB_CYCLE-1, 0, 1, 2)],
                         [(0, 0xFFFFFFFF), (1, 0xFFFFFFFF), (0, 1), (1, 1), (0, 2)])
        for invalid in (-1, DB_CYCLE):
            with self.assertRaises(ValueError):
                double_location(invalid)

    def test_protocol_and_rank_agreement(self):
        size = arena_bytes(32, protocol="ll_double")
        records = [dict(rank=r, error=None, protocol=3, size=size, host=("node", "boot"),
                        bus=str(r), handle=bytes(64)) for r in range(2)]
        validate_topology(records, 2, size, protocol="ll_double")
        records[1]["protocol"] = 2
        with self.assertRaisesRegex(RuntimeError, "layout"):
            validate_topology(records, 2, size, protocol="ll_double")
        c = DecodeConfig(tp_size=2, ipc_protocol="ll_double")
        records = [dict(rank=r, error=None, signature=setup_signature(cfg)) for r, cfg in
                   enumerate((c, replace(c, ipc_protocol="ll")))]
        with self.assertRaisesRegex(RuntimeError, "disagree"):
            _check_agreement(records, 2)

    def test_only_local_compute_barriers_remain(self):
        for tp in (1, 2, 4):
            for attention in ("reduced", "partial"):
                for ffn in ("collective", "ipc"):
                    c = DecodeConfig(tp_size=tp, ipc_protocol="ll_double",
                                     attention_input=attention, ffn_reduction=ffn)
                    self.assertEqual(c.grid_barriers_per_launch,
                                     2 + int(tp > 1 and attention == "partial"))

    def test_all_interleavings_variable_rows_reuse_and_two_rollovers(self):
        for tp in (2, 4):
            states, reuses = explore(tp, (2, 2, 2, 2, 1, 1, 2, 2))
            self.assertGreater(states, 100)
            self.assertGreater(reuses, 0)

    def test_one_bank_without_done_is_unsafe(self):
        with self.assertRaisesRegex(AssertionError, "overwrite"):
            explore(2, (2, 2, 2), banks=1)

    def test_omitting_full_bank_rollover_scrub_is_unsafe(self):
        with self.assertRaisesRegex(AssertionError, "stale tag"):
            explore(2, (2, 2, 2, 2, 1, 1, 2, 2), scrub=False)

    def test_scrubbing_both_banks_together_is_unsafe(self):
        with self.assertRaisesRegex(AssertionError, "other bank"):
            explore(2, (2, 2, 2, 2), scrub_both=True)


if __name__ == "__main__":
    unittest.main()
