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

- [quick start](https://github.com/Azure/SONiC/blob/master/doc/SONiC-User-Manual.md)
- [command reference](https://github.com/Azure/sonic-utilities/blob/master/doc/Command-Reference.md)
- [config file](https://github.com/Azure/sonic-swss/blob/master/doc/Configuration.md)

## note

- `config` & `show`
- edit config is hard, use command instead
  - `config save`: save working config to file
  - `config reload`: reload from config file
  - if a config is wrong, make sure to fix it before reboot
- enable fec
  - `portstat`
  - `sudo portconfig -p Ethernet124 -f rs`
- assign ip to router interface
  - `show ip interface`
  - `config interface ip add`
- `show lldp neighbors`
- `show interfaces status`: will print vlan port as trunk although that is not true

## DX010 setup

```bash
# generate base config
sonic-cfggen -H -k Seastone-DX010 --preset=l2 # > config_db.json
config hostname sonic

# error correction required for mellanox card
for i in `seq 0 4 124`; do sudo config interface fec "Ethernet$i" rs; done

# breakout does not work with command
# for i in `seq 112 4 124`; do sudo config interface breakout "Ethernet$i" -u; done
# https://gist.github.com/smallzzy/019daa996446dedf342694b1a70295b2
```

```json
"MGMT_INTERFACE": {
    "eth0|192.168.128.10/16": {
        "gwaddr": "192.168.128.1"
    }
}
```
