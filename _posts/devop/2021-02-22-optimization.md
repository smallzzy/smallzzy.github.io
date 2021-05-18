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
