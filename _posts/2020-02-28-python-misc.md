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

- python float is usually implemented with c double: 64 bit
- `.format` esacpe `{}` by doubling it, `{{` `}}`
  - use a `f'string {replace}'` in python3

http://bokeh.org/

## inplace operation

- `__add__` vs `__iadd__`
  - `a = b + c` vs `b += c`
- note that new PyObject is created when operation is not inplace

## asyncio

- move blocking function to another process:
  - [run_in_executor](https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.loop.run_in_executor)

## debug

[debugpy](https://code.visualstudio.com/docs/python/debugging#_debugging-by-attaching-over-a-network-connection)

```python
import debugpy

# 5678 is the default attach port in the VS Code
debugpy.listen(5678)
debugpy.wait_for_client()
debugpy.breakpoint()
```

```json
{
  "name": "Python: Attach",
  "type": "python",
  "request": "attach",
  "port": 5678,
  "host": "localhost",
  "pathMappings": [
    {
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "."
    }
  ]
}
```

## numpy

### indexing

- `Ellipsis` expands to the number of : objects needed for the selection tuple to index all dimensions.
- Each `newaxis` object in the selection tuple serves to expand the dimensions of the resulting selection by one unit-length dimension
  - `newaxis` is a alias of `None`
- operation on certain axis means to increment index along that axis.

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

## env

- override python malloc at cmd: `PYTHONMALLOC=malloc`
  - the regular pymalloc seems to cause false positive for valgrind

https://docs.python.org/3/using/cmdline.html

## edit conda environment

- install conda with `-p <path>`

Create activate and deactivate file as suggested in [document](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#macos-and-linux).

```bash
# addition
export LD_LIBRARY_PATH=<value>${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
# removal
export LD_LIBRARY_PATH=$(echo ${LD_LIBRARY_PATH} | sed -e 's|<value>:\?||')
```

## module / package

[module definition](https://docs.python.org/3/glossary.html#term-module)

> Module serves as an organizational unit of Python code. Modules have a namespace containing arbitrary Python objects. Modules are loaded into Python by the process of importing.

[import system](https://docs.python.org/3/reference/import.html)

> Python has only one type of module object, and all modules are of this type, regardless of whether the module is implemented in Python, C, or something else. To help organize modules and provide a naming hierarchy, Python has a concept of packages.
> It’s important to keep in mind that all packages are modules, but not all modules are packages.

- `import <>`: import a module into local namespace
- `from <> import <>`:
  - find the module specified in the `from` clause
  - import the `attribute` with that name
    - attribute can be a function, class or variable

### sample package

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
2. Absolute imports: import start from the toplevel pacakge
   1. may use either the `import <>` or `from <> import <>` syntax
   2. ex `from sound.effects import echo`
3. Relative import:
   1. may only use the form `from <> import <>`
      1. > import XXX.YYY.ZZZ should expose XXX.YYY.ZZZ as a usable expression, but .moduleY is not a valid expression
   2. > Two or more leading dots indicate a relative import to the parent(s) of the current package, one level per dot after the first
   3. ex for surround.py
      1. `from . import echo`
      2. `from .. import formats`
      3. `from ..formats import wavwrite`
4. consideration for `main`

> relative imports are based on the name of the current module.
> Since the name of the main module is always `__main__`,
> modules intended for use as the main module of a Python application must always use absolute imports.

### import at runtime

`my_module = importlib.import_module('os.path')`

## extending python

There are multiple ways to extend python.

1. ctypes: Load library and map python types to C when calling
   1. [find_library](https://docs.python.org/3/library/ctypes.html#finding-shared-libraries)
2. cffi: Generate function interface based on source code?
3. [extension module](https://docs.python.org/3/extending/extending.html): specific to Cython, let library register itself
   1. pybind11 is a very convenient wrapper around this interface
   2. [module search path](https://docs.python.org/3/tutorial/modules.html#the-module-search-path)
   3. [site](https://docs.python.org/3/library/site.html)

### pybind11

py::object hold reference to pyobject
py::handle does not reference

```
# links to follow
https://github.com/pybind/cmake_example/blob/master/setup.py
https://pybind11.readthedocs.io/en/stable/advanced/cast/strings.html
https://pybind11.readthedocs.io/en/stable/advanced/cast/stl.html?highlight=bytes%20to%20vector#making-opaque-types
https://pybind11.readthedocs.io/en/stable/advanced/functions.html#return-value-policies
https://pybind11.readthedocs.io/en/stable/advanced/misc.html?highlight=py%3A%3Afunction#global-interpreter-lock-gil
https://pybind11.readthedocs.io/en/stable/faq.html
```

## package

schedule
queue.work_done() queue.join()

trio?

python-config --cflags: do we need this to be binary compatible?
--ldflags: do we need this at all?
--includes : seems to be helpful

https://docs.python.org/3/distutils/setupscript.html#installing-package-data

python3 -m sysconfig | less

https://pypi.org/project/accelerate/

simple http server
`python3 -m http.server 8000`

https://nuitka.net/doc/user-manual.html

