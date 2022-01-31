// This is lab2 fibonacci
#include <cstdio>

int main() {
    short r0 = 0, r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0, r6 = 0, r7 = 0;     //store the objects 
    scanf("%hd", &r0);
    //begin
    const short n = 1023;

    r7 = 1;
    r5 = 1;
    r4 = 0;
    r0 = r0 - 2;
    if (r0 > 0) goto start;
    if (r0 < 0) goto f2;
    r7 = r7 + 1;
    f2:
    goto end;

    start:
    r5 = n;
    r1 = 1;
    r2 = 1;
    r3 = 2;

    fstart:
    r7 = r1 + r1;
    r7 = r7 + r3;
    r7 = r7 & r5;

    r1 = r2;
    r2 = r3;
    r3 = r7;
    r0 = r0 - 1;
    if (r0 != 0) goto fstart;
    end:


    //end
    printf("%hd\n", r7);
    return 0;
}