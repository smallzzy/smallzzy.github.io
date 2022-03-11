// You shouldn't inherit from enable_shared_from_this more than once in a given inheritance chain.
// main source: https://stackoverflow.com/questions/15549722/double-inheritance-of-enable-shared-from-this
// other: https://stackoverflow.com/questions/14939190/boost-shared-from-this-and-multiple-inheritance

#include <memory>
#include <iostream>

struct virtual_enable_shared_from_this_base : std::enable_shared_from_this<virtual_enable_shared_from_this_base>
{
    virtual ~virtual_enable_shared_from_this_base() {}
};

template <typename T>
struct virtual_enable_shared_from_this : virtual virtual_enable_shared_from_this_base
{
    std::shared_ptr<T> shared_from_this()
    {
        return std::dynamic_pointer_cast<T>(
            virtual_enable_shared_from_this_base::shared_from_this());
    }

    template <class Derived>
    std::shared_ptr<Derived> shared_from_base()
    {
        return std::static_pointer_cast<Derived>(this->shared_from_this());
    }
};

struct A : virtual_enable_shared_from_this<A>
{
    void foo()
    {
        shared_from_this()->baz();
    }

    void baz()
    {
        std::cout << __PRETTY_FUNCTION__ << std::endl;
    }
};

struct B : virtual_enable_shared_from_this<B>
{
    void bar()
    {
        shared_from_this()->baz();
    }

    void baz()
    {
        std::cout << __PRETTY_FUNCTION__ << std::endl;
    }
};

struct Z : A, B
{
};

int main()
{
    std::shared_ptr<Z> z = std::make_shared<Z>();
    std::shared_ptr<B> b = z->B::shared_from_this();
    std::cout << "good0.use_count() = " << z.use_count() << '\n';
    std::cout << "good1.use_count() = " << b.use_count() << '\n';

    z->foo();
    z->bar();
    // ambiguity exist for the following lines
    // z->baz();
    // std::shared_ptr<Z> zz = z->shared_from_base<Z>();
}
