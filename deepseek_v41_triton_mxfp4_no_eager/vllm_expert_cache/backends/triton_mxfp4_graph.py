"""Capture/replay ownership for shared expert-cache state.

Guards live outside graph replay because replay does not execute Python MoE
methods. All caches on a device share a submission lane. Events are inserted
only outside capture; graph nodes contain the ordinary manager/gather/GEMM work.
"""

from __future__ import annotations

from contextlib import contextmanager
from dataclasses import dataclass, field
from functools import wraps
from threading import Lock, local
from weakref import WeakKeyDictionary, WeakSet

import torch

GRAPH_API = 2
_LANES = {}
_RECORDS = WeakKeyDictionary()
_installed = False
_logger = None
_reported_replay = False


class TorchOps:
    @staticmethod
    def capturing():
        return torch.cuda.is_current_stream_capturing()

    @staticmethod
    def stream():
        return torch.cuda.current_stream()

    @staticmethod
    def join(previous, current):
        event = torch.cuda.Event()
        event.record(previous)
        current.wait_event(event)
        return event


@dataclass
class GraphLease:
    caches: dict = field(default_factory=dict)
    signatures: dict = field(default_factory=dict)
    token: int | None = None
    sealed: bool = False

    def add(self, cache):
        if self.sealed and cache not in self.caches:
            raise RuntimeError("Replay reached a cache absent from its capture")
        self.caches[cache] = cache

    def seal(self):
        self.signatures = {cache: cache.graph_signature() for cache in self.caches}
        self.sealed = True

    def validate(self):
        if not self.sealed:
            raise RuntimeError("Graph lease was not finalized after capture")
        for cache, signature in self.signatures.items():
            if cache.failed or cache.graph_signature() != signature:
                cache.failed = True
                raise RuntimeError(
                    "Expert-cache graph storage changed or was invalidated; restart worker"
                )


@dataclass
class Scope:
    mode: str
    lease: GraphLease | None
    parent: Scope | None
    stream: object
    touched: dict = field(default_factory=dict)

    def add(self, cache):
        scope = self
        while scope is not None:
            scope.touched[cache] = cache
            if scope.lease is not None:
                scope.lease.add(cache)
            scope = scope.parent


class ExecutionLane:
    """Serialize CPU submissions and GPU use of device-wide shared slot state."""

    def __init__(self, ops=None):
        self.ops = TorchOps() if ops is None else ops
        self.lock = Lock()
        self.local = local()
        self.last_stream = None
        self.bootstrap_streams = []
        self.event = None
        self.caches = WeakSet()

    @property
    def active(self):
        return getattr(self.local, "scope", None)

    def register(self, cache, stream):
        if self.ops.capturing():
            raise RuntimeError("Expert caches must be allocated before graph capture")
        self.caches.add(cache)
        self.bootstrap_streams.append(stream)

    def _fence(self, stream):
        if self.ops.capturing():
            raise RuntimeError(
                "Cross-invocation event fencing must occur outside capture"
            )
        for previous in [*self.bootstrap_streams, self.last_stream]:
            if previous is not None and previous != stream:
                self.event = self.ops.join(previous, stream)
        self.bootstrap_streams.clear()
        self.last_stream = stream

    def prepare_stream(self):
        """The manager changes capture streams before preparing each descriptor."""
        scope = self.active
        if scope is None or scope.mode != "batch":
            raise RuntimeError(
                "Capture stream preparation requires a manager batch scope"
            )
        stream = self.ops.stream()
        self._fence(stream)
        scope.stream = stream

    @contextmanager
    def execution(self, mode, lease=None):
        parent = self.active
        root = parent is None
        if root:
            if self.ops.capturing():
                raise RuntimeError(
                    "Unmanaged graph capture: use the installed vLLM graph hooks or capture_lease()"
                )
            if not self.lock.acquire(blocking=False):
                raise RuntimeError(
                    "Concurrent expert-cache graph/eager submission is unsupported"
                )
        scope = Scope(mode, lease, parent, self.ops.stream())
        try:
            if root:
                self._fence(scope.stream)
            elif scope.stream != parent.stream:
                raise RuntimeError(
                    "Nested MoE graph work must use the managed root stream"
                )
            if mode == "replay":
                lease.validate()
                for cache in lease.caches:
                    scope.add(cache)
            self.local.scope = scope
            yield scope
            if mode == "capture":
                lease.seal()
        except BaseException:
            for cache in scope.touched:
                cache.failed = True
            raise
        finally:
            self.local.scope = parent
            if root:
                self.last_stream = scope.stream
                self.lock.release()

    @contextmanager
    def cache_call(self, cache):
        if cache.failed:
            raise RuntimeError("Expert cache failed or was invalidated; restart worker")
        if self.active is None:
            with self.execution("eager") as scope:
                scope.add(cache)
                try:
                    yield
                finally:
                    cache.started = True
            return
        scope = self.active
        if self.ops.stream() != scope.stream:
            raise RuntimeError(
                "MoE cache work on an unjoined auxiliary stream is unsupported"
            )
        scope.add(cache)
        try:
            yield
        except BaseException:
            cache.failed = True
            raise
        finally:
            cache.started = True


