---
layout: post
title: 
date: 2021-04-14 18:38
category: 
author: 
tags: []
summary: 
---

## boot process

- ROM: on chip **proprietary** program. Load code from several preprogrammed location
  - program only have access to on chip sram at this stage
- secondary stage program loader: bios, uefi
  - bring up other system parts
  - load TPL into DRAM (main memory)
- third stage program loader: grub
  - efi system partition (esp)
    - `<ESP>/boot/boot<>.efi`
    - fat32, unique GUID value
  - note: it is possible to load into dram via jtag directly
- kernel

## kernel

- ram size, location
- cpu clock
- [kernel command line](https://www.kernel.org/doc/html/v4.14/admin-guide/kernel-parameters.html)
- device tree (optional)
- initramfs (optional)

### device tree

- content verified with kernel schema
- compiled into dtb when deployed

### initramfs

- initramfs includes a minimal fs to bring up the actual root fs
  - it can be created via `initramfs-tools`, `dracut`, `mkinitcpio`
  - very helpful when root fs need to load certain drivers
- depending on different boot loader, `initramfs` might
  - be a separate file: `initrd.img`
  - integrated with linux image
- `initrd.img` is several archive concatenated together
  - `lsinitramfs`
  - `cpio` does not work so well when the archive does not concat on 512 byte boundary
  - decompress progress
    - `binwalk initrd.img`: check where each archive locates
    - `dd if=initrd.img bs=21136 skip=1 | gunzip | cpio -idv`: extract from specific location

### initramfs init

- when a initramfs is provide, kernel will run `/init` from that initramfs
- the command line option `root=` can be used by `init` to locate root
- `/init` will load the root fs and run the actual init from there

#### initramfs-tools

- `man 8 initramfs-tools`
- `/etc/initramfs-tools/hooks`: script used for preparing initramfs
- `/etc/initramfs-tools/modules`: kernel module used during bringup
- `/etc/initramfs-tools/scripts`: script used during bringup

## root filesystem

https://man7.org/linux/man-pages/man7/hier.7.html

### mtd

https://bootlin.com/blog/managing-flash-storage-with-linux/

### rootfs init

- init will process `/etc/fstab`
  - the root fs is mounted as read only during boot
  - `/etc/fstab` will remount root fs with different options

## todo

- [UEFI](https://uefi.org/specifications): SEC, PEI, DXE
  - during DXE, oprom is loaded -> driver?
- ACPI
