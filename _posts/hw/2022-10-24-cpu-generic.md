---
layout: post
title:
date: 2022-10-24 12:04
category:
author:
tags: []
summary:
---

## general design problem

- pipeline hazard
  - control hazard: unpredictable branching
  - dependency hazard:
    - forwarding
  - structural hazard: station being occupied
- cache:
  - size
    - cache line size
    - total size
  - access pattern / hit rate
  - associativity
  - replacement policy
    - LRU, NLRU, Random

## abi design

- C language data type model
  - ILP32: int, long, pointer = 32 bit
  - LP64: long, pointer = 64 bit
- x32 abi:
  - reduce cache usage
  - limited memory range

https://github.com/ARM-software/abi-aa

## ordering

- compiler reorder
  - read / write barrier: specify operation order
  - volative: non-trivial side effect being optimized out
- cpu reorder
  - memory barrier: force cache write back

### out of order

- issue width
- reservation station
  - different station can have different capability
- re-ordering buffer (ROB)
- register file vs specialized register
  - register renaming

## SPECTRE