def lane_for(device):
    device = torch.device(device)
    index = device.index if device.index is not None else torch.cuda.current_device()
    if index not in _LANES:
        _LANES[index] = ExecutionLane()
    return _LANES[index]


def _current_lane():
    return lane_for(torch.device("cuda", torch.cuda.current_device()))


def register(cache):
    cache.execution_lane = lane_for(cache.device)
    cache.execution_lane.register(cache, torch.cuda.current_stream(cache.device))


@contextmanager
def capture_lease(device):
    """Enter BEFORE torch.cuda.graph(), on the same stream used for capture."""
    lease = GraphLease()
    with torch.cuda.device(device), lane_for(device).execution("capture", lease):
        yield lease


def replay_with_lease(graph, lease, device):
    """For isolated tests/custom callers; normal serving uses patched vLLM entry points."""
    with torch.cuda.device(device), lane_for(device).execution("replay", lease):
        graph.replay()


def _records(owner):
    return _RECORDS.setdefault(owner, {})


def _note_replay(lease):
    global _reported_replay
    if lease.caches and not _reported_replay:
        if _logger is not None:
            _logger.info("expert-cache: guarded Triton MXFP4 graph replay active")
        _reported_replay = True


def _replay_record(owner, key, graph):
    lease = _records(owner).get(key)
    if lease is None or lease.token != id(graph):
        raise RuntimeError(
            "No matching expert-cache capture lease for this graph; recapture with hooks installed"
        )
    return lease


def patch_standard_wrapper(cls, context_available, get_context, none_mode):
    original = cls.__call__

    @wraps(original)
    def call(self, *args, **kwargs):
        lane = _current_lane()
        if not lane.caches or not context_available():
            return original(self, *args, **kwargs)
        context = get_context()
        mode = context.cudagraph_runtime_mode
        if mode == none_mode or mode != self.runtime_mode:
            return original(self, *args, **kwargs)
        key = context.batch_descriptor
        entry = self.concrete_cudagraph_entries.get(key)
        graph = None if entry is None else entry.cudagraph
        if graph is None:
            lease = GraphLease()
            with lane.execution("capture", lease):
                result = original(self, *args, **kwargs)
            lease.token = id(self.concrete_cudagraph_entries[key].cudagraph)
            _records(self)[key] = lease
            return result
        lease = _replay_record(self, key, graph)
        with lane.execution("replay", lease):
            result = original(self, *args, **kwargs)
        _note_replay(lease)
        return result

    cls.__call__ = call
    patch_clear(cls, "clear_graphs")


