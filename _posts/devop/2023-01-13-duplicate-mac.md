---
layout: post
title:
date: 2023-01-13 15:53
category:
author:
tags: []
summary:
---

## netplan

- https://netplan.io/reference
- https://netplan.io/examples/

## detect duplicate mac??

```bash
# 1. ping might not be reliable when having duplicated mac
ping -b 192.168.1.255
arp -n

# 1.1 however, the two machine can be assign different ip
# (most likely) netplan -> dhcp-identifier -> can use duid as idenfier instead of mac
# (less likely) dhcp server have a really low lease time

# in this case, arp table will contain two ips point to the same mac.
10.137.159.110           ether   34:12:78:56:00:00   C                     enP7p4s0
10.137.159.214           ether   34:12:78:56:00:00   C                     enP7p4s0

# ping will get redirected. But it will fail later on
From 10.137.159.214: icmp_seq=6 Redirect Host(New nexthop: 10.137.159.110)

# 2. have a managed switch so that we can check mac address per-port

# 3. arpwatch?
```

## spoof mac with netplan

```yaml
# vim /etc/netplan/01-netcfg.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enP7p4s0:
        # need to match original mac.
        # otherwise renaming might cause some trouble
        match:
            macaddress: 34:12:78:56:00:00
        macaddress: 4c:ed:fe:32:de:22
        dhcp4: yes
    # note: later matches will override previous one

# netplan apply
```
