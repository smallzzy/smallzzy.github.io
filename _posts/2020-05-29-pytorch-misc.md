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
