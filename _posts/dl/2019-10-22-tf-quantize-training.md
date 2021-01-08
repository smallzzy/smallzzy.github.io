---
layout: post
title: 
date: 2019-10-22 15:00
category: 
author: 
tags: [tf]
summary: 
---

## intro

This post includes some details on [quantize aware training](https://github.com/tensorflow/tensorflow/tree/r1.14/tensorflow/contrib/quantize).

contrib/python/quantize/python/quantize_graph.py:create_eval_graph
_create_graph
get_default_graph / get_concrete_function

* contrib/python/quantize/python/quantize.py:Quantize
* _FindLayersToQuantize
  * `graph_matcher` algorithm ?
  * a list of complex matching pattern is recorded in the _FindLayersToQuantize
  * find layer_match
* _InsertQuantOp
  * will quantize the following target:
    * layer_match.weight_tensor
    * layer_match.activation_op
    * layer_match.bias_add_op
    * layer_match.bypass_op,
  * will add the following node:
    * quant_ops.py:MovingAvgQuantize
    * quant_ops.py:LastValueQuantize

<!-- todo: determine the exact graph position where the nodes are added. -->

If it is training, minmax is updated with some math operations:

[Reference](https://github.com/tensorflow/tensorflow/blob/r2.0/tensorflow/contrib/quantize/python/quant_ops.py#L282)

Then, the following ops are added based on per-channel setting.

* fake_quant_with_min_max_vars_per_channel
* fake_quant_with_min_max_vars

<!-- todo: why narrow range?  -->
<!-- todo: why zero must be included? -->
<!-- todo: why minus 2 -->

After the fake quant node is inserted, the graph can be used as a normal tensorflow graph.

[Reference](https://github.com/tensorflow/tensorflow/blob/r2.0/tensorflow/core/kernels/fake_quant_ops_functor.h#L41)

The forward path:

[Reference](https://github.com/tensorflow/tensorflow/blob/r2.0/tensorflow/core/kernels/fake_quant_ops_functor.h#L143)

The backward path:

[Reference](https://github.com/tensorflow/tensorflow/blob/r2.0/tensorflow/core/kernels/fake_quant_ops_functor.h#L174)

### side note on how variable is stored

* base on [this post]({% post_url 2019-10-31-tf-basics %})
* _ModelVariable -> minmax value
* vars_collections -> default value ops.GraphKeys.GLOBAL_VARIABLES

## tf 2.0

python/eager/def_function.py:function -> `@tf.function`
* make decorator make it possible to insert function into class

ResourceVariable ? 

## tensorflow graph collection

ops.py::Graph:get_collection(_VARSCOPESTORE_KEY) 

