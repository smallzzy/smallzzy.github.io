---
layout: post
title: 
date: 2020-02-10 16:13
category: 
author: 
tags: []
summary: 
---

This post is a reading note from panic software.

Normal function can start and finish.
Coroutine in addition can suspend and resume.

Think about generator in python.
The function suspends on `yield` and resumes on `next`

## Advantage

* fast context switch
* can customize scheduler based on application

## stackful vs stackless

The naming indicates if a full call stack needs to be maintained when coroutine suspends.

With a stack, stackful coroutine can suspend in any called function.
But stackless coroutine can only suspend in top level function.

## note on boost::fiber

* stackful
* the fiber holds a pool of context, which is run based on scheduler
* function call is run in a new context
  * the call stack exists with respect to the context object
  * yield is similar to a blocking system call, which only returns on resume

## reference

[intro](https://blog.panicsoftware.com/coroutines-introduction/)
[sample project](https://blog.panicsoftware.com/your-first-coroutine/)
