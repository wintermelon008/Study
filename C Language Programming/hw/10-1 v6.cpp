/*ver 6.0*/
#include <stdio.h>
#include <stdlib.h>

struct CITY{
    int citynum;
    struct CITY *next = NULL;
};
typedef struct CITY city;
city *citylines[100000] = {NULL};
char ans[100000];
int citycondition[100000] = {0};
int citymax = 0;

void clear(void) {
	int i;
	for (i = 0; i <= citymax; i++) {
		citycondition[i] = 0;
	}
	citymax = 0;
}

void link(int city1, int city2) {
    city *head;
    printf("test4\n");
    citymax = citymax < city1 ? city1 : citymax;
    printf("test3\n");
    if (citylines[city1] == NULL) {
    	citylines[city1] = (city *)malloc(sizeof(city));
    	if (citylines[city1] == NULL) {
    		printf("No available memory");
        	exit(0);	
		}		
		printf("链表 %d 创建成功\n", city1);
		citylines[city1]->next = NULL;
		citylines[city1]->citynum = city1;
	} 
	printf("test1\n");
	
	head = citylines[city1];
	while (head->next != NULL) {
		if (head->citynum == city2) {
			return;
		}
		head = head->next;
	}
	
    city *p = (city *)malloc(sizeof(city));
    if (p == NULL) {
        printf("No available memory");
        exit(0);
    }

	head->next = p;
	p->citynum = city2;
	p->next = NULL;

}

char check(int city1, int city2) {
	char temp;
	//int citycondition[100000] = {0};
	city *p = citylines[city1];
	citycondition[city1] = 1;
	if (p->citynum == city2) {
		return 'y';
	} else {
		while (p->next != NULL) {
			p = p->next;
			if (citycondition[p->citynum] == 0) {
				return check(p->citynum, city2);
			}
			
		}
		return 'n';
	}
}

int main() {
    int numberofcities, numberofroads;
    int i, imax, city1, city2;
    scanf("%d%d", &numberofcities, &numberofroads);
	printf("test5\n");
    for (i = 0; i < numberofcities; i++) {
        scanf("%d%d", &city1, &city2);
        link(city1, city2);
        printf("test2\n");
    }
    i = 0;
    while (1) {
    	scanf("%d%d", &city1, &city2);
    	if (city1 == 0 && city2 == 0) {
    		break;
		}
		ans[i++] = check(city1, city2);
		clear();
	}
	imax = i;
	for (i = 0; i < imax; i++) {
		if (ans[i] == 'y') printf("Yes\n");
		else printf("No\n");
	}
	return 0;
}
