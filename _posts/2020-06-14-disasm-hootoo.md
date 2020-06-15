---
layout: post
title: 
date: 2020-06-14 19:13
category: 
author: 
tags: []
summary: 
---

Today, I tried to use my hootoo usb c hub (HT-UC007) with my fire tablet.
But it cannot charge and read a usb drive at the same time.
I first think it was a hub problem.
So, I take it apart and here is what I found.

The usb hub has a metal frame.
But the bottom plastic is held to the internal plastic frame
with 11 clips shown in the circled position.

There are 5 main chips on the hub.

VL817Q7 usb 3.1 hub
FE1.1s usb 2.0 hub
VL101Q4 dp and pd controller
PS176HDM dp to hdmi
RTL8153B 1000 Mbit ethernet to usb

The connection is the following:

* VL817 UFP connects to usb c port
  * only two lanes of usb c is needed for SS
* VL817 DFP1 connects to port 2
* VL817 DFP2 connects to port 3
* VL817 DFP3 connects to RTL chip.
* VL817 DFP4 connects to port 1 (counting from usb c side)
* VL101 controls the cc pin of usb c
  * the aux of dp port communicates over SBU (side band use)
  * the other two lanes of usb c is used for dp
* FE1.1s connects to VL101 usb 2.0

Notably, 

* usb 2.0 part of VL817 DFP3 connects to UFP of FE1.1s
* usb 2.0 part of RTL chip connects to port 1 of FE1.1s

After some research, I learnt that:

1. Ones host controller contains a root hub
2. usb devices can cascade up to 7 layers. 
i.e max 5 layers of hubs between root and device
3. usb can allow up to 127 devices. With each hub counts as one device
4. A usb device can allocate up to 32 endpoints
5. during transmission, hubs are transparent
6. during enumeration, each hub will work with host.
The intermediate hubs are transparent
7. usb 2.0 and usb 3.0 have separate data and control path
So, they can be handled simultaneously across different hubs.
8. device always talks to host
   1. there is no way for device to talk to each other directly
   2. before usb 3.0, host can only broadcast to all device
   3. since usb 3.0, host can send point to point packet.

`lsusb -t` will present the tree structure of usb devices, 
with the last number as the negotiated speed

## Reference

https://www.electronicdesign.com/technologies/embedded-revolution/article/21799762/whats-the-difference-between-usb-20-and-30-hubs
