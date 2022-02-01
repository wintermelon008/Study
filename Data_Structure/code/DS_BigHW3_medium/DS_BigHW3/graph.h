#pragma once

#include <cstdio>
#include <queue>
#include <unordered_map>
#include <limits>

using namespace std;

#define MAX_VNUM 30000000		//ͼ����󶥵���Ŀ

struct Node     //����ڵ�
{
	int vlue;
	int key;
	int parent;
	bool final;
	inline friend bool operator<(Node a, Node b) {   //��Ҫʵ����С�ѣ����������У������Ҫ������������ض������ȼ�����СΪ��
		return a.key > b.key;
	}
	Node(int v)
	{
		vlue = v;
		key = numeric_limits<int>::max();           //���������INF
		parent = -1;         //ÿ�����㶼�޸��׽ڵ�
		final = false;
	}
};

typedef struct Data {	//The data	(����洢����Ϣ)
	int tag;
	Data() {
		tag = 0;
	}
}Data;

struct ENode {			//The arc	(�߽ṹ��)
	int adjvex;				//�û�ָ��Ķ���
	int length;				//����
	ENode* nextarc;			//��ǰ�������һ����
	ENode() {
		adjvex = 0;
		length = 0;
		nextarc = NULL;
	}
};

struct VNode {	//The vex	(����ṹ��)
	//Data data;
	ENode* firstarc;
	VNode() {
		firstarc = NULL;
	}
	~VNode()
	{
		ENode* p = firstarc;
		if (p == NULL) return;
		while (!p)
		{
			ENode* q = p->nextarc;
			delete p;
			p = q;
		}
	}
};

class ALGraph {
public:
	unordered_map<int, VNode*> vertices;	//ͼ���㼯
	unordered_map<int, Node*> vec;			//���ȶ��н�㼯
	ALGraph();
	~ALGraph();

	void build(int mode);		//�ļ����빹��ͼ
	void dijkstra(int m, int n);		//����uv֮������·��

	void insertarc(int u, int v, int length);		//��������uv
	void insertvex(int u);					//��Ӷ���u

	int getV();			//����ͼ�Ķ�����Ŀ
	int getE();			//����ͼ�ı���

	void save(int mode);
	void load();

private:
	int vexnum, arcnum;
};		//����ͼ