#pragma once




//=============================================================================================================

struct Customer {	//存储客户基本信息
	int id;					//客户编号, 第一位顾客编号为 1
	int arrivetime;			//客户到达时间
	int durtime;			//客户交易所需事件
	int business_type;	    //业务类型， 1 代表存入， 0 代表取出
	int money;				//操作金额
	int queueA;				//记录顾客在哪一个第一类队列, 范围 0 -> QueANum - 1

};

struct ElmCustomer {		//存储银行队列中的客户结点
	Customer customer;
	ElmCustomer *next;
};

class BankQueue {		//表示银行柜台的队列

	friend BankQueue* findMin();		//寻找当前第一类队列中人数最少的

public:

	BankQueue();
	~BankQueue();
	BankQueue in_que(Customer new_cust);			//客户进入队列
	BankQueue out_que(Customer &cust);				//离开队列的客户
	BankQueue print();								//输出当前队列
	int getlength();								//获得当前队列长度
	bool queueA_check();
	bool queueB_check();				//遍历队列，寻找可以执行业务的客户


private:
	ElmCustomer *head;			//指向当前队列头
	ElmCustomer *tail;			//指向当前队列尾(建好的空结点)
	int length;				//存储当前队列长度
	int maxlength;			//当前队列最大长度
};




//==========================================================================================================================

typedef struct Event {		//存储事件的结构体
	int type;				//事件类型: -1 表示到达， 0 表示第二类队列离开， 1~n 表示第 n 个第一类队列离开   
	int OccurTime;			//事件发生时刻
} Event;

typedef struct ElmEvent {	//事件表结点结构体
	Event event;
	ElmEvent *next;
} ElmEvent;

class Timetable {	//存储事件列表的事件表(时间增序)

public:

	Timetable();
	~Timetable();

	Timetable add_event(Event &newevent);		//在事件表内插入对应的事件，按时间顺序插入
	Timetable delete_event(Event &event);		//删除事件表的第一个事件，并存入 event 中
	bool ifempty();								//判断事件表是否为空

private:
	ElmEvent *head;	//指向事件表头
	ElmEvent *tail;	//指向事件表尾
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
