---
layout: post
title:
date: 2020-05-16 20:06
category:
author:
tags: [misc]
summary:
---

## interface setup

- show interface `/sys/class/net`
- interface: `ip link set eth1 up/down`
- static ip: `ip addr add/del 192.168.50.5 dev eth1`
- routing table:
  - `ip route show`
  - static route `ip route add 10.10.20.0/24 via 192.168.50.100 dev eth0`
    - default gateway: `ip route add default`
  - check which route will be taken `ip route get`
  - default route (gateway) is taken when no specific route is available
- arp table:
  - `ip neigh`
- maxmtu: `ip -d link list`
  - set mtu: `ip link set dev eth0 mtu 1400`

- ethtool: check network interface status
  - `-m`: read eeprom info
  - `-t`: self test

- netstat: check socket binding
  - -t (tcp), -u (udp), -x (unix)
  - -l: show listening
  - -p: process
  - -n: show numeric value (like ip) directly

### other tools

- find network interfaces `/sys/class/net`
- ifupdown
  - `/etc/network/interfaces`
  - `https://wiki.debian.org/NetworkConfiguration`
- ifconfig -> ip
  - `netstat`
- NetworkManager -> nmcli
  - https://fedoraproject.org/wiki/Networking/CLI
  - `unmanaged-devices`
  - `*/NetworkManager/conf.d/`
- netplan
  - https://netplan.io/examples/

## networking suite

IP suite (OSI)

1. (physical)
2. link (data link): mac
3. internet (network): ip
4. transport (transport): tcp/udp
   1. Transmission Control Protocol (TCP)
   2. User Datagram Protocol (UDP)
5. application (session, presentation, application): ssl/tls

## (physical)

- small form-factor pluggable (SFP)
  - direct attached cable (DAC)
    - no transceiver
  - active copper?
  - active optical cable (AOC)
- media independent interface (MII)
  - connect mac and phy
- Magnetics?
  - connect to RJ45
- T568 A/B
  - 10 / 100 Mbit use two pairs (1-2, 3-6)

