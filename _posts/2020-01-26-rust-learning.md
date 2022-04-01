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

- `const` need to specify data type
  - `const` is immutable

- local rule: type is inferred by usage instead of by literal type
  - one example is to enables `collect` to work in reverse
  - for global variable, type inference will be hard to achieve

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

- `&[u8]` byte slice
- `char`, char literal (ex `'a'`)
  - One unicode scalar value
  - 4 byte fixed size
- `&str`, string slice
  - string literal (ex `let t: &'static str = "hello";`)
  - UTF-8 encoded
  - owned type `String`

there is no non-reference string type?

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
    // match with if
    x if x < 4 => 3,
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
```

```rust
// if-let (while-let): the following two part is equivalent
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
  - scope: variable owner release when scope ends
- move: operations 'consumes' by default (taking ownership)
  - std::marker::Copy -> copy type is always copied?
  - std::clone::Clone
- borrow: keep original ownership by using reference
  - reference lifetime `<'a>` or `&'a`
  - reference coersion
    - in which case, explicit lifetime might be necessary
    - `fn add_with_lifetime<'a, 'b>(i: &'a i32, j:&'b i32) -> i32`
- special thing
  - destructuring
  - partial move

- one mutable reference or many immutable reference
  - `&` immutatable reference
  - `& mut` mutable reference
    - need variable to be mutable as well
  - both reference types can appear in the same scope as long as they do not overlap
- dereference `*`:
  - get the referenced variable for changing its value?
  - `deref` trait

https://doc.rust-lang.org/book/ch10-03-lifetime-syntax.html

```rust
// ref vs &
ref x = 1;
let x = &1;

// & vs *
let &y = x;
let y = *x;
```

`&'static`


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
  - `self`
  - `Self`: refer to current type
- closure `|parameter| {}`
  - capture: take varaible from current scope
  - parameter: pass variable at the call site
  - `move`: force copy or clone

```
Closures can capture variables:

  by reference: &T
  by mutable reference: &mut T
  by value: T

They preferentially capture variables by reference and only go lower when required.

Depending on what is captured, closures can have the following types:

  Fn: the closure uses the captured value by reference (&T)
  FnMut: the closure uses the captured value by mutable reference (&mut T)
  FnOnce: the closure uses the captured value by value (T)

Depending on the closure paramter, we can determine what is passed at call site.

 FnMut(&Self::Item) vs FnMut(Self::Item)
```

## trait

- interface inheritance rather than implementation inheritance
  - Prefer Composition to Inheritance
  - if it quacks, it's a duck

## generic

- function
  - `fn add(i: T, j: T) -> T`
- `struct Wrapper<T>`
- `impl<T> Wrapper<T>`
- trait bound:
  - generic types can take traits which place constraints on the type
  - `fn print<T: std::fmt::Display>(i: T, j: T) -> T`
  - or with the `where` clause https://doc.rust-lang.org/rust-by-example/generics/where.html

- `Option<T>`: Some(T), None
- `Result<T, E>`: Ok(T), Err(E)
  - `main` can return `Result`
- `unwrap`: panic if unable to unwarp
  - `unwarp_or_else`
- `?` return if unable to unwarp
- map_err: convert error to another type

`::<T>` turbofish

## concurrent

not thread safe type cannot cross thread boundary

- `Box` smart heap pointer
  - for dynamic size type or recursive type
  - `dyn` for trait bound type
- `Cell`, `RefCell`: manage mutability at multiple positions
  - interior mutability?
- `Arc` atomic reference count
  - when cloned, the reference count is increased
  - `Rc`
- `Mutex` -> `MutexGuard`
  - poisoned when a thread holding the lock panics
    - further lock will have `Err` result
    - `into_inner`

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

## module

- `mod`: private by default
  - `pub`
  - `use`: bring path into scope
    - `use std::time::{self, SystemTime};`
    - `use std::time::*;`
    - `as`: rename

## cargo

```
cargo add
doc
```

- `\\`: normal comment
- `\\\`: document for the following block
- `\\!`: document but for this file
- crate feature `features = ["small_rng"]`

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

std::iterators
map: lazy evaluation -> no operation until accessed
cloned
chain
FromIterator: iterators -> collections
IntoIterator: collections -> iterators

