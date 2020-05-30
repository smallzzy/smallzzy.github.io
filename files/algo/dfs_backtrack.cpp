#include <stack>

struct Action {
  bool checked = false;
  // todo: internal variable
};

class DFSBacktrack {
public:
  void solve() {
    // todo: initial frame
    frames.push({});

    while (!frames.empty()) {
      auto &f = frames.top();
      if (f.checked) {
        // frame result has been checked
        pop(f);
      } else {
        f.checked = true;
        // todo: apply change to global mem
      }

      if (!next(f))
        pop(f);
    }
  }

private:
  bool next(Action &s) {
    bool ret = false;
    // todo:
    // for all valid moves of s
    // frames.push();
    // ret = true;
    return ret;
  }

  bool pop(Action &s) {
    frames.pop();
    // todo: recover change from global mem
  }

private:
  std::stack<Action> frames;
  // todo: global memory
};
