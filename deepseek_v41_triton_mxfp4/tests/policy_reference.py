"""Independent CPU oracle for the device cache's LRU/LFU contract."""


class Policy:
    def __init__(self, experts, slots, policy=0, decay=64):
        self.E, self.S = experts, slots
        self.policy, self.decay = policy, decay
        self.experts = [-1] * slots
        self.scores = [0] * slots
        self.clock = 0

    def step(self, ids):
        self.clock += 1
        wanted = {e for e in ids if 0 <= e < self.E}
        if len(wanted) > self.S:
            raise ValueError("working set exceeds capacity")
        if self.policy == 1 and self.decay and self.clock % self.decay == 0:
            self.scores = [x // 2 for x in self.scores]
        for s, e in enumerate(self.experts):
            if e in wanted:
                self.scores[s] = self.clock if self.policy == 0 else self.scores[s] + 1
        misses = [-1] * self.S
        result = []
        for e in ids:
            if not 0 <= e < self.E:
                result.append(-1)
                continue
            if e not in self.experts:
                eligible = [
                    s for s, old in enumerate(self.experts) if old not in wanted
                ]
                s = min(
                    eligible,
                    key=lambda s: (-1 if self.experts[s] < 0 else self.scores[s], s),
                )
                self.experts[s] = e
                self.scores[s] = self.clock if self.policy == 0 else 1
                misses[s] = e
            s = self.experts.index(e)
            result.append(s)
        table = [-1] * self.E
        for s, e in enumerate(self.experts):
            if e >= 0:
                table[e] = s
        return result, misses, table
