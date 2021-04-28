# What is the Strict Aliasing Rule and Why do we care?
## (OR Type Punning, Undefined Behavior and Alignment, Oh My!)

What is strict aliasing? First we will describe what is aliasing and then we can learn what being strict about it means. 

In C and C++ aliasing has to do with what expression types we are allowed to access stored values through. In both C and C++ the standard specifies which expression types are allowed to alias which types. The compiler and optimizer are allowed to assume we follow the aliasing rules strictly, hence the term *strict aliasing rule*. If we attempt to access a value using a type not allowed it is classified as [undefined behavior](http://en.cppreference.com/w/cpp/language/ub)(**UB**). Once we have undefined behavior all bets are off, the results of our program are no longer reliable.

Unfortunately with strict aliasing violations, we will often obtain the results we expect, leaving the possibility the a future version of a compiler with a new optimization will break code we thought was valid. This is undesirable and it is a worthwhile goal to understand the strict aliasing rules and how to avoid violating them. 

To understand more about why we care, we will discuss issues that come up when violating strict aliasing rules, type punning since common techniques used in type punning often violate strict aliasing rules and how to type pun correctly, along with some possible help from C++20 to make type punning simpler and less error prone. We will wrap up the discussion by going over some methods for catching strict aliasing violations.

### Preliminary examples

Let's look at some examples, then we can talk about exactly what the standard(s) say, examine some further examples and then see how to avoid strict aliasing and catch violations we missed. Here is an example that should not be surprising ([live example](https://wandbox.org/permlink/7sCJTAyrifZ0zfFA)):

```cpp
int x = 10;
int *ip = &x;
    
std::cout << *ip << "\n";
*ip = 12;
std::cout << x << "\n";
```

We have a *int\** pointing to memory occupied by an *int* and this is a valid aliasing. The optimizer must assume that assignments through **ip** could update the value occupied by **x**.

The next example shows aliasing that leads to undefined behavior ([live example](https://wandbox.org/permlink/8qA8JyJRVHtS9LPf)):

```cpp
int foo( float *f, int *i ) { 
    *i = 1;               
    *f = 0.f;            
   
   return *i;
}

int main() {
    int x = 0;
    
    std::cout << x << "\n";   // Expect 0
    x = foo(reinterpret_cast<float*>(&x), &x);
    std::cout << x << "\n";   // Expect 0?
}
```

In the function **foo** we take an *int\** and a *float\**, in this example we call **foo** and set both parameters to point to the same memory location which in this example contains an *int*. Note, the [reinterpret_cast](http://en.cppreference.com/w/cpp/language/reinterpret_cast) is telling the compiler to treat the the expression as if it had the type specificed by its template parameter. In this case we are telling it to treat the expression **&x** as if it had type *float\**. We may naively expect the result of the second **cout** to be **0** but with optimization enabled using **-O2** both gcc and clang produce the following result:

```
0
1
```

Which may not be expected but is perfectly valid since we have invoked undefined behavior. A *float* can not validly alias an *int* object. Therefore the optimizer can assume the *constant 1* stored when dereferencing **i** will be the return value since a store through **f** could not validly affect an *int* object. Plugging the code in Compiler Explorer shows this is exactly what is happening([live example](https://godbolt.org/g/yNV5aj)):

```assembly
foo(float*, int*): # @foo(float*, int*)
mov dword ptr [rsi], 1  
mov dword ptr [rdi], 0
mov eax, 1                       
ret
```

The optimizer using Type-Based Alias Analysis (TBAA)<sup id="a6">[6](#f6)</sup> assumes **1** will be returned and directly moves the constant value into register **eax** which carries the return value. TBAA uses the languages rules about what types are allowed to alias to optimize loads and stores. In this case TBAA knows that a *float* can not alias and *int* and optimizes away the load of **i**.

## Now, to the Rule-Book

What exactly does the standard say we are allowed and not allowed to do? The standard language is not straightforward, so for each item I will try to provide code examples that demonstrates the meaning. 

### What does the C11 standard say?

The **C11** standard<sup id="a2">[2](#f2)</sup> says the following in section *6.5 Expressions paragraph 7*:

>An object shall have its stored value accessed only by an lvalue expression<sup id="a5">[5](#f5)</sup> that has one of the following types:<sup>88)</sup>
> — a type compatible with the effective type of the object,

```c
int x = 1;
int *p = &x;   
printf("%d\n", *p); // *p gives us an lvalue expression of type int which is compatible with int
```

> — a qualified version of a type compatible with the effective type of the object,

```c
int x = 1;
const int *p = &x;
printf("%d\n", *p); // *p gives us an lvalue expression of type const int which is compatible with int
```

> — a type that is the signed or unsigned type corresponding to the effective type of the object,

```c
int x = 1;
unsigned int *p = (unsigned int*)&x;
printf("%u\n", *p ); // *p gives us an lvalue expression of type unsigned int which corresponds to 
                     // the effective type of the object
```

[See Footnote 12 for gcc/clang extension](#f12), that allows assigning *unsigned int\** to *int\** even though they are not compatible types.
    
> — a type that is the signed or unsigned type corresponding to a qualified version of the effective type of the object,

```c
int x = 1;
const unsigned int *p = (const unsigned int*)&x;
printf("%u\n", *p ); // *p gives us an lvalue expression of type const unsigned int which is a unsigned type 
                     // that corresponds with to a qualified verison of the effective type of the object
```

> — an aggregate or union type that includes one of the aforementioned types among its members (including, recursively, a member of a subaggregate or contained union), or

```c
struct foo {
  int x;
};
    
void foobar( struct foo *fp, int *ip );  // struct foo is an aggregate that includes int among its members so it can
                                         // can alias with *ip

foo f;
foobar( &f, &f.x );
```

> — a character type.

```c
int x = 65;
char *p = (char *)&x;
printf("%c\n", *p );  // *p gives us an lvalue expression of type char which is a character type.
                      // The results are not portable due to endianness issues.
```

### What the C++17 Draft Standard say

The C++17 draft standard<sup id="a3">[3](#f3)</sup>  in section *\[basic.lval\] paragraph 11* says:

> If a program attempts to access the stored value of an object through a glvalue of other than one of the following types the behavior is undefined:<sup>63</sup>
> (11.1) — the dynamic type of the object,

```cpp
void *p = malloc( sizeof(int) ); // We have allocated storage but not started the lifetime of an object
int *ip = new (p) int{0};        // Placement new changes the dynamic type of the object to int
std::cout << *ip << "\n";        // *ip gives us a glvalue expression of type int which matches the dynamic type 
                                  // of the allocated object
```

> (11.2) — a cv-qualified version of the dynamic type of the object,

```cpp
int x = 1;
const int *cip = &x;
std::cout << *cip << "\n";  // *cip gives us a glvalue expression of type const int which is a cv-qualified 
                            // version of the dynamic type of x
```

> (11.3) — a type similar (as defined in 7.5) to the dynamic type of the object,

```cpp
int *a[3];
const int *const *p = a;
const int *q = p[1]; // ok, read of 'int*' through lvalue of similar type 'const int*'
```

     
> (11.4) — a type that is the signed or unsigned type corresponding to the dynamic type of the object,

```cpp  
// Both si and ui are signed or unsigned types corresponding to each others dynamic types
// We can see from this godbolt(https://godbolt.org/g/KowGXB) the optimizer assumes aliasing.
signed int foo( signed int &si, unsigned int &ui ) {
  si = 1;
  ui = 2;

  return si;
}
```

> (11.5) — a type that is the signed or unsigned type corresponding to a cv-qualified version of the dynamic type of the object,

```cpp
signed int foo( const signed int &si1, int &si2); // Hard to show this one assumes aliasing
```

> (11.6) — an aggregate or union type that includes one of the aforementioned types among its elements or nonstatic data members (including, recursively, an element or non-static data member of a subaggregate or contained union),

```cpp
struct foo {
 int x;
};

// Compiler Explorer example(https://godbolt.org/g/z2wJTC) shows aliasing assumption
int foobar( foo &fp, int &ip ) {
 fp.x = 1;
 ip = 2;

 return fp.x;
}

foo f; 
foobar( f, f.x ); 
```

> (11.7) — a type that is a (possibly cv-qualified) base class type of the dynamic type of the object,

```cpp
struct foo { int x ; };

struct bar : public foo {};

int foobar( foo &f, bar &b ) {
  f.x = 1;
  b.x = 2;

  return f.x;
}
```

> (11.8) — a char, unsigned char, or std::byte type.

```cpp
int foo( std::byte &b, uint32_t &ui ) {
  b = static_cast<std::byte>('a');
  ui = 0xFFFFFFFF;                   
  
  return std::to_integer<int>( b );  // b gives us a glvalue expression of type std::byte which can alias
                                     // an object of type uint32_t
}
```

Worth noting *signed char* is not included in the list above, this is a notable difference from *C* which says *a character type*.

## Subtle Differences

So although we can see that C and C++ say similar things about aliasing there are some differences that we should be aware of. C++ does not have C's concept of [effective type](http://en.cppreference.com/w/c/language/object#Effective_type) or [compatible type](http://en.cppreference.com/w/c/language/type#Compatible_types) and C does not have C++'s concept of [dynamic type](http://en.cppreference.com/w/cpp/language/type#Dynamic_type) or *similar type*. Although both have *lvalue* and *rvalue* expressions<sup id="a5">[5](#f5)</sup>, C++ also has *glvalue*, *prvalue* and *xvalue*<sup id="a9">[9](#f9)</sup> expressions. These differences are mostly out of scope for this article but one interesting example is how to create an object out of malloc'd memory. In C we can set the *effective type*<sup id="a10">[10](#f10)</sup> for example by writing to the memory through an *lvalue* or **memcpy**<sup id="a11">[11](#f11)</sup>.

```c
// The following is valid C but not valid C++
void *p = malloc(sizeof(float));
float f = 1.0f;
memcpy( p, &f, sizeof(float));  // Effective type of *p is float in C
                                 // Or
float *fp = p;                   
*fp = 1.0f;                      // Effective type of *p is float in C
```

Neither of these methods is sufficient in C++ which requires **placement new**:

```cpp
float *fp = new (p) float{1.0f} ;   // Dynamic type of *p is now float
```

## Are int8_t and uint8_t char types?

Theoretically neither *int8_t* nor *uint8_t* have to be *char* types but practically they are implemented that way. This is important because if they are really *char* types then they also alias similar to *char* types. If you are unaware of this it can [lead to surprising performance impacts](https://stackoverflow.com/q/26295216/1708801).  We can see that glibc typedefs [int8_t](https://github.com/lattera/glibc/blob/master/sysdeps/generic/stdint.h#L36) and [uint8_t](https://github.com/lattera/glibc/blob/master/sysdeps/generic/stdint.h#L48) to *signed char* and *unsigned char* respectively.

This would be hard to change since for *C++* it would be an ABI break. This would change name mangling and would break any API using either of those types in their interface. 

## What is Type Punning

We have gotten to this point and we may be wondering, why would we want to alias for? The answer typically is to *type pun*, often the methods used violate strict aliasing rules.

Sometimes we want to circumvent the type system and interpret an object as a different type. This is called *type punning*, to reinterpret a segment of memory as another type. *Type punning* is useful for tasks that want access to the underlying representation of an object to view, transport or manipulate. Typical areas we find type punning being used are compilers, serialization, networking code, etc… 

Traditionally this has been accomplished by taking the address of the object, casting it to a pointer of the type we want to reinterpret it as and then accessing the value, or in other words by aliasing. For example:

```cpp
int x =  1 ;

// In C
float *fp = (float*)&x ;  // Not a valid aliasing

// In C++
float *fp = reinterpret_cast<float*>(&x) ;  // Not a valid aliasing

printf( “%f\n”, *fp ) ;
```

As we have seen earlier this is not a valid aliasing, so we are invoking undefined behavior. But traditionally compilers did not take advantage of strict aliasing rules and this type of code usually just worked, developers have unfortunately gotten used to doing things this way. A common alternate method for type punning is through unions, which is valid in C but *undefined behavior* in C++<sup id="a13">[13](#f13)</sup> ([see live example](https://wandbox.org/permlink/oOf9bPlcWDYrYqPF)): 

```c
union u1
{
  int n;
  float f;
} ;

union u1 u;
u.f = 1.0f;

printf( "%d\n", u.n );  // UB in C++ n is not the active member
```

This is not valid in C++ and some consider the purpose of unions to be solely for implementing variant types and feel using unions for type punning is an abuse.

### How do we Type Pun correctly?

The standard blessed method for *type punning* in both C and C++ is **memcpy**. This may seem a little heavy handed but the optimizer should recognize the use of **memcpy** for *type punning* and optimize it away and generate a register to register move. For example if we know *int64_t* is the same size as *double*:

```cpp
static_assert( sizeof( double ) == sizeof( int64_t ) );  // C++17 does not require a message
```

we can use **memcpy**:

```cpp
void func1( double d ) {
  std::int64_t n;
  std::memcpy(&n, &d, sizeof d); 
  //...
```

At a sufficient optimization level any decent modern compiler generates identical code to the previously mentioned **reinterpret_cast** method or *union* method for *type punning*. Examining the generated code we see it uses just register mov ([live Compiler Explorer Example](https://godbolt.org/g/BfZGwX)).

### Type Punning Arrays

But, what if we want to type pun an array of *unsigned char* into a series of *unsigned ints* and then perform an operation on each *unsigned int* value? We can use **memcpy** to pun the *unsigned char array* into a temporary of type *unsinged int*. The optimizer will still manage to see through the **memcpy** and optimize away both the temporary and the copy and operate directly on the underlying data, [Live Compiler Explorer Example](https://godbolt.org/g/acjqjD):



```cpp
// Simple operation just return the value back
int foo( unsigned int x ) { return x ; }

// Assume len is a multiple of sizeof(unsigned int) 
int bar( unsigned char *p, size_t len ) {
  int result = 0;

  for( size_t index = 0; index < len; index += sizeof(unsigned int) ) {
    unsigned int ui = 0;                                 
    std::memcpy( &ui, &p[index], sizeof(unsigned int) );

    result += foo( ui ) ;
  }

  return result;
}
```

In the example, we take a *char\** **p**, assume it points to multiple chunks of **sizeof(unsigned int)** data, we type pun each chunk of data as an *unsigned int*, compute **foo()** on each chunk of type punned data and sum it into **result** and return the final value.

The assembly for the body of the loop shows the optimizer reduces the body into a direct access of the underlying *unsigned char array* as an *unsigned int*, adding it directly into **eax**:

```Assembly
add     eax, dword ptr [rdi + rcx] 
```

Same code but using **reinterpret_cast** to type pun(violates strict aliasing):

```cpp
// Assume len is a multiple of sizeof(unsigned int) 
int bar( unsigned char *p, size_t len ) {
 int result = 0;

 for( size_t index = 0; index < len; index += sizeof(unsigned int) ) {
   unsigned int ui = *reinterpret_cast<unsigned int*>(&p[index]);

   result += foo( ui );
 }

 return result;
}
```

## C++20 and bit_cast

In C++20 we may gain **bit_cast**<sup id="a14">[14](#f14)</sup> which gives a simple and safe way to type-pun as well as being usable in a constexpr context.

The following is an example of how to use **bit_cast** to type pun a *unsigned int* to *float*, ([see it live](https://wandbox.org/permlink/i5l0g4IYuCFgLzzl)):

```cpp
std::cout << bit_cast<float>(0x447a0000) << "\n" ; //assuming sizeof(float) == sizeof(unsigned int)
```

In the case where *To* and *From* types don't have the same size, it requires us to use an intermediate struct<sup id="a15">[15](#f15)</sup>. We will use a struct containing a **sizeof( unsigned int )** character array (*assumes 4 byte unsigned int*) to be the *From* type and *unsigned int* as the *To* type.:

```cpp
struct uint_chars {
 unsigned char arr[sizeof( unsigned int )] = {} ;  // Assume sizeof( unsigned int ) == 4
};

// Assume len is a multiple of 4 
int bar( unsigned char *p, size_t len ) {
 int result = 0;

 for( size_t index = 0; index < len; index += sizeof(unsigned int) ) {
   uint_chars f;
   std::memcpy( f.arr, &p[index], sizeof(unsigned int));
   unsigned int result = bit_cast<unsigned int>(f);

   result += foo( result );
 }

 return result ;
}
```

It is unfortunate that we need this intermediate type but that is the current contraint of **bit_cast**.

## What is the Common initial sequence

The common initial sequence is defined in the draft standard section [\[class.mem.general\]p22](http://eel.is/c++draft/class.mem#general-22)

The draft standard gives the following examples to demonstrate the concept:

```
struct A { int a; char b; };
struct B { const int b1; volatile char b2; };
struct C { int c; unsigned : 0; char b; };
struct D { int d; char b : 4; };
struct E { unsigned int e; char b; };

The common initial sequence of A and B comprises all members of either class.
The common initial sequence of A and C and of A and D comprises the first member in each case.
The common initial sequence of A and E is empty.
```

It says that we are allowed to read the non-static data member of the non-active member if it is part of the common initial sequence of the the structs [\[class.mem.general\]p25](http://eel.is/c++draft/class.mem#general-25).

```
struct T1 { int a, b; };
struct T2 { int c; double d; };
union U { T1 t1; T2 t2; };
int f() {
  U u = { { 1, 2 } };   // active member is t1
  return u.t2.c;        // OK, as if u.t1.a were nominated
}
```

Note, this is not allowed in constant expression context see [\[expr.const\]p5.9](http://eel.is/c++draft/expr.const#5.9)

So something like the following would be ok:

```
union U { 
  U(int x) : a{.x=x}{}
  struct { int x; } a; 
  struct { int x; } b;
};

int f() {
  U u(10);

  u.b.x = 20; // change active member, starts lifetime of b
  u.a.x = 20; // change active member again, starts lifetime of a

  return u.b.x; // ok common initial sequence
}

int main() {
  int a = f();
}
```

Note that this relies on [\[class.union.general\]p6.3](http://eel.is/c++draft/class.union#general-6.sentence-3).

Which says if the assignment is starting the lifetime of the proper type with limitations such as we are using built-in or trivial assignment operator.

Which means the following example invokes undefined behavior:

```
union U { 
    U(int x) : a{.x=x}{}
    struct { 
        int x; 
         auto &operator=(int r) {
            x = r ; 
            return *this;
        }
    } a; 
    struct { 
       int x; 
       auto &operator=(int r) {
            x = r ; 
            return *this;
        }
    } b;
};

int f() {
   U u(10);
  
   u.b = 20; // Does not change the active member
             // assignment is not trivial 
             // and UB b/c of store to out of lifetime object
   u.a = 20; // Does not change the active member
             // assignment is not trivial 
             // and UB b/c of store to out of lifetime object

   return u.b.x; // still common initial sequence
                 // but we have already invoked UB so not ok
}
```

There can be other tricky cases to watch out for:

```
union A { 
  struct { int x, y; } a;
  struct { int x, y; } b;
};
int f() {
  A a = {.a = {}};
  a.b.x = 1; // Change active member, starts lifetime of b
             // there is no initialization of y
  return a.b.y; // UB
}
```

It Is likely the common initial sequence rule was put in place to allow discriminated union without having the discriminator outside the the union and therefore likely have padding between the discriminator and the union itself e.g.

```
union { struct { char kind; ... } a; struct { char kind; ... } b; ... };
```

So the common initial sequence rule would allow us to read the `kind` discriminator regardless of which member was active. 

## Alignment

We have seen in previous examples violating strict aliasing rules can lead to stores being optimized away. Violating strict aliasing rules can also lead to violations of alignment requirement. Both the C and C++ standard state that objects have *alignment requirements* which restrict where objects can be allocated (*in memory*) and therefore accessed<sup id="a17">[17](#f17)</sup>. C11 section *6.2.8 Alignment of objects* says:

>Complete object types have alignment requirements which place restrictions on the addresses at which objects of that type may be allocated. An alignment is an implementation-defined integer value representing the number of bytes between successive addresses at which a given object can be allocated. An object type imposes an alignment requirement on every object of that type: stricter alignment can be requested using the _Alignas keyword.

The C++17 draft standard in section *[basic.align] paragraph 1*:

>Object types have alignment requirements (6.7.1, 6.7.2) which place restrictions on the addresses at which an object of that type may be allocated. An alignment is an implementation-defined integer value representing the number of bytes between successive addresses at which a given object can be allocated. An object type imposes an alignment requirement on every object of that type; stricter alignment can be requested using the alignment specifier (10.6.2).

Both C99 and C11 are explicit that a conversion that results in a unaligned pointer is undefined behavior, section *6.3.2.3 Pointers* says:

>A pointer to an object or incomplete type may be converted to a pointer to a different object or incomplete type. If the resulting pointer is not correctly aligned<sup>57)</sup> for the pointed-to type, the behavior is undefined. ...

Although C++ is not as explict I believe this sentence from *[basic.align] paragraph 1* is sufficient:

> ... An object type imposes an alignment requirement on every object of that type; ...

### An Example

So let's assume:

- **alignof(char)** and **alignof(int)** are 1 and 4 respectively 
- sizeof(int) is 4

Then type punning an array of char of size 4 as an *int* violates strict aliasing but may also violate alignment requirements if the array has an alignment of 1 or 2 bytes.

```cpp
char arr[4] = { 0x0F, 0x0, 0x0, 0x00 }; // Could be allocated on a 1 or 2 byte boundary
int x = *reinterpret_cast<int*>(arr);   // Undefined behavior we have an unaligned pointer
```

 Which could lead to reduced performance or a bus error<sup id="a18">[18](#f18)</sup> in some situations. Whereas using **alignas** to force the array to the same alignment of *int* would prevent violating alignment requirements:

```cpp
alignas(alignof(int)) char arr[4] = { 0x0F, 0x0, 0x0, 0x00 }; 
int x = *reinterpret_cast<int*>(arr);
```

### Atomics

Another unexpected penalty to unaligned accesses is that it breaks atomics on some architectures. Atomic stores may not appear atomic to other threads on x86 if they are misaligned<sup id="a7">[7](#f7)</sup>.

## Catching Strict Aliasing Violations

We don't have a lot of good tools for catching strict aliasing in C++, the tools we have will catch some cases of strict aliasing violations and some cases of misaligned loads and stores. 

gcc using the flag **-fstrict-aliasing** and **-Wstrict-aliasing**<sup id="a19">[19](#f19)</sup> can catch some cases although not without false positives/negatives. For example the following cases<sup id="a21">[21](#f21)</sup> will generate a warning in gcc ([see it live](https://wandbox.org/permlink/cfckjTgwNTYHDIry)):

```cpp
int a = 1;
short j;
float f = 1.f; // Originally not initialized but tis-kernel caught 
               // it was being accessed w/ an indeterminate value below

printf("%i\n", j = *(reinterpret_cast<short*>(&a)));
printf("%i\n", j = *(reinterpret_cast<int*>(&f)));
```

although it will not catch this additional case ([see it live](https://wandbox.org/permlink/dwd9jhy53AF7a2D0)):

```cpp
int *p;

p=&a;
printf("%i\n", j = *(reinterpret_cast<short*>(p)));
```

Although clang allows these flags it apparently does not actually implement the warnings<sup id="a20">[20](#f20)</sup>.

Another tool we have available to us is ASan<sup id="a22">[22](#f22)</sup> which can catch misaligned loads and stores. Although these are not directly strict aliasing violations they are a common result of strict aliasing violations. For example the following cases<sup id="a23">[23](#f23)</sup> will generate runtime errors when built with clang using **-fsanitize=address**

```cpp
int *x = new int[2];               // 8 bytes: [0,7].
int *u = (int*)((char*)x + 6);     // regardless of alignment of x this will not be an aligned address
*u = 1;                            // Access to range [6-9]
printf( "%d\n", *u );              // Access to range [6-9]
```

The last tool I will recommend is C++ specific and not strictly a tool but a coding practice, don't allow C-style casts. Both gcc and clang will produce a diagnostic for C-style casts using **-Wold-style-cast**. This will force any undefined type puns to use reinterpret_cast, in general reinterpret_cast should be a flag for closer code review. It is also easiser to search your code base for reinterpret_cast to perform an audit.

For C we have all the tools already covered and we also have tis-interpreter<sup id="a24">[24](#f24)</sup>, a static analyzer that exhaustively analyzes a program for a large subset of the C language. Given a C verions of the  earlier example where using **-fstrict-aliasing** misses one case ([see it live](https://wandbox.org/permlink/ebLBJ17Pg7TsnIgY))

```c
int a = 1;
short j;
float f = 1.0 ;

printf("%i\n", j = *((short*)&a));
printf("%i\n", j = *((int*)&f));
    
int *p; 

p=&a;
printf("%i\n", j = *((short*)p));
```

tis-interpeter is able to catch all three, the following example invokes tis-kernal as tis-interpreter (output is edited for brevity):

```
./bin/tis-kernel -sa example1.c 
...
example1.c:9:[sa] warning: The pointer (short *)(& a) has type short *. It violates strict aliasing
              rules by accessing a cell with effective type int.
...

example1.c:10:[sa] warning: The pointer (int *)(& f) has type int *. It violates strict aliasing rules by
              accessing a cell with effective type float.
              Callstack: main
...

example1.c:15:[sa] warning: The pointer (short *)p has type short *. It violates strict aliasing rules by
              accessing a cell with effective type int.

```

Finally there is [TySan](https://www.youtube.com/watch?v=vAXJeN7k32Y)<sup id="a26">[26](#f26)</sup> which is currently in development. This sanitizer adds type checking information in a shadow memory segment and checks accesses to see if they violate aliasing rules. The tool potentially should be able to catch all aliasing violations but may have a large run-time overhead.

## Conclusion

We have learned about aliasing rules in both C and C++, what it means that the compiler expects that we follow these rules strictly and the consequences of not doing so. We learned about some tools that will help us catch some misuses of aliasing. We have seen a common use for type aliasing is type punning and how to type pun correctly. 

Optimizers are slowly getting better at type based aliasing analysis and already break some code that relies on strict aliasing violations. We can expect the optimizations will only get better and will break more code we have been used to just working.

We have standard conformant methods for type punning and in release and sometimes debug builds these methods should be cost free abstractions. We have some tools for catching strict aliasing violations but for C++ they will only catch a small fraction of the cases and for C with tis-interpreter we should be able to catch most violations.  

Thank you to those who provided feedback on this write-up: JF Bastien, Christopher Di Bella, Pascal Cuoq, Matt P. Dziubinski, Patrice Roy, Richard Smith and Ólafur Waage 

Of course in the end, all errors are the author's. 

#### Footnotes

<b id="f1">1</b> Undefined behavior described on cppreference http://en.cppreference.com/w/cpp/language/ub [↩](#a1)
<br>
<b id="f2">2</b> Draft C11 standard is freely available http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf [↩](#a2)
<br>
<b id="f3">3</b> Draft C++17 standard is freely available https://github.com/cplusplus/draft/raw/master/papers/n4659.pdf [↩](#a3)
<br>
<b id="f4">4</b> Latest C++ draft standard can be found here: http://eel.is/c++draft/ [↩](#a4)
<br>
<b id="f5">5</b> Understanding lvalues and rvalues in C and C++  https://eli.thegreenplace.net/2011/12/15/understanding-lvalues-and-rvalues-in-c-and-c [↩](#a5)
<br>
<b id="f6">6</b> Type-Based Alias Analysis https://www.drdobbs.com/cpp/type-based-alias-analysis/184404273 [↩](#a6)
<br>
<b id="f7">7</b> Demonstrates torn loads for misaligned atomics https://gist.github.com/michaeljclark/31fc67fe41d233a83e9ec8e3702398e8 and tweet referencing this example https://twitter.com/corkmork/status/944421528829009925 [↩](#a7)
<br>
<b id="f8">8</b> Comment in gcc bug report explaining why changing int8_t and uint8_t to not be char types would be an ABI break for C++ https://gcc.gnu.org/bugzilla/show_bug.cgi?id=66110#c13 and twitter thread discussing the issue https://twitter.com/shafikyaghmour/status/822179548825468928 [↩](#a8)
<br>
<b id="f9">9</b> "New” Value Terminology which explains how glvalue, xvalue and prvalue came about http://www.stroustrup.com/terminology.pdf [↩](#a9)
<br>
<b id="f10">10</b> Effective types and aliasing  https://gustedt.wordpress.com/2016/08/17/effective-types-and-aliasing/ [↩](#a10)
<br>
<b id="f11">11</b> “constructing” a trivially-copyable object with memcpy https://stackoverflow.com/q/30114397/1708801 [↩](#a11)         
<br>
<b id="f12">12</b> Why does gcc and clang allow assigning an unsigned int * to int * since they are not compatible types, although they may alias https://twitter.com/shafikyaghmour/status/957702383810658304 and https://gcc.gnu.org/ml/gcc/2003-10/msg00184.html
 [↩](#a12)
 <br>
<b id="f13">13</b> Unions and memcpy and type punning https://stackoverflow.com/q/25664848/1708801 [↩](#a13)
<br>
<b id="f14">14</b> Revision two of the bit_cast<> proposal http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2017/p0476r2.html [↩](#a14)
<br>
<b id="f15">15</b> How to use bit_cast to type pun a unsigned char array https://gist.github.com/shafik/a956a17d00024b32b35634eeba1eb49e [↩](#a15)
<br>
<b id="f16">16</b> bit_cast implementation of pop() https://godbolt.org/g/bXBie7 [↩](#a16)
<br>
<b id="f17">17</b> Unaligned access https://en.wikipedia.org/wiki/Bus_error#Unaligned_access [↩](#a17)
<br>
<b id="f18">18</b> A bug story: data alignment on x86 http://pzemtsov.github.io/2016/11/06/bug-story-alignment-on-x86.html [↩](#a18)
<br>
<b id="f19">19</b> gcc documentation for -Wstrict-aliasing https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wstrict-aliasing [↩](#a19)
<br>
<b id="f20">20</b> Comments indicating clang does not implement -Wstrict-aliasing https://github.com/llvm-mirror/clang/blob/master/test/Misc/warning-flags-tree.c [↩](#a20)
<br>
<b id="f21">21</b> Stack Overflow questions examples came from https://stackoverflow.com/q/25117826/1708801 [↩](#a21)
<br>
<b id="f22">22</b> ASan documentation https://clang.llvm.org/docs/AddressSanitizer.html [↩](#a22)
<br>
<b id="f23">23</b> The unaligned access example take from the Address Sanitizer Algorithm wiki https://github.com/google/sanitizers/wiki/AddressSanitizerAlgorithm#unaligned-accesses [↩](#a23)
<br>
<b id="f24">24</b> TrustInSoft tis-interpreter https://trust-in-soft.com/tis-interpreter/ , strict aliasing checks can be run by building tis-kernel https://github.com/TrustInSoft/tis-kernel  [↩](#a24)
<br>
<b id="f25">25</b> Detecting Strict Aliasing Violations in the Wild https://trust-in-soft.com/wp-content/uploads/2017/01/vmcai.pdf a paper that covers dos and don't w.r.t to aliasing in C [↩](#a25)
<br>
<b id="f26">26</b> TySan patches, clang: https://reviews.llvm.org/D32199 runtime: https://reviews.llvm.org/D32197 llvm: https://reviews.llvm.org/D32198 [↩](#a26)
