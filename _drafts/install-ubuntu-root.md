---
layout: post
title:  "Install Ubuntu for Petalinux"
categories: Petalinux
---
https://wiki.ubuntu.com/ARM/RaspberryPi#Updating_the_Pi_GPU_firmware_and_bootloader_files
will create a bootable usb drive.
Which enables us to install ubuntu on local drive. aka sd card.

https://wiki.ubuntu.com/Base
a basic ubuntu install
I think the config is too hard in chroot.

linaro ubuntu-based rootfs
https://wiki.linaro.org/Platform/DevPlatform/Rootfs
http://releases.linaro.org/debian/images/developer-arm64/16.04/
https://www.linaro.org/latest/downloads/

xilinx use petalinux to generate kernel while use the rootfs from linaro 
http://www.wiki.xilinx.com/Zynq+UltraScale%EF%BC%8B+MPSoC+Ubuntu+part+1+-+Running+the+Pre-Built+Ubuntu+Image+and+Power+Advantage+Tool
http://www.wiki.xilinx.com/Zynq+UltraScale%EF%BC%8B+MPSoC+Ubuntu+part+2+-+Building+and+Running+the+Ubuntu+Desktop+From+Sources
-> contains some forum comment about the source of ubuntu base system.

We need to construct a script to copy every kernel module to the new ubunt system.

### steps

* copy over kernel module
    * mkdir lib/modules
    * cp petalinux/lib/modules/$(uname -r)  to lib/modules
* develop images has no gui
    * apt-get install xfce4


## graphics
first test on the image provided by xilinx
http://www.wiki.xilinx.com/Zynq+UltraScale%EF%BC%8B+MPSoC+Ubuntu+part+2+-+Building+and+Running+the+Ubuntu+Desktop+From+Sources

it was able to boot to desktop

* change to personally built kernel
    * able to boot
    * unable to find mali.ko -> original one appear in sdcard/mali.ko
    * ? kernel load module from its boot position?
        * might relate to u-boot commands?


Second test on the raw image from linaro
https://releases.linaro.org/debian/images/developer-arm64/18.04/

unable to boot to desktop

* missing user driver for mali
* meta-petalinux/recipes-graphcis/mali -> need debian port for this.