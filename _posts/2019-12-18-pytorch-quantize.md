---
layout: post
title: 
date: 2019-12-18 15:48
category: 
author: 
tags: []
summary: 
---

## mode

1. dynamic quantization: weight-only quantization, activation quantization is done dynamically
   1. main usage is to reduce model size
   2. `torch.quantization.quantize_dynamic()`
2. static quantization: weight-only quantization, activation quantization is calibrated via dataset
   1. calibration dataset is too small to train a model
3. quantization aware training (qat): weight is updated during re-train

for static quant and qat, the following steps are used
(Or, we could use `torch.quantization.quantize()`. Which wraps the entire process)

### steps

1. modify the model
   1. specify where activations are quantized and de-quantized
      1. adding `QuantStub` and `DeQuantStub` to activation path
   2. modify ops to quantized version
      1. for example, replace `add` with `nn.quantized.FloatFunctional().add()`
   3. fuse ops
      1. : `torch.quantization.fuse_modules`
2. set quantization configuatrion
   1. change `<model>.qconfig` or use `qconfig_dict`
   2. default config `torch.quantization.default_qconfig`
3. prepare the model:
   1. `torch.quantization.prepare()`, `torch.quantization.prepare_qat()`
      1. propagate qconfig to submodules
      2. attach leaf nodes with observer in forward hook
      3. the hook will be dropped if the module is later swapped
4. calibrate or train
5. save the model
   1. `torch.quantization.convert()`
      1. Before convertor, `stub` is simply Identity
      2. But with `prepare`, a quantization is attached
      3. after qat freeze, the qconfig is consolidated?
   2. quantize the weight
   3. save activation scale and bias
   4. replace ops with quantized version

### fuse

`fuse_modules()`

* `modules_to_fuse`: user provides the name of modules to be fused.
  * the name will be used to get the type of module
* `fuser_func`: the module will be fused using this function
  * The default version supports the following combination:

```txt
conv, bn
conv, bn, relu
conv, relu
linear, relu
```

## misc

`mapping`: map normal module to its quantized counterparts
`qconfig`: contain a observer generator which create observer for input / weight

* `QConfigDynamic`: qconfig class used in static quant.
  * contains a observer
* `QConfig`: qconfig class used in qat
  * contains fake quant node, which is built upon a observer
* `Observer`:
  * will track the statistics of the tensor.
  * And calculate scale and zero point based on the statistics
  * by default, inherted from `_ObserverBase`.
    * Which take `qscheme` and `dtype` as parameter
* `FakeQuantize`:
  * will simulate the quantize and dequantize of the tensor.
  * The quantize is performed based on `Observer`'s scale and zero point.

`torch.qscheme`: control quantization mode

* per-tensor / per-channel
* asymmetric(`affine`) / symmetric

`torch.dtype`: tensor type for quantization

* `quint8`
* `qint8`
* `qint32`

### modules

`torch.nn`: float version ops
`torch.nn.quantized`: fix point ops
`torch.nn.qat`: float ops for quantize aware training

`torch.nn.intrinsic`: fused ops are here
