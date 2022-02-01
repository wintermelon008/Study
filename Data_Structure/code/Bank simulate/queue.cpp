#include "queue.h"
#include "defines.h"
#include <cstdlib>
#include <cstring>
#include <iostream>

using namespace std;



int QueANum = QUEUEA_NUM;			//第一类队列的数量
BankQueue *cusQueA_start;	//指向第一列队列数组的指针
BankQueue QueB;				//第二类队列
Timetable timetable;		//初始化时刻表
Event nowevent;						//存储当前事件的全局变量
int bankmoney = INI_BANK_MONEY;			//银行初始财产
int closetime = CLOSE_TIME;			//银行关门时间

bool flagB = true;		//记录存钱时是否进行第二类队列检查
bool *flagA = new bool[QueANum];



/*
	构造函数
	生成一个带有一个空结点，长度为 0 的空队列
*/
BankQueue::BankQueue() {
	tail = new ElmCustomer;
	if (!tail) exit(MEMORY_LOW);

	head = tail;
	length = 0;
	maxlength = MAX_LENGTH;
}

BankQueue::~BankQueue() {

}


/*
	入队列函数
	将 new_cust 存入当前队列的末端
*/
BankQueue BankQueue::in_que(Customer new_cust) {
	if (length == maxlength) return *this;  //队列满
	ElmCustomer * new_tail = new ElmCustomer;
	if (!new_tail) exit(MEMORY_LOW);

	tail->customer = new_cust;
	tail->next = new_tail;
	tail = new_tail;
	new_tail->next = NULL;

	length++;
	return *this;

	//  head <- p1 <- p2 <- ... <- pk <- tail <- new_tail
}

/*
	出队列函数
	从队列头移出第一位客户， 存入 cust 中
*/
BankQueue BankQueue::out_que(Customer &cust) {
	if (!length) return *this;		//队列空
	cust = head->customer;

	ElmCustomer *p = head;
	head = p->next;
	delete p;

	length--;
	return *this;

	// head <- p <- ... <- tail
}

int BankQueue::getlength() {
	return length;
}

/*
	输出函数
	打印当前队列
*/
BankQueue BankQueue::print() {
	if (length == 0) {
		printf("This queue is empty.\n");
		return *this;
	}

	ElmCustomer *p = head;

	
	while (p != tail) {
		
		printf("-> customer[%d]: {atime %d, dtime %d, btype %d, money %d}\n", p->customer.id, p->customer.arrivetime, p->customer.durtime, 
																				 p->customer.business_type, p->customer.money);
		p = p->next;
	}
	cout << endl;
	return *this;
}

/*
	第一类队列遍历函数
	处理队列中第一个客户，如果可以满足则生成离开事件， 否则移入第二类队列
*/
bool BankQueue::queueA_check() {
	ElmCustomer *p = head;
	if (!length) return false;
	if (p->customer.business_type) {	//表示存钱
		Event newevent;
		newevent.type = p->customer.queueA + 1;	//确定队列以及离开事件类型
		newevent.OccurTime = nowevent.OccurTime + p->customer.durtime;
		timetable.add_event(newevent);
		bankmoney += p->customer.money;

		flagA[p->customer.queueA] = false;

		if (flagB) QueB.queueB_check();		//仅在存钱时进行第二个队列遍历
		return true;
	}
	else {		//表示取钱
		if (p->customer.money <= bankmoney) {	//取钱，且银行的钱足够
			Event newevent;
			newevent.type = p->customer.queueA + 1;	//确定队列以及离开事件类型

			flagA[p->customer.queueA] = false;

			newevent.OccurTime = nowevent.OccurTime + p->customer.durtime;
			timetable.add_event(newevent);
			bankmoney -= p->customer.money;
			return true;
		}
		else {		//取钱， 但是银行的钱不够
			Customer customer;
			out_que(customer);	//离开队列， 进入第二类队列
			QueB.in_que(customer);
			return false;
		}
	}
	
}

/*
	第二类队列遍历函数
	寻找队列中 bankmoney 前提下可以处理的客户，并添加对应事件到事件表中
	如果队列中没有人满足条件。则返回 false
*/
bool BankQueue::queueB_check() {
	ElmCustomer *p = head;
	int count = 0;	//统计已经找过的结点数
	while (count < length) {
		if (!p->customer.business_type && p->customer.money <= bankmoney) {  //确定操作类型为取钱且银行余额足够
			//执行相应的客户操作
			Event newevent;
			newevent.type = 0;	//确定队列以及离开事件类型
			newevent.OccurTime = nowevent.OccurTime + p->customer.durtime;
			timetable.add_event(newevent);
			flagB = false;
			bankmoney -= p->customer.money;
			return true;	//操作完成，退出函数
		}
		else {
			p = p->next;
			Customer customer;
			out_que(customer);
			in_que(customer);		//重新排队
			count++;				//计数
		}	
	}
	//若 count >= length 表示已经循环过一次队列，仍然没有可以操作的用户，则退出函数
	return false;
}


/*
	寻找最小函数
	返回当前人数最少的队列
*/
BankQueue* findMin() {
	int min = 0;
	for (int i = 1; i < QueANum; i++) {
		if ((cusQueA_start + i)->length < (cusQueA_start + min)->length) {
			min = i;
		}
	}
	return cusQueA_start + min;
}

//==================================================================================================================================================

/*
	事件表初始化函数
	生成一个含有一个空结点的事件表
*/
Timetable::Timetable() {
	head = new ElmEvent;
	if (!head) exit(MEMORY_LOW);

	tail = head;
	head->next = NULL;
}

Timetable::~Timetable() {

}


/*
	插入事件函数
	按照发生时间升序进行排列
*/
Timetable Timetable::add_event(Event &newevent) {
	ElmEvent *p = head;
	//判断是否为空
	if (tail == head) {
		p->event = newevent;	//存入事件
		p->next = new ElmEvent;
		if (!p->next) exit(MEMORY_LOW);
		tail = p->next;
		tail->next = NULL;
		return *this;
	}
	//执行非空插入操作
	ElmEvent *q = new ElmEvent;
	if (!q) exit(MEMORY_LOW);
	q->event = newevent;

	//判断是否插入在第一位
	if (p->event.OccurTime >= q->event.OccurTime) {
		q->next = head;	//将新的事件插入首位
		head = q;
		return *this;
	}

	//定位
	while (p->next->next && p->next->event.OccurTime < q->event.OccurTime) p = p->next;
				//表示 q 插在 p 后面
	q->next = p->next;
	p->next = q;
	

	return *this;
}

/*
	事件表删除函数
	获得当前表的第一个事件， 存入 event 中
	并且出队列
*/

Timetable Timetable::delete_event(Event &event) {

	if (head == tail) return *this;		//事件表为空

	ElmEvent *p = head;
	event = p->event;
	head = p->next;
	delete p;

	return *this;
}

/*
	判断是否为空的函数
*/
bool Timetable::ifempty() {
	if (head == tail) return true;
	else return false;
}