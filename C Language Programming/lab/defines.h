#pragma once

//数独主界面设置
//#define STARTPIC "C:\\Users\\Huawei\\Desktop\\bigHomework_v1\\Bighomework_v1\\startpic.jpg"  //图形来源
#define STARTPIC "..\\startpic.jpg"  //图形来源
//数独主界面大小
#define STARTWID 900  
#define STARTHEI 580

//数独数字方格初始位置定义
#define NUM_BASE_WID 340  //左上顶点横坐标
#define NUM_BASE_HEI 20	  //左上顶点纵坐标
#define BLOCK_SIZE 57    //每小格宽度
#define BLOCK_DISTANCE 9  //每相邻大格间距

//主界面按钮尺寸定义
#define NUMBER_OF_MAIN_BUTTON 8  //按钮数目
#define MAIN_BUT_BASE_WID 90  //左上顶点横坐标
#define MAIN_BUT_BASE_HEI 100  //左上顶点纵坐标
#define MAIN_BUT_WID 140
#define MAIN_BUT_HEI 35
#define MAIN_BUT_DISTANCE 22

#define MAIN_LOGO_BASE_WID 90  //主界面logo
#define MAIN_LOGO_BASE_HEI 35
#define MAIN_LOGO_WID 180
#define MAIN_LOGO_HEI 40

#define TOSETTING_BUT_BASE_WID 25  //进入设置界面的按钮
#define TOSETTING_BUT_BASE_HEI 25
#define TOSETTING_BUT_WID 30
#define TOSETTING_BUT_HEI 30

//设置界面按钮定义=============================================================


#define SETTING_MENU_BASE_WID 250  //设置界面标识
#define SETTING_MENU_BASE_HEI 40
#define SETTING_MENU_WID 400
#define SETTING_MENU_HEI 40

//设置界面按钮
#define NUMBER_OF_SETTING_BUTTON 2  //按钮数目
#define SETTING_BUT_BASE_WID 325  
#define SETTING_BUT_BASE_HEI 150
#define SETTING_BUT_WID 250
#define SETTING_BUT_HEI 40
#define SETTING_BUT_DISTANCE 40


//帮助界面
#define HELP_BACK_BUT_BASE_WID 50  //返回上一级菜单
#define HELP_BACK_BUT_BASE_HEI 50
#define HELP_BACK_BUT_WID 120
#define HELP_BACK_BUT_HEI 40

#define HELP_MENU_BASE_WID 250  //帮助界面主标识
#define HELP_MENU_BASE_HEI 40
#define HELP_MENU_WID 400
#define HELP_MENU_HEI 40

#define HELP_WORD_BASE_WID 80  //帮助界面文本位置
#define HELP_WORD_BASE_HEI 110
#define HELP_WORD_WID 700
#define HELP_WORD_HEI 35
#define HELP_WORD_DISTANCE 20

//模式设置界面
#define MOD_BACK_BUT_BASE_WID 50  //返回上一级菜单
#define MOD_BACK_BUT_BASE_HEI 50
#define MOD_BACK_BUT_WID 120
#define MOD_BACK_BUT_HEI 40

#define MOD_MENU_BASE_WID 250  //模式界面主标识
#define MOD_MENU_BASE_HEI 40
#define MOD_MENU_WID 400
#define MOD_MENU_HEI 40

#define MOD_BUT_BASE_WID 325
#define MOD_BUT_BASE_HEI 150
#define MOD_BUT_WID 250
#define MOD_BUT_HEI 40
#define MOD_BUT_DISTANCE 40


//加载界面按钮尺寸定义===========================================================
#define LOAD_BUT_BASE_WID 250
#define LOAD_BUT_BASE_HEI 100
#define LOAD_BUT_WID 400
#define LOAD_BUT_HEI 40
#define LOAD_BUT_DISTANCE 40

//加载界面其他定义
#define LOAD_MENU_BASE_WID 350  //返回界面标识
#define LOAD_MENU_BASE_HEI 40
#define LOAD_MENU_WID 200
#define LOAD_MENU_HEI 40

#define LOAD_PAGE_BASE_WID 400  //页码标识
#define LOAD_PAGE_BASE_HEI 510
#define LOAD_PAGE_WID 100
#define LOAD_PAGE_HEI 40


#define LOAD_BACKBUT_BASE_WID 50  //返回按钮
#define LOAD_BACKBUT_BASE_HEI 50
#define LOAD_BACKBUT_WID 120
#define LOAD_BAVKBUT_HEI 40

#define LAST_PAGE_BASE_WID 50  //上一页按钮
#define LAST_PAGE_BASE_HEI 480
#define LAST_PAGE_WID 120
#define LAST_PAGE_HEI 40

#define NEXT_PAGE_BASE_WID 730  //下一页按钮
#define NEXT_PAGE_BASE_HEI 480
#define NEXT_PAGE_WID 120
#define NEXT_PAGE_HEI 40

