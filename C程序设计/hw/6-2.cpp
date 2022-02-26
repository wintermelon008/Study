/*6-2*/
#include <stdio.h>
#include <stdlib.h>
#define N 25000001
int num[N];

int main() {
	long long n;
    long long i, j, ii, jj;
	scanf("%lld", &n);
	
    for (i = 2; i <= n; i++) num[i] = 1;
    printf("2\n");
	for (i = 3; i <= n; i++) {
		
		if (num[i] == 0) continue;
		ii = 2 * i - 3;
		jj = ii * ii;
		while (0.5 * (jj + 3) <= n) {	
		    j = 0.5 * (jj + 3);			
			jj += ii * 2;
			num[j] = 0;
		}
		if (2*i-3 <= n) printf("%lld\n", 2*i-3);
    }
	return 0;
}


