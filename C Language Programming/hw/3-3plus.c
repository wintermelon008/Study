/*Ѱ��ˮ�ɻ���(�������)*/
#include <stdio.h>
int main(){
  int k,i,num,wei;
  long long min,max,p=0,q=0,ans=0;
  double chengfang(int x,int y);
  scanf("%lld %lld",&min,&max);
  for (k=min;k<=max;k++){  //�����[min,max]֮�����е�����k
    p=k;
    wei=0;  //wei��ʼ��
    while (p!=0){  //����k�ж���λ��������wei��
       p=(p-p%10)/10;
       wei++;
    }
    p=k;  
    q=0;  //�˷��ۼӽ��q��ʼ��
    for (i=1;i<=wei;i++){            //����һ�����k��һλ������num��
       num=p%10;               //����k��ǰ�����һλ��
       q=q+chengfang(num,wei);     //����ÿһλ wei �η�֮��
       p=(p-p%10)/10;            //��ȥk�����һλ��
    }
    if (k==q) ans=ans+k; //���飺���q=k����ôk��һ��ˮ�ɻ����������
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
