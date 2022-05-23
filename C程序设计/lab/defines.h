
//��������������
//#define STARTPIC "C:\\Users\\Huawei\\Desktop\\bigHomework_v1\\Bighomework_v1\\startpic.jpg"  //ͼ����Դ
#define STARTPIC "..\\startpic.jpg"  //ͼ����Դ
//�����������С
#define STARTWID 900  
#define STARTHEI 580

//�������ַ����ʼλ�ö���
#define NUM_BASE_WID 340  //���϶��������
#define NUM_BASE_HEI 20	  //���϶���������
#define BLOCK_SIZE 57    //ÿС�����
#define BLOCK_DISTANCE 9  //ÿ���ڴ����

//�����水ť�ߴ綨��
#define NUMBER_OF_MAIN_BUTTON 8  //��ť��Ŀ
#define MAIN_BUT_BASE_WID 90  //���϶��������
#define MAIN_BUT_BASE_HEI 100  //���϶���������
#define MAIN_BUT_WID 140
#define MAIN_BUT_HEI 35
#define MAIN_BUT_DISTANCE 22

#define MAIN_LOGO_BASE_WID 90  //������logo
#define MAIN_LOGO_BASE_HEI 35
#define MAIN_LOGO_WID 180
#define MAIN_LOGO_HEI 40

#define TOSETTING_BUT_BASE_WID 25  //�������ý���İ�ť
#define TOSETTING_BUT_BASE_HEI 25
#define TOSETTING_BUT_WID 30
#define TOSETTING_BUT_HEI 30

//���ý��水ť����=============================================================


#define SETTING_MENU_BASE_WID 250  //���ý����ʶ
#define SETTING_MENU_BASE_HEI 40
#define SETTING_MENU_WID 400
#define SETTING_MENU_HEI 40

//���ý��水ť
#define NUMBER_OF_SETTING_BUTTON 2  //��ť��Ŀ
#define SETTING_BUT_BASE_WID 325  
#define SETTING_BUT_BASE_HEI 150
#define SETTING_BUT_WID 250
#define SETTING_BUT_HEI 40
#define SETTING_BUT_DISTANCE 40


//��������
#define HELP_BACK_BUT_BASE_WID 50  //������һ���˵�
#define HELP_BACK_BUT_BASE_HEI 50
#define HELP_BACK_BUT_WID 120
#define HELP_BACK_BUT_HEI 40

#define HELP_MENU_BASE_WID 250  //������������ʶ
#define HELP_MENU_BASE_HEI 40
#define HELP_MENU_WID 400
#define HELP_MENU_HEI 40

#define HELP_WORD_BASE_WID 80  //���������ı�λ��
#define HELP_WORD_BASE_HEI 110
#define HELP_WORD_WID 700
#define HELP_WORD_HEI 35
#define HELP_WORD_DISTANCE 20

//ģʽ���ý���
#define MOD_BACK_BUT_BASE_WID 50  //������һ���˵�
#define MOD_BACK_BUT_BASE_HEI 50
#define MOD_BACK_BUT_WID 120
#define MOD_BACK_BUT_HEI 40

#define MOD_MENU_BASE_WID 250  //ģʽ��������ʶ
#define MOD_MENU_BASE_HEI 40
#define MOD_MENU_WID 400
#define MOD_MENU_HEI 40

#define MOD_BUT_BASE_WID 325
#define MOD_BUT_BASE_HEI 150
#define MOD_BUT_WID 250
#define MOD_BUT_HEI 40
#define MOD_BUT_DISTANCE 40


//���ؽ��水ť�ߴ綨��===========================================================
#define LOAD_BUT_BASE_WID 250
#define LOAD_BUT_BASE_HEI 100
#define LOAD_BUT_WID 400
#define LOAD_BUT_HEI 40
#define LOAD_BUT_DISTANCE 40

//���ؽ�����������
#define LOAD_MENU_BASE_WID 350  //���ؽ����ʶ
#define LOAD_MENU_BASE_HEI 40
#define LOAD_MENU_WID 200
#define LOAD_MENU_HEI 40

#define LOAD_PAGE_BASE_WID 400  //ҳ���ʶ
#define LOAD_PAGE_BASE_HEI 510
#define LOAD_PAGE_WID 100
#define LOAD_PAGE_HEI 40


#define LOAD_BACKBUT_BASE_WID 50  //���ذ�ť
#define LOAD_BACKBUT_BASE_HEI 50
#define LOAD_BACKBUT_WID 120
#define LOAD_BAVKBUT_HEI 40

