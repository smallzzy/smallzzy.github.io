---
layout: post
title:
date: 2022-05-01 19:40
category:
author:
tags: []
summary:
---

## std::function

1. `std::function` can be construct using the following methods
   1. functor
   2. std::bind + std::ref / std::cref
   3. [lambda](https://en.cppreference.com/w/cpp/language/lambda)
      1. capture by value `=`
         1. `mutable` will allow the captured variable to be modified
      2. capture by reference `&`
         1. referenced object need to out live lambda
      3. capture `this`
         1. member variable will be assessible after capturing `this`
2. `std::function::target<T>()`: retrive function pointer if T matches
   1. note that we cannot retrive a stored class method (including lambda)
3. `std::mem_fn` can be used to wrap one single

```cpp
// bind vs lambda (c++14)

// move argument
auto f1 = std::bind(f, 42, _1, std::move(v));
auto f1 = [v = std::move(v)](auto arg) { f(42, arg, std::move(v)); };

// expression
auto f1 = std::bind(f, 42, _1, a + b);
auto f1 = [sum = a + b](auto arg) { f(42, arg, sum); };

// overloading
// bind will need template functor to accept different argument
// bind cannot distiguish function overload?
auto f = []( auto a, auto b ){ cout << a << ' ' << b; }

// perfect forwarding
// not possible with bind?
auto f1 = [=](auto&& arg) { f(42, std::forward<decltype(arg)>(arg)); };

// Using lambda to compare elements.
auto cmp = [](int left, int right) { return (left ^ 1) < (right ^ 1); };
std::priority_queue<int, std::vector<int>, decltype(cmp)> q3(cmp);
```

### function pointer

Notice that pointer to normal and static class function is the same.
But pointer to member function is different.

```c++
int (*)(char,float)
int (Fred::*)(char,float)
```

A functionoid (general form of functor) might be more useful
because object can be created with different parameters.