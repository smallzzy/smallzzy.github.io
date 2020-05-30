---
layout: post
title: 
date: 2019-10-08 14:47
category: 
author: 
tags: [tf]
summary: 
---

Follow these steps:

1. git clone && checkout r1.14
2. ./configure
   1. we could follow the default settings for the configure
   2. But on the server, we might want xla, cuda, tensorRT, MPI configured.
3. `pip install numpy keras_preprocessing` to installed some requirement.
4. `bazel build -c dbg --copt="-DNDEBUG" --config cuda --strip=never //tensorflow/tools/pip_package:build_pip_package` to build the wheel package
   1. `-DNDEBUG`: workaround absl string view problem
   2. `--copt="-Og"`: will crash a internal parser crash, do not use.
5. `./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg` to generate the package
6. `pip install tensorflow.whl` to install.


[more build instructions](https://github.com/mind/wheels)
[improvement](https://medium.com/@sometimescasey/building-tensorflow-from-source-for-sse-avx-fma-instructions-worth-the-effort-fbda4e30eec3)
It seems easier to just use [nvidia's build](https://ngc.nvidia.com/catalog/containers)

## clion

1. install the bazel plugin
2. ./configure the tensorflow environment
3. import tensorflow folder as bazel workspace 
4. create new workspace file as 

```
directories:
  .

derive_targets_from_directories: false

targets:
  //tensorflow/tools/pip_package:build_pip_package

additional_languages:
  python
```
