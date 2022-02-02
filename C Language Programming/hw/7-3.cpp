#include <stdio.h>

int number[40][2] = {0};

int main() {
	int count(int n, int sum);
	int nums[40] = {0};
	int size, target;
	int i, j, mid, total = 0, amount;
	
	scanf("%d", &size);
	for (i = 1; i <= size; i++) {
		scanf("%d", &nums[i]);
	}
	scanf("%d", &target);
	
	for (i = 1; i <= size; i++) {
		for (j = i+1; j <= size; j++) {
			if (nums[i] > nums[j]) {
				mid = nums[i];
				nums[i] = nums[j];
				nums[j] = mid;
			}
		}
	}	
	
	i = 1; j = 1;
	while (j <= size) {
		amount = 1;
		number[i][1] = nums[j];
		while (nums[j] == nums[j+1]) {
			j++;
			amount++;
		}
		number[i][0] = amount;
		i++; j++;
	}
	printf("%d", count(i-1, target));
	return 0;
}

int count(int n, int sum) {
	int ans = 0;
	if (sum <= 0 || n < 1) {
		return 0;
	}
	if (sum % number[n][1] == 0 && number[n][0] * number[n][1] >= sum) {
		ans = 1;
	}
	
	for (int j = 0; j <= number[n][0]; j++) {
		ans += count(n - 1, sum - number[n][1] * j);
	}		
	
	return ans;
}
