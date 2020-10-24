---
layout: post
title: 
date: 2020-07-19 03:47
category: 
author: 
tags: []
summary: 
---

## sql

### basic

* `PRIMARY KEY`: a unique key to identify each row
  * db usualy use a b+ tree for disk performance
  * a incremental primary key force node update on the right most node?
  * unique, index
  * a primary key can be created over many column
* foreign key: refers to primary key in another table
* `NOT NULL`: does not accept null value
* unique: indicate uniqueness on the column
  * can accept one null value
* check: check value against constraint
* default: provide default value
* index: create index to help with search
* `AUTOINCREMENT`

### data type

* string type: 
  * `CHAR`: fixed length (all unused space filled with blank)
  * `VARCHAR`: variable length (unused space left unused)
* 

## query

```sql
SELECT [DISTINCT | ALL] {* | select_list}
FROM {table_name | view_name}
WHERE
ORDER BY
```

## normal form

* 1NF: A relation is in first normal form if and only if the domain of each attribute contains only atomic values, and the value of each attribute contains only a single value from that domain.
* 2NF: 1NF + It does not have any `non-prime attribute` that is functionally dependent on any proper subset of any `candidate key` of the relation
  * candidate key consists of `prime attribute`
* 3NF: If all the attributes are functionally dependent on solely the primary key

To normalize a database, we usually

* create a separate table for each set of related data
* identify each set of related data with a primary key

### language

* `SELECT *`: not used because access on unnecessary column
* string are padded with trailing space until the same length before comparison

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

## mdadm

```
stride = chunk size / block size
stripe width = number of data disks * stride
```

* mdadm tracks the disks by RAID metadata (superblock)
  * multiple version exist
  * remove existing superblock by `mdadm --zero-superblock /dev/sdc`
* `/etc/mdadm/mdadm.conf` stores info to array definition?
  * `update-initramfs -u` after changing this file
* `mdadm --create --verbose /dev/md0`
  * `--level=0`
  * `--raid-devices=2`
* `mdadm --detail --scan >> /etc/mdadm.conf`
* `mdadm --assemble`
  * `--scan`
  * `--update=name --name=<>`
* `mdadm --stop`

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

## mdadm?

## zfs

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
