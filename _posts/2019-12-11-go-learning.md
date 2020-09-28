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

```bash
go run # build & run 
 --race # detect data race
go generate # generate go code
go build:
go install # install to $GOBIN
go get # download package to src
go fmt # format files
dlv debug --headless --listen localhost:2345 --api-version 2 # debug
--build-flags '-race'
```

### plugin

`go build -buildmode=plugin -o test.so <src>`

```go
p, err := plugin.Open("test.so") // load so
v, err := p.Lookup("V") // lookup symbol
```

### cgo

`//export Function`: generate c header
`go:linkname mallocgc runtime.mallocgc`

https://golang.org/cmd/cgo/

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
  * `defer` runs in LIFO
* make only works for map, slice, and channel
  * they hold reference to the underlying data structure, so changes are visible
  * map element is not addressable -> no pointer to them
  * [use pointer when in doubt](https://stackoverflow.com/questions/23542989/pointers-vs-values-in-parameters-and-return-values)
* `:=` will always shadow outer variable
* `switch, select` has a default break after each case
  * `break`: exit from `for, switch, select`
  * `continue`: continue from `for` 
  * `fallthrough`: transfer control to next case, must be last statement in current case
* `fmt` has special handling for some interface
  * https://godoc.org/fmt
  * `.error`

## loop

```go
for init; condition; post {}
for condition {}
for {}
```

* `break` breaks from innermost `for, switch, select`
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
  // there is also func (a Android) () {}
}
```

```go
// interface only list functions which are necessary to fullfill the interface
// interface can held a struct or a pointer to a struct
// so, a pointer to interface is not necessary
// https://stackoverflow.com/questions/44370277/type-is-pointer-to-interface-not-interface-confusion
type Shape interface {
  area() float64
}
```

* `interface{}` = any
* `struct{}` = none
* [Go Data Structures: Interfaces](https://research.swtch.com/interfaces)
  * interface stores type info (T) and concrete data (V) as pointer
    * similar to vtable in c++ -> Itab in go?
  * table computed for concrete type and interface
  * at runtime, the two tables are bind together
* when comparing interface, T and V needs to match
  * data is converted to interface for comparison
  * nil -> T = nil and V = nil
  * for nil pointer -> T != nil and V = nil

```go
// a syntax sugar that ensures a closure function also satifies its interface
type readerFunc func(p []byte) (n int, err error)
func (rf readerFunc) Read(p []byte) (n int, err error) { return rf(p) }
```

## array vs slice

* array are values, so it is always copied
* size of array is part of its type
* slice hold a reference to its content
  * internal changes are visible through copy
  * if slice is reallocated, the reference is changed

```go
func main() {
	slice:=[]string{"a","a"}
	func(slice []string) {
		slice[0] = "b"
		slice[1] = "b"
		slice = append(slice, "a") // reallocate 
		fmt.Print(slice) // bba
	}(slice)
	fmt.Print(cap(slice))
	fmt.Print(len(slice))
	fmt.Print(slice) // bb
}
```

```go
func main() {
	sliceA := make([]byte, 10)
	sliceC := sliceA[1:]
  sliceD := sliceA[2:]
  // sliceC and sliceD share the one backing array
  // we can check by the following
	fmt.Println(&sliceC[cap(sliceC)-1] == &sliceD[cap(sliceD)-1]) // true
}
```

### error

* `error` is a interface
* `fmt.Errorf` returns `error`
  * `%w` wraps another error in format
* since go 1.13, error can be chained
  * error.Unwrap() return the underlying err
  * `error.Is` and `error.As` will also check underlying err

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

## sync

### Pool

* memory pool for temporary object
* since go 1.13, a doubly linked list with used/free section
* New / Put / Get
  * New create new object for initial Get
  * object in pool might be GCed at any time

* Mutex
* WaitGroup
* Cond
* Context

## type

* there is only type assertion and type conversion
  * [assertion](https://golang.org/ref/spec#Type_assertions)
  * [conversion](https://golang.org/ref/spec#Conversions)
* assertion only works on interface to get its actual underlying type.
* [type identity](https://golang.org/ref/spec#Type_identity)
  * Named type: 
    * int / string / etc + type declaration
    * type name must match to be identical
  * Unnamed type: 
    * array / slice / map
    * they are only a description of structure
    * match as long as underlying type match
  * Alias: `type myInt = int`

```go
// type assertion
tmp, ok = value.(typeName)
// type switch
switch str := value.(type) {
  case typeName: 
}
```

## reflect

https://blog.golang.org/laws-of-reflection
`MakeFunc`
`ValueOf`
`DeepEqual`

## three dots

* last parameter of variadic function parameter `...T`
* unpack arguments to variadic function `s...`
* array literal `[...]string{"Moe", "Larry"}`
* wildcard symbol in go command

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

## import 

* internal:
  * > importable only by code in the directory tree rooted at the parent of "internal"
* vendor:
  * `go mod vendor`
  * vendor with GOPATH?
    * packages are found in all `vendor` folder
  * vendor with module
    * packages are found in the `vendor` at module's root
    * `-mod=vendor`, `-mod=mod`
      * since go 1.14, vendor is automatically used
  * useful for private package import?
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

## runtime.schedule()

* P - processor
  * limited by the number of logical processors (GOMAXPROCS)
  * when wake up a P, a M is created
* M - os thread
  * M must have a associated P to **execute**
  * M > P is possible if M is blocked
  * M will run G until blocked
* G - go routine

* When G is spawned, it is pushed onto a runnable queue
  * if P has a empty queue, it can steal from other P
* if M makes a blocking syscall
  * pessimistic, detach P from M
  * optimistic, sysmon waits until M spends too much time
    * (some syscalls return quickly)
    * P can be stolen to run other M
* if M is making a async syscall
  * M can block just as a G
  * the result can be polled on next schedule

* `runtime.schedule()`
* `go tool trace`
* work-share vs work-steal
* local and global runnable queue
* spinning thread - so that M do not get preemption

## protobuf

* install protoc
* protoc for golang is a plugin:
  * `go install google.golang.org/protobuf/cmd/protoc-gen-go`
* protoc
  * `proto_path`
    * if message are defined in several files, all source need to be included in this directory
  * `go_out` -> all generated file will be relative to this dir
  * `option go_package "full path";` generated into this path relative to go_out
    * --go_out=$GOPATH: so that pb file becomes its own package for import 
  * `go_opt=paths=source_relative` -> generated files are placed in output dir based on source's relative position vs proto_path
    * ignores go_package setting

## todo

https://go101.org/article/101.html
https://github.com/golang/go/wiki/CodeReviewComments
https://blog.golang.org/generics-next-step
https://blog.golang.org/normalization

## package

https://golang.org/pkg/
https://godoc.org/-/subrepo

### reader

* note that reader stall on empty stdin?

io.ioutil
bytes.Buffer
bufio

gob
wire
gin
tomb
