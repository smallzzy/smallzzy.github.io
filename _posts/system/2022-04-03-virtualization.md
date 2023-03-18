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

## IOMMU vs MMU

- MMU stores Virtual Address to Physical Address mapping.
  - Similarly for IOMMU, allow process to access device address directly?
- PCIe endpoint -> PCIe Root Port -> IOMMU -> System Memory <- MMU <- CPU
  - Intel IOMMU
  - ARM SMMU

## PCIe ATS

- Address translation is shifted from CPU IOMMU to Device IOMMU (ex. GMMU for GPUs)

Bus address?
or Device address?
is it used per process?
what is used before iommu?

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

http://www.elaske.com/unraid-pcie-and-iommu-groups/

## qemu

## system emulation `qemu-system`

## user emulation `qemu-static`

```
This page describes how to setup and use QEMU user emulation in a "transparent" fashion, allowing execution of non-native target executables just like native ones (i.e. ./program).

In this text, "target" means the system being emulated, and "host" means the system where QEMU is running.
```

https://wiki.debian.org/QemuUserEmulation

apt install qemu binfmt-support qemu-user-static
update-binfmts --display
update-binfmts --enable

### apt source list

ubuntu uses different address for different architecture

```
deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports jammy main restricted universe multiverse
deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse
```

### debian repackage

```bash
dpkg-deb -x xx.deb xx/
dpkg-deb --control xx.deb xx/DEBIAN
# modify control file
dpkg-deb -b xx yy.deb

# yum provides
apt-file update
apt-file search
```

### docker

https://www.stereolabs.com/docs/docker/building-arm-container-on-x86/
https://github.com/multiarch/qemu-user-static

`docker run -it --name=steamcmd --platform amd64 cm2network/steamcmd bash`

## box86 / box64

https://github.com/ptitSeb/box64
https://box86.org/2022/03/box86-box64-vs-qemu-vs-fex-vs-rosetta2/

mkdir build;
cd build;
cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DPAGE64K=ON;
make -j$(nproc)

-- Installing: /usr/local/bin/box64
-- Installing: /etc/binfmt.d/box64.conf
-- Installing: /usr/lib/x86_64-linux-gnu/libstdc++.so.5
-- Installing: /usr/lib/x86_64-linux-gnu/libstdc++.so.6
-- Installing: /usr/lib/x86_64-linux-gnu/libgcc_s.so.1
-- Installing: /usr/lib/x86_64-linux-gnu/libpng12.so.0
-- Installing: /etc/box64.box64rc

## rosetta

https://apple.stackexchange.com/questions/407731/how-does-rosetta-2-work
https://ss64.com/osx/lipo.html
