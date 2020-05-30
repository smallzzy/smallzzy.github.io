---
layout: post
title: 
date: 2019-12-31 18:39
category: 
author: 
tags: []
summary: 
---

## basics

* `[assembly: CLSCompliant(true)]` at api boundary
* `&&`, `||` has short circuit. `&`, `|` do not.
* array is a type
  * `int[] a = {1, 2, 3}`
  * `int[] a = new int[3]`
  * `int[] a = new int[3]{1, 2, 3}`
  * rectangle `int[,]` vs jagged `int[][]`
* tuple: create with `()`
* anonymous tye: create with `new {}`
* `=>` expression-bodied member syntax
  * lambda function
  * `()` can be used for void parameter.
* `const`: inherently `static`
  * `readonly`
* explicit cast will `InvalidCastException` is type does not match
  * `is` check if type match. 
    * c#7 `tmp is Salesman s` -> avoid double cast
  * `as` return null if type does not match
* `?` suffix
  * when used with value type: short cut for `Nullable`
  * when used with variable: check for not null before use.
    * will not throw if check failed

### class

* `partial`: separate class definition into multiple files
* `sealed`
* `abstract`, `interface`
* `this`, `base`

`object` define the following virtual

* `Equals`: check if the same reference in memory
  * `GetHashCode`: override at the same time.
* `Finalize`
* `GetType`: rtti
* `ToString`
* `MemberwiseClone`: shallow copy if contain reference.

### function

* function type
  * `out`: imply `ref`, must be assigned
  * `ref`
  * `params`: used on the last arg.
  Allow multiple parameters to be passed as comma delimited list.
  * optional parameter is specified with `:`
* `virtual`, `override`, `sealed`
* `abstract`: force override in child class
* `new`: shadow implementation before this one.
  * used when a parent function is not virtual and not modifiable.
  * however, the parent function is used if called with parent reference. There is no vtable after all.
* local function is private inside of another function
  * force function call in `IEnumerator` and `async`
* named parameter is provided with `:` instead of `=`
* `typeof` vs `.GetType()`

## string

* `$` enable variable name in `{}` when formatting
  * a single operation without `;` is also allowed
* `@` verbatim string: escape are ignored
* `StringComparison` defines compare mode
* `char` contains a `UTF16`

## switch

* c sharp can match to types
  * can match multiple times if using `when`

## reference type vs value type

(non-nullable) value type store data in its own memory space.
A object become value type whenever inherit from System.ValueType

* reference type = object pointer in c++?
* `ref` means reference in c++
  * must be used wherever we want pass by reference
  * including type name, function call, return type, return call

* string, arrays, ValueType, System.Enum are reference types
* non-nullable value type can also be boxed with `object`

```c#
int x = 5;
object y = x;
```

## enum

`Enum.GetUnderlyingType`
`Enum.GetValues`
`Enum.Format`
`.ToString()`

## nullable value type

`Nullable<T> where T : struct`

* use interface to safely contain null value data type
* `Value`: fail if no value exist
* `HasValue`: check if not `null`
* lifted operators
  * variable is not lifted so check must be performed before use
  * qualified op is changed to its nullable equivalent automatically
* `as` operator: convert data type. Works on nullable. Null if does not match
* `a ?? b` operator: if a is null, evaluate b.

## property

* auto property: the private variable is auto-gen
* auto property default value
* object initialization

```c#
class Garage {
  // property
  private int car;
  public int Car {
    get {return car;}
    set {car = value;}
  }

  // automatic property
  public int Car {get; set;}

  // with default value
  public Door tmp {get; set;} = new Door();
}

Garage test1 = new Garage();
test1.Car = ...;
// object initialization
Garage test2 = new Garage{Car = ...};
```

## interface

* only define member function
* can explicitly implemented as `Interface.Func`
  * avoid name clash
  * only accessible through the interface
  * hidden from object level

* `IEnumerable`
  * generate `IEnumerator`
  * `yield return`
  * named iterator
* `IClonable`
  * deepcopy
  * can based on `MemberWiseClone`
* `IComparable`
  * `CompareTo`
  * `IComparer`, `Compare`: a functor

## System.Collections

* Generic
* Specialized
* ObjectModel
* Concurrent

## generic

* arity: count of generic
* a declaration is generic only if it introduces new type
* cannot be generic
  * type: Enum
  * method and nest types: Fields, Properties Indexers, Constructors, Events, Finalizers
* type constraint:
  * specify what generic needs to provide
  * Reference type `where T: class`
  * Value type `where T: struct`
  * Constructor `where T: new()`: default constructable
  * Conversion `where T: SomeType`
  * cannot put constraint on operator support.
* reflection:
  * typeof can return `closed, constructed type`, or generic container without any types
  * In the form `List'1`

## delegate

* similar to function pointer in c++
* defines a type based on `System.MulticastDelegate` -> actual object required
  * `Invoke`, `BeginInvoke`, `EndInvoke`
  * `Combine`, `Remove`, `+=`, `-=`
  * check null before use
* `System.Delegate`:
  * `Method`: store the function call
  * `Target`: store the object associated with the call
* method group conversion: method can be converted to delegate automatically.
  * including lambda function, where the type can be inferred automatically.
* the type name of delegate do not really matter: `Action<>`, `Func<>`
* `delegate` can be used to declare anonymous method

## event

* reduce boilerplate code around delegate

```c#
public delegate void Handler(string msg);
// 1
private Handler func;
public void RegisterHandler(Handler tt) {
  func += tt;
};
// 2
public event Handler Func;
// Func can be invoked as delegate
// +=, -= (add_Func, remove_Func) can be used to change delegate
```

* a widely used pattern is to send
  * a `object`: reference to the object that send the event (this)
  * a class derived rom `System.EventArgs`: the custom information (parameter)
* which become `EventHandler<>`

## operator overload

* `this[]`: indexer
* `operator`
* `explicit`, `implicit` conversion
  * `static operator` + constructor

## extension

* defined within a static class
* using `this` on the first (and only the first) parameter
  * this specifies the object to be extended
  * the additional parameters are treated as normal incoming parameters.
  * extends the parent class?
* usually isolated within namespace and class libraries
* `object.GetType().GetMethod(methodName) != null`

## 

```
.net framework - 
mono: portable .net framework
.net core
```
