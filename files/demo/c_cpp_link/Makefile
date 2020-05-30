main: main.c cpp_target
	gcc -o test main.c -L. -lcpp

cpp_target: class.cpp class.h
	g++ -shared -o libcpp.so class.cpp -I. -fPIC

clean:
	rm *.so test