---
layout: post
title: 
date: 2020-06-24 22:43
category: 
author: 
tags: []
summary: 
---

`enum` can contain multiple type
`match`
`variant<T>`?
tagged union?

`Option<T>`

`#[test]` -> unit test / integration test

`///` -> documentation, code block inside also become test

pointer invariant

* only one owner, cannot `drop` after transfer ownership
  * no double free
* no reference to pointer after transfer ownership
  * no use after free
* one mutable reference or many immutable reference

immutable by default, 
cannot cast away?

not thread safe type cannot cross thread boundary
Rc, Arc?
spawn(move ||) ?

Rayon, parallel iterator access?

forced reference check?
`?` unwrap

no runtime -> syscall, ffi, baremetal

`Box`
`vec!`

`#[global_allocator]`
jemalloc
tcmalloc
mimalloc

dynamic dispatch

`#[no_mangle]`
`extern "C"`

`bingen`
`cbingen`

rust-analyzer
clippy
docs.rs

macro

serde: de/serialization for any type

twisted?
javascript, future?
`future, executor`?

reflection?
runtime assisted debug?

vendor support
prebuilt library
windows


