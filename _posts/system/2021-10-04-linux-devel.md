---
layout: post
title: 
date: 2021-10-04 02:00
category: 
author: 
tags: []
summary: 
---

## turn on debug message 

- [dynamic debug](https://www.kernel.org/doc/html/v4.19/admin-guide/dynamic-debug-howto.html)
  - if compile kernel with `CONFIG_DYNAMIC_DEBUG=y`, `pr_debug` can be enabled per-callsite
- change `console_loglevel`
  - `cat /proc/sys/kernel/printk`
    - `current default minimum boot-time-default`
  - `echo 7 > /proc/sys/kernel/printk`
- enable certain module, ex: `echo 'module usbcore =p' >/sys/kernel/debug/dynamic_debug/control`
  - it can be done prior to `modprobe`

## change module parameter

### static 

- static module: `/proc/sys/<modules>/<param>`
  - same at `sysctl -a`
- they can be change temporarily with `sysctl -w`
  - or permanently with `sysctl.conf`

### dynamic

* dynamic module:
  * `lsmod`, `modinfo`, `modprobe`
  * `/sys/module/<modules>/parameters/<param>`
* permanently change with `echo "options <mod> <param>=<x>" >> /etc/modprobe.d/<>.conf`
