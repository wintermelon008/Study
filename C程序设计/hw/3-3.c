#include <stdio.h>
#include <math.h>
int main(){
	long long m=0,n=0,p=0,q=0,k,cifang,ans=0;
	int count[15]={0};
	int i,j,sum,min;
	scanf("%lld %lld",&m,&n);
	for (k=m;k<=n;k++){
		p=k;
		q=0;
		for (i=14;p!=0;i--){
			count[i]=p%10;
			p=(p-p%10)/10;
		}
		p=k;
		sum=14-i;
		min=i+1;
		for (j=min;j<=14;j++){
			cifang=pow(count[j],sum);
			q=q+cifang;
			}		
		if (p==q) {
			ans=ans+k;
		}
	}
    printf("%lld",ans);
	return 0;
}
