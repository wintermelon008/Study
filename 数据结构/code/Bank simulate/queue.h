#pragma once




//=============================================================================================================

struct Customer {	//�洢�ͻ�������Ϣ
	int id;					//�ͻ����, ��һλ�˿ͱ��Ϊ 1
	int arrivetime;			//�ͻ�����ʱ��
	int durtime;			//�ͻ����������¼�
	int business_type;	    //ҵ�����ͣ� 1 ������룬 0 ����ȡ��
	int money;				//�������
	int queueA;				//��¼�˿�����һ����һ�����, ��Χ 0 -> QueANum - 1

};

struct ElmCustomer {		//�洢���ж����еĿͻ����
	Customer customer;
	ElmCustomer *next;
};

class BankQueue {		//��ʾ���й�̨�Ķ���

	friend BankQueue* findMin();		//Ѱ�ҵ�ǰ��һ��������������ٵ�

public:

	BankQueue();
	~BankQueue();
	BankQueue in_que(Customer new_cust);			//�ͻ��������
	BankQueue out_que(Customer &cust);				//�뿪���еĿͻ�
	BankQueue print();								//�����ǰ����
	int getlength();								//��õ�ǰ���г���
	bool queueA_check();
	bool queueB_check();				//�������У�Ѱ�ҿ���ִ��ҵ��Ŀͻ�


private:
	ElmCustomer *head;			//ָ��ǰ����ͷ
	ElmCustomer *tail;			//ָ��ǰ����β(���õĿս��)
	int length;				//�洢��ǰ���г���
	int maxlength;			//��ǰ������󳤶�
};




//==========================================================================================================================

typedef struct Event {		//�洢�¼��Ľṹ��
	int type;				//�¼�����: -1 ��ʾ��� 0 ��ʾ�ڶ�������뿪�� 1~n ��ʾ�� n ����һ������뿪   
	int OccurTime;			//�¼�����ʱ��
} Event;

typedef struct ElmEvent {	//�¼�����ṹ��
	Event event;
	ElmEvent *next;
} ElmEvent;

class Timetable {	//�洢�¼��б���¼���(ʱ������)

public:

	Timetable();
	~Timetable();

	Timetable add_event(Event &newevent);		//���¼����ڲ����Ӧ���¼�����ʱ��˳�����
	Timetable delete_event(Event &event);		//ɾ���¼���ĵ�һ���¼��������� event ��
	bool ifempty();								//�ж��¼����Ƿ�Ϊ��

private:
	ElmEvent *head;	//ָ���¼���ͷ
	ElmEvent *tail;	//ָ���¼���β
};

BankQueue* findMin();


extern int QueANum;
extern BankQueue *cusQueA_start;
extern BankQueue QueB;
extern int bankmoney;
extern Timetable timetable;
extern Event nowevent;
extern int closetime;	
extern bool flagB;
extern bool *flagA;