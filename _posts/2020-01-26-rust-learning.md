---
layout: post
title:
date: 2020-01-26 14:20
category:
author:
tags: [lang]
summary:
---

https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html
https://doc.rust-lang.org/std/index.html

## basic

- use `let` to declare `variable binding`
  - Variable is immutable by default
    - use `mut` to mark it as mutable
    - mutabiliy can be changed by reassigning
    - no such thing as mutable type?
  - same name can be rebind to other type in the same scope (shadowing)
  - specify data type `let b:i32 = 20;`
    - local rule: type is inferred by usage instead of by literal type

- `const` and `static` need to specify data type
  - for global variable, local rule inference will be hard to achieve
  - `const` is immutable

### primitive data type

- bool
- numeric type `i8, i16, i32, i64`, `u`, `f32, f64`
  - `isize, usize`: native width
  - infix notation (vs prefix, postfix)
  - conversion is always explicit
- numeric literal can contain:
  - data type as suffix -> concrete type?
  - underscore to help readability
  - other base: `0b` `0o` `0x`
- type cast:
  - `as`

- tuple
  - `(i32, i32)`
  - `tuple.0`
  - `let (a, b) = tuple;`
- struct
  - `struct a {}`
  - field init shorthand, make variable name the same as field name
  - struct update syntax, `..object`
  - tuple struct, different type despite same content
- enum
  - `Option<T>`
  - `Result<T, E>`
  - `unwrap`, `unwarp_or_else`, `?`

`help: ...or a vertical bar to match on multiple alternatives`

### char, string

- char literal, ex `'a'`

`String, str, char [u8]` ?

- `str` `String`
- string use `"`. And use `{}` as a placeholder for formatting.
  - data owner

### array, slice

```rust
[1, 2, 3]; // array
[0; 3];    // array with 0 repeated three times
[u8; 3]; // type: u8 array with 3 elements, size matters in type system
&[u8]    // type: slice of a u8 array
```

- taking reference to a array returns a slice.
  - `let hello = &s[0..5];`
- slice a view on another array

## control

- `if`, `else if`, `else`
- `match`
  - `=>` make function call
  - `if let`
- `for <> in <>`, `while`, `loop`
  - `n..m`, exclusive
  - `n..=m`, inclusive
  - `n..`?
  - `'label` `break 'label`: break nested loop

```rust
let result = match item {
    42 | 132 => "hit",
    _ => "miss",
}
```

## ownership

- variable has only one owner
  - cannot `drop` after move -> no double free
  - cannot reference after move -> no dangling pointer
- one mutable reference or many immutable reference
  - `&` immutatable reference
  - `& mut` mutable reference
    - need variable to be mutable as well
  - both reference types can appear in the same scope as long as they do not overlap
- dereference `*`: get the referenced variable?
  - trait `deref`

- scope: variable owner release when scope ends
- move: by default, transfer ownership when assignment or pass into function
  - std::marker::Copy
  - std::clone::Clone
- borrow: keep original ownership by using reference
  - reference lifetime `<'a>` or `&'a`
  - reference coersion
    - in which case, explicit lifetime might be necessary
    - `fn add_with_lifetime<'a, 'b>(i: &'a i32, j:&'b i32) -> i32`

## statement, expression, function, method

"""
Blocks are expressions too, so they can be used as values in assignments.
The last expression in the block will be assigned to the place expression such as a local variable.
However, if the last expression of the block ends with a semicolon, the return value will be ().
"""

https://doc.rust-lang.org/reference/expressions.html

- expression
  - place expression (lvalue)
  - value expression (rvalue)
- function return type use `->`
  - function without return type returns `()`
  - `()` unit type
  - `!` never type -> function never returns
- closure
  - `|parameter| {}`
  - `move`: force capture

## Vec

```rust
Vec<T>
let mut tags: Vec<usize> = Vec::new();
```

## trait

- interface inheritance rather than implementation inheritance
  - Prefer Composition to Inheritance
  - if it quacks, it's a duck
- a lot of rust operations can be override by traits
  - Copy, Iterator

## generic

- function
  - single upper case letters used in place of a type
  - `fn add(i: T, j: T) -> T`
  - generic types can take traits which place constraints on the type
  - `fn add<T: Add<Output = T>>(i: T, j: T) -> T`
- struct
- trait

## concurrent

not thread safe type cannot cross thread boundary

Box
Rc, RefCell
Arc, Mutex

## macro

- `if cfg!(debug_assertions) { … }`
- `!` marks a macro. But return code rather than value.

## carge

```
cargo add
doc
```

- `\\`: normal comment
- `\\\`: document for the following block
- `\\!`: document but for this file

## lib

rust-analyzer
clippy
docs.rs
future

cbingen - generate c header for rust library
bindgen - generate rust ffi bindings to c library

serde: de/serialization for any type
Rayon, parallel iterator access?

## todo

tagged union?

`#[test]` -> unit test / integration test #[cfg(test)]

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

println! will create a immutable reference.
