---
layout: post
title: 
date: 2019-12-11 11:51
category: 
author: 
tags: [compile, lang]
summary: 
---

## flags

`cmake_<LANG>_flags` is used in all build type
`cmake_<LANG>_flags_<CONFIG>` is used only if the specified build type is used

If we just `set` the flag, the flag will not appear in cache.
But it will still be used.

## add_compile_options

`target_compile_options`

add compile flags to all targets and all languages

However, the flags will not be added into the link flags.
This is a different behavior vs using flags.

### affected case

`-fsanitize=address` needs to be added to linking

### INTERFACE_COMPILE_OPTIONS

> List of public compile options requirements for a library.

## add_definitions

`add_compile_definitions`, `target_compile_definitions`

Usually used only for pre-processor values

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

## set_target_properties

set specfic properties for a target.

* this command is replacing instead of appending.
* I am not sure how to set multiple values to the same property with this command

`COMPILE_OPTIONS` set compile flags
`LINK_FLAGS` set linking flags

## generator expression

We can use generator to create settings for a target given different environment.

* `$<condition:variable>`: expand to variable then condition is met
  * `$<CONFIG:Debug>`: flags for different config
  * `$<COMPILE_LANGUAGE:lang>`: flags for different language.

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

## set default build type

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
