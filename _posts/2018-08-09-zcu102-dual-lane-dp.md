---
layout: post
title:  "Enable dual lane displayport on ZCU102"
date:   2018-08-09
tags: [misc]
---

I was trying to use dual lane displayport on ZCU102. 
But if I only enable dual lane dp in Vivado, petalinux will not be able to detect the display.
At the same time, I know that dual lane dp should work based on the fact that similar setup has previously worked on one ultra96 board.

ZynqMP devices will assign PCIe on GT lanes 0~3 base on x1, x2, x4 settings (in order & cannot be moved).
At the same tine, the ZCU102 schematic shows that dp has to use lane 0, 1, 
So, disabling pcie lane (in ps setting) is necessary for this application.

At the same time, the lane is chosen by PI2DBS6212 on board. 
Whose sel signals are set by TCA6416 (u97) on i2c0. 
For this application, all four lane sels need to be set high.

According to AR # 69248, petalinux 2017.1/2 has a bug such that lane selection must be done manually in user dtsi.
But in later version, the same bug still exists. Plus, the corresponding device tree part in kernel has been removed. 

In this case, I assumed that petalinux will entirely rely on the dts from u-boot (under u-boot/arch/arm/dts/).
And these options are not changed in the booting progress by default. 

So, I override device tree by editing user dtsi in the same way as AR # 69248.
Notice that the patch contains a bare minimal change for petalinux 2017.1/2. 
Whereas a full change is necessary for later version because the corresponding dt part is removed.
