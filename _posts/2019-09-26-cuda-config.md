---
layout: post
title: CUDA GPU Configuration
date: 2019-09-26 12:06
category: 
author: 
tags: [gpu]
summary: 
---

## installation

### nvidia driver

This method is preferred because files are registered within the package manage system.

1. go to the [cuda website](https://developer.nvidia.com/cuda-downloads)
2. choose your OS:
   1. **do not run the command which installs cuda**
   2. use the network install method
3. after running the commands, a package called `nvidia-driver-***` will be available through the package manage system.
   1. Install the version that you prefered.

### uninstall

For ubuntu run the following command:

```bash
# notice that nvidia-docker might also be matched
sudo apt purge nvidia-*
sudo apt purge libnvidia-*
sudo apt autoremove
```

### multiple cuda version

By default, cuda will be installed in `/usr/local`

```bash
# install cuda only, do not override driver that we installed
sudo sh <run_file> --silent --toolkit
# rm the symbolic link so that multiple version can co-exist
sudo rm -rf /usr/local/cuda
```

Append to `PATH` for your specific CUDA version:
**This path will change based on cuda version.**
So follow the document in [cuda install guide](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) > post-install actions > environment setup.
Choose the correct document in the top right corner of the webpage.

For 10.0, you can use the following lines.
But notice that **the command changes for all cuda versions**.

```bash
# do not copy
CUDA_PATH=/usr/local/cuda-10.0
export PATH=$CUDA_PATH/bin:$CUDA_PATH/NsightCompute-1.0${PATH:+:${PATH}}
export LD_LIBRARY_PATH=$CUDA_PATH/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```

### cudnn

todo:

### tensorrt

[Document](https://docs.nvidia.com/deeplearning/sdk/tensorrt-install-guide/index.html)

## GPUDirect

GPU direct is a technology to help data transmission to gpu.
Its official website is [here](https://developer.nvidia.com/gpudirect)

### P2P

Exchange data between GPUs.

Should be supported by the CUDA driver

### RDMA

Used for multi-node data sharing across network, such as infiniband.

MOFED driver -> [Mellanox OpenFabrics Enterprise Distribution](https://www.mellanox.com/page/software_overview_ib)

Some basic [info1](https://www.rohitzambre.com/blog/2018/2/9/for-the-rdma-novice-libfabric-libibverbs-infiniband-ofed-mofed)
[info2](https://shelbyt.github.io/rdma-explained-1.html)

### storage

Exchange data between GPU and disk?

https://developer.nvidia.com/blog/gpudirect-storage/

## connection

### PCIe

On servers, it is possible that some pcie slot is shared by a switch.

Here are some commands to reveal such problem.

```bash
lspci
lshw
lstopo # show system topology
```

### NvLink

[Linux support](https://www.pugetsystems.com/labs/hpc/NVLINK-on-RTX-2080-TensorFlow-and-Peer-to-Peer-Performance-with-Linux-1262/)

[P2P test](https://www.pugetsystems.com/labs/hpc/P2P-peer-to-peer-on-NVIDIA-RTX-2080Ti-vs-GTX-1080Ti-GPUs-1331/#what-is-nvidia-cuda-peer-to-peer-p2p)

Run test with the following steps:

* tensorflow image: `nvcr.io/nvidia/tensorflow:19.08-py3`
* basic test: `python resnet.py --layers 50 -b 64 --precision fp16 [--use_xla]`
* test with mpi: `mpiexec --allow-run-as-root -np 2 python resnet.py --layers=50 -b 64 --precision=fp16`
  * batch size is set to 64 due to memory size

### Nvlink slot

[example on Nvidia website](https://www.nvidia.com/en-us/design-visualization/nvlink-bridges/)

![]({{site.img_url}}/nvlink_slot.jpg)

### GPU test

~~We could use NVVS ([Nvidia Validation Suite](https://docs.nvidia.com/deploy/nvvs-user-guide/index.html)) to view various information.~~
It is available in the DCGM ([NVIDIA Data Center GPU Manager](https://developer.nvidia.com/data-center-gpu-manager-dcgm))

We should use [DCGM](https://docs.nvidia.com/datacenter/dcgm/latest/dcgm-user-guide/overview.html) directly to view various informaiton.

```bash
sudo nv-hostengine # start dcgmi server
dcgmi topo --gpuid 0
dcgmi nvlink --link-status
```

there seems to be a internal memory test for nvidia card
`MOdular Diagnostic Suite (MODS)` `NVIDIA Field Diagnostic`
`MATS?`

there is a reviewer toolkit
`Latency & Display Analysis Tool (LDAT)`
`Power Capture Analysis Tool (PCAT)`
`FrameView`

## misc

### Enable persistence mode on startup

~~On 09/26/2019, [persistence does not work on startup](https://github.com/NVIDIA/nvidia-persistenced/issues/2).~~
Persistence mode does work with normal installation. The problem is that libnvidia-cfg is not installed automatically.
Such problem can be revealed by `sudo less /var/log/syslog`

Then, we are supposed to enable it like [this](https://devtalk.nvidia.com/default/topic/1048549/cuda-setup-and-installation/recommended-way-to-launch-nvidia-persistence-daemon-on-boot-login/). A modified version is available here.

The power limit can be found at [overclock.net](https://www.overclock.net/forum/69-nvidia/1706276-official-nvidia-rtx-2080-ti-owner-s-club.html)
Or [techpowerup.com](https://www.techpowerup.com/vgabios/209238/zotac-rtx2080ti-11264-181023)

```txt
[Unit]
Description=Set persistence mode and power limit of GPU
Wants=syslog.target
After=nvidia-persistenced.service

[Service]
Type=oneshot
RemainAfterExit=true
ExecStart=/bin/sh -c "nvidia-smi -pm 1 && nvidia-smi -pl <PL>"

[Install]
WantedBy=multi-user.target
```

### overclock

[Optimize GPU](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/optimize_gpu.html)

```bash
sudo nvidia-smi --auto-boost-default=0
sudo nvidia-smi -ac 2505,875 # for P2
sudo nvidia-smi -ac 877,1530 # for P3
sudo nvidia-smi -ac 2505,1177 # for G3
```
