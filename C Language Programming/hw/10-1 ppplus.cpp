/*10-1 ppplus*/
#include <stdio.h>

int cityinformation[100000] = {0};
int numberoflines = 1;
char ans[100000];


void create(int city) {
	cityinformation[city] = numberoflines;
	numberoflines++;
	//printf("Create Done\n");
}

void link(int city1, int city2, int n) {
	int i;
	//printf("Start Link\n");
	if (cityinformation[city1] == 0) {
		create(city1);
	}

	if (cityinformation[city1] != cityinformation[city2]) {
		if (cityinformation[city2] != 0) {
			for (i = 1; i <= n; i++) {
				if (cityinformation[i] == 0) continue;
				if (cityinformation[i] == cityinformation[city2]) {
					cityinformation[i] = cityinformation[city1];
				}
			}
		}
		cityinformation[city2] = cityinformation[city1];
	}
	//printf("Link Done\n");
}

char check(int city1, int city2) {
	if (cityinformation[city1] == 0 || cityinformation[city2] == 0) {
		return 'n';
	}
	if (cityinformation[city1] == cityinformation[city2]) {
		return 'y';
	} else {
		return 'n';
	}
}

int main() {
	int i, city1, city2, imax;
	int numberofcities, numberofroads;
	//printf("Start first\n");
	scanf("%d%d", &numberofcities, &numberofroads);
	//printf("Firstly done\n");
	for (i = 1; i <= numberofroads; i++) {
		scanf("%d%d", &city1, &city2);
		link(city1, city2, numberofcities);
	}
	i = 0;
	do {
		scanf("%d%d", &city1, &city2);
		if (city1 == 0 && city2 == 0) {
			break;
		}
		ans[i] = check(city1, city2);
		i++;
	} while (1);
	
	imax = i;
	
	for (i = 0; i < imax; i++) {
		if (ans[i] == 'y') {
			printf("Yes\n");
		} else {
			printf("No\n");
		}
	}
	//*/
	//system("pause");
	return 0;
}
