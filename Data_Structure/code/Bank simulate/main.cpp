#include <iostream>
#include <cstdlib>
#include <ctime>
#include "defines.h"
#include "queue.h"

using namespace std;



int CustomerNum = 0, TotalTime = 0;	//记录顾客数量以及等待总时间

int maxIntervaltime = MAX_INTERVAL_TIME;			//最长到达事件间隔时间， 用于下一用户到达事件的随机数生成
int maxCustomermoney = MAX_CUST_MONEY;				//客户操作的最大金额
int maxCustomertime = MAX_CUST_DURTIME;				//最长客户操作时间


/*
	初始化函数
	初始化队列、相关数据等
*/
void OpenForDay() {
	CustomerNum = 0;	
	TotalTime = 0;
	cusQueA_start = new BankQueue[QueANum];	//生成指定数目的第一个队列
	if (!cusQueA_start) exit(MEMORY_LOW);

	nowevent.OccurTime = 0;
	nowevent.type = -1;		//表示到达事件

	timetable.add_event(nowevent);

	for (int i = 0; i < QueANum; i++) {
		flagA[i] = true;
	}

}

/*
	客户到达函数
	处理所有的到达事件(执行时要求 nowevent 中为一个到达事件)
*/
void CustomerArrive() {
	
	CustomerNum++;

	int nextArrivetime = nowevent.OccurTime + rand() % maxIntervaltime + 1;		//获得从 1 - max 的到达间隔

	if (nextArrivetime <= closetime) {		//如果银行没有关门则插入新的到达事件
		Event newevent = { -1, nextArrivetime };
		timetable.add_event(newevent);
	}

	//模拟客户业务
	Customer newcustomer;
	newcustomer.id = CustomerNum;
	newcustomer.arrivetime = nowevent.OccurTime;
	newcustomer.business_type = rand() % 2;
	newcustomer.money = rand() % maxCustomermoney + 1;
	newcustomer.durtime = rand() % maxCustomertime + 1;

	BankQueue *queue = findMin();	//确定排队人数最少的队列
	newcustomer.queueA = queue - cusQueA_start;
	queue->in_que(newcustomer);		//插入该队列
	
	//printf("一名顾客来到了银行\n");

	if (flagA[newcustomer.queueA]) queue->queueA_check();
}

/*
	客户离开函数
	处理所有的离开事件
*/
void CustomerLeave() {
	Customer customer;
	
	
	if (!nowevent.type) {	//第二类队列的离开事件		
		QueB.out_que(customer);		//出队列	
		flagB = true;
		QueB.queueB_check();
		//printf("第二类队列：");
	}
	else {
		(cusQueA_start + nowevent.type - 1)->out_que(customer);
		flagA[customer.queueA] = true;
		(cusQueA_start + nowevent.type - 1)->queueA_check();
		//printf("第一类队列[%d]: ", nowevent.type - 1);
	}

	TotalTime += nowevent.OccurTime - customer.arrivetime;
	//printf("一名顾客离开了银行\n");

}

void ShowState() {	//打印当前各队列状态函数

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
	OpenForDay();		//总初始化

	while (!timetable.ifempty()) {		//事件表非空
		timetable.delete_event(nowevent);
		ShowState();
		//printf("事件类型： %d\n", nowevent.type);
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