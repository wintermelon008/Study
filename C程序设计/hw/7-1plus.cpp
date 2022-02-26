#include <stdio.h>
int memory[10000001] = {0};
int main() {
	int MemorySize, numberofinstructions;
	int start, end, pstart, pend;  //pstart pend 是保护内存范围 
	int i, j, sum = 0;
	char instruction[20];
	
	scanf("%d%d", &MemorySize, &numberofinstructions);
	for (i = 1; i <= numberofinstructions; i++) {
		scanf("%s %d %d", &instruction, &start, &end);
		switch (instruction[0]) {
			case 'p':{
				pstart = start;
				pend = end;
				break;
			}
			case 'a':{
				int w = 0;
				if (end < pstart || start > pend) {
					for (j = start; j <= end; j++) {
						if (memory[j] == 1) {
							w = 1;
							break;
						}
					}
					if (w) 
						break;
					for (j = start; j <= end; j++) {
						memory[j] = 1;
					}
				}
				break;
			}
			case 's':{
				for (j = start; j <= end; j++) {
					memory[j] = 1;
				}
				break;
			}
    	}
	}
	for (i = 1; i <= MemorySize; i++) {
		if (memory[i] == 0) {
			sum++;
		}
	}
	printf("%d", sum);
	return 0;
}
