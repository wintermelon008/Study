#include <stdio.h>
int main(){
	long long p;  //p用来存n的值，并进行出位操作 
	int ans=1,num=0,i=1,d,dd=11;  //d是每一位的数 dd是上一位的数 
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
