/*6-1*/
#include <stdio.h>
int main() {
	char name[100001][12];
	int face[100001];
	//存储姓名、朝向的数组  0 向内，1 向外
	int number = 0, add = 0;
	//number代表当前询问的人的编号，add代表下一个人的位置
	//add为负， 向外侧右边转；为正， 向外侧左边转
	int fac, ad; // 这是输入的回答 
	int i, j, m, n;
	char ch;
	scanf("%d%d", &m, &n); 
	// m 代表人数， n 代表问话次数 
	for (i = 0; i < m; i++) {
		scanf("%d", &face[i]);
		ch = getchar(); //把空格吞掉 
		gets(name[i]);
	}
	//用来检测输入是否正常 
    /*for (i = 0; i < n; i++) {
    	printf("%d", face[i]);
    	puts(name[i]);
	} 
	*/
	
	//i 代表当前询问次数 
	for (i = 1; i <= n; i++) {
		scanf("%d%d", &fac, &ad);
		add = face[number] ^ fac ? 1 * ad : -1 * ad;
		number += add;
		if (number >= m) number -= m;
		if (number < 0) number += m;
	}
	puts(name[number]);
	return 0;
}
