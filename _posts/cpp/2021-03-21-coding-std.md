---
layout: post
title: 
date: 2021-03-21 04:46
category: 
author: 
tags: []
summary: 
---

## reference

[Common Weakness List](https://cwe.mitre.org/data/index.html)
[SEI CERT C++](https://wiki.sei.cmu.edu/confluence/collector/pages.action?key=cplusplus)

## virtual function in cpp constructor / destructor [OOP50-CPP]

> the function called is the final overrider in the constructor’s or destructor’s class and not one overriding it in a more-derived class.

Since that the children is constructed after parent class,
even if we could call the child function (such as using crtp),
the member variable would not be there.

## INT02-C

> Integer types smaller than int are promoted when an operation is performed on them

> If the operand that has unsigned integer type has rank greater than or equal to the rank of the type of the other operand, 
> the operand with signed integer type is converted to the type of the operand with unsigned integer type.

> Otherwise, if the new type is unsigned, 
> the value is converted by repeatedly adding or subtracting one more than the maximum value 
> that can be represented in the new type until the value is in the range of the new type.
