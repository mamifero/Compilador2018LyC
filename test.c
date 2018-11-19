#include <stdio.h>

int main (void)
{
  int a,b;
  int * c,d;
  int ** e;
  
  b=5;
  d=b;
  e=d;
  a=**e;
}