---
layout: post
title:
date: 2023-03-03 01:27
category:
author:
tags: []
summary:
---

## expectation of raid

data read is exactly the same as data written i.e.

Within one device, the block is fully writted or not exist at all. (write should be atomic)

Between several devices, the data should match up with the parity.

## the issue at hand

1. device failure
   1. need to build redundency such that file can be re-constructed. (mirror or parity)
2. bit rot: meaning that the disk contect is changed
   1. this is usually checked internal by using ecc within a sector
3. write hole: if parity and data has a discrepency, who is correct?
   1. this can happend due to a power loss where the write does not happen
   2. or a certain copy is corrupted due to bit rot

### power loss

1. battery backed device
2. write intent log: log the action before doing it
   1. a re-scan later can make sure that all actions are perfromed

### corrupted copy

1. if a drive is out of sync with the array, the disk can contain a good ecc so that it cannot *report* a error by itself
2. for the software to detect inconsitency, there needs to be parity data on the stripe level
   1. 520 byte sector so that 8 bytes are used for parity
      1. enterprise disks usually has this function but much more expansive
   2. filesystem level checksum block? zfs?

## reference

https://www.youtube.com/watch?v=l55GfAwa8RI -> this video is really talking about write hole

https://superuser.com/questions/1031069/hdd-ssd-physical-sector-size-if-metadata-is-included

https://danluu.com/deconstruct-files/
https://danluu.com/filesystem-errors/

https://news.ycombinator.com/item?id=24258444

https://stackoverflow.com/questions/2009063/are-disk-sector-writes-atomic

https://www.bswd.com/FMS12/FMS12-Rudoff.pdf
