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

## ACS (Access Control Service)


## IOMMU vs MMU

- PCIe endpoint -> PCIe Root Port -> IOMMU -> System Memory <- MMU <- CPU
  - Intel IOMMU
  - ARM SMMU
- MMU stores Virtual Address to Physical Address mapping
- IOMMU allows DMA-capable devices to access system memory
  - note that IOMMU has groups, and each group has its own mapping table
  - however, multiple devices in the same IOMMU group means that they cannot be individually isolated for virtualization

### fun fact: ACS override patch

- there is a patch in linux to override ACS (Access Control Service)
- by using ACS, it mimics the behavior of splitting device into multiple IOMMU groups.
- but on hardware level, the IOMMU group is still shared so DMA attack is still possible

## PCIe address translation service (ATS)

- when pcie devices found caching a memory translation is beneficial, it can perform ATS requset to TA (translating agent) to retrieve the translation.
  - PCIe devices will store the result in its own cache (ATC)

- Address translation is shifted from CPU IOMMU to Device IOMMU (ex. GMMU for GPUs)
- device can send translation request to IOMMU, IOMMU is supposted to return the RWX permission for the request
  - the following request can be sent with translated address
  - however, what if malicious device send fake translated address?

### security

https://cloud.google.com/blog/products/gcp/fuzzing-pci-express-security-in-plaintext

The most interesting challenge here is protecting against PCIe's Address Translation Services (ATS).
Using this feature, any device can claim it's using an address that's already been translated, and thus bypass IOMMU translation.

https://www.intel.com/content/www/us/en/pci-express/pci-sig-sr-iov-primer-sr-iov-technology-paper.html

Access Control Services (ACS) provides a mechanism by which a Peer-to-Peer PCIe transaction can be forced to go up through the PCIe Root Complex.
ACS can be thought of as a kind of gate-keeper - preventing unauthorized (P2P)transactions from occurring

https://www.intel.com/content/dam/develop/external/us/en/documents/intel-whitepaper-using-iommu-for-dma-protection-in-uefi-820238.pdf

IOMMU is suggested to be used for limiting device access to system memory. Thus limiting the DMA attack.
Note that the whitepaper suggests to let IOMMU kick in at very early stage.

### note

note that ACS and IOMMU can be modified to allow DMA for improved performance on trustworthy devices. But the method is platform specific.
It is easier to just disable them for performance.

Bus address?
or Device address?
is it used per process?

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
https://wiki.debian.org/QemuUserEmulation

This page describes how to setup and use QEMU user emulation in a "transparent" fashion, allowing execution of non-native target executables just like native ones (i.e. ./program).

In this text, "target" means the system being emulated, and "host" means the system where QEMU is running.
```

`apt install qemu binfmt-support qemu-user-static`

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

instead of emulating everything. instead try to interpret function calls and runs with system native library

https://github.com/ptitSeb/box64
https://box86.org/2022/03/box86-box64-vs-qemu-vs-fex-vs-rosetta2/

mkdir build;
cd build;
cmake .. -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo -DPAGE64K=ON;
make -j$(nproc)
sudo make install

-- Installing: /usr/local/bin/box64
-- Installing: /etc/binfmt.d/box64.conf
-- Installing: /usr/lib/x86_64-linux-gnu/libstdc++.so.5
-- Installing: /usr/lib/x86_64-linux-gnu/libstdc++.so.6
-- Installing: /usr/lib/x86_64-linux-gnu/libgcc_s.so.1
-- Installing: /usr/lib/x86_64-linux-gnu/libpng12.so.0
-- Installing: /etc/box64.box64rc

### update-binfmts vs systemd-binfmt

These are two conflicting ways of interacting with kernel binfmt

```bash
# update-binfmts
/usr/share/binfmts/
update-binfmts --display
update-binfmts --enable

# systemd-binfmt
/etc/binfmt.d/
/usr/lib/systemd/systemd-binfmt --cat-config
```

## rosetta

https://apple.stackexchange.com/questions/407731/how-does-rosetta-2-work
https://ss64.com/osx/lipo.html
