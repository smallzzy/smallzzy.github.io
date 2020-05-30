---
layout: post
title: 
date: 2019-10-25 16:52
category: 
author: 
tags: [compile]
summary: 
---

## flags

* basic: `-pedantic -Wall -Wextra` 
* error: `-Werror -Wl,--fatal-warnings`
* math: `-Wcast-align -Wfloat-equal -Wsign-compare`
* use gold linker: `-fuse-ld=gold`
* build id: `-Wl,--build-id`

## compile options record

`-frecord-gcc-switches`

## reduce binary size

function remove:

* mark with: `-ffunction-sections -fdata-sections`
* remove with: `-Wl,--gc-sections`

remove rtti `-fno-rtti`

## performance flags

link time optimization, optimize across compilation unit: `-lto`

## strict-aliasing

Strict aliasing make dereferencing a pointer with incompatible type a UB.

More details on this [gist](https://gist.github.com/shafik/848ae25ee209f698763cffee272a58f8)

```c
unsigned long a;
a = 5;
*(unsigned short *)&a = 4;
```

With strict aliasing,

* gcc might assume that two pointers are different memory locations
* optimization (such as re-order) might took place against our intention.

## frame-pointer

In a stack frame, we have:

* top
* local variable
* return address
* parameter
* bottom

And

* stack pointer, which points to the top of the stack
* frame pointer, which points to the return address of function
  * a frame pointer is needed when we have variable stack length ex. alloca

With the flag,

* `-fno-omit-frame-pointer`
  * compiler will always generate frame pointer
  * can help with debug because variable position can be easily determined
* `-fomit-frame-pointer`
  * can reduce code size when frame pointer is not necessary
  * it might still get generated when compiler determine it is necessary

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

## todo

```
sized-deallocation
-rdynamic
-Wl,--hash-style=gnu
-Wl,-Bsymbolic-functions
--dynamic-list
-print-file-name
```

coverage
cppinsight
