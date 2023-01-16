---
layout: post
title:
date: 2023-01-16 13:26
category:
author:
tags: []
summary:
---

## analog format

http://what-when-how.com/display-interfaces/standards-for-analog-video-part-i-television-display-interfaces-part-1/

### NTSC

Power Grid is at 60 Hz. Thus lighting & TV are clocked at that frequency

NTSC set standard at 60i x 525 line

### scan line

Progressive - Entire frame is updated at once
Interlaced - Each frame is divided into Upper & Lower field. Only one of the field is updated

60i = 30 fps

### Frequency Band & Color signal

6 MHz band for each channel =

- 0.25 MHz guard band
- 1 MHz until the Luminance Carrier Frequency
- 4.5 MHz signal between Luminance and Audio
  - Unable to change the bandwidth otherwise Audio Demodulation will not work
  - need Chrominace signal to be added into this band
- 0.25 Mhz to the next channel

(30 / 1.001) x 525 Lines x 286 (Need a Integer?) = 4.5MHz [NTSC]
30 / 1.001 -> 29.97 fps

286 x 2 = 572 = 455 + 117 (these two number needs to be odd?)
455/2 x (30/1.001) x 525 ~= 3 579 545 Hz (Color Signal Carrier Offset)

### movie conversion

movie are shot at 24 fps
movie = 24 / 30 = 4 / 5
2：3 pulldown -> separate frame into 2 field / 3 field alternatively

### Phase Alteration Line (PAL)

50i x 625 Lines

25 x 625 Lines x 384 = 6Mhz [PAL]

Movie only need to add once repeating frame

### misc

Vestigial Sideband (VSB) Modulation
Kell Factor

### Sony's D1

D1 720x486 -> 720x480

D2, D3 ...

### misc 2

Common Intermediate Format (CIF) = 352x288
Source Input Format (SIF) = 352x240
960H = 960x480
