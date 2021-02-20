---
layout: post
title: 
date: 2021-02-10 13:47
category: 
author: 
tags: []
summary: 
---

## printk

* if compiled with `DEBUG`, `pr_debug` are replaced with `printk(KERN_DEBUG`
* `console_loglevel`
  * `cat /proc/sys/kernel/printk`
  * `current default minimum boot-time-default`
* [dynamic debug](https://www.kernel.org/doc/html/v4.19/admin-guide/dynamic-debug-howto.html)
  * `pr_debug` can be enabled per-callsite
  * enable via `<debugfs>/dynamic_debug/control`

## debug

* debugfs: /etc/kernel/debug

## tracing

* tracefs: /etc/kernel/tracing
  * [tracepoint](https://www.kernel.org/doc/Documentation/trace/tracepoints.txt)
    * a hook to call `probe` at runtime
    * represent as `subsystem:event` in `available_events`
    * or inside `events` folder
      * `enable`: enable this event
      * `format`: event's field to be recorded
      * `filter`: output when event's field meet certain criteria
  * available_filter_functions:
    * function calls are recorded during compilation
    * dynamic ftrace
    * `set_ftrace_filter`
  * tracers: a set of runtime function to call
    * `trace_options`
  * output:
    * static: `trace`
      * clear trace `echo > trace`
    * dynamic: `trace_pipe`

### some event

workqueue:workqueue_queue_work -> kworker

[events](https://www.kernel.org/doc/Documentation/trace/events.txt)
