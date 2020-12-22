---
layout: post
title: 
date: 2020-05-16 20:06
category: 
author: 
tags: [misc]
summary: 
---

## networking suite

IP suite (OSI)

1. (physical)
2. link (data link): mac
3. internet (network): ip
4. transport (transport): tcp/udp
  * Transmission Control Protocol (TCP)
  * User Datagram Protocol (UDP)
5. application (session, presentation, application): ssl/tls

## physical

* small form-factor pluggable (SFP)
  * direct attached cable (DAC)
    * no transceiver
  * active copper?
  * active optical cable (AOC)
* media independent interface (MII)
  * connect to mac
* Magnetics?
  * connect to RJ45
* T568 A/B
  * 10 / 100 Mbit use two pairs (1-2, 3-6)

[fiber](https://www.multicominc.com/training/technical-resources/single-mode-sfp-vs-multi-mode-sfp/)

### SFP & QSFP

* SFP, SFP+, SFP28
  * 1G, 10G, 25G
* QSFP+, QSFP28
  * QSFP was not widely adopted?
* the modules are usually backward-compatible
* switch need to support breakout to split QSFP into SFP

[infiniband data rate](https://en.wikipedia.org/wiki/InfiniBand)

### fiber

* connector
  * LC
    * CWDM4
  * MPO
    * SR4, PSM4
* ferrule: how fiber contact
  * PC, UPC, APC
* cable (ISO11801)
  * related to `mode` of light
  * single mode -> long reach
    * OS1, OS2 -> yellow
  * multi mode -> short reach
    * OM1, OM2 -> led, orange
    * OM3, OM4 -> laser, aqua
    * OM5
      * WDM is specified on MMF since OM5
  * larger core means less distance
* wavelength
  * 850, 1300, 1550
  * scattering and absorption
    * water band
* wavelength division multiplexing
  * in comm, we call it frequency division multiplexing
  * transmit multiple wavelength on the same fiber
  * Coarse WDM (20 nm)
  * Dense WDM (0.8 nm)

## protocol

1. Shared media / Repeater / Hub (same segment):
  * CSMA/CD
2. Switch (different segment)
  * Address Resolution Protocol: knowing ip, broadcast request for a mac address
  * redundant links to achieve high availibity (STP)
  * mutltiple links for high throughput (aggregation)
  * LLDP (802.1AB): discovery capability on link
  * aggregation
    * link aggregation group, LAG
    * link aggregation control protocol, LACP(802.1ax)
      * active, passive
      * `bonding`, `ifenslave`
3. Router
  * QoS:
  * UPnP
  * NAT

## switch

* switch algorithm:
  * required because the port can be shared
  * cut-through: forward the packet after reading the mac
  * store-and-forward: store and check the packet before forwarding
  * fragment-free: forward the packet after reading 64 byte
* switching memory
  * shared
  * matrix
  * bus
* transparent bridging
  * learning
  * flooding (arp)
  * forwarding
  * filtering
    * do not forward packet on same segment
  * aging
* architecture
  * access
  * core

[howstuffworks](https://computer.howstuffworks.com/lan-switch.htm)

## Spanning Tree Protocol / Shortest Path Bridging

* this tech has evolved several times
  * STP 802.1d
  * RSTP 802.1w
  * MSTP 802.s
* the goal is to select one root bridge
  * should select one manually
  * if root bridge is different from default gateway, uncessary traffic might be generated.
* bridge protocol data units (BPDU) is constantly being shared between nodes
  * calculate path cost to root bridge
  * path cost can be determined by admin
* based on cost, we determine best path to specific segment
  * root port: uplink to root bridge
  * designated ports: downlink to another segment
  * avoid boardcast storm
* MSTP considers all vlan to be the same tree
  * either enable trunk on all port
  * or per-vlan RSTP?

### guard

* bpdu guard: disable STP on undesired port
* root guard: disable STP from changing manually designated root switch
  * not recommanded
* loop guard
  * normally, ports will be disabled based on BPDU
  * if a unidirectional failure cause BPDU to be lost, switch might choose to forward packet through the port. Which defeats STP
  * loop guard disable that port with unidirectional failure

## vlan 802.1q 

* tag range: 1-4094
* trunk
  * allow vlan to be transmitted between switch and / or switch
  * trunk port / tagged port
  * access port / untagged port
* native vlan
  * configured per trunk
  * a untagged vlan on trunk port get native vlan
  * backward compatible with device w/o vlan
* l3 switch
  * support cross vlan
* instead of configure vlan group on every device, configure on one device and propagte
  * GARP -> MRP
  * GMRP -> MMRP
  * GVRP -> MVRP
* dynamic vlan: assign vlan based on mac
  * Cisco: VLAN Member Policy Server

## IP

* unicast: transmit from point to point
  * unspecified: `0.0.0.0`, `::`
  * loopback: `127.0.0.1`, `::1`
* multicast: transmit to one group of addresses
  * `224.0.0.0/4` `FF00::/8`
  * [wiki](https://en.wikipedia.org/wiki/Multicast_address)
* boardcast: transmit to a certain domain?
  * ipv4
* anycast: transmit to any one in the group
  * ipv6

### fragmentation

* maximum transmission unit (MTU)
  * specify the max bytes on one link
* MSS in tcp?
* mtu discovery
  * icmp blocked
* Do not fragment

[fragmentation](https://blog.cloudflare.com/ip-fragmentation-is-broken/)

### IPv6

* left-most continuous zero octets can be compressed as `::`
  * otherwise, each octet needs to retain at least one zero
* wrapped in square bracket so `:` is not confused with port number

## scope

* IPv4
  * private: 10.0/24, 172/16, 192.168.
  * link-local: 169.254.0.0/16
* IPv6
  * link-local: fe80::/10

## L3 Switch

* route between vlan without packets leaving the switch
* devices on vlan will use switch as the gateway
  * configure vlan interface to be a virtual device with a ip
* switch will use the router as the gateway
  * might need to disable switching in order to assign a ip

## rdma

pfc?
ECN?

PCP 802.1q Priority Code Point)
differentiated services code point (DSCP)

VPI

OFED -> rdma-core -> libfabric
openucx

## quic

## zeroconf

* traditional dns, unicast
* multicast dns (mDNS, RFC6762)
  * resolve on link local network
  * `.local` domain
  * boujour, avahi 
  * `avahi-browse --all --ignore-local --resolve --terminate`

### name service switch 

* specify how different services are resolved
  * `/etc/nsswitch.conf`
* `nss-mdns`: resolve host name with mdns

## service discover

* SSDP / UPnP
* WS-Discovery
* DNS-SD
  * query DNS PTR record
  * returns SRV and TXT

http://www.dns-sd.org/ServiceTypes.html

## http

* compression: `Accept-Encoding`
* `Connection: Keep-Alive`
  * persistent connection, reuse tcp connection
  * http 1.1: persistent by default
  * http 2: do not use this header
  * http 2: multiplex requests over a single TCP connection
* `Connection: Upgrade`

## REST

Representational state transfer (REST) is a style to design api.

* Uniform interface
* client-server architecture
* statelessness
* cacheability
* layered system
* code on demand

## tools

nmap
tracepath
traceroute

multi-homed dhcp
dhcp relay

VRPP
LLDP
cat /proc/net/dev

https://docs.cumulusnetworks.com/cumulus-linux-40/Monitoring-and-Troubleshooting/Troubleshooting-Network-Interfaces/Monitoring-Interfaces-and-Transceivers-Using-ethtool/

ethtool -m: module

        Optical diagnostics support               : Yes

ip route s 

https://frrouting.org/


MXS824 PCIE switch