//input界面定义
#define  INPUT_BUT_BACKBUT_BASE_WID 50  //返回按钮
#define  INPUT_BUT_BACKBUT_BASE_HEI 50
#define  INPUT_BUT_BACKBUT_WID 120
#define  INPUT_BUT_BAVKBUT_HEI 40

 

//退出数独界面定义
#define EXIT_BASE_WID 50  //结束提示词
#define EXIT_BASE_HEI 160
#define EXIT_WID 800
#define EXIT_HEI 50

//其他定义===============================================================================

#define _CRT_SECURE_NO_WARNINGS 1

#define DIFFICLUTY 3  //数独难度
#define MAX_SOLUTION 20  //单个数独最大解数目
#define MIN_NUMNER 17  //一个数独的最小非零数字数目
#define MAX_SAVE 20 //最多的存档数目


int numberCount = 0;  //当前的合法数字数目
bool ifinputaccept = true;;  //判断输入的数独是否合法

bool ifDigsudoku = true;  //判断是否生成对角线数独

int wrongState[9][9] = { 0 };  //input专用记录错误列表, 0为对， 1为错
int numberofwrongs = 0;
int tempsolutiontable[9][9] = { 0 };


//优化求解
int availableNumbers[9][9][9] = { 0 };  //存储每一个位置的数字所可能的情况
int availableCount[9][9] = { 0 };  //存储对应的情况数目
int minAvailable = 9;  //记录当下最少的可能数
int min_row = 0, min_col = 0;

char main_buttonwords[NUMBER_OF_MAIN_BUTTON][20] =
{
	"生成",
	"清空",	
	"求解",
	"提示",
	"输入",
	"保存",
	"载入",
	"退出"  //退出需要在最后一位
};

char help_words[NUMBER_OF_MAIN_BUTTON][50] =
{
	"[生成]：随机生成一个新的数独",
	"[清空]: 清除当前已经输入的数字",
	"[求解]：求解当前数独",
	"[提示]：填入一个正确的数",
	"[输入]：可以输入自定义数独，左键输入，右键撤销",
	"[保存]：保存当前的数独",
	"[载入]：载入已保存的数独",
	"[退出]：退出游戏"  //退出需要在最后一位

};

char setting_buttonwords[NUMBER_OF_SETTING_BUTTON][20] =
{
	"按钮功能介绍",
	"数独设置"
};

///*
//选数小窗口设置  //目前暂无用
#define NUMBERWID 155
#define NUMBERHEI 155
#define NUM_BLOCKSIZE 45
#define NUM_BLOCKDISTANCE 5
//注，这里的参数设置认为外边框与内边框等宽
//*/

void BK_ChooseMenu_Paint(void) {  //绘制选数菜单9个方格
	//以下是大方格绘制=======================================================================================
	setlinecolor(RGB(105, 105, 105)); //规定边框色
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
	setfillcolor(RGB(211, 211, 211));  //规定填充色
	setfillstyle(BS_SOLID); //设置填充样式

	for (int i = 0; i <= 2; i++) { //方格绘制
		for (int j = 0; j <= 2; j++) {
			fillrectangle((i + 1) * NUM_BLOCKDISTANCE + i * NUM_BLOCKSIZE,
				(j + 1) * NUM_BLOCKDISTANCE + j * NUM_BLOCKSIZE,
				(i + 1) * NUM_BLOCKDISTANCE + (i + 1) * NUM_BLOCKSIZE,
				(j + 1) * NUM_BLOCKDISTANCE + (j + 1) * NUM_BLOCKSIZE);
		}
	}
}

