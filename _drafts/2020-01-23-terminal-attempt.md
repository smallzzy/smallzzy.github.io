---
layout: post
title: 
date: 2020-01-23 17:07
category: 
author: 
tags: []
summary: 
---
 
## terminal game

This post records the attempt to solve [terminal](https://terminal.c1games.com/).

## plan

* use alphazero agent to determine game plan

## things to consider

* what can we do if mcts cannot resolve to the end?
* how to generate random actions fast for mcts?
* how to generate different output? ie what is a behavior parameter
* how to relate action with win / loss?
* how to deploy network for evaluation?
  * how to do lstm?

## action space

* defense space = 28 * 28 / 4 (game space) * 3 (unit) * 2 (upgrade) = 1176
* attack space = 28 (game space) * 3 (unit) * 30 (max damage possible) = 2520
* it is not possible to search through the combinations
* plan:
  * given all actions a score
  * use a deploy factor to determine what actions gets performed

## what is the input

* board status
  * only defense units and player status
* previous damage (on units and on player):
  * assumption: damage done is equivalent to previous attack  
  * pro: damage can be represent in a similar pattern as board.
  * pro: analyze attack require us to look at game state on the fly
  * con: same damage can be generated with different attack.
    * which might correspond to different defense

## what to train for

* win / loss
* invalid play
* maybe penalize no action taken
* maybe penalize turn loss

### cold start

* in the begin, instead of doing self play which does not have any value
  * learn from replay winner action pattern
  * try to replicate their action
