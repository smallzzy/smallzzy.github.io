#include <iostream>

// local function
// Intentionally conflict with library function
void DoThing()
{
  printf("local\n");
};

// supposed library call
void DoLayer();

int main()
{
  printf("start \n");
  DoThing();
  DoLayer();
  printf("finished \n");
  return 0;
}
