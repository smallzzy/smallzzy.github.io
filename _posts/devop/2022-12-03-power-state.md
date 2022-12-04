---
layout: post
title:
date: 2022-12-03 21:44
category:
author:
tags: []
summary:
---

## [ACPI States](https://uefi.org/specifications)

ACPI-defined State Definitions:

- Global system power states (G-states, S0, S5)
- System sleeping states (S-states S1-S4)
- Device power states (D-states)
- Processor power states (C-states)
- Device and processor performance states (P-states)

[Power States for Intel](https://www.intel.com/content/dam/www/public/us/en/documents/datasheets/xeon-e3-1200v3-vol-1-datasheet.pdf)

- G0 - Working
  - S0 - Processor Fully Po
    - C0 - Active mode
      - P* - Performance mode
    - C* - Processor Partially Off
- G1 - Sleeping
  - S* - Suspend to Ram / Disk
- G3 - Mechanical Off

## Windows

Review current power state support on Windows
`powercfg /a`

## Reference

https://www.dell.com/support/kbdoc/en-us/000060621/what-is-the-c-state

https://docs.microsoft.com/en-us/windows/win32/power/system-power-states
