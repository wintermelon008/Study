#include <stdio.h>
int memory[1000001] = {0};
char instruction[20];
int main() {
	int MemorySize, numberofinstructions, start, end, prostart, proend;
	int i, j, sum = 0;
	
	scanf("%d%d", &MemorySize, &numberofinstructions);
	for (i = 1; i <= numberofinstructions; i++) {
		scanf("%s %d %d", &instruction, &start, &end);
		switch (instruction[0]) {
			case 'p': {
				prostart = start;
		 		proend = end;
				break;
			}
			case 'a': {
				if (start <= prostart && end >= prostart ||
				    start <= proend && end >= proend) {
					break;
				}
				for (j = start; j <= end; j++) {	
					memory[j] = 1;
				}
				break;
			}
			case 's': {
				for (j = start; j <= end; j++) {	
					memory[j] = 1;
				}
				break;
			}
		}		
	}
	for (i = 1; i <= MemorySize; i++) {
		//printf("%d", memory[i]);
		//if (i % 50 == 0) printf("\n");
		if (memory[i] == 0) {
			sum++;
		}
	}
	printf("%d", sum);
	return 0;
}
/*
10000 6
protect 10 100
allocate 1 11
allocate 120 300
allocate 110 130
sudoallocate 20 30
sudoallocate 50 150
*/
/*
300 6
protect 10 100
allocate 1 11
allocate 120 300
allocate 110 130
sudoallocate 20 30
sudoallocate 50 150
*/
