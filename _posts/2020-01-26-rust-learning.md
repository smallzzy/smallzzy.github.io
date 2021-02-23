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
  * same name can be rebind to other type in the same scope (shadowing)
  * variable are dropped with they went out of scope
* string use `"`. And use `{}` as a placeholder for formatting.
* `&` and `*` represent reference and de-reference

### data type

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

* `str` `String`
  * data owner

* tuple
* struct
* enum
  * `Option<T>`
  * `Result<T, E>`
  * `unwrap`, `unwarp_or_else`, `?`

### control

* `if`, `else if`, `else`
* `match`
  * `=>` make function call
  * `if let`
* `for <> in <>`, `while`, `loop`
  * `n..m`, exclusive
  * `n..=m`, inclusive
  * `n..`?
  * `'label` `break 'label`: break nested loop

```rust
let result = match item {
    42 | 132 => "hit",
    _ => "miss",
}
```

## ownership

* scope
* borrow
* reference
* lifetime

* only one owner, cannot `drop` after transfer ownership
  * no double free
* no reference to pointer after transfer ownership
  * no use after free
* one mutable reference or many immutable reference

## expression, function, method

* all expressions return values
  * expression that ends with `;` returns `()`
  * functions return the last expression's result
* function return type use `->`
  * function without return type returns `()`
  * `()` unit type
  * `!` never type -> function never returns
* reference coersion
  * in which case, explicit lifetime might be necessary
    * `fn add_with_lifetime<'a, 'b>(i: &'a i32, j:&'b i32) -> i32`
* closure
  * `|parameter| {}`
  * `move`: force capture

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

### iter

* `.iter()` return iterator which is a reference to the elements
* reference to array, iterate?
  * ownership?
* `iter_mut()`, `into_iter()`?
* `.enumerate()` return idx when chained with iterator

## trait

* interface inheritance rather than implementation inheritance
  * `Prefer Composition to Inheritance`
  * `if it quacks, it's a duck`

## generic

* function
  * single upper case letters used in place of a type
  * `fn add(i: T, j: T) -> T`
  * generic types can take traits which place constraints on the type
  * `fn add<T: Add<Output = T>>(i: T, j: T) -> T`
* struct
* trait

## concurrent

not thread safe type cannot cross thread boundary

Box
Rc, RefCell
Arc, Mutex

## macro

* `if cfg!(debug_assertions) { … }`
* `!` marks a macro. But return code rather than value.

## carge

```
cargo add
doc
```

* `\\`: normal comment
* `\\\`: document for the following block
* `\\!`: document but for this file

## lib

rust-analyzer
clippy
docs.rs
future

serde: de/serialization for any type
Rayon, parallel iterator access?

## todo

tagged union?

`#[test]` -> unit test / integration test

`#[global_allocator]`
jemalloc
tcmalloc
mimalloc

`#[no_mangle]`
`extern "C"`

`bingen`
`cbingen`

dynamic dispatch?
reflection?
runtime assisted debug?
