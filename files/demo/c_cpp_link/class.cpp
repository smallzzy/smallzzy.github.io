#include "class.h"
#include <iostream>

M::M(int i): j(i) {}

void M::call(int k) {
    std::cout << "j" << j << "k" << k << std::endl;
};


M* m_create(int i) {
    return new M(i);
};

void m_call(M* m, int k) {
    m->call(k);
};

void m_destory(M* m) {
    delete m;
};
