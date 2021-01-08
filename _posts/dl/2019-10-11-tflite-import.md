---
layout: post
title: 
date: 2019-10-11 11:07
category: 
author: 
tags: [tf]
summary: 
---

## call graph

```
lite/toco/toco_tooling.cc:Import
lite/toco/import_tensorflow.cc:ImportTensorFlowGraphDef
lite/toco/import_tensorflow.cc:GetTensorFlowNodeConverterMap
lite/toco/import_tensorflow.cc -> minmax is stored in fake quant node
ConvertFakeQuantWithMinMaxArgs / ConvertFakeQuantWithMinMaxVars
```

```
minmax is stored in FakeQuantOperator
which is converted from 
core/framework/node_def.proto -> attr
core/framework/graph.proto
```


In tflite, the model information is converted to the model structure.
`lite/toco/model.h:Model`, 

todo: analyze how different data is store in array here.
`lite/toco/model.h:Array`

