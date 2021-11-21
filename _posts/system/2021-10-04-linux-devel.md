---
layout: post
title: 
date: 2021-10-04 02:00
category: 
author: 
tags: []
summary: 
---

## logging level

- `dmesg`: reads from the kernel ring buffer (`/dev/kmsg`)
  - change dmesg size in boot parameter: `log_buf_len=5M`
- syslog: a text based protocol to communicate log (RFC 5424)
  - client-server structure
  - rsyslog: a server implementation for syslog
    - `imfile`, `imuxsock`
- journald: a log manager in systemd
  - one central location for services
  - can export to syslog

## turn on kernel debug message 

- change `console_loglevel`
  - `cat /proc/sys/kernel/printk`
    - `current default minimum boot-time-default`
  - `echo 8 > /proc/sys/kernel/printk`
  - [logging level](https://elinux.org/Debugging_by_printing)
- [dynamic debug](https://www.kernel.org/doc/html/v4.19/admin-guide/dynamic-debug-howto.html)
  - if compile kernel with `CONFIG_DYNAMIC_DEBUG=y`, `pr_debug` can be enabled per-callsite
  - enable certain module, ex: `echo 'module usbcore =p' >/sys/kernel/debug/dynamic_debug/control`
    - it can be done prior to `modprobe`

## change driver parameter

### static linked

- static module: `/proc/sys/<modules>/<param>`
  - same at `sysctl -a`
- they can be change temporarily with `sysctl -w`
  - or permanently with `sysctl.conf`

### module

- dynamic module:
  - `lsmod`, `modinfo`, `modprobe`
  - `/sys/module/<modules>/parameters/<param>`
- permanently change with `echo "options <mod> <param>=<x>" >> /etc/modprobe.d/<>.conf`
