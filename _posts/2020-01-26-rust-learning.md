---
layout: post
title: 
date: 2020-01-26 14:20
category: 
author: 
tags: [lang]
summary: 
---

## basic

* use `let` to declare `variable binding`
  * Variable is immutable by default
  * use `mut` to mark it as mutable
  * specify data type `let b:i32 = 20;`
* data type `i8, i16, i32, i64`, `u`, `f32, f64`
  * `isize, usize`: native width
  * infix notation (vs prefix, postfix)
  * conversion is always explicit
  * can have methods?
* numeric literal can contain:
  * data type as suffix -> concrete type?
  * underscore to help readability
  * other base: `0b` `0o` `0x`
* type cast:
  * `as`


* `!` marks a macro. But return code rather than value.
* string use `"`. And use `{}` as a placeholder for formatting.
* `&` and `*` represent reference and de-reference


* `str` `String`
* `(usize, String)` is a tuple
* `unwrap` ? 
* `if cfg!(debug_assertions) { … }`

## carge

```
cargo add
doc
```

## array, slice

`String, str, char [u8]` ?

```rust
[1, 2, 3];
[0; 3]; // 0 repeated three times
[u8; 3]; // u8 array with 3 elements, size matters in type system
[u8] // slice of a u8 array
```

* taking reference to a array returns a slice. 
* referenced form ? `&[T]`
* iter() is also supported

## slice

* slice is both a dynamic sized array?
  * and a view on another array.
  * slice support iteration without iter()

## Vec

```rust
Vec<T>
let mut tags: Vec<usize> = Vec::new();
```

## functions

* function return type use `->`
  * function without return type returns `()`
  * `()` unit type
  * `!` never type -> function never returns
* expression based -> all expressions return values
  * functions return the last expression's result
  * expression that ends with `;` returns `()`
* function can take reference as input.
  * in which case, explicit lifetime might be necessary
  * `fn add_with_lifetime<'a, 'b>(i: &'a i32, j:&'b i32) -> i32`
* generic
  * single upper case letters used in place of a type
  * `fn add(i: T, j: T) -> T`
  * generic types can take traits which place constraints on the type
  * `fn add<T: Add<Output = T>>(i: T, j: T) -> T`

```rust
let description = if is_even(123456) {
  "even"
} else {
  "odd"
};
```

## condition


* `if`, `else if`, `else`
* `match`

```rust
let result = match item {
    42 | 132 => "hit",
    _ => "miss",
}
```

* `Some(T)`
* `None`
* `=>` make function call. in case of `()`, do nothing?

## loop

* `for <> in <>`, `while`, `loop`
  * `n..m`, exclusive
  * `n..=m`, inclusive
  * `n..`?
  * `'label` `break 'label`: break nested loop
* do not manually loop over array
  * boundary check?
  * multiple access?

### iter

* `.iter()` return iterator which is a reference to the elements
* reference to array, iterate?
  * ownership?
* `iter_mut()`, `into_iter()`?
* `.enumerate()` return idx when chained with iterator

## safety

* boundary check
* ownership?
  * live long enough to destory?
* lifetime with reference
  * if refernce needs to out live function call?

## use

`std::time::{Duration, Instant}`

## generic

trait?
