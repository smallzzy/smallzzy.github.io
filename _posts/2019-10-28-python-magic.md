---
layout: post
title: 
date: 2019-10-28 17:13
category: 
author: 
tags: [python]
summary: 
---

## `with`

An object can be used in `with` when it implements `__enter__` and `__exit__`.
The return value of `__enter__` can be used with `as`.

OR

`from contextlib import contextmanager`

## __new__ vs __init__

- `__new(cls)__` is used to construct a object
  - used in factory pattern, one class can be used to construct different sub-class
  - if the result has been initialized, `__init__` will be skipped
- `__init(self)__` is used to initialize a object
  - no return value is expected

### multiple inheritance

- `super(MyClass, self).__init__()` provides the next `__init__` method according to the used Method Resolution Ordering (MRO) algorithm in the context of the complete inheritance hierarchy.
  - for `class D(B, C)`, that means D -> B -> A -> C -> A
  - then removing all dup except the last: D -> B -> C -> A
- Which means that the base class needs to be designed to handle inheritance
  - it might need to call `super` with arbitrary parameter 
- The other solution is to call `__init__` explicitly for each class.

## __slots__ vs __dict__

- python attribute is usually stored in `__dict__` which use a lot of memory
- it is possible to a static set of attribute in `__slots__`
  - reduce foot print for small object

## decorator

In normal use case, decorator is a function that wraps another function.

```python
def my_decorator(func):
    def wrapper():
        print("Something is happening before the function is called.")
        func()
        print("Something is happening after the function is called.")
    return wrapper

@my_decorator
def say_whee():
    print("Whee!")
```

* notice that `say_whee` is passed into the decorator
* the returned `wrapper` end up replacing the original function
  * the function `__name__` is changed during the process
* use `functools.wraps` to maintain the original `__name__`

Moreover, parameter can be passed into the decorator.
Which gets evaluated first before the decorator.

In the next section, a `cls` is passed into `add_method` generate a decorator.

### modifying a class

This section describes the code to add methods to an existing class.

[source](https://medium.com/@mgarod/dynamically-add-a-method-to-a-class-in-python-c49204b85bd6)

```python
from functools import wraps # This convenience func preserves name and docstring

class A:
    pass

def add_method(cls):
    def decorator(func):
        @wraps(func) 
        def wrapper(self, *args, **kwargs): 
            return func(*args, **kwargs)
        setattr(cls, func.__name__, wrapper)
        # Note we are not binding func, but wrapper which accepts self but does exactly the same as func
        return func # returning func means func can still be used normally
    return decorator

# No trickery. Class A has no methods nor variables.
a = A()
try:
    a.foo()
except AttributeError as ae:
    print(f'Exception caught: {ae}') # 'A' object has no attribute 'foo'

try:
    a.bar('The quick brown fox jumped over the lazy dog.')
except AttributeError as ae:
    print(f'Exception caught: {ae}') # 'A' object has no attribute 'bar'

# Non-decorator way (note the function must accept self)
# def foo(self):
#     print('hello world!')
# setattr(A, 'foo', foo)

# def bar(self, s):
#     print(f'Message: {s}')
# setattr(A, 'bar', bar)

# Decorator can be written to take normal functions and make them methods
@add_method(A)
def foo():
    print('hello world!')

@add_method(A)
def bar(s):
    print(f'Message: {s}')

a.foo()
a.bar('The quick brown fox jumped over the lazy dog.')
print(a.foo) # <bound method foo of <__main__.A object at {ADDRESS}>>
print(a.bar) # <bound method bar of <__main__.A object at {ADDRESS}>>

# foo and bar are still usable as functions
foo()
bar('The quick brown fox jumped over the lazy dog.')
print(foo) # <function foo at {ADDRESS}>
```

## good decorator

`from functools import cache, cached_property`: memorization
