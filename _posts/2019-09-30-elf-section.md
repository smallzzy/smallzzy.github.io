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

## position independent code (PIC)

shared lib can be loaded anywhere
symbol relocation via linker and dynamic linker?

* procedure linkage table (PLT)
  * for function
* global offset table (GOT)
  * for data
* lazy binding: the tables are only filled once
* LD_PRELOAD: symbols provided by loaded lib will be override later

## linker script
