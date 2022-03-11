
#include <memory>
#include <iostream>

// start of template
template <class Base>
class enable_shared_from_base
    : public std::enable_shared_from_this<Base>
{
protected:
    template <class Derived>
    std::shared_ptr<Derived> shared_from_base()
    {
        // `this->` is needed
        return std::static_pointer_cast<Derived>(this->shared_from_this());
    }
};
// end of template

struct Good : enable_shared_from_base<Good>
{
    std::shared_ptr<Good> getptr()
    {
        // both will compile just fine
        return shared_from_this();
        // return shared_from_base<Good>();
    }
};

struct GoodChild : public Good
{
    std::shared_ptr<GoodChild> getptr() {
        // shared_from_this() will return base class pointer
        // but usually, we would expect child class pointer 

        // return shared_from_this(); // won't compile
        return shared_from_base<GoodChild>();
    }
};

void testGood()
{
    std::shared_ptr<GoodChild> good0 = std::make_shared<GoodChild>();
    std::shared_ptr<GoodChild> good1 = good0->getptr();
    std::cout << "good0.use_count() = " << good0.use_count() << '\n';
    std::cout << "good1.use_count() = " << good1.use_count() << '\n';
}

int main()
{
    testGood();
}
