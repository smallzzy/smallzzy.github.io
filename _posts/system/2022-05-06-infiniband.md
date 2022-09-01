---
layout: post
title:
date: 2022-05-06 13:05
category:
author:
tags: []
summary:
---

## InfiniBand (IB) component

- IB switch
- Subnet Manager (SM)
  - Master + Standby
- network hosts
  - host channel adapter (HCA)
- gateway: IB to ethernet
- router: between multiple IB subnet

[infiniband data rate](https://en.wikipedia.org/wiki/InfiniBand)

## failover

- SM-based
- self healing?

## load-balance

- adaptive routing? multi-path?

## reduce

scalable hierachical aggregation and reduction protocol??
SHARP -

## RDMA

## Nvidia Academy Fundamentals of RDMA Programming

Data path can skip kernel layer. ex. prepend message header does not involve kernel interaction.
But device driver is still involved in the control path. ex. Connection establishment & Resource management.

### traditional socket model - two side model

When receiving a message, the receiver is involved in deciding where the message is put in memory
So, there will be a memcpy path (NIC -> Kernel -> User)

### rdma model - one side model

The message carries the memory destination. The NIC will directly put message into user space.
-> IOMMU

3. RDMA operations and Atomics?

Used for multi-node data sharing across network, such as infiniband.

MOFED driver -> [Mellanox OpenFabrics Enterprise Distribution](https://www.mellanox.com/page/software_overview_ib)

Some basic [info1](https://www.rohitzambre.com/blog/2018/2/9/for-the-rdma-novice-libfabric-libibverbs-infiniband-ofed-mofed)
[info2](https://shelbyt.github.io/rdma-explained-1.html)

## NVSHMEM
