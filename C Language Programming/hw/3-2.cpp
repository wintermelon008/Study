#include <stdio.h>
#include <math.h>
int main()
{
	long n,k,w,s;
	s=0;
	long max,min;
	long long ans;
	scanf("%d",&min);
	scanf("%d",&max);
	n=min; 
	while (n<=max)
	{
	   k=2;
	   w=0;	
 	   while (k<=sqrt(n)&&w==0)
	   {
		    if(n%k==0)
	    	w=1;
		    k++;
	   } 
	   if(w==0)
    	{
	     s++;
	     ans=ans+n;
	     printf("%lld\n",ans);
        }
	    n++;
    }
    printf("%d %lld",s,ans);
	return 0;
 } 