[fiber](https://www.multicominc.com/training/technical-resources/single-mode-sfp-vs-multi-mode-sfp/)

### SFP & QSFP

- SFP, SFP+, SFP28
  - 1G, 10G, 25G
- QSFP+, QSFP28
  - QSFP was not widely adopted?
- the modules are usually backward-compatible
- switch need to support breakout to split QSFP into SFP

[infiniband data rate](https://en.wikipedia.org/wiki/InfiniBand)

### fiber

- connector
  - LC
    - CWDM4
  - MPO
    - SR4, PSM4
    - type A / B / C : different fiber cross over pattern
- ferrule: how fiber contact
  - PC, UPC, APC
- cable (ISO11801)
  - related to `mode` of light
  - single mode -> long reach
    - OS1, OS2 -> yellow
  - multi mode -> short reach
    - OM1, OM2 -> led, orange
    - OM3, OM4 -> laser, aqua
    - OM5
      - WDM is specified on MMF since OM5
  - larger core means less distance
- wavelength
  - 850, 1300, 1550
  - scattering and absorption
    - water band
- wavelength division multiplexing
  - in comm, we call it frequency division multiplexing
  - transmit multiple wavelength on the same fiber
  - Coarse WDM (20 nm)
  - Dense WDM (0.8 nm)

## link

1. Shared media / Repeater / Hub (same segment):
   1. CSMA/CD
2. Switch (different segment, same scope):
   1. segment determined by physical connection, scope determined by subnet mask
   2. Address Resolution Protocol: knowing ip, broadcast request for a mac address
   3. redundant links to achieve high availibity (STP)
   4. multiple links for high throughput (aggregation)
      1. link aggregation group, LAG
      2. link aggregation control protocol, LACP(802.1ax)
         1. active, passive
         2. `bonding`, `ifenslave`
   5. LLDP (802.1AB): discovery capability on link
   6. use `bridge` to form a software switch
3. Router (different scope)
   1. packet cross different scope via default gateway
   2. QoS:
   3. UPnP
   4. NAT

## internet

- `mtr`: my trace route -> much better interface
- `traceroute` return packet path to host
  - by setting incrementing ttl number
- `tracepath` also traces mtu size

### reserved address

- unicast: transmit from point to point
  - unspecified: `0.0.0.0`, `::`
  - loopback: `127.0.0.1`, `::1`
- multicast: transmit to one group of addresses
  - `224.0.0.0/4` `FF00::/8`
  - [wiki](https://en.wikipedia.org/wiki/Multicast_address)
- boardcast: transmit to a certain domain?
  - ipv4
- anycast: transmit to any one in the group
  - ipv6

### reserved scope

- IPv4
  - private(RFC 1918): 10./8, 172.16./12, 192.168./16
  - link-local: 169.254.0.0/16
- IPv6
  - link-local: fe80::/10

### IPv6

- left-most continuous zero octets can be compressed as `::`
  - otherwise, each octet needs to retain at least one zero
- wrapped in square bracket so `:` is not confused with port number

### fragmentation

- maximum transmission unit (MTU)
  - specify the max bytes through one link
- packet will be fragmented when exceeding MTU
  - maximun segment size (MSS) in tcp header
    - usually set to MTU - tcp header size
  - udp packet do not have size constraint
  - if one segment is lost, the whole packet is resent
    - Do not fragment (DF) force packet to be dropped instead
- MTU Discovery is done through ICMP message
  - `ping -M do -s 2000`: force mtu discovery
  - icmp might be blocked on old firewall
- In IPv6, mtu discovery and DF is required in protocol?

[fragmentation](https://blog.cloudflare.com/ip-fragmentation-is-broken/)

## switch

- switch algorithm:
  - required because the port can be shared
  - cut-through: forward the packet after reading the mac
  - store-and-forward: store and check the packet before forwarding
  - fragment-free: forward the packet after reading 64 byte
- switching memory
  - shared
  - matrix
  - bus
- transparent bridging
  - learning
  - flooding (arp)
  - forwarding
  - filtering
    - do not forward packet on same segment
  - aging
- architecture
  - access
  - core

[howstuffworks](https://computer.howstuffworks.com/lan-switch.htm)

## Spanning Tree Protocol / Shortest Path Bridging

- this tech has evolved several times
  - STP 802.1d
  - RSTP 802.1w
  - MSTP 802.s
- the goal is to find the shortest route to root bridge
  - root bridge can be found automatically. (prefer manual setting)
  - if root bridge is different from default gateway, unncessary traffic might be generated.
- bridge protocol data units (BPDU) is constantly being shared between nodes
  - calculate path cost to root bridge
  - path cost can be determined by admin
- based on cost, we determine best path to specific segment
  - root port: uplink to root bridge
  - designated ports: downlink to another segment
  - avoid boardcast storm
- MSTP considers all vlan to be the same tree
  - either enable trunk on all port
  - or per-vlan RSTP?

### guard

- bpdu guard: disable STP on undesired port
- root guard: disable STP from changing manually designated root switch
  - not recommanded
- loop guard
  - normally, ports will be disabled based on BPDU
  - if a unidirectional failure cause BPDU to be lost, switch might choose to forward packet through the port. Which defeats STP
  - loop guard disable that port with unidirectional failure

## vlan 802.1q

- tag range: 1-4094
- trunk
  - allow vlan to be transmitted between switch and / or switch
  - trunk port / tagged port
  - access port / untagged port
- native vlan
  - configured per trunk
  - a untagged vlan on trunk port get native vlan
  - backward compatible with device w/o vlan
- instead of configure vlan group on every device, configure on one device and propagte
  - GARP -> MRP
  - GMRP -> MMRP
  - GVRP -> MVRP
- dynamic vlan: assign vlan based on mac
  - Cisco: VLAN Member Policy Server

### L3 Switch

- route between vlan without packets leaving the switch
- L3 can work between following elements
  - Router Interface: a single port to another router
  - Port Channel: port aggregation to another router
  - Vlan Interface: between vlan groups
- L3 switch might have different forwarding capacity for L3 switching

## transport

## rdma

- Forward Error Correction (FEC):
  - mellanox might enable FEC by default

ECN?

VPI

OFED -> rdma-core -> libfabric
openucx

## DCB

- PFC
  - Priority Code Point (PCP)
    - 3 bits in Vlan
  - Differentiated Services Code Point (DSCP)
  - global pause?
- ETS
- DCBX
  - LLDP
- QCN

## dhcp

- for vlan
  - dhcp server for each vlan
  - multi-homed dhcp + dhcp relay
- [dhcp options](https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml)
  - 15: domain name, 119: domain search
  - 26: mtu

## application

## zeroconf

- traditional dns, unicast
- multicast dns (mDNS, RFC6762)
  - resolve on link local network
  - `.local` domain
  - boujour, avahi
  - `avahi-browse --all --ignore-local --resolve --terminate`

## service discover

- SSDP / UPnP
- WS-Discovery
- DNS-SD
  - query DNS PTR record
  - returns SRV and TXT

http://www.dns-sd.org/ServiceTypes.html

LLDP?
SNMP?

## http

- compression: `Accept-Encoding`
- `Connection: Keep-Alive`
  - persistent connection, reuse tcp connection
  - http 1.1: persistent by default
  - http 2: do not use this header
  - http 2: multiplex requests over a single TCP connection
- `Connection: Upgrade`

quic?

## REST

Representational state transfer (REST) is a style to design api.

- Uniform interface
- client-server architecture
- statelessness
- cacheability
- layered system
- code on demand

## todo

`nmap`

VRPP

https://docs.cumulusnetworks.com/cumulus-linux-40/Monitoring-and-Troubleshooting/Troubleshooting-Network-Interfaces/Monitoring-Interfaces-and-Transceivers-Using-ethtool/

https://frrouting.org/

[tuning](https://fasterdata.es.net/)
