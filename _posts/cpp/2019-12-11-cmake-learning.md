---
layout: post
title: 
date: 2019-12-11 11:51
category: 
author: 
tags: [compile, lang]
summary: 
---

## basic

* variable is stored in string
* list is a semicolon separated string
  * semicolon is replaced when used in flags

## flags

`cmake_<LANG>_flags` is used in all build type
`cmake_<LANG>_flags_<CONFIG>` is used only if the specified build type is used

If we just `set` the flag, the flag will not appear in cache.
But it will still be used.

### ccache

* `CMAKE_<LANG>_COMPILER_LAUNCHER=ccache`
* CCACHE_BASEDIR
  * rewrite absolute path under the base directory to relative path when construsting hash
  * typical path:
    * home directory
    * parent of build directory
* CCACHE_DIR: store compiler output

## cmake property

* `add_<property>`
  * `target_<property>`
  * `set_target_properties`
* COMPILE_DEFINITIONS
* COMPILE_OPTIONS
  * options will not be added to linking (different from flags)
* INCLUDE_DIRECTORIES
* SYSTEM_INCLUDE_DIRECTORIES
* LINK_OPTIONS
* LINK_LIBRARIES

### misc

* `-fsanitize=address` needs to be added to linking
  * if only library is sanitized, libasan is not loaded first
    * `LD_PRELOAD=$(gcc -print-file-name=libasan.so)`
* cmake seems to de-duplicate flags in options

### interface

Property in interface will be inherited by child target.

## target_link_libraries

The parameter can take:

* library target, path to library, library name
* link flags: add flags to the link command
* `debug`, `optimized`, `general` set config specific option

### rpath

[rpath handling](https://gitlab.kitware.com/cmake/community/-/wikis/doc/cmake/RPATH-handling)

* Using shared library in `target_link_libraries` seems to have certain side effect.
  * EX. it might not update build rpath correctly if a version number is given
* The idiomatic way is to use `find_library`

## generator expression

We can use generator to create settings for a target given different environment.

* `$<condition:true_string>`: expand to variable then condition is met
  * `$<CONFIG:cfg>`: flags for different config
  * `$<COMPILE_LANGUAGE:languages>`: flags for different language.
* `$<TARGET_PROPERTY:tgt,prop>`
  * `$<TARGET_PROPERTY:prop>`

## external packages

* git submodule + add_subdirectory
* ExternalProject
* FetchContent

```cmake
include(FetchContent)

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        release-1.10.0
)

FetchContent_GetProperties(googletest)
if(NOT googletest_POPULATED)
    FetchContent_Populate(googletest)
    add_subdirectory(${googletest_SOURCE_DIR} EXCLUDE_FROM_ALL)
endif()
```

## default build type

```cmake
set(default_build_type "RelWithDebInfo")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Setting build type to '${default_build_type}' as none was specified.")
    set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE STRING "Choose the type of build." FORCE)
endif()
```

## configure_file

move file into position and substitutes the variables. (`@VAR@` or `${VAR}`)

## cmake toolchain file

[ios](https://github.com/leetal/ios-cmake)
[vcpkg](https://vcpkg.readthedocs.io/en/latest/)
