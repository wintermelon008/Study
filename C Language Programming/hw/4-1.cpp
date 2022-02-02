#include <stdio.h>
int main() {
	long long m, n, p, k, ans=0;
	int i, wei, w;
	int num[10]={0};
	scanf("%lld%lld",&m, &n);
	for (k=m; k<=n; k++) {
		w=0;
		i=0;
		p=k;
		while (p != 0) {
			num[i]=p%10;
			p=(p-p%10)/10;
			i++;
		}
		wei=i-1;
		for (i=0; i<=wei/2; i++) {
			if (num[i] != num[wei-i]) w=1; //w=1不是回文数 
		}
		if (w == 0) ans+=k;
	}
	printf("%lld",ans);
	return 0;
}
