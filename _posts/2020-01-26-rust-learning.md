---
layout: post
title:
date: 2020-01-26 14:20
category:
author:
tags: [lang]
summary:
---

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

- `const` need to specify data type
  - for global variable, local rule inference will be hard to achieve
  - `const` is immutable

`&'static`

### primitive data type

- `bool`
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
  - tuple struct
    - will become different type even if structs have same content
  - unit struct, for implement trait?

```rust
// enum, tagged union
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}
```

### array, slice

```rust
[1, 2, 3]; // array
[0; 3];    // array with 0 repeated three times
[u8; 3]    // type: u8 array with 3 elements, size matters in type system
&[u8]      // type: slice of a u8 array
```

- taking reference to a array returns a slice.
  - `let hello = &s[0..5];`

### char, string

- `[u8]` byte array
- `char`, char literal (ex `'a'`)
  - One unicode scalar value
  - 4 byte fixed size
- `str`, string literal (ex `"hello"`)
  - UTF-8 encoded
  - owned type `String`

## control

- `if`, `else if`, `else`
- `for <> in <>`, `while`, `loop`
  - `n..m`, exclusive
  - `n..=m`, inclusive
  - `n..`?
  - `'label` `break 'label`: break nested loop
- `match`
  - need to cover all variants

```rust
// switch case
let result = match item {
    // match certain item
    42 | 132 => 1,
    // call-all and use the captured value
    other => other + 1
    // call-all and ignore
    _ => 2
}

// match can be used for enum to match against type
let result = match message {
    // match certain item
    Quit => "quit",
    // capture value
    Move(move) => move
    // call-all
    _ => 2
}

// if-let: the following two part is equivalent
let config_max = Some(3u8);
match config_max {
  Some(max) => println!("The maximum is configured to be {}", max),
  _ => (),
}

let config_max = Some(3u8);
if let Some(max) = config_max {
  println!("The maximum is configured to be {}", max);
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
- dereference `*`:
  - get the referenced variable for changing its value?
  - `deref` trait

- scope: variable owner release when scope ends
- move: by default, transfer ownership when assignment or pass into function
  - std::marker::Copy
  - std::clone::Clone
- borrow: keep original ownership by using reference
  - reference lifetime `<'a>` or `&'a`
  - reference coersion
    - in which case, explicit lifetime might be necessary
    - `fn add_with_lifetime<'a, 'b>(i: &'a i32, j:&'b i32) -> i32`

https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html

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
- function `fn`
  - use `->` for return type
  - function without return type returns `()`
  - `()` unit type
  - `!` never type -> function never returns
- method
  - `impl`
- closure
  - `|parameter| {}`
  - `move`: force capture

## trait

- interface inheritance rather than implementation inheritance
  - Prefer Composition to Inheritance
  - if it quacks, it's a duck

## generic

- function
  - single upper case letters used in place of a type
  - `fn add(i: T, j: T) -> T`
  - generic types can take traits which place constraints on the type
  - `fn add<T: Add<Output = T>>(i: T, j: T) -> T`
- struct
- trait

  - `Option<T>`
  - `Result<T, E>`
  - `unwrap`, `unwarp_or_else`, `?`

## concurrent

not thread safe type cannot cross thread boundary

Box
Rc, RefCell
Arc, Mutex

## macro

- compiler can help generate code
  - `println!`, `panic!`, `assert!`
  - derive
    https://doc.rust-lang.org/rust-by-example/trait/derive.html
    https://doc.rust-lang.org/std/fmt/index.html


- `#[cfg(test)]`
- `if cfg!(debug_assertions) { … }`
`#[test]` -> unit test / integration test #[cfg(test)]

?

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[should_panic]
```

## carge

```
cargo add
doc
```

- `\\`: normal comment
- `\\\`: document for the following block
- `\\!`: document but for this file

## module

- `mod`: private by default
  - `pub`
  - `use`: bring path into scope
    - `use std::time::{self, SystemTime};`
    - `use std::time::*;`
    - `as`: rename

## lib

rust-analyzer
clippy
docs.rs
future

cbingen - generate c header for rust library
bindgen - generate rust ffi bindings to c library

serde: de/serialization for any type
Rayon, parallel iterator access?

## collections

```rust
Vec<T>
Vec::new();
vec![]; // macro to construct list directly
```

## todo

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

