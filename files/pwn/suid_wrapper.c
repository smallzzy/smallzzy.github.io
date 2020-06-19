#include <unistd.h>

extern char **environ;

int main (int argc, char ** argv) {
    execve("/usr/sbin/iotop", argv, environ);
}
