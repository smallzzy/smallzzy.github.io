#include <memory>
#include <queue>

struct Memory {
  // todo: deep copy
  Memory(const Memory &) {}

  Memory &operator=(const Memory &m) { return *this; }
};

struct Action {
  std::shared_ptr<Memory> mem;
  // todo: internal variable
};

class BFSBacktrack {
public:
  void solve() {
    // todo: initial frame & memory
    frames.push({});

    while (!frames.empty()) {
      auto &f = frames.front();
      // todo: apply change to mem
      auto mem = std::make_shared<Memory>(*(f.mem));
      next(f, mem);
      frames.pop();
    }
  }

private:
  void next(Action &s, std::shared_ptr<Memory> &mem) {
    // todo:
    // for all valid moves of s
    // f.mem = mem;
    // frames.push(f);
  }

private:
  std::queue<Action> frames;
};