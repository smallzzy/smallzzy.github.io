---
layout: post
title: 
date: 2019-12-10 00:14
category: 
author: 
tags: [cpp]
summary: 
---

![]({{site.img_url}}/cpp_init_forest.gif)

## storage duration

1. automatic: RAII
2. dynamic: memory controlled by programmer.
3. static: allocated at program start and dealloc at program end
   1. All objects declared at namespace scope (including global namespace) have this storage duration.
4. thread: allocated at thread start and dealloc at thread end
   1. `thread_local`

### static keyword

> When used in a declaration of a class member, it declares a static member. 
> When used in a declaration of an object, it specifies static storage duration (except if accompanied by thread_local). 
> When used in a declaration at namespace scope, it specifies internal linkage.

## step 1: Static Initialization

> 1) If relevant, constant initialization is applied.
> 2) Otherwise, non-local static and thread-local variables are zero-initialized.

* Done at compile time. Might involve .data, .rodata, .bss
* static non-local are initialized before main
* static local or thread local are initialized at first pass through of their decleration

### zero initiailization

> 1) If T is a scalar type, the object's initial value is the integral constant zero **explicitly converted** to T.
> 2) If T is an non-union class type, all base classes and non-static data members are zero-initialized, 
> and all padding is initialized to zero bits. The constructors, if any, are ignored.
> 3) If T is a union type, the first non-static named data member is zero-initialized and all padding is initialized to zero bits.
> 4) If T is array type, each element is zero-initialized.
> 5) If T is reference type, nothing is done.

* if we only perform 2), the object will be indeterminate values

## step 2: Dynamic initialization

1. value initialization
2. direct initialization
3. copy initialization
4. list initialization
5. aggregate initialization
6. reference initialization

### value initialization

* Usually appear in the form of `T()`

> 1) if T is a class type with no default constructor or with a user-provided or deleted default constructor,
> the object is default-initialized;
> 2) if T is a class type with a default constructor that is neither user-provided nor deleted
> (that is, it may be a class with an implicitly-defined or defaulted default constructor),
> the object is zero-initialized and then it is default-initialized if it has a non-trivial default constructor;
> 3) if T is an array type, each element of the array is value-initialized;
> 4) otherwise, the object is zero-initialized.

Note:

* if default constructor is deleted, it will fail compilation
* defaulted default: `= default`

### default initialization

* expanded to value initialization from `C++03`
* Usually appear in the form of `T`

> 1) when a variable with **automatic, static, or thread-local storage duration** is declared with no initializer;
> 2) when an object with dynamic storage duration is created by a new-expression with no initializer;
> 3) when a **base class or a non-static data member is not mentioned in a constructor initializer list** and that constructor is called.

The effects of default initialization are:

> 1) if T is a class type, the constructors are considered and subjected to **overload resolution against the empty argument list**.
> The constructor selected (which is one of the default constructors) is called to provide the initial value for the new object;
> 2) if T is an array type, every element of the array is default-initialized;
> 3) otherwise, nothing is done: the objects with automatic storage duration (and their subobjects) are initialized to **indeterminate values**.

## list initialization

* all constructors that take initializer_list matched by overload resolution
  * against a single argument of type initializer_list
* if no match, all constructors matched by overload resolution 
  * against the set of arguments that consists of the elements of the braced-init-list

### std::initializer_list

* initializer_list is automatically constructed when
  * list-initialize
  * function argument contains initializer_list
  * ranged for loop
* this is different from `constructor initializer list`:
  * `a(): b() {}`: `b()`

## explicit vs converting constructor

* cannot be used for implicit conversion & copy-initialization

## todo

dynamic non-local

class member

copy elision

## Reference

[CPP Reference](https://en.cppreference.com/w/cpp/language/initialization)
