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

## what does type means?

With type we will have the following things:

1. function overload at compile time (+)
2. type-safe check (+)
3. worse code size and compile time (-)
4. difficulty in decleration & implementation separation due to template (-)

With type erasure, we wish to trade code size with some run time performance.

(PS. type inference with reflection)

## solution 1: erasure with void *

C style. Not type safe.

## solution 2: erasure with interface inheritance

We can let all data type inherit a common interface.
Then, the interface can be used in other function call.

In the case of std::equal_range, functor class can always be this interface class.

1. Not a useful interface.
2. Not all type can inherit. POD / Vendor
3. Involves vtable.
4. Type safe becomes runtime exception

## solution 3: erasure with value semantic

Use container that stores type as a value.

For example, what type is used in std::equal_range?

1. iterator type
2. member type
3. compare functor

So, we can use std::function in place of functor,
boost::any_iterator in place of iterator.

As the result, we only need one template deduction wrt data type.
The other type can be hidden in the value semantic

### std::any, std::variant

We will have a container that holds type as a value.

However, we also lose all functionality.
As a result, we have to cast to original type before use.

## std::pmr memory allocator

## function pointer

Notice that pointer to normal and static class function is the same.
But pointer to member function is different. 
-> possibly a completely different data structure due to inheritance.

```c++
int (*)(char,float)
int (Fred::*)(char,float)
```

A functionoid (general form of functor) might be more useful
because object can be created with different parameters.
