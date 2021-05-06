---
layout: post
title:
date: 2021-05-05 17:48
category:
author:
tags: []
summary:
---

## programming

- when dealing with a possible large value, keep in mind of possible overflow
  - `a * 100000 / b;`
- remember to deallocate resource, even when exiting from error condition
- algorithm complexity is important but constant term is also important
  - I did strlen + loop through the array, which go through array twice

## debug

- how to resolve a hard to find bug?
  - debug technique + reproduction
- reproduction:
  - replay problematic input
  - stress testing the system
  - reducing performance
    - alive but laggy

## design

- when encounter a requirement, we need to add **clearity** towards all details
  - reach consensus with client
- when proposing a solution, work out the part that you are sure about
  - for the less certain part, try to propose solution based on your experience.

- constraint: what limitation a system need to ensure?
- assumption: what a system assumes to be true?
- dependency: what a system depends on for proper operate?
