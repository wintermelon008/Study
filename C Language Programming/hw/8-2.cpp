#include <stdio.h>
int number[101][101] = {0};
int main() {
	void print(int m, int n);
	
	int m, n, i, j;
	scanf("%d%d", &m, &n);
	for (j = 0; j < m; j++) {
		for (i = 0; i < n; i++) {
			scanf("%d", &number[j][i]);
		}
	}
	print(n, m);
	return 0;
	
	/*
	for (j = 0; j < m; j++) {
		for (i = 0; i < n; i++) {
			printf("%d ", number[j][i]);
		}
		printf("\n");
	}
	*/
}

void print(int m, int n) {
	int dx = 0, dy = 0, k = 0;
	int i, j;
	int len = m > n ? n : m;
	for (k = 0; k <= len / 2; k++) {
		for (dx = k; dx < m - k; dx++) {
			printf("%d ", number[dy][dx]);
		}
		dx--;
 
		for (dy = k + 1; dy < n - k; dy++) {
			printf("%d ", number[dy][dx]);
		}
		dy--;
		if (k + 1 >= n - k) break;
		for (dx = m - k - 2; dx >= k; dx--) {
			printf("%d ", number[dy][dx]);
		}
		dx++;
		if (m - k - 2 <= k) break;
		for (dy = n - k - 2; dy >= k + 1; dy--) {
			printf("%d ", number[dy][dx]);
		}
		dy++;

	}
}
/*
3 6
1 2 3 4 5 6
7 8 9 10 11 12
13 14 15 16 17 18

*/
