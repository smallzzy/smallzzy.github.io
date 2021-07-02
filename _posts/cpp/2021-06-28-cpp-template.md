---
layout: post
title:
date: 2021-06-28 13:38
category:
author:
tags: []
summary:
---

## template

- different default argument in template is not considered to be a different template
- If a function / class is specialized, future call will only look at the specialized version
  - which means a token can resolve differently based on specialization
  - extract a common base class in order to share function between specialization

```c++
// function template
template <typename T> void func(T param) {}
// specialization
template <> void func<int>(int param) {}
// explicit instantiation
template void func<int>(int param);
```

## only allow specialization

```c++
// 1. delete base implementation
template<typename T>
T GetGlobal(const char *name) = delete;

// 2. no type will have sizeof = 0
template<typename T>
T GetGlobal(const char *name) {
    static_assert(sizeof(T) == 0, "");
}

template<>
int GetGlobal<int>(const char *name);
```

## template name lookup

For names in templates, there is a two phase name lookup.
`dependent` and `nondependent` with respect to some template parameter.

- The compiler will not look into dependent base class when looking up nondependent names.
  - `this->` is needed to use member for templated base class
  - The compiler might look into the bigger namespace instead
    - it is possible to get a different function with the same name
- The compiler might not be sure if a dependent name is a type
  - In this case, `typename` need to be specified
- The compiler might not be sure if a nondependent name becomes a dependent one.
  - In this case, `template` need to be specified

[Reference 1](https://eli.thegreenplace.net/2012/02/06/dependent-name-lookup-for-c-templates)
[Reference 2](https://en.cppreference.com/w/cpp/language/dependent_name)
[Guideline](https://isocpp.org/wiki/faq/templates#nondependent-name-lookup-members)

## SFINAE

- Short for Substitution failure is not an error.
- same token can resolve to different type.
  - by detecting the difference, one can perform template meta programming
  - ex: make one template fail so that a compliment template can be effective
- `enable_if<bool, T=void>::type`
  - resolve to T if true
  - otherwise, fail
  - `enable_if_t<bool> * = nullptr`

## c++ concepts

Just like trait in rust, it is time to specify constraint for template parameter.
