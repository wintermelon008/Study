#pragma once

//¥Ê¥¢ŒËµ∏¡¨À„∑®
#include <iostream>
using namespace std;
#define N 1010
typedef struct node
{
	int data;
	struct node *left;
	struct node *right;
	struct node *up;
	struct node *down;
	struct node *column;
}NODE;
NODE *head, *col[N], *last_row[N];
int m, n;
bool dlx();
void remove(NODE*);
void recover(NODE*);

int arr[4][5] =
{
1, 0 ,0 ,0 ,0,
0 ,1 ,1 ,1 ,1,
0 ,0 ,1 ,0 ,1,
0 ,1 ,0 ,0 ,1
};

int Now_R = 4, Now_C = 5;

/*
ŒËµ∏¡¥À„∑®∫À–ƒ∫Ø ˝

*/
int Dlx(int ROW, int COL, int input[][324])
{
	int a;
	int n = Now_R, m = Now_C;
	//cin >> n >> m;
	head = new NODE;
	for (int i = 1; i <= m; i++)
	{
		col[i] = new NODE;
	}
	col[1]->left = head;
	col[1]->right = col[2];
	col[1]->up = col[1]->down = col[1];
	col[1]->data = 1; col[1]->column = col[1];
	for (int i = 2; i <= m - 1; i++)
	{
		col[i]->data = i;
		col[i]->left = col[i - 1];
		col[i]->right = col[i + 1];
		col[i]->up = col[i]->down = col[i];
		col[i]->column = col[i];
	}
	col[m]->data = m;
	col[m]->left = col[m - 1];
	col[m]->right = head;
	col[m]->up = col[m]->down = col[m];
	col[m]->column = col[m];
	head->right = col[1];
	head->left = col[m];
	for (int i = 1; i <= n; i++)
	{
		NODE *last = NULL;
		for (int j = 1; j <= m; j++)
		{
			//cin >> a;
			a = arr[i - 1][j - 1];
			if (a == 1)
			{
				NODE *s = new NODE;
				s->data = i;
				s->column = col[j];
				if (last_row[j] != NULL)
				{
					s->up = last_row[j];
					s->down = last_row[j]->down;
					s->up->down = s;
					col[j]->up = s;
				}
				else
				{
					s->up = col[j];
					s->down = col[j];
					col[j]->up = s;
					col[j]->down = s;
				}
				if (last != NULL)
				{
					s->left = last;
					s->right = last->right;
					s->left->right = s;
				}
				else
				{
					s->left = s->right = s;
				}
				last = s;
				last_row[j] = s;
			}
		}
	}
	if (dlx())
	{
		cout << "true" << endl;
	}
	else
	{
		cout << "false" << endl;
	}

	system("pause");
	return 0;
}

bool dlx()
{
	NODE *c = head->right;
	if (head == head->right)
		return true;
	if (c->down == c)
		return false;
	remove(c);

	for (NODE *i = c->down; i != c; i = i->down)
	{
		for (NODE *j = i->right; j != i; j = j->right)
		{
			remove(j->column);
		}
		if (dlx())
		{
			cout << i->data << endl;
			return true;
		}
		else
		{
			for (NODE *j = i->right; j != i; j = j->right)
			{
				recover(j->column);
			}
		}
	}
	return false;
}

void remove(NODE *c)
{
	c->left->right = c->right;
	c->right->left = c->left;
	if (c->down == c)
		return;
	for (NODE *i = c->down; i != c; i = i->down)
	{
		for (NODE *j = i->right; j != i; j = j->right)
		{
			j->up->down = j->down;
			j->down->up = j->up;
		}
	}
	return;
}

void recover(NODE *c)
{
	c->left->right = c;
	c->right->left = c;
	for (NODE *i = c->down; i != c; i = i->down)
	{
		for (NODE *j = i->right; j != i; j = j->right)
		{
			j->up->down = j;
			j->down->up = j;
		}
	}

}