/*
int  a[1000];

struct  point
{
	int  x, y, c;
	inline  void  zh(int  tt) { x = (tt - 1) / 81 + 1; y = ((tt - 1) % 81) / 9 + 1; c = ((tt - 1) % 9) + 1; }//将tt值转回来
}ans[1000];

struct  node
{
	int  l, r, u, d, lie, hang;
};

node  p[210000]; int  len;

int  DLX_size[1000], last[1000], map[11][11];
bool  bol[1000];
inline  void  make(int  l, int  r, int  u, int  d, int  lie, int  hang) { p[len].l = l; p[len].r = r; p[len].u = u; p[len].d = d; p[len].lie = lie; p[len].hang = hang; }
inline  void  sxdel(int  x) { p[p[x].u].d = p[x].d; p[p[x].d].u = p[x].u; }
inline  void  nsxdel(int  x) { p[p[x].u].d = p[p[x].d].u = x; }
inline  void  zydel(int  x) { p[p[x].l].r = p[x].r; p[p[x].r].l = p[x].l; }
inline  void  nzydel(int  x) { p[p[x].l].r = p[p[x].r].l = x; }
inline  void  clear(int  x)
{
	len = 0; p[0].l = p[0].r = p[0].u = p[0].d = 0;
	for (int i = 1; i <= x; i++)
	{
		len++; make(i - 1, p[i - 1].r, i, i, i, 0);
		nzydel(i); DLX_size[i] = 0; last[i] = i;
	}
}
inline  void  add(int  row)
{
	if (!a[0])return;
	len++; make(len, len, last[a[1]], p[last[a[1]]].d, a[1], row);
	nsxdel(len); DLX_size[a[1]]++; last[a[1]] = len;
	for (int i = 2; i <= a[0]; i++)
	{
		len++;
		make(len - 1, p[len - 1].r, last[a[i]], p[last[a[i]]].d, a[i], row);
		nsxdel(len); nzydel(len); DLX_size[a[i]]++; last[a[i]] = len;
	}
}
inline  void  del(int  x)
{
	zydel(x);
	for (int i = p[x].u; i != x; i = p[i].u)
	{
		for (int j = p[i].r; j != i; j = p[j].r)
		{
			sxdel(j), DLX_size[p[j].lie]--;
		}
	}
}
inline  void  back(int  x)
{
	nzydel(x);
	for (int i = p[x].d; i != x; i = p[i].d)
	{
		for (int j = p[i].l; j != i; j = p[j].l)nsxdel(j), DLX_size[p[j].lie]++;
	}
}
inline bool dance(int  x)
{
	//打了无数遍的代码
	if (!p[0].r)
	{
		for (int i = 1; i <= x; i++)
		{
			map[ans[i].x][ans[i].y] = ans[i].c;
		}

		//sudokuCopy(map, solutiontable);
		for (int i = 1; i <= 9; i++)
		{
			for (int j = 1; j <= 9; j++) {
				tempsolutiontable[i - 1][j - 1] = map[i][j];
				//printf("%d ",map[i][j]);
			}
			//printf("%d\n",map[i][9]);
		}
		return  true;
	}
	int  first = 0, mi = 999999999;
	for (int i = p[0].r; i; i = p[i].r)
	{
		if (DLX_size[p[i].lie] < mi)mi = DLX_size[p[i].lie], first = p[i].lie;
	}
	if (mi == 0)return  false;
	del(first);
	for (int i = p[first].u; i != first; i = p[i].u)
	{
		for (int j = p[i].l; j != i; j = p[j].l)del(p[j].lie);
		ans[x + 1].zh(p[i].hang);
		if (dance(x + 1))return  true;
		for (int j = p[i].r; j != i; j = p[j].r)back(p[j].lie);
	}
	back(first);
	return  false;
}
int SudokuInfo::Dlx_solve()
{
	memset(bol, false, sizeof(bol));//清0
	clear(4 * 9 * 9);
	for (int i = 1; i <= 9; i++)
	{
		for (int j = 1; j <= 9; j++)
		{
			map[i][j] = showsudokutable[i - 1][j - 1];
			// scanf("%d",&map[i][j]);
			if (map[i][j])
			{
				bol[(i - 1) * 9 + j] = true;
				//				dlx.del((i-1)*9+j);
				bol[81 + (i - 1) * 9 + map[i][j]] = true;
				//				dlx.del(81+(i-1)*9+dlx.map[i][j]);
				bol[162 + (j - 1) * 9 + map[i][j]] = true;
				//				dlx.del(162+(j-1)*9+dlx.map[i][j]);
				bol[243 + (((i - 1) / 3) * 3 + (j - 1) / 3) * 9 + map[i][j]] = true;
				//				dlx.del(243+(((i-1)/3)*3+(j-1)/3)*9+dlx.map[i][j]);
							   // if (i == j) bol[324 + map[i][j]] = true;
							   // if (i + j == 10) bol[333 + map[i][j]] = true;
			}
			else
			{
				for (int k = 1; k <= 9; k++)//枚举k
				{
					if (!bol[81 + (i - 1) * 9 + k] && !bol[162 + (j - 1) * 9 + k] && !bol[243 + (((i - 1) / 3) * 3 + (j - 1) / 3) * 9 + k]
						// &&!bol[324 + k] && !bol[333 + k]
						)
					{
						a[0] = 0;
						a[++a[0]] = (i - 1) * 9 + j;
						a[++a[0]] = 81 + (i - 1) * 9 + k;
						a[++a[0]] = 162 + (j - 1) * 9 + k;
						a[++a[0]] = 243 + (((i - 1) / 3) * 3 + (j - 1) / 3) * 9 + k;
						add((i - 1) * 81 + (j - 1) * 9 + k);
					}
				}
			}
		}
	}
	for (int i = 1; i <= 324; i++)//这个要打在外面，因为如果在for循环里面删除的话，会因为last并没有更新而导致在add里面把删除的节点重新还原
	{
		if (bol[i])del(i);
	}
	dance(0);

	sudokuCopy(tempsolutiontable, solutiontable[0]);

	//system("pause");
	return  0;
}

*/