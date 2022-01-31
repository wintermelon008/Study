// This is lab4 task1 rec
#include <cstdio>
#include <cstdlib>

short r0 = 0, r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0, r6 = 0, r7 = 0;     //store the objects 
short num = 5;
short arr[10] = {0};

void fun() {
    arr[r2] = r7;
    r2 = r2 + 1;
    r0 = r0 + 1;
    r1 = num;
    r1 = r1 - 1;
    num = r1;
    if (num == 0) goto label;
    fun();
    label:
    r2 = r2 - 1;
    r7 = arr[r2];
    return;
}

int main() {
   
    //begin

    r2 = 0;
    r0 = r0 & 0;
    fun();

    //end
  
    return 0;
}