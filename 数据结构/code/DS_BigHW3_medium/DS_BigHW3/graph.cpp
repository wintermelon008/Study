#include "graph.h"

char buf[1 << 20], * p1, * p2;
#define gc(fp)																				 \
  (p1 == p2 && (p2 = (p1 = buf) + fread(buf, 1, 1 << 20, fp), p1 == p2) ? EOF : *p1++)

bool readdone = false;
//读入优化
inline int read(FILE* fp) {
	int x = 0;
	char ch = gc(fp);
	while (ch >= '0' && ch <= '9') {
		x = (x << 1) + (x << 3) + (ch ^ 48);
		ch = gc(fp);
	}
	if (ch == EOF)
		readdone = true;
	return x;
}

ALGraph::ALGraph() {
	vexnum = 0;
	arcnum = 0;
}

ALGraph::~ALGraph() {
	for (auto it = vertices.begin(); it != vertices.end(); it++) {
		delete(it->second);
	}
}

void ALGraph::build(int mode) {
	if (mode == 0) {
		FILE* fp;
		fopen_s(&fp, "D:\\repos\\DS_BigHW3_medium\\DS_BigHW3\\medium\\source.txt", "r");
		if (!fp) {
			printf_s("文件打开失败!\n");
			system("pause");
			exit(1);
		}
		while (!readdone) {
			int u = 0, v = 0, len = 0;
			u = read(fp); v = read(fp); len = read(fp);
			insertarc(u, v, len);
		}
		printf("build done for mode 0\n");
		fclose(fp);
	}
	else if (mode == 1) {
		load();
		printf("build done for mode 1\n");
	}
	else if (mode == 2)
	{
		FILE* fp;
		fopen_s(&fp, "D:\\repos\\DS_BigHW3_medium\\DS_BigHW3\\medium\\bit2.txt", "rb");
		if (!fp) {
			printf_s("文件打开失败!\n");
			system("pause");
			exit(1);
		}
		while (!feof(fp)) {
			int u = 0, v = 0, len = 0;
			fread(&u, sizeof(u), 1, fp);
			fread(&v, sizeof(v), 1, fp);
			fread(&len, sizeof(len), 1, fp);
			insertarc(u, v, len);
		}
		printf("build done for mode 2\n");
		fclose(fp);
	}

}

void ALGraph::dijkstra(int m, int n) {
	priority_queue<Node> quene;
	vec[m]->key = 0;
	quene.push(*vec[m]);
	while (!quene.empty())
	{
		register int u = quene.top().vlue;
		quene.pop();
		if (vec[u]->final) continue;
		vec[u]->final = true;
		if (u == n) break;
		ENode* p = vertices[u]->firstarc;
		while (p) {
			if (!vec[p->adjvex]->final && vec[u]->key + p->length < vec[p->adjvex]->key) {
				vec[p->adjvex]->key = vec[u]->key + p->length;
				vec[p->adjvex]->parent = u;
				quene.push(*vec[p->adjvex]);
			}
			p = p->nextarc;
		}
	}
}

void ALGraph::insertarc(int u, int v, int length) {
	insertvex(u);
	insertvex(v);
	ENode* pu = vertices[u]->firstarc, * pv = vertices[v]->firstarc;
	ENode* ppu = new ENode(), * ppv = new ENode();
	ppu->adjvex = v;
	ppu->length = length;
	ppv->adjvex = u;
	ppv->length = length;

	if (!pu) {
		vertices[u]->firstarc = ppu;
	}
	else {
		while (pu->nextarc) {
			pu = pu->nextarc;
		}
		pu->nextarc = ppu;
	}

	if (!pv) {
		vertices[v]->firstarc = ppv;
	}
	else {
		while (pv->nextarc) {
			pv = pv->nextarc;
		}
		pv->nextarc = ppv;
	}

	arcnum++;
}

void ALGraph::insertvex(int u) {
	if (vexnum == MAX_VNUM) {
		printf_s("图空间已满!\n");
		exit(1);
	}
	else {
		if (vertices.find(u) == vertices.end()) {
			vertices[u] = new VNode();
			vexnum++;
		}
	}
}

int ALGraph::getE() {
	return arcnum;
}

int ALGraph::getV() {
	return vexnum;
}

void ALGraph::save(int mode) {
	FILE* fp, * fp1;
	if (mode == 1) {
		build(0);
		const int divide = -1;
		fopen_s(&fp, "D:\\repos\\DS_BigHW3_medium\\DS_BigHW3\\medium\\bit1.txt", "wb");
		if (!fp) {
			printf("文件打开失败\n");
			system("pause");
			return;
		}
		fwrite(&vexnum, sizeof(int), 1, fp);
		for (auto it = vertices.begin(); it != vertices.end(); it++) {
			ENode* p = it->second->firstarc;
			fwrite(&it->first, sizeof(int), 1, fp);
			while (p) {
				fwrite(&p->adjvex, sizeof(int), 1, fp);
				fwrite(&p->length, sizeof(int), 1, fp);
				p = p->nextarc;
			}
			fwrite(&divide, sizeof(int), 1, fp);
		}
		fclose(fp);
		printf("save done for mode 1\n");
		return;
	}
	else if (mode == 2) {
		fopen_s(&fp, "D:\\repos\\DS_BigHW3_medium\\DS_BigHW3\\medium\\source.txt", "r");
		fopen_s(&fp1, "D:\\repos\\DS_BigHW3_medium\\DS_BigHW3\\medium\\bit2.txt", "wb");
		if (!fp || !fp1) {
			printf_s("文件打开失败!\n");
			system("pause");
			exit(1);
		}
		while (!feof(fp)) {
			int u = read(fp), v = read(fp), len = read(fp);
			fwrite(&u, sizeof(u), 1, fp1);
			fwrite(&v, sizeof(v), 1, fp1);
			fwrite(&len, sizeof(len), 1, fp1);
		}
		fclose(fp);
		fclose(fp1);
		printf("save done for mode 2\n");
	}
}

void ALGraph::load() {
	FILE* fp;
	fopen_s(&fp, "D:\\repos\\DS_BigHW3_medium\\DS_BigHW3\\medium\\bit1.txt", "rb");
	if (!fp) {
		printf("文件打开失败\n");
		system("pause");
		return;
	}
	register int num = 0;
	fread(&num, sizeof(int), 1, fp);
	for (register int i = 0; i < num; ++i) {
		int v = 0, u = 0, len = 0;
		fread(&v, sizeof(int), 1, fp);
		while (1) {
			fread(&u, sizeof(int), 1, fp);
			if (u == -1) break;
			fread(&len, sizeof(int), 1, fp);
			insertarc(v, u, len);
		}
	}
	fclose(fp);
}