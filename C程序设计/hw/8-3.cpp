#include <stdio.h>
int space[201][201] = {0};
//int anspace[201][201] = {0};
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
//	int nextx = 0, nexty = 0, backx = 0, backy = 0;
	int max = 0;
	//bestchoice 对应 +x +y -x -y 为 1 2 3 4 为0则代表进入死路 
	if (space[x][y] > space[x - 1][y] && x != 0) {
		//backx = 1;
		if (max < findlongest(x - 1, y)) {
			max = findlongest(x - 1, y);
		//	bestchoice = 3;
		}
	}
	if (space[x][y] > space[x + 1][y] && x != n - 1) {
		//nextx = 1;
		if (max < findlongest(x + 1, y)) {
			max = findlongest(x + 1, y);
		//	bestchoice = 1;
		}
	}
	if (space[x][y] > space[x][y + 1] && y != m - 1) {
		//nexty = 1;
		if (max < findlongest(x, y + 1)) {
			max = findlongest(x, y + 1);
		//	bestchoice = 2;
		}
	}
	if (space[x][y] > space[x][y - 1] && y != 0) {
		//backy = 1;
		if (max < findlongest(x, y - 1)) {
			max = findlongest(x, y - 1);
		//	bestchoice = 4;
		}
	}
	return 1 + max;
}
