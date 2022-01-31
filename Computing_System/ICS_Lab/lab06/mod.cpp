// This is lab4 task2 mod
#include <cstdio>
#include <cstdlib>

short r0 = 0, r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0, r6 = 0, r7 = 0;     //store the objects 
const short num = 14;


void fun() {
    r2 = r2 + 1;
    r3 = r3 + 8;
    start2:
    r5 = r3 & r1;
    if (r5 == 0) goto label;
    r4 = r2 + r4;
    label:
    r2 = r2 + r2;
    r3 = r3 + r3;
    if (r3 > 0) goto start2;
    return;
}

int main() {
   
    //begin
    r1 = num;
    start1:
    fun();
    r2 = r1 & 7;
    r1 = r2 + r4;
    r0 = r1 - 7;
    if (r0 > 0) goto start1;
    r0 = r1 - 7;
    if (r0 < 0) goto fend;
    r1 = r1 - 7;
    fend:   
    printf("%hd", r1);
    //end
  
    return 0;
}