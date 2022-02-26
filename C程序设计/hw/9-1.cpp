/*9-1*/
#include <stdio.h>
int main() {
	int rank(int *p, int num);
	int oddnum[10001] = {0}, evennum[10001] = {0};
	int *podd = oddnum, *peven = evennum;
	int i, n, temp, nodd = 0, neven = 0;
	
	scanf("%d", &n);
	
	for (i = 0; i < n; i++) {
		scanf("%d", &temp);
		
		if (temp % 2 == 0) {
			evennum[neven++] = temp;
		} else {
			oddnum[nodd++] = temp;
		}
	}
	
	rank(peven, --neven);
	rank(podd, --nodd);
	
	for (i = 0; i <= neven; i++) {
		printf("%d ", *(peven + i));
	}
	if (neven != 0) printf("\n");
	for (i = 0; i <= nodd; i++) {
		printf("%d ", *(podd + i));
	}
	return 0;
}

int rank(int *p, int num) {
	int i, j, temp;
	for (i = 0; i <= num; i++) {
		for (j = i + 1; j <= num; j++) {
			if (*(p + i) < *(p + j)) {
				temp = *(p + i);
				*(p + i) = *(p + j);
				*(p + j) = temp;
			}
		}
	}
	return 0;
}
