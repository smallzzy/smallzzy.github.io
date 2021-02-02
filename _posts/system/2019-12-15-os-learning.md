---
layout: post
title: 
date: 2019-12-15 23:33
category: 
author: 
tags: [os]
summary: 
---

## virtualization

## system call

fork(): duplicate the current process context -> will copy the address space
exec(): replace current context with new process
wait(): wait for process return
clone(): similar to fork, but share the address space
pipe(): connect file descriptor
signal(): register a handler for signal

### difference vs library function

* has no address to jump to, because the program does not know where the kernel is.
* user mode vs kernel mode, privilage change
* context switch
* trap, return-from-trap, trap table

### fork safety

[Source](https://www.evanjones.ca/fork-is-dangerous.html)

* Due to the implicit usage of threading, fork() can be dangerous.
  * if another thread is holding a lock, or using a blocking syscall, we will end up in dead lock.
* if use coroutine, fork() can copy the entire process
* if fork() run all threads, there will be no dead lock
* what is spawn()?

## scheduler

turnaround time vs response time

* interrupt table
* preemptive -> willing to stop and switch
* core affinity
* shortest job first
* shortest time-to-completion first
* round-robin: switch by time slice
* multilevel feedback queue
   1. several queues are given tiers where higher tier has less time quantum
   2. task start on high priority and move to lower priority queue if it cannot be finished
      1. count total run time
   3. priority boost to help long running process
   4. prefer short jobs and i/o bound job
* CFS
   * run process with least progress (vruntime)
   * physical run time (pruntime) determined by max slice, min slice, total # process
   * virtual run time determined by pruntime and niceness
* Heterogeneous multiprocessing 
  * big.Little
  * Cluster Migration: migrate between CPU clusters
  * CPU Migration: migrate between CPU pairs
  * Global Task Scheduling: scheduling using all cores
    * dynamic voltage and frequency scaling (DVFS)

## memory

* internal vs external fragmentation
  * internal: memory not fully utilized in one allocation
  * extermal: consecutive memory after usage
* MMU: Memory Management Unit
  * mapping virual address to physical 
  * segementation
  * multiple level page table
    * no external frag -> fixed block size
* TLB: Translation lookaside buffer
  * store recent page table
  * content addressable memory
  * partial tlb replacement
    * kernel do not need swap
  * hugetlb

## concurrency

* Atomicity-Violation Bugs
  > A code region is intended to be atomic, but the atomicity is not enforced during execution
* Order-violation Bugs
  > The dependency is not enforced during execution
* time of check to time of use (TOCTTOU)
* waiting race
  * we need to release lock before we yield. (otherwise, the lock is held forever)
  * it is possible that os context switch after releasing lock before yield
  * during which, another thread can pop the queue
  * then, the yield is waiting on something that has been executed
* mutex:
  * mutual exclusive over critical section
* conditional variable:
  * extends mutex such that thread can yield on mutex lock
  * ensure order and fairness over spin lock
* semaphore:
  * a generalization of mutex and cv, basically atomic variable
  * sem_wait -> decrement by one, wait if negative
  * sem_post -> increment by one, wake waiting thread

### process, thread, coroutine

process:

* fork() + exec()
* spawn()?

thread:

* kernel space -> pthread
* user space -> coroutine

### event based concurrency

* model every step as a non-blocking event.
* work on one event at a time
* blocking become two events

## persistance

* disk characteristic
* file system consistence
* log based vs table based

## Reference

[OSTEP](http://pages.cs.wisc.edu/~remzi/OSTEP/)
