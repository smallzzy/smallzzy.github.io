---
layout: post
title: 
date: 2019-10-18 16:08
category: 
author: 
tags: [tf]
summary: 
---

tflite/guide/inference.md

The model is created by reinterpret a raw memory directly. 

## call graph

```
Interpreter::Invoke
Subgraph::Invoke
Subgraph::OpInvoke
TfLiteRegistration::Invoke
```

## Op Registration

In tflite, ops are registerred to the interpreter.

1. lite/python/optimize/calibrator_wrapper.cc:CreateWrapperCPPFromBuffer > lite/kernels/register.cc:BuiltinOpResolver
   1. BuiltinOpResolver creates a default registration
2. the Resolver is used by BuildLocalIndexToRegistrationMapping
   1. which create flatbuffer_op_index_to_registration_
3. The mapping is used by model.cc:InterpreterBuilder::ParseNodes
   1. which retrieve registration from op_index
   2. the registration and node is added by Subgraph::AddNodeWithParameter
4. The node and registration is used in Invoke

## when is minmax being updated?

1. the info is stored in lite/schema :TensorT:quantization
2. moved by lite/tools/optimize/calibration/calibration_reader.cc:AddCalibrationToModel
   1. from logger_ -> GetCalibrationValues
3. created in lite/tools/optimize/calibration/calibrator.cc:BuildLoggingInterpreter
   1. in GetCalibratorRegistry()->CreateCalibrator
4. Calibrator is based on result stored in LoggingOpResolver
5. LoggingOpResolver overwrite TfLiteRegistration::invoke
   1. with calibrator.cc:LoggingEval
   2. calibrator is retrieved from the context. (singleton)
6. calls LogTensorValue
   1. updates tensor stats map calibration_logger.h:Update
   2. with min, max -> absolute value

## how does tensor get indexed by int?

in tensorflow, tensor is refereced by string

todo: how does this work in tflite

## special ops

### add

scale and zero point

[Reference](https://github.com/tensorflow/tensorflow/blob/r2.0/tensorflow/lite/kernels/add.cc#L99)

calculation

[Reference](https://github.com/tensorflow/tensorflow/blob/r2.0/tensorflow/lite/kernels/internal/optimized/integer_ops/add.h#L92)

### concat

scale and zero point is taken as an array

[Reference](https://github.com/tensorflow/tensorflow/blob/r2.0/tensorflow/lite/kernels/concatenation.cc#L136)

if input and output scale is the same, memcpy
if they are different,

[Reference](https://github.com/tensorflow/tensorflow/blob/r2.0/tensorflow/lite/kernels/internal/reference/reference_ops.h#L1644)