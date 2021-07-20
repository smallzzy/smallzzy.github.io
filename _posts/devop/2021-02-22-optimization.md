---
layout: post
title:
date: 2021-02-22 20:49
category:
author:
tags: []
summary:
---

## collect stat

```bash
# kernel log
dmesg | tail
# misc infomation on system
# r: running process on cpu
vmstat
# run time per cpu
mpstat -P ALL
# htop but print out every pid
pidstat
# process
pstree
pgrep
# disk
iostat
# network stat
sar -n DEV
sar -n TCP,ETCP
```

[netflix](https://netflixtechblog.com/netflix-at-velocity-2015-linux-performance-tools-51964ddb81cf)
[Brendan D. Gregg](http://www.brendangregg.com/linuxperf.html)

## lsof

- find out which processes open a file
- `-u`: file opened by user
- `-U`: socket file
- `-c`: files opened by command
- `+d`: opened file in folder
- `-d`: exclude file
- `-p`: file opened by pid
- `-P`: inhibit conversion of port number to port name
- `-n`: inhibit conversion of network number to host name
- `-i`: select files with matching internet address
- `-a`: provide `and` result from given conditions

- a similar command is fuser

## stress test

iperf
fio
stress: cpu

[fio on google cloud](https://cloud.google.com/compute/docs/disks/benchmarking-pd-performance)

## monitor

`psensor`

`dstat`?

`munin` and `cacti`
`pcm`

## cpu pin

NUMA node is common on server.
The performance for certain workload might tank if it operates on a remote NUMA node

- `taskset`
  - `taskset <mask> <command>`: start with affinity
  - `taskset -p <pid>`: print affinity
  - `taskset -p <mask> <pid>`: set affinity
  - `-c`: interpret mask as cpu list
- `isolcpus`?

https://unix.stackexchange.com/questions/247209/how-to-use-cgroups-to-limit-all-processes-except-whitelist-to-a-single-cpu

### interrupt

- `/proc/interrupts`
  - `cat / echo` `/proc/irq/92/smp_affinity`
- irqbalance

> Irqbalance identifies the highest volume interrupt sources, 
> and isolates them to a single CPU, 
> so that load is spread as much as possible over an entire processor set, 
> while minimizing cache hit rates for irq handlers. 

- mellanox recommands to map each interrupt to a different cpu and only one cpu
  - `mlnx_tune`
  - `show_irq_affinity`
