/*6-1*/
#include <stdio.h>
int main() {
	char name[100001][12];
	int face[100001];
	//�洢���������������  0 ���ڣ�1 ����
	int number = 0, add = 0;
	//number����ǰѯ�ʵ��˵ı�ţ�add������һ���˵�λ��
	//addΪ���� ������ұ�ת��Ϊ���� ��������ת
	int fac, ad; // ��������Ļش� 
	int i, j, m, n;
	char ch;
	scanf("%d%d", &m, &n); 
	// m ���������� n �����ʻ����� 
	for (i = 0; i < m; i++) {
		scanf("%d", &face[i]);
		ch = getchar(); //�ѿո��̵� 
		gets(name[i]);
	}
	//������������Ƿ����� 
    /*for (i = 0; i < n; i++) {
    	printf("%d", face[i]);
    	puts(name[i]);
	} 
	*/
	
	//i ����ǰѯ�ʴ��� 
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
