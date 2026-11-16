"""Exercise graph-boundary ownership without pretending to execute a GPU graph."""

from dataclasses import dataclass
from threading import Thread
from types import SimpleNamespace as NS

import pytest
from vllm_expert_cache.backends import triton_mxfp4_graph as hooks


class Ops:
    def __init__(self):
        self.current = "default"
        self.capture_active = False
        self.joins = []

    def capturing(self):
        return self.capture_active

    def stream(self):
        return self.current

    def join(self, previous, current):
        assert not self.capture_active, "cross-invocation fence was captured"
        self.joins.append((previous, current))
        return object()


class Cache:
    def __init__(self):
        self.failed = self.started = False
        self.storage_version = 0
        self.policy_step = 0

    def graph_signature(self):
        return (self.storage_version,)


class Graph:
    def __init__(self):
        self.replays = 0
        self.fail = False

    def replay(self):
        if self.fail:
            raise RuntimeError("injected graph launch error")
        self.replays += 1


@pytest.fixture
def runtime(monkeypatch):
    ops = Ops()
    lane = hooks.ExecutionLane(ops)
    cache = Cache()
    lane.register(cache, ops.stream())
    monkeypatch.setattr(hooks, "_current_lane", lambda: lane)
    return ops, lane, cache


def test_captured_scope_has_no_external_fences_and_replay_checks_storage(runtime):
    ops, lane, cache = runtime
    with lane.cache_call(cache):
        cache.policy_step += 1
    lease = hooks.GraphLease()
    ops.current = "capture"
    with lane.execution("capture", lease):
        ops.capture_active = True
        with lane.cache_call(cache):
            pass
        ops.capture_active = False
    assert ops.joins == [("default", "capture")]
    # Evolving device metadata is intentionally not part of the storage signature.
    cache.policy_step += 1
    ops.current = "default"
    with lane.execution("replay", lease):
        pass
    assert ops.joins[-1] == ("capture", "default")
    cache.storage_version += 1
    with pytest.raises(RuntimeError, match="storage changed"):  # noqa: SIM117 - show ownership entry before nested capture/replay
        with lane.execution("replay", lease):
            pytest.fail("stale graph must never launch")
    assert cache.failed


def test_replay_exception_invalidates_caches_even_without_python_moe_call(runtime):
    _, lane, cache = runtime
    lease = hooks.GraphLease()
    lease.add(cache)
    lease.seal()
    with pytest.raises(RuntimeError, match="launch"):  # noqa: SIM117 - show ownership entry before nested capture/replay
        with lane.execution("replay", lease):
            raise RuntimeError("launch failed")
    assert cache.failed


def test_unmanaged_capture_is_refused(runtime):
    ops, lane, cache = runtime
    ops.capture_active = True
    with pytest.raises(RuntimeError, match="Unmanaged"), lane.cache_call(cache):
        pass


def test_concurrent_submissions_are_refused(runtime):
    _, lane, cache = runtime
    errors = []

    def other_thread():
        try:
            with lane.cache_call(cache):
                pass
        except RuntimeError as error:
            errors.append(str(error))

    with lane.execution("eager"):
        worker = Thread(target=other_thread)
        worker.start()
        worker.join(timeout=3)
        assert not worker.is_alive()
    assert len(errors) == 1 and "Concurrent" in errors[0]


def test_standard_wrapper_guards_real_replay_boundary_and_clear(runtime):
    ops, lane, cache = runtime
    context = NS(cudagraph_runtime_mode="FULL", batch_descriptor=1)

    class Wrapper:
        runtime_mode = "FULL"

        def __init__(self):
            self.concrete_cudagraph_entries = {}
            self.python_calls = 0

        def __call__(self):
            entry = self.concrete_cudagraph_entries.setdefault(
                context.batch_descriptor, NS(cudagraph=None)
            )
            if entry.cudagraph is None:
                ops.capture_active = True
                with lane.cache_call(cache):
                    self.python_calls += 1
                ops.capture_active = False
                entry.cudagraph = Graph()
            else:
                entry.cudagraph.replay()
            return 42

        def clear_graphs(self):
            self.concrete_cudagraph_entries.clear()

    hooks.patch_standard_wrapper(Wrapper, lambda: True, lambda: context, "NONE")
    wrapper = Wrapper()
    assert wrapper() == wrapper() == 42
    assert wrapper.python_calls == 1
    graph = wrapper.concrete_cudagraph_entries[1].cudagraph
    assert graph.replays == 1
    cache.storage_version += 1
    with pytest.raises(RuntimeError, match="storage changed"):
        wrapper()
    assert graph.replays == 1
    wrapper.clear_graphs()
    assert wrapper not in hooks._RECORDS


def test_breakable_capture_replay_and_eager_break_share_the_same_lease(runtime):
    ops, lane, cache = runtime

    class Wrapper:
        def _capture(self, entry, args, kwargs):
            ops.capture_active = True
            with lane.cache_call(cache):
                pass
            ops.capture_active = False
            entry.capture = Graph()
            return "captured"

        def _replay(self, entry, args, kwargs):
            entry.capture.replay()
            # A Python eager segment may execute between captured segments.
            with lane.cache_call(cache):
                pass
            return "replayed"

        def clear_graphs(self):
            pass

    hooks.patch_breakable_wrapper(Wrapper)
    wrapper, entry = Wrapper(), NS(capture=None)
    assert wrapper._capture(entry, (), {}) == "captured"
    assert wrapper._replay(entry, (), {}) == "replayed"
    assert entry.capture.replays == 1
    assert hooks._RECORDS[wrapper][id(entry)].sealed


@dataclass(frozen=True)
class Desc:
    tokens: int
    num_ubatches: int = 1


def test_gpu_manager_direct_full_graphs_are_captured_and_guarded(runtime):
    ops, lane, cache = runtime

    class Manager:
        def __init__(self):
            self.graphs = {}

        def capture(self, factory):
            previous = ops.current
            ops.current = "manager-capture"
            for desc in (Desc(1), Desc(4)):
                factory(desc, warmup=True)("NONE")
                forward = factory(desc, warmup=False)
                ops.capture_active = True
                forward("NONE")
                ops.capture_active = False
                self.graphs[desc] = Graph()
            ops.current = previous

        def run_fullgraph(self, desc):
            self.graphs[desc].replay()

        def release_graphs(self):
            self.graphs.clear()

    hooks.patch_manager(Manager)
    counts = {True: 0, False: 0}

    def factory(desc, warmup):
        assert not ops.capture_active

        def forward(mode):
            with lane.cache_call(cache):
                counts[warmup] += 1

        return forward

    manager = Manager()
    manager.capture(factory)
    assert counts == {True: 2, False: 2}
    assert lane.last_stream == "manager-capture"
    manager.run_fullgraph(Desc(1))
    manager.run_fullgraph(Desc(4))
    assert counts == {True: 2, False: 2}  # replay never re-enters Python MoE
    assert ("manager-capture", "default") in ops.joins
    assert len(hooks._RECORDS[manager]) == 2
    manager.release_graphs()
    assert manager not in hooks._RECORDS


def test_nested_replay_registers_resources_in_parent_capture(runtime):
    _, lane, cache = runtime
    child, parent = hooks.GraphLease(), hooks.GraphLease()
    child.add(cache)
    child.seal()
    with lane.execution("capture", parent), lane.execution("replay", child):
        pass
    assert parent.sealed and cache in parent.caches
