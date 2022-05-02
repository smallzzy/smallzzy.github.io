---
layout: post
title:
date: 2019-11-27 15:34
category:
author:
tags: [cpp]
summary:
---

This post is a reading note based on [Andrzej's blog](https://akrzemi1.wordpress.com/2013/11/18/type-erasure-part-i/).

## the problem

Let us say we are try to use `std::equal_range`, which has a template like the following.

```c++
template< class ForwardIt, class T, class Compare >
constexpr std::pair<ForwardIt,ForwardIt>
              equal_range( ForwardIt first, ForwardIt last,
                           const T& value, Compare comp );
```

Note that each different type will cause a different code to be generated.

## what does type means?

With type we will have the following things:

1. function overload at compile time (+)
   1. otherwise, we can only pass to one generic function and detect at runtime
2. type-safe check (+)
3. worse code size and compile time (-)
4. difficulty in decleration & implementation separation due to template (-)
   1. different type can have vastly different requirement

With type erasure, we wish to trade code size with some run time performance.

(PS. type inference with reflection)

## solution 1: erasure with `void *`

C style. Not type safe.

## solution 2: erasure with interface inheritance

We can let all data type inherit a common interface.
Then, the interface can be used in other function call.

In the case of std::equal_range, functor class can always be this interface class.

1. Not a useful interface.
2. Not all type can inherit. POD / vendor type
3. Involves vtable.
4. Type safe becomes runtime exception

## solution 3: erasure with value semantic

Use container that stores type as a value.

For example, what type is used in std::equal_range?

1. iterator type
2. member type
3. compare functor

So, we can use std::function in place of functor.

```c++
template <typename T>
using AnyBinaryPredicate =
  std::function<bool(T const&, T const&)>;
```

boost::any_range in place of iterator

```c++
template <typename T>
using AnyForwardRange = boost::any_range<
  T,                            // real param
  boost::forward_traversal_tag, // fixed
  T&,                           // repeated param
  std::ptrdiff_t                // fixed
>;

// examples
std::vector<int> vec {9, 8, 5, 4, 2, 1, 1, 0};
std::set<int> set {1, 2, 3, 5, 7, 9};

AnyForwardRange<int> rng = vec; // initialize interface
std::distance (boost::begin(rng), boost::end(rng));

rng = set;                      // rebind interface
std::distance (boost::begin(rng), boost::end(rng));
```

As the result, we only need one template deduction wrt data type.
The other type can be hidden in the value semantic.

```c++
template <typename T>
AnyForwardRange<T> Search (AnyForwardRange<T> rng, T const& v,
                           AnyBinaryPredicate<T> pred)
{
  auto ans = std::equal_range (rng.begin(), rng.end(), v, pred);
  return {ans.first, ans.second};
}
```

### std::any, std::variant

They will hold any type as a value.
Thus, any functionality is also erasured.
As a result, we have to cast to original type before use.

## std::function

Moved to separate post.

## std::pmr memory allocator

- normal allocator is fixed in type and cannot be converted to each other
- std::pmr allow different allocator to have same type
- std::pmr::vector != std::vector
