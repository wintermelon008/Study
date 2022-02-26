#include <stdio.h>
int number[1020][1020] = {0};
int sum[1000][1000] = {0};

int main() {
	int n, win_size, stride, padding;
	int i, j, si = 1, sj = 1, dx, dy, si_length, sj_length;
	
	scanf("%d%d%d%d", &n, &win_size, &stride, &padding);
	//ÊäÈëÊı×é 
	for (i = 7; i <= 6 + n; i++) {
		for (j = 7; j <= 6 + n; j++) {
			scanf("%d", &number[i][j]);
		}
	}
	i = 7 - padding; 
	while (i <= 6 + padding + n) {
		j = 7 - padding;
		sj = 1;
		while (j <= 6 + padding + n) {
			for (dy = 0; dy < win_size; dy++) {
				for (dx = 0; dx < win_size; dx++) {
					sum[si][sj] = sum[si][sj] < number[i + dy][j + dx] ?
					              number[i + dy][j + dx] : sum[si][sj];
				}
			}
			sj++; j += stride;
		}
		sj_length = sj - 1;
		si++; i += stride;
	}
	si_length = si - 1;
	
	for (si = 1; si < si_length; si++) {
		for (sj = 1; sj < sj_length; sj++) {
			printf("%d ", sum[si][sj]);
		}
		if (si != si_length - 1) {
			printf("\n");
		}
	}
	return 0;
}
