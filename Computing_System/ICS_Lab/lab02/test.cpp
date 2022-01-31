#include <stdio.h>
int main() {
	int f0 = 1, f1 = 1, f2 = 2; 
	for (int i = 3; i < 100; i++) {
		int temp = (f2 + 2 * f0) % 1024;
		if (temp == 930 || temp == 10 || temp == 246 || temp == 50) printf("f(%d) = %d\n", i, temp); 
		f0 = f1;
		f1 = f2;
		f2 = temp;
	}
//	system("pause");
	return 0;
} 
