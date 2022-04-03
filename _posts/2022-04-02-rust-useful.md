---
layout: post
title:
date: 2022-04-02 22:16
category:
author:
tags: []
summary:
---

## command

```bash
# install tool chain
rustup component list
#
cargo --list
cargo new
cargo doc
```

## crate

- clippy: additional list of code lints
  - [lint level](https://doc.rust-lang.org/rustc/lints/levels.html)
  - `clippy::all` mean all lints that are enabled by default. Not all lints

rust-analyzer
docs.rs
future

cbingen: generate c header for rust library
bindgen: generate rust ffi bindings to c library

serde: de/serialization for any type
Rayon: parallel iterator access?

## struct / enum

- `Option<T>`: Some(T), None
- `Result<T, E>`: Ok(T), Err(E)
  - `main` can return `Result`
  - `ok()` and `err()` to create `Option`

- `unwrap`: panic if unable to unwarp
  - `unwarp_or_else`
- `?` return Err if unable to unwarp
  - require current function to return corresponding `Result` type
  - will auto convert Err type if available

- `map_err`: convert error to another type
- `or_else`?

## trait

### std::iterators

> In Rust, iterators are lazy,
> meaning they have no effect until you call methods that consume the iterator to use it up

map: lazy evaluation -> no operation until accessed
cloned
chain
FromIterator: iterators -> collections
IntoIterator: collections -> iterators

#### iter, iter_mut, into_iter

- `iter`: iterator over immutable references
- `iter_mut`: iterator over mutable references
- `into_iter`: iterator over owned values

https://hermanradtke.com/2015/06/22/effectively-using-iterators-in-rust.html/

### std::convert

- `From`, `Into`: type conversion trait
  - `as`: only available for primitive types
  - reflexive??: https://doc.rust-lang.org/std/convert/trait.Into.html
- `AsRef`, `AsMut`: light weight conversion between reference
  - possible because the underlying struct is the same?
