---
layout: post
title: 
date: 2020-08-22 12:26
category: 
author: 
tags: []
summary: 
---

## basics

* errno:
  * thread local
  * never cleared until actual error

## system limits

```
<unistd.h> // compile time
sysconf()
pathconf() fpathconf()
```

## fd

```
open
memfd_create
fnctl
select, poll, epoll?
```

* file status flags:
  * `O_SYNC`:
    * when fd `close` fail, data is not guaranteed to be written 
  * `O_APPEND`:
    * cannot lseek -> gurantee that write is sequential
* fd flags: 
  * `FD_CLOEXEC`: if set, fd is closed when `exec()`
    * prevent fd leak to child process
* shared access:
  * fd can point to same file -> `dup()`
  * file can be open multiple times
  * lseek() + read() / write is not atomic
  * pread(), pwrite()
* umask: set file permission for various syscall
  * `mode & ~umask`
  * can be read from `/proc/pid/status` and `/proc/self/status`

## exec

```
execve
execveat
```

## signal

~~signal, pause, setjmp, longjmp~~

* signal is reset to default after trigger
* signal cannot be turned off
* system call will be interrupted
  * might auto restart
* reentrant function: some func cannot be used because their use of global struct

sigaction, sigsuspend, sigsetjmp, siglongjmp, 

* sigaction does not reset
* sigaction allow mask
  * automatically masked unless SA_NODEFER
  * mask is inherit through fork so we need to make sure that we only attach handler when necessary
* sa_flags:
  * SA_RESTART, SA_INTERRUPT: default to restart
  * SA_SIGINFO: more info for signal (also, enable signal queue)
* sigsuspend is atomic:
  * race between signal set and pause
* jmp needs to make sure that mask is cleared

### signal note

* async signal safe != thread safe
  * thread is in band, thread safe can be achieved with mutex
  * signal is out of band, reentrant cannot have broken global state
  * handle signal in special thread 
* when ignoring SIGCLD / SIGCHLD, do not generate zombie
  * SIGCLD:
    * if child can be waited, signal is triggered immediately
      * only set signal after wait
  * SIGCHLD:
    * generate when child state actually changes?

## pthread

## seccomp

limit syscall

```
seccomp_init
seccomp_rule_add
seccomp_load
```

## sockets

* address domain + socket type
  * domain = unix / internet + port (>2000 is generally available)
  * type = stream (tcp) / datagram (udp)
* unix socket is a file
  * it might not have a name
  * nor in the filesystem namespace?
  * file descriptor passing?
* byte order
  * `hton*`, `ntoh*`

```c++
// common
int socket(int domain, int type, int protocol);
// domain: AF_UNIX, AF_INET
// type: SOCK_STREAM, SOCK_DGRAM
// protocol: /etc/protocols

// todo: setsockopt()
```

```c
// server
// 1. bind socket to interface
int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

// domain = AF_UNIX for local socket
struct sockaddr_un {
    sa_family_t sun_family;               /* AF_UNIX */
    char        sun_path[108];            /* Pathname */
};

// domain = AF_INET for internet socket
struct sockaddr_in {
    sa_family_t    sin_family; /* address family: AF_INET */
    in_port_t      sin_port;   /* port in network byte order */
    struct in_addr sin_addr;   /* internet address */
};

struct in_addr {
    uint32_t       s_addr;     /* address in network byte order */
};

// s_addr = INADDR_ANY bind to all interface
// gethostbyname
// port needs htons

// 2. listen on socket
listen()
// 3. accept connection
accept()
```

```c
// client
connect(): connect to another socket
```

```c
// op
recv & send
read & write
```

## search table

https://fedora.juszkiewicz.com.pl/syscalls.html
https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md
