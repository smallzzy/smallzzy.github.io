---
layout: post
title: 
date: 2019-10-09 16:12
category: 
author: 
tags: [tf]
summary: 
---

## lite/toco/graph_transformations/quantize.cc

### call graph

```
getArray -> check for minmax
ChooseQuantizationForOperatorInput
ChooseQuantizationForOperatorOutput
```

### how to determine minmax

[Some can be imported from the tensorflow model]({% post_url 2019-10-11-tflite-import %}).

But they can also be calculated from dataset.

### input

```
ChooseQuantizationForOperatorInput
```

* bias is handled specially
* min max is determined differently in training, ie not numerical minmax
  * > GetOrComputeMinMax
  * todo: what is the actual method
* > ChooseQuantizationParams
  * > scale = (rmax - rmin) / (qmax_double - qmin_double)
  
    r -> float min max
    q -> quantized value min max

  * > zero_point_from_min = qmin_double - rmin / scale
    > zero_point_from_max = qmax_double - rmax / scale
    > zero_point_from_min_error = std::abs(qmin_double) + std::abs(rmin / scale)
    > zero_point_from_max_error = std::abs(qmax_double) + std::abs(rmax / scale)

    The actual zero point is chosen from the smaller error side.
    Todo: determine why it is done like this. It relates to numeric stability.

  * the zero point is nudged into quantized range
    todo: not sure why

### output 

```
ChooseQuantizationForOperatorOutput
```

### how to quantize

> QuantizeBuffer
> const auto inverse_scale = 1. / quantization_params.scale;
> quantization_params.zero_point + inverse_scale * src_val;

quantized = 1 / scale * float + zero_point

## weight only quantize

1. weight only quantization is done in `Export > lite/tools/optimize/quantize_weight.cc:QuantizeWeightsInternal`
2. record quantizable input `InsertQuantizableInputTensorsFromOperator`
   1. `GetWeightInputIndices` only a handful of op is supported
3. symmetric quantize.
4. add dequantize when ops need float input.

## dataset quantize

* will disable weight only quantize
* a extension step that based on same model memorys

`lite/python/lite.py:_calibrate_quantize_model`
`lite/tools/optimize/quantize_model.cc:QuantizeModel`

1. feed input to interpreter
   1. `lite/python/optimize/calibration_wrapper.cc`
   2. minmax information is stored [here]({% post_url 2019-10-18-tflite-interpreter %})
2. QuantizeWeightsInputOutput
   1. weight is stored in constant buffer `lite/toco/model.h:array::buffer`
   2. tensor is stored in allocator
   3. operator is supported via `lite/tools/optimize/operator_property.cc:GetOperatorProperty`
3. ApplyConstraints
4. QuantizeBiases
5. SetInputAndOutputTypes

## quantize-aware training

[Here]({% post_url 2019-10-22-tf-quantize-training %})
