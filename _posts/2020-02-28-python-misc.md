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

python float is usually implemented with c double: 64 bit

## edit conda environment

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

TODO:
how should a folder be constructed?
