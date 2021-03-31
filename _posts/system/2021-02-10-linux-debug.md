---
layout: post
title:
date: 2021-02-10 13:47
category:
author:
tags: [os]
summary:
---

## printk

- if compiled with `DEBUG`, `pr_debug` are replaced with `printk(KERN_DEBUG`
- `console_loglevel`
  - `cat /proc/sys/kernel/printk`
  - `current default minimum boot-time-default`
- `dmesg`: `-w` follow, `-H` human readable format
- [dynamic debug](https://www.kernel.org/doc/html/v4.19/admin-guide/dynamic-debug-howto.html)
  - `pr_debug` can be enabled per-callsite
  - enable via `<debugfs>/dynamic_debug/control`
  - ex: `echo 'module usbcore =p' >/sys/kernel/debug/dynamic_debug/control`
- change dmesg size in boot parameter: `log_buf_len=5M`

### syslog

- logging content are present on the following file
  - `/dev/log`: syslog
    - `syslog()` in libc
    - socket
  - `/dev/kmsg`: kernel message
    - `klogd`
- rsyslog is one impl to process logging
  - config in `/etc/rsyslog.conf`
  - write to `/var/log`
  - `imuxsock`: read from `/dev/log`
  - `imjournal`, `omjournal`: let rsyslog talk to journald
- journald can also process logging
  - install along with systemd
  - write to `/var/log/journal` (persistent) or `/run/log/journal` (volatile)

## debug

- debugfs: /etc/kernel/debug

## tracing

- tracefs: /etc/kernel/tracing
  - [tracepoint](https://www.kernel.org/doc/Documentation/trace/tracepoints.txt)
    - a hook to call `probe` at runtime
    - represent as `subsystem:event` in `available_events`
    - or inside `events` folder
      - `enable`: enable this event
      - `format`: event's field to be recorded
      - `filter`: output when event's field meet certain criteria
  - available_filter_functions:
    - function calls are recorded during compilation
    - dynamic ftrace
    - `set_ftrace_filter`
  - tracers: a set of runtime function to call
    - `trace_options`
  - output:
    - static: `trace`
      - clear trace `echo > trace`
    - dynamic: `trace_pipe`

### some event

workqueue:workqueue_queue_work -> kworker

[events](https://www.kernel.org/doc/Documentation/trace/events.txt)

## oops

- kernel can oops when having a bug
  - kernel will crash when oops to a irrecoverable state
- `kexec`: execute kernel
- `kdump`: dump crash context to `/var/crash`
- `crash`: reload crash context

```bash
kdump-tools.service

# /etc/default/kdump-tools
KDUMP_SYSCTL="kernel.panic_on_oops=1"

# /etc/default/grub.d/kdump-tools.default
# load backup kernel to specified location
# meaning: for ram size > 384M, reserve 128 M for kexec
# crashkernel=auto for auto size detection
GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT crashkernel=384M-:128M"
```

[kexec-reboot](https://github.com/error10/kexec-reboot)
