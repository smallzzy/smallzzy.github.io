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
  * ipv4 broadcast through the all one address
  * ipv6 does not have broadcast
  * maximum transmission unit (MTU) is max size of a ip packet
  * [fragmentation](https://blog.cloudflare.com/ip-fragmentation-is-broken/)
4. transport (transport): tcp/udp
  * Transmission Control Protocol (TCP)
  * User Datagram Protocol (UDP)
5. application (session, presentation, application): ssl/tls

### physical

* small form-factor pluggable (SFP)
* media independent interface (MII)
  * connect to mac
* Magnetics?
  * connect to RJ45
* T568 A/B
  * 10 / 100 Mbit use two pairs (1-2, 3-6)

### protocol

1. Shared media / Repeater: 
  * CSMA/CD
2. Switch
  * Address Resolution Protocol: knowing ip, broadcast request for a mac address
  * Spanning Tree Protocol / Shortest Path Bridging
3. Router
  * QoS:
  * UPnP
  * NAT

## IPv6

* left-most continuous zero octets can be compressed as `::`
  * otherwise, each octet needs to retain at least one zero
* wrapped in square bracket for port number
* address
  * localhost: `::1`?
  * unspecified: `::`?
  * unique local: `fc00::/7`
* scope?
  * 

boardcast domain
vlan

## REST

Representational state transfer (REST) is a style to design api.

* Uniform interface
* client-server architecture
* statelessness
* cacheability
* layered system
* code on demand

## http

* compression: `Accept-Encoding`
* `Connection: Keep-Alive`
  * persistent connection, reuse tcp connection
  * http 1.1: persistent by default
  * http 2: do not use this header
  * http 2: multiplex requests over a single TCP connection
* `Connection: Upgrade`

## socat

connect bitstream between two address

* address
  * open: file
  * exec
  * create
  * various network protocol
* options
* option group
* split io: `!!`

## quic

## zeroconf

## tools

nmap
tracepath
traceroute
