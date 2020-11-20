---
layout: post
title: 
date: 2020-03-06 10:46
category: 
author: 
tags: [compile]
summary: 
---

## header design 

Even with the right header design, we still need to consider symbol visibility.

### pimpl

Implemented in the form of forward declaration and opaque pointer.

* pimpl hides private symbol
* class struct is not built into client code
* pimpl might require additional memory allocation

Pimpl relies on the fact that imcompleted type can be used as pointer.

[pimpl helper](http://oliora.github.io/2015/12/29/pimpl-and-rule-of-zero.html#pimpl-without-special-members-defined)
[pimpl alloc](https://probablydance.com/2013/10/05/type-safe-pimpl-implementation-without-overhead/)

### abstract interface + factory function

## some rule to remember

* You cannot change the order of virtual function declaration
* Compiler might choose to call virtual function directly if it determines it is safe to do so.

## check against abi change

[abi-compliance-checker](https://lvc.github.io/abi-compliance-checker/)

[abigail](https://sourceware.org/libabigail/manual/index.html)

[kde guideline](https://community.kde.org/Policies/Binary_Compatibility_Issues_With_C%2B%2B)

### mac os

The abi issue is mitigated by `-mmacosx-min-version` which specify the minimal abi version.
And unsupported feature will trigger a error.

## known abi problem

`_GLIBCXX_USE_CXX11_ABI`

anoy namespace c++?

## todo

[swift vs rust abi](https://gankra.github.io/blah/swift-abi/)
