---
layout: post
title:
date: 2023-03-03 01:27
category:
author:
tags: []
summary:
---

## expectation

data read is exactly the same as data written

i.e. correct errors even when the drive itself does not report it

-> can drive detect errors?

## the issue at hand

1. device missing (ex. due to failure)
   1. need to build redundency such that file can be re-constructed. (mirror or parity)
2. bit rot: meaning that the disk contect is changed
   1. need to perfrom some form of checks to make sure data read is correct
3. write hole: if parity and data has a discrepency, who is correct?
   1. this can happend due to a power loss or a *bit rot*

## bit rot

1. can a disk know that if has a rotten bit?
   1. ecc within a sector
      1. how is this even exposed?
   2. if a drive is out of sync with the array, it can still contain a good ecc
      1. can this happen in nomral condition??
2. can the software know that if there is a rotten bit
   1. parity should be checked on each read ? performance hit?
   2. 520 byte sector so that 8 bytes are used for parity
      1. enterprise disks usually has this function but much more expansive
   3. filesystem level checksum block? zfs?

## write hole

1. battery backed device
2. write intent log: log the action before doing it

## reference

https://www.youtube.com/watch?v=l55GfAwa8RI

https://superuser.com/questions/1031069/hdd-ssd-physical-sector-size-if-metadata-is-included

https://danluu.com/deconstruct-files/
https://danluu.com/filesystem-errors/

https://news.ycombinator.com/item?id=24258444

https://stackoverflow.com/questions/2009063/are-disk-sector-writes-atomic

https://www.bswd.com/FMS12/FMS12-Rudoff.pdf
