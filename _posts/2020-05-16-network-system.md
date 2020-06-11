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

### protocol

1. Shared media / Repeater: 
  * CSMA/CD
2. Switch
  * Address Resolution Protocol: knowing ip, broadcast request for a mac address
  * Spanning Tree Protocol / Shortest Path Bridging
  * https://en.wikipedia.org/wiki/IPv6_address
3. Router
  * QoS:
  * UPnP
  * NAT

## REST

Representational state transfer (REST) is a style to design api.

* Uniform interface
* client-server architecture
* statelessness
* cacheability
* layered system
* code on demand

## sockets

* address domain + socket type
  * domain = unix / internet + port (>2000 is generally available)
  * type = stream (tcp) / datagram (udp)
* unix socket is a file
  * it might not have a name
  * nor in the filesystem namespace?
  * file descriptor passing?

## http

* compression: `Accept-Encoding`
* `Connection: Keep-Alive`
  * persistent connection, reuse tcp connection
  * http 1.1: persistent by default
  * http 2: do not use this header
  * http 2: multiplex requests over a single TCP connection
* `Connection: Upgrade`

## quic

## zeroconf
