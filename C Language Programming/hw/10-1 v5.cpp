/*10-1 version5*/
#include <stdio.h>
#include <stdlib.h>

char ans[100000];

int main() {
	int numberofcities, numberofroads;
	int i, city1, city2, imax;
	
	scanf("%d%d", &numberofcities, &numberofroads);
	for (i = 1; i <= numberofroads; i++) {
		scanf("%d%d", &city1, &city2);
		//link(city1, city2);
	}
	
	i = 0;
	do {
		scanf("%d%d", &city1, &city2);
		if (city1 == 0 && city2 == 0) {
			break;
		}
		//ans[i] = check(city1, city2);
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
