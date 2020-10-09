---
layout: post
title: 
date: 2019-12-15 23:33
category: 
author: 
tags: [misc]
summary: 
---

Reading Note for OSTEP

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

## memory

* internal vs external fragmentation
* page table vs segmentation
* multiple level page table
* larger page table size

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

### files

* hard link: create a file with the same inode number
  * inode is unique on one device. Thus, hard link does not work across drives.
  * also, reference counting is necessary
* symbol link: create a symbolic file that points to another file
* bind mount: make a folder available at another position
  * there are possible drawbacks when having the same folder appear twice in the system
  * rbind: bind recursively
* loop mount: make a file accessible as a block device
  * if the file contains an entire file system,
  it can then be mounted as a disk device

## uid

* RUID (real)
  * actual owner of a process
* EUID (effective)
  * authority of a process is determined according to EUID
* SUID (set)
  * When a command with SUID bit is run,
  its EUID become that of the owner of the file,
  rather than that of the user who is running it.
  * `chmod +s`
  * `rws` for SUID + x, `rwS` for SUID only

* `access` check if RUID has capability
  * by default, will follow symbolic link
* suid will not work for things which need a interpreter ex. script
* `ltrace` does not work because of security

### sticky bit

* used for shared directories
* can create, read and execute files owned by other users
* but cannot remove files owned by other users
* `chmod +t`

## attribute

`chattr`

* `A`: do not update atime record
* `S`: changes are synchronously write to disk
* `a`: only open in append mode
* `i`: cannot be modified (no renaming, no symbolic link, no execution)
* `j`: write journal before content
* `t`: no tail-merging (multiple tail block can be merged to reduce disk usage)

## process id

the kernel starts as a dummy process 0
the first process to run is `init` as process 1
`SysV` `systemd`

* if a parent does not read its child process exit state (wait),
  * the child become zombie after it finished execution
  * `ps aux | grep Z`
* if a parent exit before its child process, 
  * the child is transfered to `init` (orphaned)
  * `init` will clean up periodically
  * orphaned process get SIGHUP and SIGCONT
* daemon process: orphaned but still working?

* parent process id `ppid`
* process group `pgid`
  * `getpgid()` / `setpgid()`
  * pipelined process can be placed into one group
* session `sid`
  * `setsid()` create new session
    * the process become the session leader
    * network hang up is sent to session leader
  * a session can have one controlling terminal
* controlling terminal: some tty device
  * `/dev/tty`: current tty device 
  * foreground / background process group
    * terminal send signal to the foreground pg `tpgid`
    * `tcgetpgrp` / `tcsetpgrp`
    * bg can talk to `/dev/tty`
* job control
  * when reading in background, process get SIGTTIN
    * if orphaned, read gets EIO
  * when writing in background, process get SIGTTOU if tty disconnected

## virtualization

* proxmox, ESXi
* KVM XEN
* lxc lxd
* virtio

### container

* namespace change visibility of services
  * mnt
  * pid
  * net
  * ipc
  * UTS
  * user
  * cgroup
  * time
* cgroup limit resource usage
* capability: partial ability as root

## reference

[OSTEP](http://pages.cs.wisc.edu/~remzi/OSTEP/)
[attr](https://en.wikipedia.org/wiki/Chattr)

## todo

* https://blog.yadutaf.fr/2013/12/28/introduction-to-linux-namespaces-part-2-ipc/

* [UEFI](https://uefi.org/specifications): SEC, PEI, DXE
  * during DXE, oprom is loaded -> driver?

* https://refspecs.linuxfoundation.org/
