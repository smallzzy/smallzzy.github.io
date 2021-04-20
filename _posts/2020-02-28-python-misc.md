---
layout: post
title: 
date: 2020-02-28 17:08
category: 
author: 
tags: [python]
summary: 
---

## basic

* python float is usually implemented with c double: 64 bit
* `.format` esacpe `{}` by doubling it, `{{` `}}` 
  * use a `f'string {replace}'` in python3

## inplace operation

* `__add__` vs `__iadd__`
  * `a = b + c` vs `b += c`
* note that new PyObject is created when operation is not inplace

## asyncio

* move blocking function to another process:
  * [run_in_executor](https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.loop.run_in_executor)

## numpy

### indexing

* `Ellipsis` expands to the number of : objects needed for the selection tuple to index all dimensions.
* Each `newaxis` object in the selection tuple serves to expand the dimensions of the resulting selection by one unit-length dimension
  * `newaxis` is a alias of `None`
* operation on certain axis means to increment index along that axis.

```python
>>> x = np.array([[[1],[2],[3]], [[4],[5],[6]]])
>>> x.shape
(2, 3, 1)
>>> x[...,0]
array([[1, 2, 3],
       [4, 5, 6]])
>>> x[:,np.newaxis,:,:].shape
(2, 1, 3, 1)
```

### boardcast

- Two dimensions are compatible when
  1. they are equal, or
  2. one of them is 1
- Lining up the sizes of the trailing axes according to the broadcast rules, will shows if arrays are compatible
- Dimensions with size 1 are stretched or “copied” to match the other

## pybind

py::object hold reference to pyobject
py::handle does not reference

_a -> user defined literal

return value policy
keepalive
capsule
https://pybind11.readthedocs.io/en/stable/advanced/functions.html#python-objects-as-arguments

## env

* override python malloc at cmd: `PYTHONMALLOC=malloc`
  * the regular pymalloc seems to cause false positive for valgrind

https://docs.python.org/3/using/cmdline.html

## edit conda environment

* install conda with `-p <path>` 

Create activate and deactivate file as suggested in [document](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#macos-and-linux).

```bash
# addition
export LD_LIBRARY_PATH=<value>${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# removal
export LD_LIBRARY_PATH=$(echo ${LD_LIBRARY_PATH} | sed -e 's|<value>:\?||')
```

## module / package

```txt
sound/                        Top-level package
    __init__.py               Initialize the sound package
    formats/                  Subpackage for file format conversions
        __init__.py
        wavread.py
        wavwrite.py
    effects/                  Subpackage for sound effects
        __init__.py
        echo.py
        surround.py
```

1. The `__init__.py` files are required to make Python treat directories containing the file as packages.
2. Users of the package can import individual modules from the package.
3. when using `from package import item`,
   the item can be either a submodule (or subpackage) of the package,
   or some other name defined in the package
4. When using `import item.subitem.subsubitem`,
   each item except for the last must be a package.
   the last item can be a module or a package but cannot be some other name defined in the package.
5. Submodule can import its sublings via:
   1. absolute import: `from sound.effects import echo`
   2. relative import (ex for surround.py):
      1. `from . import echo`
      2. `from .. import formats`
      3. `from ..formats import wavwrite`

> relative imports are based on the name of the current module.
> Since the name of the main module is always `__main__`,
> modules intended for use as the main module of a Python application must always use absolute imports.

## setup.py

```python
setup(
    name='egg file name',
    packages=['package name'], # find_packages()
    # custom building step
    # listed in distutils.command
    cmdclass={},
    # external modules to build 
    ext_modules=[]
)
```

a good example for [cmake+setup.py](https://github.com/pybind/cmake_example/blob/master/setup.py)

## package 

schedule
queue.work_done() queue.join()

trio?
