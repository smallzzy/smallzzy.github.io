#include <iostream>

void DoThing()
{
  printf("correct\n");
}

static void IAmHidden()
{
  printf("I am hidden by default\n");
}

void DoLayer()
{
  printf("layer\n");
  DoThing();
  IAmHidden();
}
