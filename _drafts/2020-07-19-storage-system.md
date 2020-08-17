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

* primary key: a unique key to identify each row
  * db usualy use a b+ tree for disk performance
  * a incremental primary key force node update on the right most node?
  * unique, index
  * a primary key can be created over many column
* foreign key: refers to primary key in another table
* not null: does not accept null value
* unique: indicate uniqueness on the column
  * can accept one null value
* check: check value against constraint
* default: provide default value
* index: create index to help with search
* auto increment

### language

* `SELECT *`: not used because access on unnecessary column
* string are padded with trailing space until the same length before comparison

## Ceph

object storage daemon (OSD): manage data
monitor: manage metadata -> need to reach a quorum
Reliable Autonomic Distributed Object Store (RADOS): formed by osd and monitor
based on RADOS, ceph can form object gateway, block device, file system

## todo

GlusterFS, Lustre, Spectrum Scale(GPFS), BeeGFS
