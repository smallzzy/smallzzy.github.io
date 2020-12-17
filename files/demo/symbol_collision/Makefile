# this is the correct behavior
correct: main.cpp libhide.so
	g++ -c main.cpp -o main.o
	g++ -o test main.o -L. -lhide

# shared library symbol is hidden unintentionally
one_shared: main.cpp libone_shared.so
	g++ -c main.cpp -o main.o
	g++ -o test main.o -L. -lone_shared

# static library cannot be linked if there is duplicated symbol
# although the introduction is a unwanted side effect
one_static: main.cpp libone_static.a
	g++ -c main.cpp -o main.o
	g++ -o test main.o -L. -lone_static

# shared library symbol is hidden unintentionally
two_shared: main.cpp libtwo_shared.so
	g++ -c main.cpp -o main.o
	g++ -o test main.o -L. -ltwo_shared

# static library symbol is not introduced if the object is not included
two_static: main.cpp libtwo_static.a
	g++ -c main.cpp -o main.o
	g++ -o test main.o -L. -ltwo_static

libone_shared.so: one_fail.cpp
	g++ -c one_fail.cpp -o one_fail.o -fPIC
	g++ -shared -o libone_shared.so one_fail.o

libone_static.a: one_fail.cpp
	g++ -c one_fail.cpp -o one_fail.o
	ar rc libone_static.a one_fail.o

libtwo_shared.so: two_func.cpp two_fail.cpp
	g++ -c two_fail.cpp -o two_fail.o
	g++ -c two_func.cpp -o two_func.o
	g++ -shared -o libtwo_shared.so two_fail.o two_func.o

libtwo_static.a: two_func.cpp two_fail.cpp
	g++ -c two_fail.cpp -o two_fail.o
	g++ -c two_func.cpp -o two_func.o
	ar rc libtwo_static.a two_fail.o two_func.o

# run nm -C and observe the difference please
libhide.so: two_func.cpp two_fail.cpp
	g++ -c -fvisibility=hidden two_fail.cpp -o two_fail.o
	g++ -c -fvisibility=hidden two_func.cpp -o two_func.o
	g++ -shared -o libhide.so two_fail.o two_func.o

clean:
	rm *.o *.so *.a test 