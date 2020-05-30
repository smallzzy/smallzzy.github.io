#include <iostream>

void DoThing() {
    printf("thing \n");
}

void DoLayer()
{
  printf("layer \n");
  DoThing();
}

