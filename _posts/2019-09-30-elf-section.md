---
layout: post
title: 
date: 2019-09-30 10:57
category: 
author: 
tags: [compile]
summary: 
---

## display symbol table

[nm result](https://sourceware.org/binutils/docs/binutils/nm.html)

```bash
nm -C # demangle
nm -D # dynamic symbol
nm --print-size --size-sort --radix=d # sort symbol size
```

```bash
objdump -t # content symbol table
objdump -T # content of dynamic symbol table
objdump -x # display all headers
objdump -s # dump full contents of all sections requested
objdump -j=NAME # display one specified section
```

```bash
readelf -W # output width
readelf -s # symbol table
readelf --dyn-syms # dynamic symbol table
readelf -d # dynamic section # library deps, rpath
```

## c++ demangle

```bash
c++filt
```

## elf file format

bss: uninitialized data section (for global or static variable)

* uninitialized or zero initialized by program.
* zero initialized by system.
* reduce binary size

data: initialized data section (for global or static variable)

* have a pre-defined value

## strip

`--strip-unneeded`

### debug symbol

* gdb support two modes: `debug link` and `build id`
* for `debug link`, we generate debug symbol file as the following

```bash
# all version
BIN=foo
objcopy --only-keep-debug $BIN $BIN.debug
strip -g $BIN
objcopy --add-gnu-debuglink=$BIN.debug $BIN
# special strip version required
strip foo -f foo.debug
```

## compile

* guard variable for static:
  * dep?
  * multi-thread?

## rpath

```bash
patchelf --set-rpath '$ORIGIN/../lib64' <bin>
```

## plt & got

* address of function can change within library
* ASLR can load library at different position
* for performance, plt can identify cpu and jump to corresponding got?

### noun

* procedure linkage table: `.plt`
  * `-fno-plt`
  * `.got.plt`: used for lazy binding?
* global offset table: `.got`
* `.plt.got`?
* lazy binding: got might not get filled until first use
* ld-linux: dynamic linker, set in `.interp` section
  * LD_PRELOAD: symbols provided by loaded lib will be override later loaded ones

### process

* external function points to some address in plt
  * extern data points to address in got directly
* plt contains a script that:
  * jump to got if symbol loaded
  * otherwise, trigger the linker to load got

### relocation read-only (RELRO)

* partial: force got before bss so that a global variable overflow does not overwrite got
* full: make got read only. cannot use with lazy loading

## linker script

## reference

[plt got in static binary](https://reverseengineering.stackexchange.com/questions/2172/why-are-got-and-plt-still-present-in-linux-static-stripped-binaries)


## read list

https://www.agner.org/optimize/blog/read.php?i=167
https://linker.iecc.com/
https://www.airs.com/blog/archives/38
