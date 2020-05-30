#include "class.h"

int main() {
    M* test = m_create(1);
    m_call(test, 10);
    m_destory(test);
}
