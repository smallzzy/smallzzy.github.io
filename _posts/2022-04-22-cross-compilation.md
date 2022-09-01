---
layout: post
title:
date: 2022-04-22 17:25
category:
author:
tags: []
summary:
---

gcc -print-file-name=libc.so

- libc.so is excutable file which prints out its own version
- for cross compile. by resolve the link, we will know the current glibc version

## chroot

[mount propagation](https://lwn.net/Articles/690679/)

> Making a mount point a slave allows it to receive propagated mount and unmount events from a master peer group,
> while preventing it from propagating events to that master.

```bash
mount -t proc /proc proc/
mount -t sysfs /sys sys/
mount --rbind /dev dev/
mount --make-rslave dev/
# chroot
umount --recursive proc sys dev
```
