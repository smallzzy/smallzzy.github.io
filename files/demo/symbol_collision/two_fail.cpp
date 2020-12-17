#include <iostream>

void DoThing();

static void IAmHidden()
{
  printf("I am hidden by default\n");
}

__attribute__((visibility("default"))) void DoLayer()
{
  printf("layer \n");
  DoThing();
  IAmHidden();
}
