---
layout: post
title: 
date: 2020-08-17 03:40
category: 
author: 
tags: [misc]
summary: 
---

## exact cover

* an exact cover S of X satifies two conditions:
  * The intersection of any two distinct subsets in S is empty
  * The union of the subsets in S* is X
* represent exact problem as a matrix:
  * row = all subsets = possible solutions
  * column = element of the cover = constraint of the problem
* an exact cover can be solved by Algorithm X:
  * choose a column (deterministically)
    * preferably with a column with less valid rows
  * choose a row (nondeterministically)
    * basically, guess between all the valid rows
  * remove other rows that contains same cover as the chosen row
  * repeat until no column can be chosen
    * fail if a cover cannot be achieved
* Algorithm X can be implemented using dancing links:
  * implement the matrix as doubly circular linked list
    * a special headers are included so that a entire column can be removed
  * when removing nodes, two adjecent nodes are connected
    * the removed nodes still retain the connection information

## conjective normal form (CNF)
