symbol_conflict: main.cpp libconflict.so
	g++ -c main.cpp -o main.o
	g++ -o test main.o -L. -lconflict

symbol_sconflict: main.cpp libconflict.a
	g++ -c main.cpp -o main.o
	g++ -o test main.o -L. -lconflict

symbol_hide: main.cpp libhide.so
	g++ -c main.cpp -o main.o
	g++ -o test main.o -L. -lhide

cc_fail: main.cpp libfail.a
	g++ -c main.cpp -o main.o
	g++ -o test main.o -L. -lfail

cc_success: main.cpp libfail.so
	g++ -c main.cpp -o main.o
	g++ -o test main.o -L. -lfail

libconflict.so: thing.cpp conflict.cpp
	g++ -c conflict.cpp -o conflict.o
	g++ -c thing.cpp -o thing.o
	g++ -shared -o libconflict.so thing.o conflict.o

libconflict.a: thing.cpp conflict.cpp
	g++ -c conflict.cpp -o conflict.o
	g++ -c thing.cpp -o thing.o
	ar rc libconflict.a thing.o conflict.o

libhide.so: thing.cpp conflict.cpp
	g++ -c -fvisibility=hidden conflict.cpp -o conflict.o
	g++ -c -fvisibility=hidden thing.cpp -o thing.o
	g++ -shared -o libhide.so thing.o conflict.o

libfail.a: fail.cpp
	g++ -c fail.cpp -o fail.o
	ar rc libfail.a fail.o

libfail.so: fail.cpp
	g++ -c fail.cpp -o fail.o -fPIC
	g++ -shared -o libfail.so fail.o

clean:
	rm *.o *.so *.a test 