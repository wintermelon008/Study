#include <stdio.h>
int main() {
	int a, b;
	int ben=1, jin=1, sum;
	scanf("%d%d",&a, &b);
	while (jin != 0) {
		ben=a^b;
		jin=(a&b)<<1;
		a=ben;
		b=jin;
		sum=jin|ben;
	}
	printf("%d",sum);
	return 0;
}
