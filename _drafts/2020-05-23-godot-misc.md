---
layout: post
title: 
date: 2020-05-23 00:35
category: 
author: 
tags: []
summary: 
---

## shader

Process each element separately which enables parallel processing on gpu

* vertex: runs over all vertices in the mesh,
  return its position
* fragment: runs for every pixel which is covered by mesh,
  return its color
* light: runs for every pixel and every light

https://thebookofshaders.com/

## CanvasItem / Spatial

1. attach material
2. new shader


## GLSL

* a single main function for each shader
* type: 
  * float, int, bool
  * vec2, vec3, vec4
  * mat2, mat3, mat4
  * sampler2D, samplerCube
  * rgba, xyzw, stpq
  * normalized
* in, out, inout
* c macro
* reserved global variable
  * gl_FragColor: COLOR
  * gl_FragCoord: UV
* precision
  * `precision mediump float;`: set float precision to medium
  * automatic cast type is not part of spec
  * used `.` for float
* uniform
  * can be assigned
  * have the same value across all shaders

## curve

https://docs.godotengine.org/en/stable/tutorials/math/beziers_and_curves.html
https://docs.godotengine.org/en/stable/classes/class_tween.html
https://easings.net/

## functions

* step
* smoothstep(edge0, edge1, x): apply Hermite interpolation if edge0 < x < edge1
* mix: mix color with ratio
* fract(x): return the fraction part
  * multiply to make a grid
* Faceforward, Reflect, Refract
* matrix math: translate, rotate, scale

http://www-cs-students.stanford.edu/~amitp/game-programming/polygon-map-generation/#polygons
http://www.extremeoptimization.com/Documentation/Default.aspx


https://medium.com/game-dev-daily/four-ways-to-create-a-mesh-for-a-sphere-d7956b825db4
https://medium.com/@theclassytim/robotic-path-planning-rrt-and-rrt-212319121378
https://github.com/cnr-isti-vclab/meshlab
https://github.com/PyMesh/PyMesh
