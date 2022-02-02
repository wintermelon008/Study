/*寻找水仙花数(无数组版)*/
#include <stdio.h>
int main(){
  int k,i,num,wei;
  long long min,max,p=0,q=0,ans=0;
  double chengfang(int x,int y);
  scanf("%lld %lld",&min,&max);
  for (k=min;k<=max;k++){  //穷举在[min,max]之间所有的整数k
    p=k;
    wei=0;  //wei初始化
    while (p!=0){  //计算k有多少位数，存入wei中
       p=(p-p%10)/10;
       wei++;
    }
    p=k;  
    q=0;  //乘方累加结果q初始化
    for (i=1;i<=wei;i++){            //倒序一次输出k的一位，存在num中
       num=p%10;               //存入k当前的最后一位数
       q=q+chengfang(num,wei);     //计算每一位 wei 次方之和
       p=(p-p%10)/10;            //消去k的最后一位数
    }
    if (k==q) ans=ans+k; //检验：如果q=k，那么k是一个水仙花数，并求和
  }
  printf("%lld\n",ans);
  return 0;     
}

double chengfang(int x,int y){
  int j;
  long long s=1;
  for (j=1;j<=y;j++){
     s=s*x;
  }
  return (s);
}
