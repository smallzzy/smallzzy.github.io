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
- type cast `as`

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
- `break`
  - `break 'label`: break nested loop
  - `loop` break can carry return value

```rust
// switch case
let result = match item {
    // match certain item
    42 | 132 => 1,
    // match with if, for additioanl condition
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

// match
let v: Vec<_> = s.split(',').collect();
let (city, year, temp) = match &v[..] {
    [city, year, temp] => (city.to_string(), year, temp),
    _ => return Err(ParseClimateError::BadLen),
};
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

- interior mutability: internal state can be changed through shared reference
  - `std::cell::UnsafeCell`

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
  - closure can `capture` varaible from current scope
    - `move`: force move during capture
  - parameter: variable to be expected at call site
    - closure has its return type
    - `return` `?` might not suit in closure

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

- default implemenation?
- combine trait?
- requried internal type?

## generic

- function
  - `fn add(i: T, j: T) -> T`
- `struct Wrapper<T>`
- `impl<T> Wrapper<T>`
- trait bound:
  - generic types can take traits which place constraints on the type
  - `fn print<T: std::fmt::Display>(i: T, j: T) -> T`
  - or with the `where` clause https://doc.rust-lang.org/rust-by-example/generics/where.html

`::<T>` turbofish

## concurrent

not thread safe type cannot cross thread boundary

- `Box` smart heap pointer
  - for dynamic size type or recursive type
  - `dyn` for trait bound type
- `Cell`, `RefCell`: runtime borrow check for multiple reference
- `Arc` atomic reference count
  - when cloned, the reference count is increased
  - `Rc`
- `Mutex` -> `LockResult` -> `MutexGuard`
  - Mutex will be poisoned when a thread holding the lock panics
    - further lock will have `Err` result
    - `into_inner`
  - LockResult is unwarped in place to paic if lock failed
  - MutexGuard is a RAII style guard
    - `drop` to release the lock
    - `Condvar`: reliquish while waiting, acquire when signaled

## crate & module

- crate can be one library or multiple binary
  - dependency specified via `Cargo.toml`
  - Or `--extern` when compiling
- `mod`: control function scoping
  - `pub()`: expose function to other path
  - `use`: bring path into scope
    - `use std::time::{self, SystemTime};`
    - `use std::time::*;`
    - `as`: rename
- [path](https://doc.rust-lang.org/edition-guide/rust-2018/path-changes.html)
  - `self`: refer to current module
  - `super`: refer to parent module
  - `crate`: refer to crate root

### comment

- `\\`: normal comment
- `\\\`: document for the following block
- `\\!`: document but for this file

### Cargo.toml

- enable feature for crate `features = ["small_rng"]`
