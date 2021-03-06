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

- [profile guide](https://docs.nvidia.com/nsight-compute/ProfilingGuide/index.html) has a good general introduction
- [compute capability](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#compute-capabilities)
- organization: grid > block > warp > thread
- `kernel<<< blocks, threads, smem, stream>>>();`

### grid

- one kernel call correspond to one grid
- grid split into many blocks

### block

- also known as Cooperative Thread Array (CTA)
- block can only be assigned to one SM
- one SM can hold more than one block
- one block can have up to 1024 threads

### warp

- group of 32 threads
  - the threads in one warp is executed at the same time

> If the number of threads in a CTA is not dividable by 32, the last warp will contain the remaining number of threads

### thread

- thread are identified by: blockIdx * blockDim + threadIdx
  - block per grid: can contain up to 3 dimension
  - thread per block: can contain up to 3 dimension

## memory

| Type     | Specifier    | Position | Cache |
| -------- | ------------ | -------- | ----- |
| register | N/A          | on chip  |       |
| shared   | `__shared__` | on chip  | L1    |
| global   |              | off chip | L2    |
| constant | `__constant__`   |

- L1 cache can split between register spill + shared memory
  - `cudaDeviceSetCacheConfig`
- local memory (refers to register + spill) can only be accessed by current thread
  - register count can be controlled when compiling with `maxregcount`
    - or deducted from `__launch_bounds__(MAX_THREADS_PER_BLOCK, MIN_BLOCKS_PER_MP)`
  - stored in global memory
    - usually available through cache
    - the access is controlled by compiler
- shared memory can be shared across a block
  - sync is most likely required
- read-only memory: instruction cache, constant memory, texture memory and RO cache
  - `cudaMemcpyToSymbol`

### host memory

- host vs device
  - pcie link is usually the bottleneck
  - `cudaHostAlloc` vs `cudaMalloc`
  - `cudaHostRegister`

### shared memory

- static: `__shared__ int s[64];`
- dynamic: `extern __shared__ int s[];`
  - require smem in kernel launch
- shared memory is access via bank
  - for same address
    - for read, we will have a boardcast. OK
    - for write, we will have a conflict
  - for same bank, we will have a serial acess for r / w. Bad
  - for different bank, we can have a higher bandwidth for r / w
    - how configurable width is done in hardware?

> Shared memory has 32 banks that are organized such that successive 32-bit words map to successive banks that can be accessed simultaneously

### vectorized memory access

- we can generate a wider copy instruction by using int2, int4 or float2
  - require alignment
- fill multiple cache lines in a single fetch

## unified memory

```c++
cudaMallocManaged()
cudaMemAdvise()
cudaMemPrefetchAsync()
cudaStreamAttachMemAsync()
```

> Global memory is a 49-bit virtual address space that is mapped to physical memory on the device, pinned system memory, or peer memory.

- supposely based on page fault
  - cannot access concurrently from host and device
  - only allocated when used -> can appear on gpu
  - sync mmu on cpu and gpu?

### (not) uniform memory access

- for UMA, cpu should be able to operate directly on the memory
- in cuda, the driver takes care of memory transfer?

## memory best practice

- multi-thread + multi-word + **multi-iteration**
- coalesced access: let consecutive thread access consecutive data
  - otherwise, multiple fetch might be needed
  - scatter & gather exist, but avoid if you can
    - scatter: read seq, write rand
    - gather: read rand, write seq
- array of struct vs struct of array
  - aos is prefered in single thread
    - aos will became strided access in simt
  - soa is prefered in simt
- [trove](https://github.com/bryancatanzaro/trove)
  - convert aos to soa for execution on cuda

## host sync

- kernel calls are async wrt host
  - use `CUDA_LAUNCH_BLOCKING=1` to debug kernel launch
- multiple kernel can operate at the same time
  - which require kernel to be launched in different stream
    - behavior can be changed when set up stream
  - default stream is in sync with all other stream
    - behavior can be changed via compile option
  - `cudaStreamNonBlocking`
  - `cudaStreamAddCallback`
  - `cudaStreamCreateWithPriority`

`cudaDeviceSynchronize`
`cudaStreamSynchronize`
`cudaStreamWaitEvent`

[Sync Rule](https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html#asynchronous-concurrent-execution)
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
- bound by hardware
  - Warps per SM
  - Blocks per SM
- bound by resorce sharing 
  - Registers per SM
  - Shared Memory per SM

> A warp is considered active from the time its threads begin executing to the time when all threads in the warp have exited from the kernel.

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
