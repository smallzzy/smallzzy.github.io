---
layout: post
title: 
date: 2020-07-19 03:47
category: 
author: 
tags: []
summary: 
---

## disk protocol

* SCSI: Small Computer System Interface
  * serial attached scsi: sas
  * usb attached scsi: uas
  * iSCSI
* ATA
  * SATA
  * ACHI: host protocol
* NVMe
  * PCIe

### iSCSI

* present server's disk as local disk on client
  * Initiator: client `iscsiadm`
  * Target: server `tgtd`
* block level access -> client create file system on top
* Storage Area Network
  * Logical Unit Number: logic volume
  * usually over a dedicate network
* problem:
  * one client become single point of failure
  * multiple client has no sync 
    * shared-disk file system
    * SCSI fencing

### JBOD enclosure

* SAS support multiplexing
  * daisy chain also seems to be possible
* we can have SAS expander
  * backplane
  * JBOD enclousre
* SFF connector
  * 8484 can fan out to 4 8482
  * 8639: U2

## disk

`du -sch .[!.]* *`: show file size including hidden
`ncdu`: show file size in command line, very quick

### alignment

```
parted /dev/sda
align-check opt n
```

### mount options

* defaults = rw, suid, dev, exec, auto, nouser, aync
  * dev: interpret char or block device
  * exec: allow binary execution
  * suid: allow use of suid and sgid
* user: allow any user to mount this partition
  * imply noexec, nosuid, nodev
  * nouser: root only
* noatime: do not update last access time
* auto/noauto: mount automatically at boot
* nofail: do not block if cannot pass fsck
  * x-systemd.device-timeout
* ~~systemd service can used to mount disk~~
* fsck: 1 for root, 2 for other, 0 to disable

[fstab options](https://wiki.archlinux.org/index.php/Fstab)

### expansion

1. after raid expansion, rescan the disk
   1. `echo 1>/sys/class/block/sdd/device/rescan`
2. re-write the GPT backup header at the new end of the disk 
   1. `gdisk x e`
3. resize partition
   1. `gdisk d n`
   2. `parted resizepart`
4. resize fs
   1. `resize2fs`

## mdadm

```
stride = chunk size / block size
stripe width = number of data disks * stride
```

* mdadm tracks the disks by RAID metadata (superblock)
  * multiple version exist
  * remove existing superblock by `mdadm --zero-superblock /dev/sdc`
* `/etc/mdadm/mdadm.conf` automates array assembly
  * `mdadm --detail --scan >> /etc/mdadm.conf`
  * necessary when booting from raid 
  * `update-initramfs -u` after changing this file
* `mdadm --create --verbose /dev/md0`
  * `--level=0`
  * `--raid-devices=2`
* `mdadm --assemble`
  * `--scan`
  * `--update=name --name=<>`
* `mdadm --stop`
* `--detail`: information about raid
* `--examine`: look for superblock on device
* `echo check > /sys/block/md0/md/sync_action`

[raid for existing partition](https://feeding.cloud.geek.nz/posts/setting-up-raid-on-existing/)
[multipath](https://discourse.ubuntu.com/t/device-mapper-multipathing-introduction/11316)

### storcli

* the x is a placeholder for a number
  * can use `all`
* `show all` is present all info
* use jbod mode: `storcli /c0 show jbod`

### raid and partition

* use raid on top of partition instead of raw disk:
  * some motherboard might fix broken gpt header automatically
    * seems to be defined in UEFI
    * `sgdisk --zap`
  * leave some margin at the end of disk ensures easily replacement
  * `0xfd` makes it obvious that parition belongs to a raid
* ~~use raid on raw disk~~

[Reference](https://unix.stackexchange.com/questions/320103/whats-the-difference-between-creating-mdadm-array-using-partitions-or-the-whole)

* ~~partition on top of raid~~:
  * unless you want further divide the partition
  * partition fails when raid fails

https://serverfault.com/questions/796460/partition-table-on-one-disk-from-raid-always-equal-to-partition-table-configured
https://serverfault.com/questions/619862/should-i-partition-a-raid-or-just-create-a-file-system-on-it

## ssd trim

* when fs delete a file, it only needs to remove it from dir
  * the underlying inode is not touched
* ssd controller has no way of knowing if a block is actually used in fs
* trim tells ssd controller when a block is disposed
* [trim not necessary](https://www.spinics.net/lists/raid/msg40916.html)
  * the block will get reused when fs write again
  * with proper op, occupied block should not be a big problem

* trim support mode: drat dzat
* trim support in protocol: https://en.wikipedia.org/wiki/Trim_(computing)

## smr

* higher density but write amplification
* not suitable to small file write

https://www.ixsystems.com/community/resources/list-of-known-smr-drives.141/

## file system

https://danluu.com/deconstruct-files/
https://danluu.com/filesystem-errors/

https://news.ycombinator.com/item?id=24258444

xfs, btrfs, zfs
disk structure?

### zfs

* zpool: device pool
  * virtual devices, vdev
    * mirror / raidz
      * disk / slice / file
    * hot spare
    * intent log
    * cache devices
* zfs:
  * `create` filesystem datasets
    * inherit parent `-O mountpoint`
  * `create -V size` volume as block device
    * `set shareiscsi=on`
* zvol

### btrfs

https://work-work.work/blog/2018/12/01/ubuntu-1804-btrfs.html

## distributed file system

GlusterFS, Lustre, Spectrum Scale(GPFS), BeeGFS

## Ceph

* object storage daemon (OSD): manage data
* monitor: manage metadata -> need to reach a quorum

* Reliable Autonomic Distributed Object Store (RADOS): formed by osd and monitor
* based on RADOS, ceph can form
  * object gateway
  * block device, RBD
  * file system

### ceph at cern

CephScaleTestMarch2015
https://github.com/cernceph/ceph-scripts

NVDIMM

##

[disk firmware](https://firmware.hddsurgery.com/index.php)
