#include <stdio.h>
int main(){
	long long p;  //p������n��ֵ�������г�λ���� 
	int ans=1,num=0,i=1,d,dd=11;  //d��ÿһλ���� dd����һλ���� 
	scanf("%lld",&p);
	num=p%10;
	while (p!=0){
		d=p%10;
		if (d==dd){
			i++;
			if (i>=ans) num=dd;
		}
		else {
			i=1;
		}
		if (i>ans) ans=i;
		dd=d;
		p=(p-p%10)/10;
	}
	printf("%d %d",num,ans);
	return 0;
}
