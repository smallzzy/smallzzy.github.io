---
layout: post
title: 
date: 2020-11-24 02:37
category: 
author: 
tags: []
summary: 
---

* PXE is provided by
  * a DHCP server which hand out BOOTP paramter
  * a tftp server which serve the files

## dnsmasq

```
# network config
interface=<if>

# disable dns
port=0

bind-interfaces

# dhcp
dhcp-range=
## dhcp-option?
## proxy?

# tftp
enable-tftp
tftp-root=/srv/tftp

# pxe-service?
```

## boot server

* give client a boot file
  * `pxelinux.0`
* pxelinux then proceed with
  * `pxelinux.cfg`
  * `kernel + initramfs`
  * `ldlinux`?
