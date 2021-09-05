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
- [edge core note](https://support.edge-core.com/hc/en-us/categories/360002134713-Edgecore-SONiC)
- [nvidia note](https://docs.nvidia.com/networking-ethernet-software/)

## stable image

- the link starting with `sonic-jenkins` is deprecated
- the build artifact is now hosted on `https://sonic-build.azurewebsites.net/ui/sonic/pipelines`
  - `Build History` > `Artifacts` > your build name here > `sonic-boardcom.bin`
  - which is built from this azure pipeline `https://dev.azure.com/mssonic/build`
  - note: it seems to only keep the latest build artifact which might not be stable
    - so, always keep a binary that you use and confirmed to work

## note

- edit config is hard, use `show / config` if possible
  - if a config is wrong, `config reload` will fail
    - the switch is in a broken state and it might not be able to perform another reload
    - make sure to fix the config before reboot
- `reboot` is linked to a custom script which might fail in extreme cases
  - use `/sbin/reboot` to force a unclean reboot
- a interface can be in one of three states
  - `PortChannel`: a interface can be part of a bonding
    - make sure to config the bonding before connecting the cable
    - otherwise, it might cause a boardcasting storm to happen
  - `Router Port`: a interface can be used to connect to another router for L3 routing
    - it will be assigned a ip for this use.
  - `Port`: just a regular port
- For L2 switching to work, we just need to make sure that vlan is connected
  - the native vlan is always 1. But the allowed vlan depends on interface setting
  - `Port` and `PortChannel` can be used in multple vlans (ie more allowed vlan)
- For L3 routing, a client can
  - 1. take a specified route through a known device
  - 2. take the default gateway if no other rules fit
- the same principle applies for l3 router (either a actual router or a l3 enabled switch)
  - 1. route towards another router with known ip
  - 2. relay to a upper layer router
  - On a small scale, the routing can be configed manually with static ip on both router + static routing for all subnet
  - On a large scale, there is BGP for autonomous configuration

## DX010 setup

```bash
# generate base config
## there is also other presets
## use t2 as a template for core routing
sonic-cfggen -H -k Seastone-DX010 --preset=l2 # > /etc/sonic/config_db.json
config reload

# change the default hostname
config hostname sonic
config save

# change the management ip by adding the following section to config.json
# then config reload
```

```json
"MGMT_INTERFACE": {
    "eth0|192.168.128.10/24": {
        "gwaddr": "192.168.128.1"
    }
}
```

``` bash 
# error correction required for mellanox 100G card
for i in `seq 0 4 124`; do sudo config interface fec "Ethernet$i" rs; done

# breakout does not work with command
# for i in `seq 112 4 124`; do sudo config interface breakout "Ethernet$i" -u; done

# breakout by changing the config directly
# https://gist.github.com/smallzzy/019daa996446dedf342694b1a70295b2
```

```bash
# some sancheck command
## those services are run in docker and they have a systemd status.
## services failure is usually a firmware issue. try another sonic version
## ex. pmon failure will cause fan to run at full speed
show services
show environment

# specific setup commands
## command will print vlan port as trunk although that might not be true
show interface status

# vlan
## use the name Vlan200 for vlan tag = 200
show vlan brief
config vlan add / del
config vlan member add / del # use -u for untagged port

# bonding
## use the PortChannel01 for the first portchannel
show interface portchannel
config portchannel add / del
config portchannel member add / del

# routing 
## not necessary for l2 operation
show ip interface
config interface ip add
```

## meraki side note: IP Source Address Spoofing Protection 

The goal is to disallow client to use a static ip that collide with dhcp config.
i.e. to stop a malicious client from spoofing into certified ip range

But there seems to be some issues in my test.
Those issues sometimes trigger a event log with type `Source IP and/or VLAN mismatch`.
Here are my observations.

1. if the same mac is configed under two different dhcp servers, it might cause the whole dhcp subnet to be dropped.
2. if the same client is configed with a dhcp ip and a static ip, the static ip might be dropped.
3. if l3 switch is configed, there is no option to turn the protection off on the switch
   1. there is a option in the security appliance

Please follow this meraki document for a proper setup.
https://documentation.meraki.com/MX/Firewall_and_Traffic_Shaping/IP_Source_Address_Spoofing_Protection

## meraki side note: dhcp server

1. a dhcp server is only able to advertise its own ip
   1. only after it is configed under a static route, the server has the option to advertise another ip. 
2. dhcp relay does not seem to work even between meraki device.
   1. even with setting in 1, it did not work.
