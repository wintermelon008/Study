#include <stdio.h>
int main() {
	int n, ans=0, k=5;
	scanf("%d",&n);
	while (n >= k) {
		ans+=n/k;
		k*=5;
	}
	printf("%d",ans);
	return 0;
}
