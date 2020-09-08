---
layout: post
title: 
date: 2020-03-06 10:46
category: 
author: 
tags: [compile]
summary: 
---

## pimpl

Implemented in the form of forward declaration and opaque pointer,
pimpl is useful for hiding symbol and reducing abi changes.

Another valid approach is to use version script (to remove symbol)
and factory functions (to construct the pimpl type)

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
