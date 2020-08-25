---
layout: post
title: 
date: 2019-12-11 02:19
category: 
author: 
tags: [lang]
summary: 
---

## go module

Go module is released in go 1.12 to help package control.
Module can be found at `https://godoc.org/`

* At the root of go module, we have a `go.mod` file.
  * can be generated via `go mod init`
* any sub-dir (packages) will be considered part of the module
* When we import a new module and it is not found during build, 
    go will fetch it from online and add to go.mod file

```
go list -m all # print current module dependency
go get # update a dependency
go mod tidy # remove unused dependency
```

## environment variable

```
GOROOT - go sdk install dir
GOPATH - go workspace dir
GOBIN - binary install dir
```

## command

```
go run: build & run 
 --race: detect data race
go generate: generate go code
go build:
go install - install to $GOBIN
go get - download package to src
go fmt: format files
```

## go language

The program entry point is:

```go
package main
func main() {}
```

The `package` must be the first line

```go
panic()
// return the argument passed to panic
recover()
// each source file can have init() functions
// init() is evaluated after imported packages
init()
```

* `_`is used as a dummy variable
  * can suppress unused import and unused variable
  * `import _ "net/http/pprof"` for side effect
* A `defer` statement defers the execution of a function until the surrounding function returns 
  * ie: the surrounding `func`
* make only works for map, slice, and channel
  * they hold reference to the underlying data structure, so changes are visible
  * map element is not addressable -> no pointer to them
* type alias `type myInt = int`

[use pointer when in doubt](https://stackoverflow.com/questions/23542989/pointers-vs-values-in-parameters-and-return-values)

## loop

```go
for init; condition; post {}
for condition {}
for {}
```

* `break` breaks from innermost `for, switch, select`
  * `switch, select` has a default break after each case
* loop variable is reused in go
  * if used within the goroutine, the value will change.
  * [iter](https://golang.org/ref/spec#For_statements)

## struct vs interface

```go
type Android struct {
  Person // anonymous field -> is-a relation
  // called embedding in go, can also be used on interface
  Model string // -> has-a relation
}

func (a *Android) () {
  // define function for struct
}
```

```go
type Shape interface {
  // interface is a pointer by itself
  area() float64 // describe the function needed for this interface
}
```

```go
func test(a interface{}) {}
// request a empty interface, i.e. any parameter
```

## go routine / channel

`go func()`

* limit the amount of go routine
* channel could block if there is no receiver
* `close(chan)` will retain its remaining values
  * write to a closed chan will panic
* `range` will wait on channel forever if not closed
* `select` can used to wait on multiple channels
  * and to avoid waiting with `default`
  * receive from a closed channel yields zero value
  * a nil channel is never ready for comm
  * select give no priority over order of case 

* Mutex
* WaitGroup
* Cond
* sync.Pool
* Context

## array vs slice

* array are values, so it is always copied
* size of array is part of its type
* slice hold a reference to its content
  * internal changes are visible through copy
  * if slice is reallocated, the reference is lost

```go
func main() {
	slice:=[]string{"a","a"}
	func(slice []string) {
		slice[0] = "b"
		slice[1] = "b"
		slice = append(slice, "a")
		fmt.Print(slice) // bba
	}(slice)
	fmt.Print(cap(slice))
	fmt.Print(len(slice))
	fmt.Print(slice) // bb
}
```

## plugin

`go build -buildmode=plugin -o test.so <src>`

```go
p, err := plugin.Open("test.so") // load so
v, err := p.Lookup("V") // lookup symbol
```

## type assertion

Only works for interface to get its actual underlying type.

```go
v.(func(int)) // cast to function
tmp, ok = value.(typeName) // type cast
switch str := value.(type) {
  case typeName: 
} // type switch
```

https://stackoverflow.com/questions/32393460/convert-function-type-in-golang
https://golang.org/pkg/reflect/#MakeFunc
https://golang.org/doc/faq#stack_or_heap

### reflection

`ValueOf`

## three dots

* last parameter of variadic function parameter `...T`
* unpack arguments to variadic function `s...`
* array literal `[...]string{"Moe", "Larry"}`
* wildcard symbol in go command

## printf

[cheatsheet](https://yourbasic.org/golang/fmt-printf-reference-cheat-sheet/)

## test and benchmark

https://blog.golang.org/pprof
https://golang.org/doc/diagnostics.html

```
go test -run=xxx # run all test matching xxx
go test -bench=. # run all tests + benchmarks
```

* benchmark is run for a minimum of 1s. `-benchtime`
* benchmark is run until stable
  * changing runtime is not acceptable
* compiler might eliminate function
  * always retrieve result to a package level variable

## cgo

`//export Function`: generate c header

https://golang.org/cmd/cgo/

## import 

* internal:
  * > importable only by code in the directory tree rooted at the parent of "internal"
* vendor:
  * similar import rule as internal
  * package import check vendor first
    * package in vendor does not need parent package name
    * package in vendor can shadow outer package
  * useful for private package import
* [limit import url](https://golang.org/cmd/go/#hdr-Import_path_checking)
  * `package gin // import "github.com/gin-gonic/gin"`

## workspace - legacy

* a go project is kept in one workspace
  * $GOPATH should point to this workspace
* a workspace will include following directory
  * src: packages sources
  * bin: compiled binary will be installed here
  * pkg: compiled static lib here (will be platform & arch specific)
* src can include many directory
  * each directory become its own package
    * one of which is user's project, others can be from `go get`
    * package version need to be manually controlled
    * all files in the same package must use the same package name.
