---
layout: post
title: 
date: 2020-05-29 19:52
category: 
author: 
tags: []
summary: 
---

## print precision

`torch.set_printoptions(precision=20)`

## parameter vs buffer

* Parameter is learnable and is exposed in model.parameters
  * register is automatic for submodule but not tensor
  * nn.Parameter
* buffer is not learnable
  * register_buffer

## nn.ModuleList

> ModuleList can be indexed like a regular Python list, but modules it contains are properly registered, and will be visible by all Module methods.

## torch seed

```python
torch.manual_seed(191009)
```

## set and get module from torch model

```python
# Generalization of getattr
def _get_module(model, submodule_key):
    tokens = submodule_key.split('.')
    cur_mod = model
    for s in tokens:
        cur_mod = getattr(cur_mod, s)
    return cur_mod

# Generalization of setattr
def _set_module(model, submodule_key, module):
    tokens = submodule_key.split('.')
    sub_tokens = tokens[:-1]
    cur_mod = model
    for s in sub_tokens:
        cur_mod = getattr(cur_mod, s)

    setattr(cur_mod, tokens[-1], module)
```
## memory

https://github.com/Stonesjtu/pytorch_memlab

## distributed training

1. depending on how a task is started, we need to derive env differently
   1. [mmcv](https://github.com/open-mmlab/mmcv/blob/master/mmcv/runner/dist_utils.py)
   2. `python -m torch.distributed.launch --nproc_per_node=NUM_GPUS_YOU_HAVE`
      1. `--local_rank` needs to be parsed
2. `torch.cuda.set_device(local_rank)`
   1. `torch.cuda.get_current_device()`
3. `dist.init_process_group`
   1. read config from env or a key-value store
      1. `world_size`: total number of process
      2. `rank`: id in the world
      3. `local_rank`: id on a specific node, equals rank if one a single machine
   2. initialize communication backend: gloo vs nccl
4. setup model
   1. `model = ToyModel().to(local_rank)`
   2. `ddp_model = DDP(model, device_ids=[local_rank])`

### DataParallel

`torch/nn/parallel/data_parallel.py`

> In each forward, `module` is **replicated** on each device, 
> so any updates to the running module in `forward` will be lost.

> **in-place** updates to the parameters or buffers on ``device[0]`` will be recorded

### DistributedDataParallel

`torch/nn/parallel/distributed.py`

> Parameters are never broadcast between processes.

> Buffers are broadcast from the module in process of rank 0,
> to all other replicas in the system in every iteration

1. cannot create new parameter because it will not be registered in optimizer
2. cannot resize existing paramter because it has require_grad state
3. replace `.data` is the way to go
   1. initialize on multiple gpu might be problematic?
