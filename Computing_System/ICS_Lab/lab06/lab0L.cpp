// This is lab1 L verson
#include <cstdio>

int main() {
    short r0, r1, r7;     //store the objects 
    scanf("%hd %hd", &r0, &r1);
    //begin
    r7 = 0;
    label:
    r7 = r7 + r0;
    r1 = r1 - 1;
    if (r1 != 0)
        goto label;
    //end
    printf("%hd\n", r7);
    return 0;
}