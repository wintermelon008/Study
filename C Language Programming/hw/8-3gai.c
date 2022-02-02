#include <stdio.h>
int space[200][200] = {100};
int anspace[200][200] = {0};
int m, n;
int main() {	
	int findlongest(int x, int y);
    int longest = 0;
    int i, j;
	scanf("%d%d", &m, &n);
	for (i = 0; i < n; i++) {
		for (j = 0; j < m; j++) {
			scanf("%d", &space[i][j]);
		}
	}
	for (i = 0; i < n; i++) {
		for (j = 0; j < m; j++) {
			longest = longest < findlongest(i, j) ? findlongest(i, j) : longest;
		}
	}
	printf("%d", longest);
	return 0;
}

int findlongest(int x, int y) {
	int max = 0;
	if (anspace[x][y] != 0) {
		return anspace[x][y];
	} else {
			if (x > 0 && space[x][y] > space[x - 1][y]) {
				if (max < findlongest(x - 1, y)) {
					max = findlongest(x - 1, y);
				}
			}
			if (x < n - 1 && space[x][y] > space[x + 1][y]) {
				if (max < findlongest(x + 1, y)) {
					max = findlongest(x + 1, y);
				}
			}
			if (y < m - 1 && space[x][y] > space[x][y + 1]) {	
				if (max < findlongest(x, y + 1)) {
					max = findlongest(x, y + 1);
				}
			}
			if (y > 0 && space[x][y] > space[x][y - 1]) {
				if (max < findlongest(x, y - 1)) {
					max = findlongest(x, y - 1);
				}
			}
	}
    anspace[x][y] = 1 + max;
	return 1 + max;
}
/*
6 5
1 1 1 2 3 0
1 2 2 2 4 0
1 2 7 2 5 0
1 2 2 2 6 0
1 1 1 1 1 0
*/
