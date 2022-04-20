---
layout: post
title:
date: 2019-10-25 16:52
category:
author:
tags: [compile]
summary:
---

https://gcc.gnu.org/onlinedocs/gcc/Option-Index.html#Option-Index

## flags

- basic: `-pedantic -Wall -Wextra`
- error: `-Werror -Wl,--fatal-warnings`
- math: `-Wcast-align -Wfloat-equal -Wsign-compare`
- use gold linker: `-fuse-ld=gold`
- build id: `-Wl,--build-id`
- compile options record: `-frecord-gcc-switches`
- generate compile dependency: `-MM`

## spec file

[format](https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html)

- customize linker behavior
  - link to a different set of libraries
    - `newlib`, `newlib_nano`
  - change link flag

### semihosting

- `--specs=rdimon.specs`: printf is redirected to host machine using jtag

## reduce binary size

function remove:

- mark with: `-ffunction-sections -fdata-sections`
- remove with: `-Wl,--gc-sections`

remove rtti `-fno-rtti`

## performance flags

- link time optimization `-lto`
  - optimize across compilation unit
- profile guided optimization
  - hot cold splitting

[function attibute](https://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html)

## strict-aliasing

> an object of one type is assumed never to reside at the same address as an object of a different type

- optimization (such as re-order) might took place against our intention.

### type aliasing in c++

Dereferencing a pointer with incompatible type is a UB.
More details [here](https://gist.github.com/shafik/848ae25ee209f698763cffee272a58f8)

memcpy, bit_cast, union, aggregate?

## frame-pointer

In a stack frame, we have:

- top
- local variable
- return address
- parameter
- bottom

And

- stack pointer, which points to the top of the stack
- frame pointer, which points to the return address of function
  - a frame pointer is needed when we have variable stack length ex. alloca

With the flag,

- `-fno-omit-frame-pointer`
  - compiler will always generate frame pointer
  - can help with debug because variable position can be easily determined
- `-fomit-frame-pointer`
  - can reduce code size when frame pointer is not necessary
  - it might still get generated when compiler determine it is necessary

## overloaded virtual

```c++
class base
{
public:

    virtual void exception()
    {
    cerr << "unknown exception" << endl;
    }

    virtual void exception(const char* msg)
    {
    cerr << "exception: " << msg << endl;
    }
};

class derived : public base
{
public:
    // method 1
    // using base::execption;
    virtual void exception()
    {
        intermediate::exception("derived:unknown exception");
    }
    // method 2
    // private:
    // void exception(const char* tmp);
};
```

If we have a overloaded virtual function and only partially inherit it,
the other overload will be shadowed.
In the example, only `exception()` can be called through `derived`

This flag will show the shadowing as a warning.

## hardening

[Reference](https://wiki.debian.org/Hardening#Environment_variables)

```
-Wformat -Wformat-security -Werror=format-security # warn about uses of format function
-D_FORTIFY_SOURCE=2 # replace unlimited length buffer function call
-fstack-protector-strong # add check against stack overwrites
-fPIE -pie # ASLR
-Wl,-z,relro # turn several elf section to be read only
-Wl,-z,now # resolve all symbol now so that the complete GOT will be read only
```

### executable stack

[Reference](https://wiki.gentoo.org/wiki/Hardened/GNU_stack_quickstart)

```
-Wa,--noexecstack
-Wl,-z,noexecstack
-Wl,--warn-execstack
```

## pre-compile header

- avoid header being processed multiple times in larger project
- generate `.gch` file which take precedence over normal header file
- only one pre-compile header can be used in one translation unit
- ASLR can generate not binary identical `.gch` file
  - gch is a dump of compiler parsing state?
- any macro must be defined the same way when compiling the header
  - cannot use compiled header over c / c++
- debug info must be the same format, but can be ignored

## gcc path

- `-print-file-name`: print file path to certain file
  - very helpful when use library from gcc
- `--sysroot`: change gcc base folder for searching headers
- `gcc -E -Wp,-v -xc /dev/null`: print what the include path is
  - https://stackoverflow.com/questions/17939930/finding-out-what-the-gcc-include-path-is

## makefile

```makefile
FILES := $(shell ...)  # expand now; FILES is now the result of $(shell ...)
FILES = $(shell ...)   # expand later: FILES holds the syntax $(shell ...)

FILES != ... # same as FILES := $(shell ...)

all:
    # once inside of a indented block, each line is run by a separate shell
    FILES="$(shell ls)"; echo $$FILES
```

## todo

```
sized-deallocation
-rdynamic
-Wl,--hash-style=gnu
-Wl,-Bsymbolic-functions
--dynamic-list
```

coverage

-dM : generate a list of ‘#define’ directives for all the macros defined during the execution of the preprocessor, including predefined macros


-Wl,--no-undefined
does not work with weak symbol?

-Wl,--no-allow-shlib-undefined
