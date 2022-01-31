// This is lab5 prime
#include <cstdio>
#include <cstdlib>

short r0 = 0, r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0, r6 = 0, r7 = 0;     //store the objects 
const short num = 29;
const short minus1 = -1;


void Judge() {
    r2 = r2 + 2;
    r1 = r1 + 1;
    r5 = r5 + 1;
    r3 = minus1;
    r3 = r3 + r3;
    r4 = r0 + r3;
    if (r4 > 0) goto startmul;
    return;
    startmul:
    r3 = -r2;
    r4 = r0 + r3;
    if (r4 == 0) goto canmod;
    if (r4 < 0) goto modend;
    startmod:
    r4 = r4 + r3;
    if (r4 > 0) goto startmod;
    if (r4 < 0) goto modend;
    canmod:
    r1 = r1 & 0;
    return;
    modend:
    r6 = r2 + r2;
    r2 = r2 + 1;
    r6 = r5 + r6;
    r5 = minus1;
    r5 = r6 + r5;
    r6 = -r0;
    r4 = r6 + r5;
    if (r4 < 0) goto startmul;
    return;

}

int main() {
   
    //begin
    r0 = num;
    Judge();
    printf("%hd", r1);
    //end
    
    return 0;
}