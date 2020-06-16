---
layout: post
title: Symbol, Linkage, Visibility
date: 2019-12-05 10:43
category: 
author: 
tags: [compile]
summary: 
---

This post aims to help understanding the problem of symbol missing or conflict that appears during the compilation process.

## basics

A object file can:

* expect symbol from other object
  * "undefined" for imported symbol
  * ex, function in header, `extern` variable
* provide symbol for other object
  * "export" if default visibility
  * "internal" if hidden visibility

Visibility does not prevent symbol from being generated,
but instructs the linker that symbol cannot be used externally.
Note that only linker will care about visibility.

In `nm`:

* "undefined" is `U`.
* "export" is `T`.
* "internal" is `t`.

A static library is simply a collection of objects.
And it uses `ar` instead of `ld`.
Meaning that no linking is performed.

## linking object and static

Linker will maintain two lists.
One for exported symbols. One for undefined symbols.

Multiple definitions will happen when symbols are exported twice.
Undefined reference will happen when there are undefined symbols at the end of linking.

Object files are always imported by the linker.
Both lists will be updated correspondingly.

When linker encounters a static library, it will go through each object:

1. If that object exports a symbol that is in the undefined list,
   linker will import that object.
2. If that object has no symbol of interest, the object is skipped for now.
3. The iteration might run several times to resolve symbol dependency in the library.

Note:

1. By only import necessary object from static library,
   we can reduce binary size.
   The standard library even make a object per function to help this.
2. After linker has looked at a library,
   linker will not look at it again even if it contains necessary symbol.
   This behavior can be overrided by certain flags

## linking shared

Linking a shared library works similar to link a object,
but the duplicated symbol does not trigger an error.

> When binding symbols at runtime,
> the dynamic linker searches libraries in the same order
> as they were specified on the link line
> and uses the first definition of the symbol encountered.
> If more than one library happens to define the same symbol,
> only the first definition applies

## linking order

Linker will look at all the files from left to right in the command line.

1. For every file A that depends on file B, A needs to come before B to get A's undefined symbol registered.
2. For circular dependency, we can use linker flag:
   1. `--start-group archives --end-group`: Which resolves symbols recursively with possible "significant performance cost"
   2. `--undefined`: which tells linker some specific symbols will be missing.
   3. `--whole-archive`: force the entire library to be linked

* by default, the linker will add a DT_NEEDED tag for each dynamic library mentioned on the command line,
  regardless of whether the library is actually needed or not. `--no-as-needed`

## linkage

A translation unit refers to an implementation file (c/cpp) and all included headers.

* If internal linkage, that symbol is only visible to that translation unit.
* If external linkage, that symbol can used in other translation unit.
* `static` keyword / anonymous namespace force symbol to have internal linkage.
* `extern` force symbol to have external linkage.

By default,

* Non-const global variables have external linkage
* Const global variables have internal linkage
* Functions have external linkage

Linkage can affect symbol generation.
So, it will have an impact on visibility.
But its capability is limited across multiple sources.

## changing visibility

### shared

We can toggle symbol visibility in shared library via ths following methods:

#### Windows

`__declspec(dllexport)`: export symbol in dll
`__declspec(dllimport)`: import this symbol from some dll
We need to toggle this flag between dev and user.

Or using a def file. Where more definitions can be made.

#### Linux

`__attribute__ ((visibility ("default")))`: symbol is visible either for exporting or importing.
`__attribute__ ((visibility ("hidden")))`: symbol is not visible
Note: we need to use `-fvisibility=hidden` during compile to change default visibility

Or using a version script. Which is used to maintain binary compatibility.
The script can be used degenerately and just choose exposed symbols.

### static

Static library does no linking. Thus, we need to modify the symbol.

* `single object pre-link`: mac only solution. It will enable linking on the static lib.
And it will to hide library internal symbols
* `--exclude-libs` can be used to hide all symbols in a static library

Problematic approach:

* `strip` the unnecessary symbol if necessary symbols are known
  * might affect internal symbols
* `ar -x` extract object file from static library
  * The object will be linked with proper visibility
  * every object will be linked

### objcopy

`objcopy` can be used to change object symbol visibility

Op Note -> objcopy

## symbol confliction

If we have two conflicting symbols, the conflicted symbol might:

* trigger nothing if the symbol is defined in shared library
* not be included if that object is not included
* trigger multiple definition if object is imported via another function.

Possible solution:

1. We could use a different namespace
2. wrap with header and build into dynamic library
   1. need to change symbol visibility
3. use objcopy to modify symbol

## Reference

* [library order in static linking](https://eli.thegreenplace.net/2013/07/09/library-order-in-static-linking/)
* [internal and external linkage](http://www.goldsborough.me/c/c++/linker/2016/03/30/19-34-25-internal_and_external_linkage_in_c++/)
* [C++ visibility](https://gcc.gnu.org/wiki/Visibility)
* [mac symbol hiding](https://stackoverflow.com/questions/3276474/symbol-hiding-in-static-libraries-built-with-xcode)
* [How to write shared libraries](https://akkadia.org/drepper/dsohowto.pdf)
* [Good Practices in Library Design, Implementation, and Maintenance](https://akkadia.org/drepper/goodpractice.pdf)
* [share libary symbol conflict](https://holtstrom.com/michael/blog/post/437/Shared-Library-Symbol-Conflicts-%28on-Linux%29.html)
* [Inside story on shared library](https://cseweb.ucsd.edu/~gbournou/CSE131/the_inside_story_on_shared_libraries_and_dynamic_loading.pdf)

## todo

* [static library conflict](https://stackoverflow.com/questions/6940384/how-to-deal-with-symbol-collisions-between-statically-linked-libraries)
* [conflict demo](https://labjack.com/news/simple-cpp-symbol-visibility-demo)