#define LAST_PAGE_BASE_WID 50  //��һҳ��ť
#define LAST_PAGE_BASE_HEI 480
#define LAST_PAGE_WID 120
#define LAST_PAGE_HEI 40

#define NEXT_PAGE_BASE_WID 730  //��һҳ��ť
#define NEXT_PAGE_BASE_HEI 480
#define NEXT_PAGE_WID 120
#define NEXT_PAGE_HEI 40

//input���涨��
#define  INPUT_BUT_BACKBUT_BASE_WID 50  //���ذ�ť
#define  INPUT_BUT_BACKBUT_BASE_HEI 50
#define  INPUT_BUT_BACKBUT_WID 120
#define  INPUT_BUT_BAVKBUT_HEI 40

 

//�˳��������涨��
#define EXIT_BASE_WID 50  //������ʾ��
#define EXIT_BASE_HEI 160
#define EXIT_WID 800
#define EXIT_HEI 50

//��������===============================================================================

#define _CRT_SECURE_NO_WARNINGS 1

#define DIFFICLUTY 3  //�����Ѷ�
#define MAX_SOLUTION 20  //��������������Ŀ
#define MIN_NUMNER 17  //һ����������С����������Ŀ
#define MAX_SAVE 20 //���Ĵ浵��Ŀ


int numberCount = 0;  //��ǰ�ĺϷ�������Ŀ
bool ifinputaccept = true;;  //�ж�����������Ƿ�Ϸ�

bool ifDigsudoku = true;  //�ж��Ƿ����ɶԽ�������

int wrongState[9][9] = { 0 };  //inputר�ü�¼�����б�, 0Ϊ�ԣ� 1Ϊ��
int numberofwrongs = 0;
int tempsolutiontable[9][9] = { 0 };


//�Ż����
int availableNumbers[9][9][9] = { 0 };  //�洢ÿһ��λ�õ����������ܵ����
int availableCount[9][9] = { 0 };  //�洢��Ӧ�������Ŀ
int minAvailable = 9;  //��¼�������ٵĿ�����
int min_row = 0, min_col = 0;

char main_buttonwords[NUMBER_OF_MAIN_BUTTON][20] =
{
	"����",
	"���",	
	"���",
	"��ʾ",
	"����",
	"����",
	"����",
	"�˳�"  //�˳���Ҫ�����һλ
};

char help_words[NUMBER_OF_MAIN_BUTTON][50] =
{
	"[����]���������һ���µ�����",
	"[���]: �����ǰ�Ѿ����������",
	"[���]����⵱ǰ����",
	"[��ʾ]������һ����ȷ����",
	"[����]�����������Զ���������������룬�Ҽ�����",
	"[����]�����浱ǰ������",
	"[����]�������ѱ��������",
	"[�˳�]���˳���Ϸ"  //�˳���Ҫ�����һλ

};

char setting_buttonwords[NUMBER_OF_SETTING_BUTTON][20] =
{
	"��ť���ܽ���",
	"��������"
};

///*
//ѡ��С��������  //Ŀǰ������
#define NUMBERWID 155
#define NUMBERHEI 155
#define NUM_BLOCKSIZE 45
#define NUM_BLOCKDISTANCE 5
//ע������Ĳ���������Ϊ��߿����ڱ߿�ȿ�
//*/

void BK_ChooseMenu_Paint(void) {  //����ѡ���˵�9������
	//�����Ǵ󷽸����=======================================================================================
	setlinecolor(RGB(105, 105, 105)); //�涨�߿�ɫ
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
	setfillcolor(RGB(211, 211, 211));  //�涨���ɫ
	setfillstyle(BS_SOLID); //���������ʽ

	for (int i = 0; i <= 2; i++) { //�������
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
	inline  void  zh(int  tt) { x = (tt - 1) / 81 + 1; y = ((tt - 1) % 81) / 9 + 1; c = ((tt - 1) % 9) + 1; }//��ttֵת����
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
	//����������Ĵ���
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
	memset(bol, false, sizeof(bol));//��0
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
				for (int k = 1; k <= 9; k++)//ö��k
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
	for (int i = 1; i <= 324; i++)//���Ҫ�������棬��Ϊ�����forѭ������ɾ���Ļ�������Ϊlast��û�и��¶�������add�����ɾ���Ľڵ����»�ԭ
	{
		if (bol[i])del(i);
	}
	dance(0);

	sudokuCopy(tempsolutiontable, solutiontable[0]);

	//system("pause");
	return  0;
}

*/