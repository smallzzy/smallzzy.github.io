#include <iostream>
void DoThing() {
    printf("work\n");
};
void DoLayer();

int main()
{
  printf("start \n");
  DoThing();
  DoLayer();
  printf("finished \n");
  return 0;
}