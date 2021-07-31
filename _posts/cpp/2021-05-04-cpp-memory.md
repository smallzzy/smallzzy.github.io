---
layout: post
title:
date: 2021-05-04 15:46
category:
author:
tags: []
summary:
---

## data type

* Trivial Type
* Standard Layout class
* POD
* Aggregate

[aggregate, POD](https://stackoverflow.com/questions/4178175/what-are-aggregates-and-pods-and-how-why-are-they-special)

## memory layout

- alignment:
  - decide how members are arrange in memory
  - decide how the struct is used by others
    - might cause additional code to be emit for risc
  - might cause false sharing in cacheline
- placement new: construct objects in allocated storage
  - `new (placement params) type (initializer)`
  - must manually call destructor to avoid releasing memory
  - usually encapsulated by `Allocator`
- changing aligment
  - `alignof, alignas`: put additional alignment requirement on struct
    - reduce alignment is ill-formed
    - `#pragma pack` is needed when reduce beyond default alignment
  - `std::align()`: given pointer to memory area, return pointer which is aligned

## unique_ptr

- Notice that when we use `release`, the custom deleter is lost.
  - So, when constructing shared_ptr from unique_ptr, we need to `move`.
- `unique_ptr` points to one element of T, which differs from raw pointer
  - `unique_ptr<int>` point to one and only one int
  - `unique_ptr<int[]>` point to one int array
    - notice that this is a array specialization of unique_ptr

## shared_ptr

```c++
struct Good: std::enable_shared_from_this<Good> // note: public inheritance
{
    std::shared_ptr<Good> getptr() {
        return shared_from_this();
    }
};
```

- When `Good` is managed by a `shared_ptr`,
  `shared_from_this` generates additional `shared_ptr` from `this` with shared ownership.
  - `std::shared_ptr<Good>(this)` is broken due to separate reference count

## std::launder

1. in a class, we can have `const` member
2. we can use `placement new` for any class

- if we combine those conditions, a pointer to const element might not be constant

```c++
struct X { const int n; };
union U { X x; float f; };
void tong() {
  U u = {{ 1 }};
  u.f = 5.f;               // OK, creates new subobject of 'u'
  X *p = new (&u.x) X {2}; // OK, creates new subobject of 'u'
  assert(p->n == 2);       // OK
  assert(*std::launder(&u.x.n) == 2); // OK

  // undefined behavior, 'u.x' does not name new subobject due to possible optimization
  assert(u.x.n == 2);
}
```

### side note

- `EXP39-C. Do not access a variable through a pointer of an incompatible type`
- `EXP40-C. Do not modify constant objects`
