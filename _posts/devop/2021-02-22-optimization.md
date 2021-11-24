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
- `-i :80`: select files with matching internet address
- `-a`: provide `and` result from given conditions

- a similar command is fuser

## stress test

iperf
fio
stress: cpu

[fio on google cloud](https://cloud.google.com/compute/docs/disks/benchmarking-pd-performance)
https://www.mankier.com/1/stress-ng

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
- `docker`
  - `--cpuset-cpus <core-list>`

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

https://developer.amd.com/resources/epyc-resources/epyc-tuning-guides/
https://www.amd.com/en/processors/server-tech-docs/search
https://www.amd.com/system/files/documents/amd-epyc-7002-tg-hpc-56827.pdf

## numa

```
# bind process w.r.t resource locality. ex. netdev, pcie
numactl
# numa memory hit / miss
numastat
# per process numa allocation
/proc/<pid>/numa_maps
```

https://frankdenneman.nl/2016/07/11/numa-deep-dive-part-3-cache-coherency/
