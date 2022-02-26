/*9-3*/
#include <stdio.h>
#include <stdlib.h>
int main() {
	char str[20];
	int sum, n, k, i, j;
	int count, num, ans = 0;
	scanf("%d%d", &k, &n);
	
	for (i = 0; i <= 511; i++) {
		count = 0;
		num = i;
		sum = 0;
		for (j = 1; j <= 9; j++) {	
		    if (count > k) goto s1;		
			if (num & 1 == 1) count++;
			sum += (num & 1) * j;
			num >>= 1;
		}
		if (sum == n && count == k) {
			itoa(i,str,2);
		//	printf("%d ", i);
		//	puts(str);
			ans++;
		}
		s1: 0;
	}
	printf("%d", ans);
	return 0;
}
