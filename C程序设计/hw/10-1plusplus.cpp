/*10-1plus*/ 
#include <stdio.h>
#include <stdlib.h>
struct Lines {
	int citynumber;
	struct Lines *back;
	struct Lines *next;
};
typedef struct Lines lines;
lines *lineheads[10000];  //存放头地址的数组
lines *linetails[10000];  //存放尾地址的数组 
int numberofheads = 1, numberoftails = 1; 
char ans[100000];
int citycondition[100000] = {0};  //记录城市归属的数组 


void print(lines *head) {
	lines *p = head;
	//printf("输出函数部分:\n");
	//if (p->back == NULL) printf("testNULL\n");
	//printf("%d\n", p->citynumber);
	if (p->next == NULL) {
		printf("NULL\n");
	} else {
		//printf("链表 %d:\n",citycondition[p->next->citynumber]) ;
	//	printf("test2\n");
		while (p->next != NULL) {
			p = p->next;
			printf("%d->", p->citynumber);
		}
		printf("\n");
	}
}

lines *createhead(int city_number) {  //为citynumber 创造一个新的链表头,并把下一位存入citynumber 
	lines *head = (lines *)malloc(sizeof(lines)), *tail;
	if (head == NULL) {
		printf("No available memory\n");
		exit(0);
	} 
	head->back = NULL;
	tail = (lines *)malloc(sizeof(lines));
	if (tail == NULL) {
		printf("No available memory\n");
		exit(0);
	}
	head->next = tail;
	tail->next = NULL;
	tail->back = head;
	tail->citynumber = city_number;  
	
	lineheads[numberofheads] = head;
	linetails[numberoftails] = tail;
	citycondition[city_number] = numberofheads;
	//printf("head %d 创造成功\n", numberofheads);
	//print(head); 
	numberofheads++;
	numberoftails++;
	
	return (tail);
}

void connect(lines *tail, int city_num) {  //把 city_num 连入 head所在的链表末尾
    lines *p = tail, *q;
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
	linetails[citycondition[city_num]] = q;
	//print(head);
}

void lineconnect(lines *tail1, lines *head2) {  //连接两个链表 
	lines *p1 = tail1, *p2 = head2, *q;
	q = head2->next;
	q->back = p1;
	p1->next = q;
	//head2->next->back = p1;
	
	if (p2->next != NULL) {
		p2 = p2->next;
	}
	linetails[citycondition[p1->citynumber]] = linetails[citycondition[p2->citynumber]];
	p2 = head2;
	while (p2->next != NULL) {
		p2 = p2->next;
		citycondition[p2->citynumber] = citycondition[p1->citynumber];
		//printf("城市 %d 现在位于链表 %d 中\n", p2->citynumber, citycondition[p1->citynumber]);
	}
	
	head2->next = NULL;
	//print(head1);
}

void link(int city1, int city2) {  //处理输入的路径 
	int i;
	lines *p1, *p2;
	if (citycondition[city1] != 0) {
		//找到了 city1 所在的链表
		p1 = linetails[citycondition[city1]]; 
	} else {
		p1 = createhead(city1);  
	}
	//以上是对city1的处理  p1 为存有 city1 的尾节点 
	if (citycondition[city2] != citycondition[city1]) {  //保证city1, city2不在一条链表上 
		if (citycondition[city2] != 0) {
			//找到了 city2 所在的链表 
			p2 = lineheads[citycondition[city2]];
			lineconnect(p1, p2);
		} else {
			//把 city2 连入 p1
			connect(p1, city2);
		}
	}
}

char check(int city1, int city2){  //检查两座城市是否位于一个链表中
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
	printf("链表总数为 %d\n", numberofheads-1);
	for (i = 1; i < numberofheads; i++) {
		printf("链表%d:\n", i);
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
	system("pause");
	return 0;
}
