---
layout: post
title:
date: 2020-10-31 18:31
category:
author:
tags: [os]
summary:
---

## driver

- driver custom struct
  - `module_init`, `module_exit`
  - store `cdev`
- inode
  - only one inode for each file, but multiple filp can exist
  - `dev_t`?
  - `cdev *` how about other type?
- filp: file descriptor
  - `void *private_data`
    - usually set to the driver's custom struct
  - `struct file_operations *f_op`
    - store pointer syscall implementation

### present status

- generate `/proc` file: not recommanded because proc should only be about process
  - seq_file:
- ioctl: transmit data to user space when asked
- sysfs:

### ioctl

- command number
- command struct

### char device

- sequential access
- `cdev_init`

### block device

- random, page access

## access control

- uid, gid
- capability
- cgroup?
  - limit resource usage

### namespace

> Changes to the global resource are visible to other processes that are members of the namespace, but are invisible to other processes

- mnt, pid, net, ipc, UTS, user, cgroup, time
- `lsns`: show process namespace
- `unshare`: move the calling process to another ns

## time

- timer interrupt
  - jiffies, jiffies_64, HZ
- cpu cycle register
  - x86: TSC
- timespec
  - second + nanosecond
- timeval
  - second + microsecond

wait queue

exclusive

## atomic

- semaphore
  - mutex
- spinlock
- atomic

- in_interrupt()
  - in hardware or software interrupt
- in_atomic
  - interrput + if spinlock is held

## delay

- busy wait
  - `cpu_relax()`
- yield
  - `schedule()`
  - no guarantee of reschedule
- timeout
  - `wait_event_timeout`
  - `schedule_timeout`
    - `set_current_state`
- delay
  - `mdelay`
  - `msleep`

## future work

- timer: `linux/timer.h`
  - `add_timer`
    - timer only get schduled on the same CPU?
    - timer function can reschedule itself
  - `del_timer`
    - ensure that timer is not queued
    - return non-zero if the timer is actually dequeued
      - timer might already finished
    - delete might be done on another CPU
  - `del_timer_sync`
    - also ensure that timer is not executing at return
    - this function can sleep
    - ensure function does not reschedule itself
- tasklet: schedule function to be called later
  - no time specified, but no later than next time tick
- workqueue: in kernel process context
  - per-cpu thread might be inited
  - `queue_work`
  - shared workqueue: `schedule_work()`

## interrupt

## memory

- memory mapping
  - /proc/iomem
    - embedded in normal memory range
    - non-prefetchable
  - /proc/ioports
    - special instruction required
  - nopage / remap_pfn_range
- dma
  - bus address

## sys, proc, dev

### sysfs

- `/sys` contains the running information for the system
  - each driver will create one directory in the tree
    - module relationship is expressed as symbolic link
  - each attribute becomes one file in the directory
- different folder represents the structure in different ways
  - `/sys/devices`: describe devices' physical connection
  - `/sys/dev`: char and block device
  - `/sys/class`: based on devices' function
  - `/sys/bus`: based on interconnect type

https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt
https://www.kernel.org/doc/html/latest/admin-guide/sysfs-rules.html

### proc

- `/proc` decribes running information for each process
  - `cpuinfo`, `meminfo`
  - `iomem`, `ioport`
- device tree:
  - `/proc/device-tree/`
  - of-node

### dev

- simulated file for actual data transfer
- https://www.kernel.org/doc/Documentation/admin-guide/devices.txt

## reference

[Linux Specfication](https://refspecs.linuxfoundation.org/)
