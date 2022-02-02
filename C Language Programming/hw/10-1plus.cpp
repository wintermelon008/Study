/*10-1plus*/ 
#include <stdio.h>
#include <stdlib.h>
struct Lines {
	int citynumber;
	struct Lines *back;
	struct Lines *next;
};
typedef struct Lines lines;
lines *lineheads[10000];  //���ͷ��ַ������
int numberofheads = 1; 
char ans[100000];
int citycondition[100000] = {0};  //��¼���й��������� 


void print(lines *head) {
	lines *p = head;
	//printf("�����������:\n");
	//if (p->back == NULL) printf("testNULL\n");
	//printf("%d\n", p->citynumber);
	if (p->next == NULL) {
		printf("NULL\n");
	} else {
		//printf("���� %d:\n",citycondition[p->next->citynumber]) ;
	//	printf("test2\n");
		while (p->next != NULL) {
			p = p->next;
			printf("%d->", p->citynumber);
		}
		printf("\n");
	}
}

lines *createhead(int city_number) {  //Ϊcitynumber ����һ���µ�����ͷ,������һλ����citynumber 
	lines *head = (lines *)malloc(sizeof(lines)), *q;
	if (head == NULL) {
		printf("No available memory\n");
		exit(0);
	} 
	head->back = NULL;
	q = (lines *)malloc(sizeof(lines));
	if (q == NULL) {
		printf("No available memory\n");
		exit(0);
	}
	head->next = q;
	q->next = NULL;
	q->back = head;
	q->citynumber = city_number;  
	
	lineheads[numberofheads] = head;
	citycondition[city_number] = numberofheads;
	//printf("head %d ����ɹ�\n", numberofheads);
	//print(head); 
	numberofheads++;
	
	return (head);
}

void connect(lines *head, int city_num) {  //�� city_num ���� head���ڵ�����ĩβ
    lines *p = head, *q;
	while (p->next != NULL) {
		p = p->next;
	} 
	q = (lines *)malloc(sizeof(lines));
	if (q == NULL) {
		printf("No available memory\n");
		exit(0);
	}
	
	p->next = q;
	q->back = p;
	q->citynumber = city_num;
	q->next = NULL;
	
	citycondition[city_num] = citycondition[p->citynumber];
	//print(head);
}

void lineconnect(lines *head1, lines *head2) {  //������������ 
	lines *p1 = head1, *p2 = head2, *q;
	while (p1->next != NULL) {
		p1 = p1->next;
	}
	q = head2->next;
	q->back = p1;
	p1->next = q;
	//head2->next->back = p1;
	
	
	while (p2->next != NULL) {
		p2 = p2->next;
		citycondition[p2->citynumber] = citycondition[p1->citynumber];
		//printf("���� %d ����λ������ %d ��\n", p2->citynumber, citycondition[p1->citynumber]);
	}
	head2->next = NULL;
	//print(head1);
}

void link(int city1, int city2) {  //���������·�� 
	int i;
	lines *p1, *p2;
	if (citycondition[city1] != 0) {
		//�ҵ��� city1 ���ڵ�����
		p1 = lineheads[citycondition[city1]]; 
	} else {
		p1 = createhead(city1);  
	}
	//�����Ƕ�city1�Ĵ���  p1 Ϊ���� city1 ��ͷ�ڵ� 
	if (citycondition[city2] != citycondition[city1]) {  //��֤city1, city2����һ�������� 
		if (citycondition[city2] != 0) {
			//�ҵ��� city2 ���ڵ����� 
			p2 = lineheads[citycondition[city2]];
			lineconnect(p1, p2);
		} else {
			//�� city2 ���� p1
			connect(p1, city2);
		}
	}
}

char check(int city1, int city2){  //������������Ƿ�λ��һ��������
    if (citycondition[city1] == 0 || citycondition[city2] == 0) {
    	return 'n';
	} 
	if (citycondition[city1] == citycondition[city2]) {
		return 'y';
	} else {
		return 'n';
	}
}
/*
5 2
1 3
4 2

  
*/
int main() {
	int numberofcities, numberofroads;
	int i, city1, city2, imax;
	
	scanf("%d%d", &numberofcities, &numberofroads);
	for (i = 1; i <= numberofroads; i++) {
		scanf("%d%d", &city1, &city2);
		link(city1, city2);
	}
	/*
	printf("��������Ϊ %d\n", numberofheads-1);
	for (i = 1; i < numberofheads; i++) {
		printf("����%d:\n", i);
		print(lineheads[i]);
	}
	*/
	///*
	i = 0;
	do {
		scanf("%d%d", &city1, &city2);
		if (city1 == 0 && city2 == 0) {
			break;
		}
		ans[i] = check(city1, city2);
		i++;
	} while (1);
	
	imax = i;
	
	for (i = 0; i < imax; i++) {
		if (ans[i] == 'y') {
			printf("Yes\n");
		} else {
			printf("No\n");
		}
	}
	//*/
	return 0;
}
