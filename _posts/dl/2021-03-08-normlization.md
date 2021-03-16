---
layout: post
title: 
date: 2021-03-08 14:03
category: 
author: 
tags: []
summary: 
---

## p-norm

\(
\left\| x \right\| _p = \left( |x_1|^p + |x_2|^p + \dotsb + |x_n|^p \right) ^{1/p}
\)

* p = 1, Manhattan Distance
* p = 2, Euclidean Distance
* p = 0, counting the number of zero
* p = inf, -> max{x_1, x_2, \dotsb, x_n}  

### sparsity

https://www.quora.com/Why-is-L1-regularization-supposed-to-lead-to-sparsity-than-L2

When minimizing norm(x) for Ax = b, we are try to find a intersection with the norm.

* l1 norm has a diamond shape. 
  * intersection is on vertex -> only one parameter is effective -> sparse
  * intersection align with edge (rare) -> multiple solution might be possible
* l2 norm has a sphere shape
  * intersection is unique and can involve multiple parameter

## batch norm

* collect stat from a batch of samples for each channel
* usually on image model

## layer norm

* collect stat from all sequence in a single sample
* usually on seq2seq model
