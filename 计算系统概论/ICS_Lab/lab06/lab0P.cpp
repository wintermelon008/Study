// This is lab1 P verson
#include <cstdio>

int main() {
    short r0 = 0, r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0, r6 = 0, r7 = 0;     //store the objects 
    scanf("%hd %hd", &r0, &r1);
    //begin
    r2 = 1;
    r6 = r0;
    again:
    r3 = r2 & r1;
    if (r3 == 0) goto label1;
    r7 = r7 + r6;
    label1:
    r6 = r6 + r6;
    r2 = r2 + r2;
    if (r2 != 0) goto again;
    //end
    printf("%hd\n", r7);
    return 0;
}