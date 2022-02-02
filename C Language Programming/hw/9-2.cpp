/*9-2*/
#include <stdio.h>

int nums[10000] = {0};
int count[10000] = {0};

int main() {
	int findmax(int x, int y);
	int size, i, j, bef, temp, ncount = 0;
	int check;
	
	scanf("%d", &size);
	for (i = 0; i < size; i++) {
		scanf("%d", &nums[i]);
	}
	
	for (i = 0; i < size; i++) {
		for (j = i + 1; j < size; j++) {
			if (nums[i] > nums[j]) {
				temp = nums[i];
				nums[i] = nums[j];
				nums[j] = temp;
			}
		}
	}
	/*
	for (i = 0; i <size; i++) {
		printf("%d ", nums[i]);
	}
	printf("\n");
	*/
	bef = nums[0];
	for (i = 1; i < size; i++) {
		if (nums[i] == bef) {
			count[ncount]++;		
		} else {
			bef = nums[i];
			ncount++;
		}
	}
	
	for (i = 0; i <= ncount; i++) {
		if (count[i] == 0) {
			printf("0");
			return 0;
		}
		count[i]++;
		//printf("%d ", count[i]);
	}
	
	while (ncount >= 2) {
		for (i = 0; i < ncount; i++) {
			check = findmax(count[i], count[i + 1]);
			if (check == 1) {
				printf("0");
				return 0;
			} else {
				count[i] = check;
			}
		}
		ncount--;
	}
	
	printf("1");
	return 0;
}

int findmax(int x, int y) {
	int ans, k, bef, now;
	bef = x > y ? y : x;
	now = x < y ? y : x;
	while (bef != now) {
		x = now;
		y = now - bef;
		bef = x > y ? y : x;
    	now = x < y ? y : x;
	}
	ans = bef;
	return ans;
}

