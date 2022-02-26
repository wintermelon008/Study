// This is lab3 fibonacci
#include <cstdio>

int main() {
    short r0 = 0, r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0, r6 = 0, r7 = 0;     //store the objects 
    scanf("%hd", &r0);
    //begin
    
    const short num = 1023;
    r7 = r7 + 2;
    r0 = r0 - 2;
    if (r0 > 0) goto label1;
    if (r0 == 0) goto label2;
    r7 = r7 - 1;
    label2:
    if (1) goto fend;
    label1:
    r1 = r1 + 1;
    r2 = r2 + 1;
    start:
    r1 = r1 + r1;
    r4 = r7 + r1;
    r1 = r2;
    r2 = r7;
    r7 = r4;
    r0 = r0 - 1;
    if (r0 > 0) goto start;
    r7 = num;
    r7 = r7 & r4;
    fend:

    //end
    printf("%hd\n", r7);
    return 0;
}