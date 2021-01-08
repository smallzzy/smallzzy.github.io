---
layout: post
title: 
date: 2021-01-07 18:33
category: 
author: 
tags: []
summary: 
---

## general link

* [command reference](https://github.com/Azure/sonic-utilities/blob/master/doc/Command-Reference.md)
* [config file](https://github.com/Azure/sonic-swss/blob/master/doc/Configuration.md)

## note

* edit config is hard, use command instead
  * `config save/reload`
* enable fec
  * `sudo portconfig -p Ethernet124 -f rs`
* assign ip to router interface
  * `show ip interface`
  * `config interface ip add`
* `show lldp neighbors`
