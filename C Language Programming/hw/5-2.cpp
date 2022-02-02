#include <stdio.h>
#include <math.h>
int main() {
	double x, add, sum = 0;
	int i = 1;
	scanf("%lf", &x);
	add = x;
	do {
		sum += add;
		i += 2;
		add *= (-1) * x * x / (i * (i - 1));	
	} while (fabs(add) >= 1e-5);
	printf("The approximate value of sin(x) is %.5f",sum);
	return 0;
}
