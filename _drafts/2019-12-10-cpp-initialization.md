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

## initialization

1. value initialization
2. direct initialization
3. copy initialization
4. list initialization
5. aggregate initialization
6. reference initialization

### static

1. zero initialization
2. constant initialization

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

## explicit vs converting constructor

* cannot be used for implicit conversion & copy-initialization

## todo

dynamic non-local

class member

copy elision

## Reference

[CPP Reference](https://en.cppreference.com/w/cpp/language/initialization)
