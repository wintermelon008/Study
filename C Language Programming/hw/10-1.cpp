/*10-1
【问题描述】
小崎和小雪是一对好朋友。
小崎住在城市a，小雪住在城市b。
本来按理说作为一对好朋友平时出门见见面都是很正常的事情，但是由于城市a和周边的几个城市处于亚热带季风气候地区，动不动就要下雨等一系列原因把路封了，所以小崎有的时候并不能到小雪那里找她玩。
所以小崎就要到了最近各个地区公路之间的通行情况。并问你今天他能不能过去玩了。
请你可怜可怜这个可怜的孩儿吧。
【输入形式】
第一行为两个整数N，M。表示地区中有N个城市和M条尚能通行的交通路线。（0<N,M<100,000）
第二行到第M+1行每行两个整数u和v，表示u和v两座城市之间有可以相互通行的道路。(0<u,v<N)
第三行开始每行两个整数f和e，表示询问f和e两座城市是否互通。以f和e均为0结束。
【输出形式】
数个字符串。如果询问中的两个城市能互相到达则输出Yes，否则输出No。
【样例输入】
5 3
1 4
1 3
2 5
3 4
2 1
0 0
【样例输出】
Yes
No
【样例说明】
从城市3出发可以先去城市1然后到达城市4。
从城市2出发只能去到城市5。
【提示】
由于本题目中城市的数量非常多，而道路的数量较少，所以可以通过给每一个城市维护一个链表来保存从这个城市出发的道路。*/

#include <stdio.h>
#include <stdlib.h>

struct CityConnection {
	int citynumber;  //城市序号
	struct CityConnection *back, *next;  
};
typedef CityConnection cityconnect;
cityconnect *lines[1000];  //用来存每一个不同的头节
int numofheads = 0; 
int citycondition[100000] = {0};  //如果编号为i的城市被连入了那么citycondition[i]的值变为i所在链表头节的编号+1 
 
cityconnect *createhead (void) {  //创造链表头节 
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

void connect(cityconnect *head, int city_num) {  //将编号为 city_num 的城市连入以 head 为头节的链表的最后面 
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
	while (i < numofheads && lines[i] != head) {  //找到 head 在 头节数组中的位置，+1赋值给citycondition数组记录 
		i++;
	}
	citycondition[city_num] = i;
}

void lineconnect(cityconnect *head1, cityconnect *head2) {  //连接两个链表 
    cityconnect *p = head1;
	while (p->next != NULL) {
		p = p->next;
	}
	p->next = head2;
	head2->back = p;
}

void check(cityconnect *head, int city_num, int city_new) {  
//检查以 head 为头节的链表中有没有编号为 city_num 的城市，如果有则把 city_new 连上去;
//检查以 head 为头节的链表中有没有编号为 city_new 的城市，如果有则把 city_num 连上去;
//如果都没有就开创一个新链表 
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
		
		if (citycondition[city_new] == 0) { //判断后一个城市是否在其他链表中 
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
	
//	int *roadinfo = (int *)malloc(2 * numberofroads * sizeof(int)); //申请空间存入道路信息 
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
