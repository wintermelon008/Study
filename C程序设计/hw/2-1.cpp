#include<stdio.h>
int main()
{
int a,b;
double ans;
scanf("%d%d",&a,&b);
if (b!=0)
{
ans=a*1.0/b;
printf("%d %.2f",a/b,ans);
}
return 0;
}


