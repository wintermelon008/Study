#include <iostream>
#include <cstdlib>
#include <ctime>
#include "defines.h"
#include "queue.h"

using namespace std;



int CustomerNum = 0, TotalTime = 0;	//��¼�˿������Լ��ȴ���ʱ��

int maxIntervaltime = MAX_INTERVAL_TIME;			//������¼����ʱ�䣬 ������һ�û������¼������������
int maxCustomermoney = MAX_CUST_MONEY;				//�ͻ������������
int maxCustomertime = MAX_CUST_DURTIME;				//��ͻ�����ʱ��


/*
	��ʼ������
	��ʼ�����С�������ݵ�
*/
void OpenForDay() {
	CustomerNum = 0;	
	TotalTime = 0;
	cusQueA_start = new BankQueue[QueANum];	//����ָ����Ŀ�ĵ�һ������
	if (!cusQueA_start) exit(MEMORY_LOW);

	nowevent.OccurTime = 0;
	nowevent.type = -1;		//��ʾ�����¼�

	timetable.add_event(nowevent);

	for (int i = 0; i < QueANum; i++) {
		flagA[i] = true;
	}

}

/*
	�ͻ����ﺯ��
	�������еĵ����¼�(ִ��ʱҪ�� nowevent ��Ϊһ�������¼�)
*/
void CustomerArrive() {
	
	CustomerNum++;

	int nextArrivetime = nowevent.OccurTime + rand() % maxIntervaltime + 1;		//��ô� 1 - max �ĵ�����

	if (nextArrivetime <= closetime) {		//�������û�й���������µĵ����¼�
		Event newevent = { -1, nextArrivetime };
		timetable.add_event(newevent);
	}

	//ģ��ͻ�ҵ��
	Customer newcustomer;
	newcustomer.id = CustomerNum;
	newcustomer.arrivetime = nowevent.OccurTime;
	newcustomer.business_type = rand() % 2;
	newcustomer.money = rand() % maxCustomermoney + 1;
	newcustomer.durtime = rand() % maxCustomertime + 1;

	BankQueue *queue = findMin();	//ȷ���Ŷ��������ٵĶ���
	newcustomer.queueA = queue - cusQueA_start;
	queue->in_que(newcustomer);		//����ö���
	
	//printf("һ���˿�����������\n");

	if (flagA[newcustomer.queueA]) queue->queueA_check();
}

/*
	�ͻ��뿪����
	�������е��뿪�¼�
*/
void CustomerLeave() {
	Customer customer;
	
	
	if (!nowevent.type) {	//�ڶ�����е��뿪�¼�		
		QueB.out_que(customer);		//������	
		flagB = true;
		QueB.queueB_check();
		//printf("�ڶ�����У�");
	}
	else {
		(cusQueA_start + nowevent.type - 1)->out_que(customer);
		flagA[customer.queueA] = true;
		(cusQueA_start + nowevent.type - 1)->queueA_check();
		//printf("��һ�����[%d]: ", nowevent.type - 1);
	}

	TotalTime += nowevent.OccurTime - customer.arrivetime;
	//printf("һ���˿��뿪������\n");

}

void ShowState() {	//��ӡ��ǰ������״̬����

	printf("-----------------------------------------------------------------------------------\n");
	printf("Event: occur_time = %d, type = %d \n", nowevent.OccurTime, nowevent.type);
	printf("Bankmoney: %d\n", bankmoney);
	for (int i = 0; i < QueANum; i++) {
		printf("QueueANo.%d:\n", i + 1);
		(cusQueA_start + i)->print();
	}

	printf("QueueB:\n");
	QueB.print();
	printf("\n\n");
}

int main() {
	
	unsigned seed = (unsigned)time(0);
	srand(seed);
	//srand( 13 );
	OpenForDay();		//�ܳ�ʼ��

	while (!timetable.ifempty()) {		//�¼���ǿ�
		timetable.delete_event(nowevent);
		ShowState();
		//printf("�¼����ͣ� %d\n", nowevent.type);
		if (nowevent.type == -1) {
			CustomerArrive();
		}
		else {
			CustomerLeave();
			//printf("%d\n", TotalTime);
		}
	}

	CustomerNum -= QueB.getlength();
	for (int i = 0; i < QueANum; i++) {
		CustomerNum -= (cusQueA_start + i)->getlength();
	}
	printf("%d, %.2f", CustomerNum, 1.0 * TotalTime/CustomerNum);
	
	return 0;

}