---
layout: post
title: 
date: 2020-07-19 03:47
category: 
author: 
tags: []
summary: 
---

## disk

`iotop`: view disk usage by application
`iostat`: view disk usage by device

### disk protocol

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

### SAS

* multiplexing
  * daisy chain SAS expander
* multipath
* backplane
  * might have SAS expander
  * might have nvme passthrough
* JBOD enclousre
* SFF connector
  * 8484 can fan out to 4 8482
  * 8639: U2

### nvme

- Supported LBA Sizes: `smartctl -a /dev/`
- change LBA size: `nvme format /dev/nvme1n1 -l 1`

https://tinyapps.org/docs/nvme-secure-erase.html

### ssd trim

* when fs delete a file, it only needs to remove it from dir
  * the underlying inode is not touched
* ssd controller has no way of knowing if a block is actually used in fs
* trim tells ssd controller when a block is disposed
* [trim not necessary](https://www.spinics.net/lists/raid/msg40916.html)
  * the block will get reused when fs write again
  * with proper op, occupied block should not be a big problem

* trim support mode: drat dzat
* trim support in protocol: https://en.wikipedia.org/wiki/Trim_(computing)

### smr

* higher density but write amplification
* not suitable to small file write

https://www.ixsystems.com/community/resources/list-of-known-smr-drives.141/

## partition

`partprobe`: read partition after change

- partition table indicate the position of file system
  - but it is not involved in the structure of fs
  - assuming 512 byte sector
    - mbr: only the first sector (LBA 0)
    - gpt:
      - protective mbr (LBA 0)
      - gpt header (LBA 1)
      - at least 32 sector
- `lsblk -o` can use the following option to print info on partition
- `PARTUUID`: partition identifier, fs independent
  - `UUID`: stored in filesystem, cannot be read if filesystem is unknown
- `PARTLABEL`: partition name, fs independent
- to identify partition purpose
  - `Partition type ID`: mbr
  - `PARTTYPE`, `Partition type UUID`: gpt

[make fs on file](http://www.orangepi.org/Docs/Makingabootable.html)

### alignment

```
parted /dev/sda
align-check opt n
```

### mount options

* `man 8 mount`
* defaults = rw, suid, dev, exec, auto, nouser, async
  * dev: interpret char or block device
  * exec: allow binary execution
  * suid: allow use of suid and sgid
* user: allow any user to mount this partition
  * imply noexec, nosuid, nodev
  * nouser(default): root only
* noatime: do not update last access time
* `auto`: mount automatically at boot
  * `noauto,x-systemd.automount`: let systemd mount at access
* `_netdev`: try mount after network is up
  * `_netdev,x-systemd.mount-timeout=30`: remote file system
* `nofail`: do not report error if device does not exist
  * `nofail,x-systemd.device-timeout=1ms`: removable device
* fsck: 1 for root, 2 for other, 0 to disable

[systemd mount](https://www.freedesktop.org/software/systemd/man/systemd.mount.html)

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
[raid reliability](https://wintelguy.com/raidmttdl.pl)

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
  * leave some margin at the end of disk ensures easy disk replacement
  * `0xfd` makes it obvious that parition belongs to a raid
* ~~use raid on raw disk~~

[Reference](https://unix.stackexchange.com/questions/320103/whats-the-difference-between-creating-mdadm-array-using-partitions-or-the-whole)

* ~~partition on top of raid~~:
  * unless you want further divide the partition
  * partition fails when raid fails

https://serverfault.com/questions/796460/partition-table-on-one-disk-from-raid-always-equal-to-partition-table-configured
https://serverfault.com/questions/619862/should-i-partition-a-raid-or-just-create-a-file-system-on-it


## file system

https://danluu.com/deconstruct-files/
https://danluu.com/filesystem-errors/

https://news.ycombinator.com/item?id=24258444

https://stackoverflow.com/questions/2009063/are-disk-sector-writes-atomic

https://www.bswd.com/FMS12/FMS12-Rudoff.pdf

`du -sch .[!.]* *`: show file size including hidden
`ncdu`: show file size in command line, easier than `du -h`

### ext4

```bash
tune2fs -l /dev/sda # list filesystem stat
tune2fs -m 0 /dev/sda # reduce reserve to 0
```

#### expansion

1. after raid expansion, rescan the disk
   1. `echo 1>/sys/class/block/sdd/device/rescan`
2. re-write the GPT backup header at the new end of the disk 
   1. `gdisk x e`
3. resize partition
   1. `gdisk d n`
   2. `parted resizepart`
4. resize fs
   1. `resize2fs`

### iso9660

- iso is a file system definition
  - some software might interpret the iso file structure as overlapping partition
- https://superuser.com/questions/1353671/run-efi-files-scripts-from-boot-virtual-media-iso


### overlayfs

- allows one, usually read-write, directory tree to be overlaid onto another, read-only directory tree
- file -> work -> upper -> lower

[reference](https://wiki.archlinux.org/index.php/Overlay_filesystem)

### zfs

* [archlinux](https://wiki.archlinux.org/title/ZFS)
* zpool: device pool, there can be multiple pool on one system
  * storage is not shared between pools
  * vdev, virtual devices
    * there can be multiple vdev in one pool
    * parity is provided over one vdev
  * vdev types
    * mirror / raidz
      * disk / slice / file
    * hot spare
    * intent log
    * cache devices
  * dataset vs zvol:
    * zvol is used to simulate block device on top of zfs
    * `recordsize` vs `volblocksize`
* tuning
  * `ashift=12`: depending on device, can be `13` for 8K native 
  * `xattr=sa`
  * `atime=off`
  * `compression`: depending on cpu power?
  * `recordsize`: depending on workload
* arc:
  * `zfs_arc_max`
* l2arc:
  * `l2arc_noprefetch=0`: allow seq read to be cached
  * `l2arc_write_max`: max write speed for cache
  * `l2arc_write_boost`: max write speed at boot (for warmup)
* snapshot:
  * `send/receive`
  * [sanoid](https://github.com/jimsalterjrs/sanoid)

```bash
make deb
apt install zfs libnvpair libuutils libzfs libzpool zfs-dkms
## enable systemd service -> archlinux
# check various parameter
zfs list
zfs get all <pool>
zpool get all <pool>
# add vdev to pool
zpool add <pool> cache <device-id>
zpool replace
zpool remove
# check which pool is loaded during boot
zdb -C
# check various arc stat
arc_summary
arcstat
zpool iostat
```

### btrfs

https://work-work.work/blog/2018/12/01/ubuntu-1804-btrfs.html

### Filesystem in Userspace (FUSE)

- bindfs: mapping uid when mounting a fs
- mergerfs: store file across different fs

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

##

[disk firmware](https://firmware.hddsurgery.com/index.php)

mylto - tape


https://www.tjansson.dk/2013/09/migrate-from-raid-6-to-raid-5-with-mdadm/

# efi parition is mounted for easy upgrade?
sudo grub-install --target=x86_64-efi --efi-directory=/mnt/esp 
parted 
set esp on?

https://kb.netapp.com/Advice_and_Troubleshooting/Data_Storage_Software/ONTAP_OS/What_are_the_NFS_mount_options_for_databases_on_NetApp

https://dev.mysql.com/doc/refman/8.0/en/disk-issues.html

