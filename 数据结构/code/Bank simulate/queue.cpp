#include "queue.h"
#include "defines.h"
#include <cstdlib>
#include <cstring>
#include <iostream>

using namespace std;



int QueANum = QUEUEA_NUM;			//��һ����е�����
BankQueue *cusQueA_start;	//ָ���һ�ж��������ָ��
BankQueue QueB;				//�ڶ������
Timetable timetable;		//��ʼ��ʱ�̱�
Event nowevent;						//�洢��ǰ�¼���ȫ�ֱ���
int bankmoney = INI_BANK_MONEY;			//���г�ʼ�Ʋ�
int closetime = CLOSE_TIME;			//���й���ʱ��

bool flagB = true;		//��¼��Ǯʱ�Ƿ���еڶ�����м��
bool *flagA = new bool[QueANum];



/*
	���캯��
	����һ������һ���ս�㣬����Ϊ 0 �Ŀն���
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
	����к���
	�� new_cust ���뵱ǰ���е�ĩ��
*/
BankQueue BankQueue::in_que(Customer new_cust) {
	if (length == maxlength) return *this;  //������
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
	�����к���
	�Ӷ���ͷ�Ƴ���һλ�ͻ��� ���� cust ��
*/
BankQueue BankQueue::out_que(Customer &cust) {
	if (!length) return *this;		//���п�
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
	�������
	��ӡ��ǰ����
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
	��һ����б�������
	��������е�һ���ͻ���������������������뿪�¼��� ��������ڶ������
*/
bool BankQueue::queueA_check() {
	ElmCustomer *p = head;
	if (!length) return false;
	if (p->customer.business_type) {	//��ʾ��Ǯ
		Event newevent;
		newevent.type = p->customer.queueA + 1;	//ȷ�������Լ��뿪�¼�����
		newevent.OccurTime = nowevent.OccurTime + p->customer.durtime;
		timetable.add_event(newevent);
		bankmoney += p->customer.money;

		flagA[p->customer.queueA] = false;

		if (flagB) QueB.queueB_check();		//���ڴ�Ǯʱ���еڶ������б���
		return true;
	}
	else {		//��ʾȡǮ
		if (p->customer.money <= bankmoney) {	//ȡǮ�������е�Ǯ�㹻
			Event newevent;
			newevent.type = p->customer.queueA + 1;	//ȷ�������Լ��뿪�¼�����

			flagA[p->customer.queueA] = false;

			newevent.OccurTime = nowevent.OccurTime + p->customer.durtime;
			timetable.add_event(newevent);
			bankmoney -= p->customer.money;
			return true;
		}
		else {		//ȡǮ�� �������е�Ǯ����
			Customer customer;
			out_que(customer);	//�뿪���У� ����ڶ������
			QueB.in_que(customer);
			return false;
		}
	}
	
}

/*
	�ڶ�����б�������
	Ѱ�Ҷ����� bankmoney ǰ���¿��Դ���Ŀͻ�������Ӷ�Ӧ�¼����¼�����
	���������û���������������򷵻� false
*/
bool BankQueue::queueB_check() {
	ElmCustomer *p = head;
	int count = 0;	//ͳ���Ѿ��ҹ��Ľ����
	while (count < length) {
		if (!p->customer.business_type && p->customer.money <= bankmoney) {  //ȷ����������ΪȡǮ����������㹻
			//ִ����Ӧ�Ŀͻ�����
			Event newevent;
			newevent.type = 0;	//ȷ�������Լ��뿪�¼�����
			newevent.OccurTime = nowevent.OccurTime + p->customer.durtime;
			timetable.add_event(newevent);
			flagB = false;
			bankmoney -= p->customer.money;
			return true;	//������ɣ��˳�����
		}
		else {
			p = p->next;
			Customer customer;
			out_que(customer);
			in_que(customer);		//�����Ŷ�
			count++;				//����
		}	
	}
	//�� count >= length ��ʾ�Ѿ�ѭ����һ�ζ��У���Ȼû�п��Բ������û������˳�����
	return false;
}


/*
	Ѱ����С����
	���ص�ǰ�������ٵĶ���
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
	�¼����ʼ������
	����һ������һ���ս����¼���
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
	�����¼�����
	���շ���ʱ�������������
*/
Timetable Timetable::add_event(Event &newevent) {
	ElmEvent *p = head;
	//�ж��Ƿ�Ϊ��
	if (tail == head) {
		p->event = newevent;	//�����¼�
		p->next = new ElmEvent;
		if (!p->next) exit(MEMORY_LOW);
		tail = p->next;
		tail->next = NULL;
		return *this;
	}
	//ִ�зǿղ������
	ElmEvent *q = new ElmEvent;
	if (!q) exit(MEMORY_LOW);
	q->event = newevent;

	//�ж��Ƿ�����ڵ�һλ
	if (p->event.OccurTime >= q->event.OccurTime) {
		q->next = head;	//���µ��¼�������λ
		head = q;
		return *this;
	}

	//��λ
	while (p->next->next && p->next->event.OccurTime < q->event.OccurTime) p = p->next;
				//��ʾ q ���� p ����
	q->next = p->next;
	p->next = q;
	

	return *this;
}

/*
	�¼���ɾ������
	��õ�ǰ��ĵ�һ���¼��� ���� event ��
	���ҳ�����
*/

Timetable Timetable::delete_event(Event &event) {

	if (head == tail) return *this;		//�¼���Ϊ��

	ElmEvent *p = head;
	event = p->event;
	head = p->next;
	delete p;

	return *this;
}

/*
	�ж��Ƿ�Ϊ�յĺ���
*/
bool Timetable::ifempty() {
	if (head == tail) return true;
	else return false;
}