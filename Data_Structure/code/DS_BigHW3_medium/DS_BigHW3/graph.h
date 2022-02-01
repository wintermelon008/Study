#pragma once

#include <cstdio>
#include <queue>
#include <unordered_map>
#include <limits>

using namespace std;

#define MAX_VNUM 30000000		//图中最大顶点数目

struct Node     //顶点节点
{
	int vlue;
	int key;
	int parent;
	bool final;
	inline friend bool operator<(Node a, Node b) {   //因要实现最小堆，按升序排列，因而需要重载运算符，重定义优先级，以小为先
		return a.key > b.key;
	}
	Node(int v)
	{
		vlue = v;
		key = numeric_limits<int>::max();           //估算距离置INF
		parent = -1;         //每个顶点都无父亲节点
		final = false;
	}
};

typedef struct Data {	//The data	(顶点存储的信息)
	int tag;
	Data() {
		tag = 0;
	}
}Data;

struct ENode {			//The arc	(边结构体)
	int adjvex;				//该弧指向的顶点
	int length;				//弧长
	ENode* nextarc;			//当前顶点的下一条弧
	ENode() {
		adjvex = 0;
		length = 0;
		nextarc = NULL;
	}
};

struct VNode {	//The vex	(顶点结构体)
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
	unordered_map<int, VNode*> vertices;	//图顶点集
	unordered_map<int, Node*> vec;			//优先队列结点集
	ALGraph();
	~ALGraph();

	void build(int mode);		//文件读入构建图
	void dijkstra(int m, int n);		//搜索uv之间的最短路径

	void insertarc(int u, int v, int length);		//添加无向边uv
	void insertvex(int u);					//添加顶点u

	int getV();			//返回图的顶点数目
	int getE();			//返回图的边数

	void save(int mode);
	void load();

private:
	int vexnum, arcnum;
};		//无向图