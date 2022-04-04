---
layout: post
title:
date: 2022-04-03 23:48
category:
author:
tags: []
summary:
---

## virtualization type

- type 1 hypervisor: bare metal
  - XEN, KVM
- type 2 hypervisor: virtual machine
  - QEMU, VMWare, VirtualBox

## iommu

Each guest os will have it own vitual address mapping.
To coordinate different virtual address mapping, we need to use IOMMU.

## libvirt

- virtio:
- uefi: `edk2-ovmf`
- virsh
  - `net-list --all`
  - `net-start`
- virt-manager
  - `usermod -aG libvirt <>`
  - `libvirtd.service`

https://wiki.archlinux.org/title/libvirt#Server

- proxmox, ESXi, xcp-ng
- lxc lxd
