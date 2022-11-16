---
layout: post
title:
date: 2022-11-16 02:40
category:
author:
tags: []
summary:
---

## architecture option

https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html
https://gcc.gnu.org/onlinedocs/gcc/AArch64-Options.html

- identify cpu on platform
  - https://github.com/google/cpu_features
  - https://github.com/pytorch/cpuinfo
- identify flag used in elf
  - x86: https://github.com/pkgw/elfx86exts
  - arm: ?
  - record flag in binary: `-frecord-gcc-switches`

## disassembler

- https://github.com/icedland/iced
- http://www.capstone-engine.org/

### commercial

- https://binary.ninja/
- https://www.hex-rays.com/ida-pro/
