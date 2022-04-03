---
layout: post
title:
date: 2022-04-02 21:13
category:
author:
tags: []
summary:
---

## procedural macro

1. Function-like macros - `custom!(...)`
2. Derive macros - `#[derive(CustomDerive)]`
3. Attribute macros - `#[CustomAttribute]`

## attribute

[attribute](https://doc.rust-lang.org/rust-by-example/attribute.html)

- `#[cfg]` attribute
- `cfg!()` macro

## defining macro

- `macro_rules!`
  - macro definition order matters
- `#[macro_export]`
  - always export to the crate root?

- metavariable
- similar to `match`
https://doc.rust-lang.org/reference/macros-by-example.html

## test macro

> Most unit tests go into a `tests` mod with the `#[cfg(test)]` attribute.
> Test functions are marked with the `#[test]` attribute.

## todo

- `println!`, `panic!`, `assert!`
- `#[derive()]` for some basic traits
- https://doc.rust-lang.org/rust-by-example/trait/derive.html
- `format!` https://doc.rust-lang.org/std/fmt/index.html

`#[global_allocator]`
jemalloc
tcmalloc
mimalloc

`#[no_mangle]`
`extern "C"`
