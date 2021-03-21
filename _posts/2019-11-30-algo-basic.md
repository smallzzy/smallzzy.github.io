---
layout: post
title: 
date: 2019-11-30 17:51
category: 
author: 
tags: [misc]
summary: 
---

## data structure

Lookup the complexity [here](https://www.bigocheatsheet.com/).

### linear

1. array
2. linked list
   1. n integers in range [1, n] can be interpreted as linked list
3. skip list
   1. In linked list, search will take O(n)
   2. Skip list choose to build indexes list that skip nodes in the list.
   3. When doing the search, we will search the most sparse list and proceed to the denser list.
   4. We improve by effectively reducing search size n.
   5. The layer of indexes is randomly decided when inserting a node.
4. disjoint-set / union-find / merge-find
   1. flatten the tree by setting intermediate node' parent to actual parent during find
5. Floyd's Algorithm: find a loop in linked list
   1. hare is two times faster than tortoise
      1. 2 * (F + a) = F + a + n * C
      2. F + a = n * C
   2. After they meet again:
      1. (F + a) + (C - a) = F

### stack / queue

1. stack
   1. LIFO structure
2. queue
   1. FIFO structure
3. priority queue / stack

### hash table

1. load factor
   1. key count / capacity of hash table
2. collision handling
   1. separate chaining (closed addressing)
      1. conflict key is kept in the same location as a linked list
      2. waste of space (linked list & not used key)
      3. less sensitive to hash function and load factor
   2. open addressing
      1. probe for a open address to put in the key
      2. linear probe / quadratic probe / double hashing
      3. table can become full
   3. double hashing
      1. use another function hash again and help generate new address
   4. coalesced hashing
      1. combine open addressing and chaining
      2. all keys are stored in table, but each node will hold a pointer to next conflicted key
   5. overflow area
      1. conflict keys are kept in overflow area
   6. Cuckoo
      1. using two or more hash functions, check if one of the two possible positions is open
      2. when conflicting, push old key to its possibly open position.
         More positions should be available due to multiple hash function.
3. common hash function
   1. hash = key % table_size
   2. hash = key % m -> m being a prime number can help reduce collision
   3. hash = rand(key) % m
   4. hash = (a * key + b) % m

#### implementation in different language

* c++: unordered_map
  * By default, use `std::hash`, which can be specialized for custom class.
  * Otherwise, we can provide a functor template to generate hash
  * no specialization for `const char *`
  * specialization exist for all pointers `std::hash<T*>`
* python: dict
  * an object is hashable if `__hash__(), __eq__()`
  * by default, `__hash__()` is derived from `id()`
  * `id()` is guaranteed to unique during its lifetime
    * in cpython, it is the address of object

### tree

1. binary search tree
   1. if the data is sorted at insertion,
   a binary tree might be heavily imbalanced.
2. b / b + tree
   1. basically the same as binary tree
   except that each node can have multiple keys and child nodes
   1. maintain continuous data structure inside one node helps performance
3. red-black tree
   1. node being either red or black
   2. root is always black
   3. no adjacent red node
   4. every path from a node to any its descendant null node has the same number of black nodes
4. splay tree
5. avl
6. kd tree
7. segment tree
   1. say we want sum on part of array, we can:
      1. save the array and calculate each time -> fast update, slow query
      2. save all results -> slow update, fast query
      3. segment tree -> each node save part of the solution
   2. each node will keep track of a interval and the result on this interval
   3. when searching for a interval, we could:
      1. split the interval and search in both child branch
      2. follow one child branch
      3. return when interval matches
8. zkw segment tree
9. trie
   1. save storage space by sharing prefix
10. huffman table
    1. save storage space by entropy
    2. asymmetric number system
11. heap property
    1. a tree with parent node larger or equal to child node (max heap)
    2. easier to maintain when only relative order is required
    3. insert at child node and push up
    4. remove at root node, place leaf node at root and push down
    5. std::make_heap, push_heap, pop_heap, sort_heap, is_heap

## algorithm

### note

1. always consider edge cases
2. problem might be symmetric
   1. certain sub problems might be easier to solve
   2. answer might be the union / intersect of sub problems 

### basic ideas

1. divide and conquer
   1. prove that recursion work at step 0 and step n + 1
2. greedy
   1. prove optimal by proving that any other choice is equivalent or worse
3. dynamic programming
   1. design a objective that is recurring
   2. solve the result by gradually solving the objective
4. sliding window: maintain invariant between range
   1. usually done with two pointers
   2. useful for finding stuff in range

### sort

1. merged sort -> divide and conquer
2. quick sort
   1. choose a pivot and partition based on pivot -> median of three
   2. recursively apply the steps to smaller sub-array
   3. need O(log(n)) due to recursive call -> tail call
3. heap sort
   1. partition into a heap area and sorted area.
   2. heap property is maintained and root is moved to sorted area.
4. insertion sort
   1. sort by inserting new value into a proper position in the sorted part.
5. bucket sort
   1. sort by putting values into buckets
   2. sort bucket and read

### graph theory

1. adjacency matrix
2. bfs / dfs
3. shortest distance
   1. Dijkstra's
      1. take the vertex with minimal distance and update its neighbors
      2. normal implementation $ O(V^2) $
      3. with adjacency list $ O(E \log{V}) $
   2. Bellman-Ford: works for graph with negative cycle $ O(\abs{V} \abs(E)) $
      1. repeat distance update for every edges for a total of V - 1 times
      i.e. let the weight propagate to all vertex
      2. check negative weight cycle by update once more, see if any path can be improved
   3. Floyd / SPFA
4. minimal spanning tree
   1. a sub-graph that connects all the vertices together
   2. Kruskal -> pick V - 1 edges with minimal weights that does not form a cycle
   3. Prim
      1. basically Dijkstra's method and keep tree structure
5. union-find: group nodes given some criteria
   1. find: find node's parent
      1. often involves flatten the tree by setting intermediate's parent directly to root
   2. union: combine two tree with different parent

### max flow

* model the problem as a graph with one source and one sink
  with the wanted value being the number of connection to src or sink
* construct the graph under problem constraint
* the value is thus known to be max
* min-cut / max-flow

### string matching

1. regex
2. KMP / Boyer-Moore
3. Rabin-Karp

## side note

* sign bit can be used as a free marker

### b tree

Properties of a B-tree of order m:

* Every node has at most m children
* Every node except the root node contain at least m/2 children.
* Root node contains at least two nodes if it is not a leaf node.
* A non-leaf node with k children contains k - 1 keys
* All leaves are at the same level.

(Note that the leaf node definition is different from Knuth's definition.
But follows other trees' definition.)

At insertion, if we run out of space at the child node,
we will split the child node and add the separator to parent. (possibly recursively)

At deletion, we might need to rotate element from siblings.
Or merged with a sibling.

### b+ tree

For B + tree, the separator is the first value in the right child node.
Which leads to the following advantage:

1. Because separator is presented in the children,
   only leaf nodes need to hold the data corresponding to the separator.
2. Thus, more keys can be fit on a page of memory. Helps with search speed.
3. The leaf node can be linked together to help with range query.
   1. ie tree branches are interconnected

### tail call optimization

Normally, at function end, the stack frame needs to be popped.
But if we have a function call at the end of stack,
we can modified the frame directly for that function.
Thus, reducing the amount of stack used.

### tree stored in array

```c
left = 2 * i + 1;
right = 2 * i + 2;
parent = (i - 1) / 2; -> use integer division
```

## todo

Topological sorting
Morris
Manacher / suffix array
Shell Sort
token Bucket
