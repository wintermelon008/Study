/*version 4.0*/
#include <stdio.h>
#include <stdlib.h>

struct Cities {
    int city_num;
    struct Cities *next;
    struct Cities *back;
};
typedef struct Cities city;

city *heads[100000], *tails[100000];
int numofheads = 1, numoftails = 1;
int citycondition[100000] = {0};
char ans[100000];

city *create(int city_number) {
    city *head, *tail;
    head = (city *)malloc(sizeof(city));
    tail = (city *)malloc(sizeof(city));
    if (head == NULL || tail == NULL) {
        printf("No available memory\n");
        exit (0);
    }
    head->back = NULL;
    head->next = tail;
    tail->city_num = city_number;
    tail->back = head;
    tail->next = NULL;

    heads[numofheads++] = head;
    tails[numoftails++] = tail;
    citycondition[city_number] = numofheads - 1;

    return tail;
}

void connect(city *tail, int city_number) {
    city *p = tail, *q;
    q = (city *)malloc(sizeof(city));
    if (q == NULL) {
        printf("No available memory\n");
        exit (0);
    }

    tail->next = q;
    q->city_num = city_number;
    q->back = tail;
    q->next = NULL;

    citycondition[city_number] = citycondition[tail->city_num];
    tails[citycondition[city_number]] = q;

}

void link(city *tail1, city *head2) {
    city *ptail = tail1, *phead = head2;
    city *pstart = head2->next, *pend = tails[citycondition[pstart->city_num]];
    ptail->next = pstart;
    pstart->back = ptail;
    phead->next = NULL;

    while (pstart != NULL) {
        citycondition[pstart->city_num] = citycondition[ptail->city_num];
        pstart = pstart->next;
    }
}

void makeup(int city1, int city2) {
    city *p1, *p2;
    if (citycondition[city1] == 0) {
        p1 = create(city1);
    } else {
        p1 = tails[citycondition[city1]];
    }
    if (citycondition[city1] == citycondition[city2]) {
        return;
    }
    if (citycondition[city2] == 0) {
        connect(p1, city2);
    } else {
        p2 = heads[citycondition[city2]];
        link(p1, p2);
    }
}


int main() {
    int numberofcities, numberofroads;
    int i, city1, city2, imax;

    scanf("%d%d", &numberofcities, &numberofroads);
    for (i = 1; i <= numberofroads; i++) {
        scanf("%d%d", &city1, &city2);
        makeup(city1, city2);
    }
    i = 0;
    do {
        scanf("%d%d", &city1, &city2);
        if (city1 == 0 && city2 == 0) {
            break;
        }
        if (citycondition[city1] == citycondition[city2]) {
            ans[i++] = 'y';
        } else {
            ans[i++] = 'n';
        }
    } while (1);
    imax = i - 1;
    for (i = 0; i <= imax; i++) {
        if (ans[i] == 'y') printf("Yes\n");
        else printf("No\n");
    }   
    system("pause");
    return 0;
}
