#include <iostream>
void DoThing();

__attribute__ ((visibility ("default")))
void DoLayer()
{
  printf("layer \n");
  DoThing();
}