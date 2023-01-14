---
layout: post
title:
date: 2020-11-24 02:37
category:
author:
tags: []
summary:
---

- Preboot Execution Environment (PXE) server compose of the following
  - a DHCP server which hands out BOOTP paramter
  - a TFTP server which serves Network Bootstrap Program (NBP)
  - another server which serves file system
    - usually NFS

## dnsmasq

```bash
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

- give client a boot file
  - `pxelinux.0`
- pxelinux then proceed with
  - `pxelinux.cfg`
  - `kernel + initramfs`
  - `ldlinux`?
