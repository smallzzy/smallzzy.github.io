---
layout: post
title: 
date: 2020-01-06 16:45
category: 
author: 
tags: [cpp]
summary: 
---

## perfect forwarding

* We want to forward function argument to another function (ex emplace_back) without:
  * changing type
  * writing multiple function to deal with const, lvalue, rvalue

## basics

* You cannot separate the reference from the referent.
* You cannot bind a rvalue to non-const reference
* `int&&` is `rvalue reference`, which is a reference by itself.
* In a type deducing context (`T&& t`), `T&&` does not necessarily mean rvalue reference.
  * if `t` is a lvalue of type `U`, `T` deduce to `U&`. `T&&` is `U&`
  * if `t` is a rvalue of type `U`, `T` deduce to `U`. `T&&` is `U&&`
  * This usage is given the name `universal reference`

## reference collapsing

```
& & -> &
& && -> &
&& & -> &
&& && -> &&
```

Since C++11, there are also ref-qualified member functions.
The implicit object parameter will have a corresponding type reference.

## std::forward

* gurantees that type does not change at forwarding
* if we depends on reference collapsing only, the type could change implicitly.
* use `std::remove_reference<T>` to break out of the universal reference pattern.
  * which cause std::forward to require template

```c++
#include <iostream>
#include <utility>

void func(int const&)
{
    std::cout << "lvalue" << std::endl;
}

void func(int&&)
{
    std::cout << "rvalue" << std::endl;
}

template<typename T>
void wrap(T&&a) {
    func(std::forward<T>(a));
    func(a);
}

int main() {
    int a =0;
    wrap(a); // print lvalue, lvalue
    wrap(0); // print rvalue, lvalue
}
```

### pass by value or reference

For constructor,

1. If we pass by reference, we cannot be sure if the reference is stored in the class.
2. If we pass by value, we do not need to care about it storage.
   1. We can also save the performance by doing two moves. One move on the caller, one move on the callee.
   2. Otherwise, it will still work with two copies, or one copy + one move.
   3. We also avoid multiple overload of the function.
3. Thus, pass by value is preferred

For functions, we might have a problem with unnecessary dealloc. 

1. Ex, string has a internal capacity that get re-used on copy
2. If we pass by value and move it, the string will always dealloc.
   1. No dealloc on constructor because there is no variable to dealloc.
3. If we pass by const reference, we have the choice of move or copy
4. However, most classes do not have this re-use pattern. Thus, both patterns can be helpful.

## reference

[Rvalue references in Chromium](https://www.chromium.org/rvalue-references)
[Reference collapsing](https://stackoverflow.com/questions/13725747/concise-explanation-of-reference-collapsing-rules-requested-1-a-a-2)
[forwarding](https://eli.thegreenplace.net/2014/perfect-forwarding-and-universal-references-in-c)
