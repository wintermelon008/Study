/*10-1
������������
С���Сѩ��һ�Ժ����ѡ�
С��ס�ڳ���a��Сѩס�ڳ���b��
��������˵��Ϊһ�Ժ�����ƽʱ���ż����涼�Ǻ����������飬�������ڳ���a���ܱߵļ������д������ȴ����������������������Ҫ�����һϵ��ԭ���·���ˣ�����С���е�ʱ�򲢲��ܵ�Сѩ���������档
����С���Ҫ�����������������·֮���ͨ�������������������ܲ��ܹ�ȥ���ˡ�
�������������������ĺ����ɡ�
��������ʽ��
��һ��Ϊ��������N��M����ʾ��������N�����к�M������ͨ�еĽ�ͨ·�ߡ���0<N,M<100,000��
�ڶ��е���M+1��ÿ����������u��v����ʾu��v��������֮���п����໥ͨ�еĵ�·��(0<u,v<N)
�����п�ʼÿ����������f��e����ʾѯ��f��e���������Ƿ�ͨ����f��e��Ϊ0������
�������ʽ��
�����ַ��������ѯ���е����������ܻ��ൽ�������Yes���������No��
���������롿
5 3
1 4
1 3
2 5
3 4
2 1
0 0
�����������
Yes
No
������˵����
�ӳ���3����������ȥ����1Ȼ�󵽴����4��
�ӳ���2����ֻ��ȥ������5��
����ʾ��
���ڱ���Ŀ�г��е������ǳ��࣬����·���������٣����Կ���ͨ����ÿһ������ά��һ�������������������г����ĵ�·��*/

#include <stdio.h>
#include <stdlib.h>

struct CityConnection {
	int citynumber;  //�������
	struct CityConnection *back, *next;  
};
typedef CityConnection cityconnect;
cityconnect *lines[1000];  //������ÿһ����ͬ��ͷ��
int numofheads = 0; 
int citycondition[100000] = {0};  //������Ϊi�ĳ��б���������ôcitycondition[i]��ֵ��Ϊi��������ͷ�ڵı��+1 
 
cityconnect *createhead (void) {  //��������ͷ�� 
	cityconnect *head = (cityconnect *)malloc(sizeof(cityconnect));
	if (head == NULL) {
		printf("No available memory\n");
		exit(0);
	}
	head->back = NULL;
	head->next = NULL;
	lines[numofheads++] = head;
	return (head);
}

void connect(cityconnect *head, int city_num) {  //�����Ϊ city_num �ĳ��������� head Ϊͷ�ڵ����������� 
	cityconnect *p = head;
	int i = 0;
	while (p->next != NULL) {
		p = p->next;
	}
	p->next = (cityconnect *)malloc(sizeof(cityconnect));
	if (p->next == NULL) {
		printf("No available memory\n");
		exit(0);
	}
    p->next->back = p;
	p = p->next;
	p->citynumber = city_num;
	p->next = NULL;
	while (i < numofheads && lines[i] != head) {  //�ҵ� head �� ͷ�������е�λ�ã�+1��ֵ��citycondition�����¼ 
		i++;
	}
	citycondition[city_num] = i;
}

void lineconnect(cityconnect *head1, cityconnect *head2) {  //������������ 
    cityconnect *p = head1;
	while (p->next != NULL) {
		p = p->next;
	}
	p->next = head2;
	head2->back = p;
}

void check(cityconnect *head, int city_num, int city_new) {  
//����� head Ϊͷ�ڵ���������û�б��Ϊ city_num �ĳ��У��������� city_new ����ȥ;
//����� head Ϊͷ�ڵ���������û�б��Ϊ city_new �ĳ��У��������� city_num ����ȥ;
//�����û�оͿ���һ�������� 
	cityconnect *p = head;
	int w = 1;
	while (p->next != NULL) {
		p = p->next;
		if (p->citynumber == city_num) {
			connect(head, city_new);
			w = 0;
			break;
		}/*
		if (p->citynumber == city_new) {
			connect(head, city_num);
			w = 0;
			break;
		}*/
	}
	if (w) {
		
		if (citycondition[city_new] == 0) { //�жϺ�һ�������Ƿ������������� 
			cityconnect *pnew = createhead();
			connect(pnew, city_num);
			connect(pnew, city_new);
		} else {		
			lineconnect(head, lines[citycondition[city_new] - 1]);
		}
		
	}
}

void print(cityconnect *head) {
	cityconnect *p = head;
	while (p != NULL) {
		printf("%d->", p->citynumber);
		p = p->next;
	}
	printf("\n");
}

int main() {
	cityconnect *p;
	int numberofcities, numberofroads;
	int i, j, temp1, temp2;
	scanf("%d%d", &numberofcities, &numberofroads);
	
//	int *roadinfo = (int *)malloc(2 * numberofroads * sizeof(int)); //����ռ�����·��Ϣ 
//	if (roadinfo == NULL) {
//		printf("No available memory\n");
//		exit(0);
//	}
	
	for (i = 0; i < numberofcities; i++) {
		scanf("%d%d" ,temp1 , temp2);
//		*(roadinfo + i * 2 + 0) = temp1;
//		*(roadinfo + i * 2 + 1) = temp2;
		if (i == 0) {
			p = createhead();
			connect(p, temp1);
		}
		for (j = 0; j < numofheads; j++) {
			check(lines[j], temp1, temp2);
		}
	}
	for (j = 0; j < numofheads; j++) {
		print(lines[j]);
	}
	return 0;
}
