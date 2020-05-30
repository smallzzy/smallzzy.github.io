---
layout: post
title: TFLite Study
date: 2019-10-08 14:53
category: 
author: 
tags: [tf]
summary: 
---

## test script

```python
import tensorflow as tf

graph_def_file = "./mobilenet_v1_1.0_224/frozen_graph.pb"
input_arrays = ["input"]
output_arrays = ["MobilenetV1/Predictions/Softmax"]

converter = tf.lite.TFLiteConverter.from_frozen_graph(
  graph_def_file, input_arrays, output_arrays)
tflite_model = converter.convert()
open("converted_model.tflite", "wb").write(tflite_model)
```

## graph transform call graph

The call graph converts tensorflow model into tflite model.

```
tensorflow/lite/python/lite.py:TFLiteConverter::convert
tensorflow/lite/python/convert.py:toco_convert_impl
tensorflow/lite/python/convert.py:toco_convert_protos -> will call toco_from_protos -> modified to start gdbserver instead
```

Note:
* In `convert.py`, post train quantization is triggered by `_is_post_training_optimize`
  * In r1.14, it is being triggered if any optimization is set (optimization settings currently does not matter)
  * or if only int8 ops is used.
* If a representative dataset is provided, the activation will also be quantized
  * it is being performed at the last step _calibrate_quantize_model
  * this step will also quantize weight, I suppose this helps reduce complexity.
* in weight only mode, the inference input/output type need to be float
  * I suppose it is caused by the lack of information on data path. (todo)
* these infomation is transferred using toco_flag
  * I think using a adaptive data structure is good

```
tensorflow/lite/toco/python/toco_from_protos.py -> this is will be called in command line
pywrap_tensorflow::TocoConvert -> lite/toco/python/toco.i -> lite/toco/python/toco.h:TocoConvert

```

```
lite/toco/toco_tooling.cc:toco::Import
lite/toco/toco_tooling.cc:toco::Transform
lite/toco/toco_tooling.cc:toco::Export
```

```
lite/toco/toco_tooling.cc:toco::TransformWithStatus
toco::RunGraphTransformationsWithStatus
toco::GraphTransformationPass -> position of transformations
```

## Some helpful gdb setup lines

Read more [here]({{site.asset_url}}/files/gdb.sh)

## Questions to be answered.

* In what way how does graph transformation change the graph?
  * basically, change graph to tflite format.
  * todo: review more possible optimize here.
* [How to determine quantization range?]({% post_url 2019-10-09-tflite-quantize %})
* [how each operation is performed?]({% post_url 2019-10-18-tflite-interpreter %})
  * They have optimized implementation in lite/kernels
  * Does not seem to be gpu-optimized.
  * Be aware of possibly different interpreter / op_resolver.

## variable regularization

```python
regularizer = tf.contrib.layers.l2_regularizer(scale=0.1)
tf.layers.conv2d(kernel_regularizer=regularizer)
reg_losses = tf.get_collection(tf.GraphKeys.REGULARIZATION_LOSSES)
loss = tf.add_n([base_loss] + reg_losses, name="loss")
```
