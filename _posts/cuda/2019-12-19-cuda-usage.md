---
layout: post
title:
date: 2019-12-19 14:40
category:
author:
tags: [gpu]
summary:
---

## execution

- organization: grid > block > warp > thread
- `kernel<<< blocks , threads, smem, stream>>>();`

### grid

- one kernel call correspond to one grid
- grid split into many blocks

### block

- block can only be assigned to one SM
- one SM can hold more than one block
- one block can have up to 1024 threads

### warp

- group of 32 threads
  - the threads in one warp is executed at the same time
- state: selected, eligible, stalled, active
  - active = eligible + stalled

### thread

- thread are identified by: blockIdx * blockDim + threadIdx
  - block per grid
  - thread per block

## memory

| Type     | Specifier    | Position | Cache |
| -------- | ------------ | -------- | ----- |
| register | N/A          | on chip  |       |
| shared   | `__shared__` | on chip  | L1    |
| global   |              | off chip | L2    |
| constant | `constant`   |

- L1 / shared memory split
  - register will spill to L1 if cannot fit?
  - all threads in a block can access the same shared memory
- register and shared memory is shared by all active threads
  - theoretical occupancy
- read-only memory: instruction cache, constant memory, texture memory and RO cache
- L2 cache is shared between all block

## unified memory

```c++
cudaMallcManaged()
cudaMemAdvise()
cudaMemPrefetchAsync()
cudaStreamAttachMemAsync()
```

- 49 bit addressing -> x86 currently has 48 bit addressing
- based on page fault
  - cannot access concurrently from host and device
  - only allocated when used -> can appear on gpu
  - sync mmu on cpu and gpu?

### (not) uniform memory access

- for UMA, cpu should be able to operate directly on the memory
- in cuda, the driver takes care of memory transfer?

### shared memory

- static: `__shared__ int s[64];`
- dynamic: `extern __shared__ int s[];`
  - require smem in kernel launch
- shared memory is access via bank
  - if same address, we will have a boardcast. OK
  - if same bank, we will have a serial acess. Bad
  - if different bank, we can have a higher bandwidth
    - configurable width?

### vectorized memory access

- we can generate a wider copy instruction by using int2, int4 or float2
  - require alignment

## host sync

- kernel calls are async wrt host
- stream sync means that kernel will not operate at the same time
  - which is possible if no dependency
  - default stream is in sync with all other stream
    - behavior can change via compile option
  - `cudaStreamNonBlocking`
  - `cudaStreamAddCallback`
  - `cudaStreamCreateWithPriority`

`cudaDeviceSynchronize`
`cudaStreamSynchronize`
`cudaStreamWaitEvent`

[Sync Rule](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#explicit-synchronization)
[API Sync](https://docs.nvidia.com/cuda/cuda-runtime-api/api-sync-behavior.html#api-sync-behavior)
[Stream Sync](https://docs.nvidia.com/cuda/cuda-runtime-api/stream-sync-behavior.html#stream-sync-behavior)

## device sync

- `__syncthreads()`: wait for all threads in the same block
  - dead lock if some threads do not make the call

### cooperative group

To achieve sub-block sync, we use [cooperative group](https://developer.nvidia.com/blog/cooperative-groups/)

## nvprof metric

- issue efficiency
- branch_efficiency
- gld_throughput
- inst_per_warp
  - divergence can cause high inst
- stall_sync

### occupancy

- achieved vs theoretical
- Warps per SM
- Blocks per SM
- Registers per SM
- Shared Memory per SM

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

- tensor core has a fixed calculation pipeline
  - `out = A * B + C`
- accessed via `nvcuda::wmma`

## todo

access

shuffle
