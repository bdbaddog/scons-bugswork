// +FHDR------------------------------------------------------------
//  Imported by Picocom, 2023
// -----------------------------------------------------------------

#include "stdio.h"

int main (void)
{

//Section 1: Hello World!
  printf("\nHello Friend!\n");
  printf("Welcome to T-HEAD World!\n");

//Section 2: Define a,b,c
  int a;
  int b;
  int c;
  a=1;
  b=2;
  c=0;
  printf("\na is %d!\n",a);
  printf("b is %d!\n",b);
  printf("c is %d!\n",c);

//Section 3: Embeded ASM in C
//c=a+b
asm(
    "mv  x5,%[a]\n"
    "mv  x6,%[b]\n"
    "label_add:"
    "add  %[c],x5,x6\n"
    :[c]"=r"(c)
    :[a]"r"(a),[b]"r"(b)
    :"x5","x6"
    );

if(c == 3)
  printf("!!! PASS !!!");
else
  printf("!!! FAIL !!!");
  printf("after ASM c is changed to %d!\n",c);

  return 0;
}
