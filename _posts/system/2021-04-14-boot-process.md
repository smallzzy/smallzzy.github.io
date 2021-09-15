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
- secondary stage program loader: bios, uefi, 
  - bring up other system parts
  - load TPL into DRAM (main memory)
- third stage program loader: grub, uboot
  - efi system partition (esp)
    - <ESP>/boot/boot<>.efi
    - fat32, unique GUID value
  - note: it is possible to load into dram via jtag directly
- kernel

## kernel

- ram size, location
- cpu clock
- kernel command line
- device tree (optional)
- ramdisk (optional)

### device tree

- content verified with kernel schema
- compiled into dtb when deployed

### initramfs

- initramfs includes utilities to bring up root fs
  - `man 8 initramfs-tools`
  - `/etc/initramfs-tools/hooks`: script used for preparing initramfs
  - `/etc/initramfs-tools/modules`: kernel module used during bringup
  - `/etc/initramfs-tools/scripts`: script used during bringup
- depending on different boot loader, `initramfs` might
  - be a separate file: `initrd.img`
  - integrated with linux image
- `initrd.img` is several archive concatenated together
  - `lsinitramfs`
  - `cpio` does not work so well when the archive does not concat on 512 byte boundary
  - decompress progress
    - `binwalk initrd.img`: check where each archive locates
    - `dd if=initrd.img bs=21136 skip=1 | gunzip | cpio -idv`: extract from specific location

## root filesystem

### mtd 

https://bootlin.com/blog/managing-flash-storage-with-linux/

### init

- after root fs is up, `init` will run and process `/etc/fstab`
- when running fstab, root fs might get remount with different paramter

## todo

* [UEFI](https://uefi.org/specifications): SEC, PEI, DXE
  * during DXE, oprom is loaded -> driver?

$DISPLAY
xauth add $DISPLAY . hexkey
xauth remove $DISPLAY
