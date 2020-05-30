#include <cstdio>

namespace you {
namespace will {
template<typename T>
class fail {
    public:
    void test() {
        printf("%d\n", 1);
    };
};
}
}

// does not work before gcc 7
// unless with -fpermissive, which
// > Downgrade some diagnostics about nonconformant code from errors to warnings
using you::will::fail;

template<>
void fail<double>::test() {
    printf("%d\n", 10);
}

int main() {
    fail<int> a;
    a.test();

    fail<double> b;
    b.test();
}