def patch_breakable_wrapper(cls):
    original_capture, original_replay = cls._capture, cls._replay

    @wraps(original_capture)
    def capture(self, entry, args, kwargs):
        lane = _current_lane()
        if not lane.caches:
            return original_capture(self, entry, args, kwargs)
        lease = GraphLease()
        with lane.execution("capture", lease):
            result = original_capture(self, entry, args, kwargs)
        lease.token = id(entry.capture)
        _records(self)[id(entry)] = lease
        return result

    @wraps(original_replay)
    def replay(self, entry, args, kwargs):
        lane = _current_lane()
        if not lane.caches:
            return original_replay(self, entry, args, kwargs)
        lease = _replay_record(self, id(entry), entry.capture)
        with lane.execution("replay", lease):
            result = original_replay(self, entry, args, kwargs)
        _note_replay(lease)
        return result

    cls._capture, cls._replay = capture, replay
    patch_clear(cls, "clear_graphs")


def patch_manager(cls):
    original_capture, original_run = cls.capture, cls.run_fullgraph

    @wraps(original_capture)
    def capture(self, create_forward_fn, *args, **kwargs):
        lane = _current_lane()
        if not lane.caches:
            return original_capture(self, create_forward_fn, *args, **kwargs)
        pending = {}

        def factory(desc, warmup):
            lane.prepare_stream()
            if getattr(desc, "num_ubatches", 1) != 1:
                raise RuntimeError(
                    "Expert-cache graphs do not support microbatch overlap"
                )
            forward = create_forward_fn(desc, warmup=warmup)

            def run(mode):
                if lane.ops.capturing():
                    lease = pending.setdefault(desc, GraphLease())
                    with lane.execution("capture", lease):
                        return forward(mode)
                return forward(mode)

            return run

        with lane.execution("batch"):
            result = original_capture(self, factory, *args, **kwargs)
        for desc, lease in pending.items():
            if desc in self.graphs:
                lease.token = id(self.graphs[desc])
                _records(self)[desc] = lease
        return result

    @wraps(original_run)
    def run(self, desc):
        lane = _current_lane()
        if not lane.caches:
            return original_run(self, desc)
        lease = _replay_record(self, desc, self.graphs[desc])
        with lane.execution("replay", lease):
            result = original_run(self, desc)
        _note_replay(lease)
        return result

    cls.capture, cls.run_fullgraph = capture, run
    patch_clear(cls, "release_graphs")


def patch_clear(cls, name):
    original = getattr(cls, name)

    @wraps(original)
    def clear(self, *args, **kwargs):
        result = original(self, *args, **kwargs)
        _RECORDS.pop(self, None)
        return result

    setattr(cls, name, clear)


def install_vllm_hooks(logger):
    global _installed, _logger
    if _installed:
        return
    from vllm.compilation.breakable_cudagraph import BreakableCUDAGraphWrapper
    from vllm.compilation.cuda_graph import CUDAGraphWrapper
    from vllm.config import CUDAGraphMode
    from vllm.forward_context import get_forward_context, is_forward_context_available
    from vllm.v1.worker.gpu.cudagraph_utils import CudaGraphManager

    # Resolve all source-pinned entry points before mutating any of them.
    for cls, names in (
        (CUDAGraphWrapper, ("__call__", "clear_graphs")),
        (BreakableCUDAGraphWrapper, ("_capture", "_replay", "clear_graphs")),
        (CudaGraphManager, ("capture", "run_fullgraph", "release_graphs")),
    ):
        if not all(callable(getattr(cls, name, None)) for name in names):
            raise RuntimeError(
                "Unreviewed vLLM graph API; install the pinned source revision"
            )
    patch_standard_wrapper(
        CUDAGraphWrapper,
        is_forward_context_available,
        get_forward_context,
        CUDAGraphMode.NONE,
    )
    patch_breakable_wrapper(BreakableCUDAGraphWrapper)
    patch_manager(CudaGraphManager)
    _logger = logger
    _installed = True
    logger.info(
        "expert-cache: installed capture/replay guards for FULL, PIECEWISE and breakable graphs"
    )
