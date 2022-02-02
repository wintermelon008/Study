/*6-3*/
#include <stdio.h>
int main() {
	int space[170][170] = {0};
	int i, xi, yi, x, y, nmax = 1, sum, max = -1;
	int d, n, x0, y0, k;
	scanf("%d", &d);
	scanf("%d", &n);
	for (i = 1; i <= n; i++) {
		scanf("%d%d%d", &x0, &y0, &k);
		space[21 + x0][21 + y0] = k; 
	}
	for (xi = 21; xi <= 149; xi++) {
		for (yi = 21; yi <= 149; yi++) {
			sum = 0;
			for (x = xi - d; x <= xi + d; x++) {
				for (y = yi - d; y <= yi + d; y++) {
					sum += space[x][y];
				}
			}
			if (sum > max) {
				max = sum;
				nmax = 1;
			} 
			else if (sum == max) {
				nmax++;
			}
		}
	}
	printf("%d %d", nmax, max);
	return 0;
}
