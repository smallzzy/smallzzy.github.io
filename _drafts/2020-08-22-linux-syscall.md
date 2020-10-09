---
layout: post
title: 
date: 2020-08-22 12:26
category: 
author: 
tags: []
summary: 
---

## intro

https://fedora.juszkiewicz.com.pl/syscalls.html
https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md

## fd

```
open
memfd_create
fnctl
select, poll, epoll?
```

* `O_SYNC`:
  * when fd `close` fail, data is not guaranteed to be written 
* `FD_CLOEXEC`: if set, fd is closed when `exec()`
  * prevent fd leak to child process
* in C11, `fopen()` can have `wx` flag to prevent overwrite
* umask: set file permission for various syscall
  * `mode & ~umask`
  * can be read from `/proc/pid/status` and `/proc/self/status`

## exec

```
execve
execveat
```

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
