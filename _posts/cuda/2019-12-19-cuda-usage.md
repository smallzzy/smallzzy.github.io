---
layout: post
title: 
date: 2019-12-19 14:40
category: 
author: 
tags: [gpu]
summary: 
---

## executation

grid -> block -> thread -> warp

* thread shares:
  * register file
  * shared memory
* block can only be assigned to one SM
* one SM can hold more than one block
* SM resources are partitioned among all threads and blocks
  * limit the amount of active warp

## memory

| Type     | Specifier    | Position | Cache | Note                              |
| -------- | ------------ | -------- | ----- | --------------------------------- |
| Register | N/A          | on chip  |       | Will spill to local if cannot fit |
| local    | N/A          | off chip | L1    |
| shared   | `__shared__` | on chip  | L1    |
| global   |              | off chip | L2    |
| constant | `constant`   |

* L0 is used for instruction cache

## unified memory

```c++
cudaMallcManaged()
cudaMemAdvise()
cudaMemPrefetchAsync()
cudaStreamAttachMemAsync()
```

* 49 bit addressing -> x86 currently has 48 bit addressing
* based on page fault
  * cannot access concurrently from host and device
  * only allocated when used -> can appear on gpu
  * sync mmu on cpu and gpu?

### (not) uniform memory access

* for UMA, cpu should be able to operate directly on the memory
  * no memory transfer, zero copy
* in cuda, the driver takes care of memory transfer?

## access

## shuffle

## sync behavior

* kernel calls are always async wrt host

`Device`
`Stream`
`event`
`threads`

[API Sync](https://docs.nvidia.com/cuda/cuda-runtime-api/api-sync-behavior.html#api-sync-behavior)
[Stream Sync](https://docs.nvidia.com/cuda/cuda-runtime-api/stream-sync-behavior.html#stream-sync-behavior)

## nvprof

* achieved_occupancy
* branch_efficiency
* gld_throughput
* inst_per_warp
  * divergence can cause high inst
* stall_sync

## Hyper-Q

Starting from Kepler, CUDA kernels can be processed concurrently on the same GPU.

## Multi-Process Service (MPS)

Enable multiple processes to co-operate.

Starting from Volta, MPS client talk to GPU without passing through MPS server.

[Reference](https://docs.nvidia.com/deploy/pdf/CUDA_Multi_Process_Service_Overview.pdf)

## Multi-Instance GPU (MIG)

Supported in A100.
Let GPU to be partitioned into separate GPU instance.
I suppose it is best fit for multiple users.

[Reference](https://docs.nvidia.com/datacenter/tesla/mig-user-guide/index.html)

## tensor core

* tensor core has a fixed calculation pipeline
  * out = A * B + C
* accessed via `nvcuda::wmma`
