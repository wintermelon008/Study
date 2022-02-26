#include "graph.h"
#include <iostream>
#include <ctime>

using namespace std;


/*
*	这是针对中数据集的版本
*	m = 123456, n = 54321

*/

int main() {
	int m = 123456, n = 54321;		//mn最短路径
	
	int mode = 0;

	//图读取
	clock_t start, end;
	double endtime;
	ALGraph* graph = new ALGraph();
	//ALGraph *graph_1 = new ALGraph();
	start = clock();
	graph->build(mode);
	end = clock();
	endtime = (double)(end - start) / CLOCKS_PER_SEC;
	cout << "Build Total time for mode 0:" << endtime * 1000 << "ms" << endl;

	/*
	graph_1 = new ALGraph();
	start = clock();
	graph_1->build(1);
	end = clock();
	endtime = (double)(end - start) / CLOCKS_PER_SEC;
	cout << "Build Total time for mode 1:" << endtime * 1000 << "ms" << endl;
	delete graph_1;

	graph_1 = new ALGraph();
	start = clock();
	graph_1->build(0);
	end = clock();
	endtime = (double)(end - start) / CLOCKS_PER_SEC;
	cout << "Build Total time for mode 2:" << endtime * 1000 << "ms" << endl;
	delete graph_1;

	*/

	//图构建
	for (auto it = graph->vertices.begin(); it != graph->vertices.end(); it++) {
		graph->vec[it->first] = new Node(it->first);
	}
	start = clock();
	graph->dijkstra(m, n);
	end = clock();
	endtime = (double)(end - start) / CLOCKS_PER_SEC;
	cout << "Improved Dijkstra Total time:" << endtime * 1000 << "ms" << endl;

	//路径输出
	printf("The length from %d to %d is = %d\n",m, n, graph->vec[n]->key);
	int v = n;
	while (v != m) {
		printf("%d->", v);
		v = graph->vec[v]->parent;
	}
	printf("%d\n", m);

	for (auto it = graph->vec.begin(); it != graph->vec.end(); it++) {
		delete (it->second);
	}
	delete graph;
	return 0;
}