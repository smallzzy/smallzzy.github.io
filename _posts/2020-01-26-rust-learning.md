---
layout: post
title: 
date: 2020-01-26 14:20
category: 
author: 
tags: []
summary: 
---

## basic

* use `let` to declare `variable binding`. Variable is immutable by default.
  * use `mut` to mark it as mutable
* `!` marks a macro. But return code rather than value.
* string use `"`. And use `{}` as a placeholder for formatting.
* `main` function take no parameter and return nothing
* `i8, i16, i32, i64`, `u`, `f32, f64`, `isize, usize`
* support numeric literal and formatting in other bases (`b, o, h`)
* `&` and `*` represent reference and de-reference
* `.iter()` return iterator which is a reference to the elements
* `.enumerate()` return idx when chained with iterator
* `(usize, String)` is a tuple
* `unwrap` ? 

## match keyword

```rust
let result = match item {
    42 | 132 => "hit",
    _ => "miss",
}
```

* `Some(T)`
* `None`
* `=>` make function call. in case of `()`, do nothing?

## functions

* function return type use `->`
* functions return the last expression's result (without `;`).
  * otherwise, will return `()`
* function can take reference as input.
  * in which case, explicit lifetime might be necessary
  * `fn add_with_lifetime<'a, 'b>(i: &'a i32, j:&'b i32) -> i32`
* generic
  * capital letters used in place of a type
  * `fn add(i: T, j: T) -> T`
  * generic types can traits which place constraints on the type
  * `fn add<T: Add<Output = T>>(i: T, j: T) -> T`

## array, slice

`String, str, char [u8]` ?

```rust
[1, 2, 3];
[0; 3]; // 0 repeated three times
[u8; 3]; // u8 array with 3 elements, size matters in type system
[u8] // slice of a u8 array
```

* taking reference to a array returns a slice. slice support iteration without iter()
* iter() is also supported
* slice is both a dynamic sized array, and a view on another array.
* referenced form ? `&[T]`

```rust
for i in 0..a.len() {
    sum += a[i];
}
```

## vec

```rust
Vec<T>
let mut tags: Vec<usize> = Vec::new();
```
