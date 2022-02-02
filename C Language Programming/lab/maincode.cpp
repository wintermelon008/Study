
#include <conio.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <graphics.h>
#include <fstream>
#include <iostream>
#include <stdio.h>
#include <string>
#include <limits.h>
#include <vector>
#include <time.h>
#include <Windows.h>

#include "defines.h"
#include "SudokuInfo.h"
#include "DLX.h"



using namespace std;

int numberofNames = 0; //存档数目
char savedfiles[MAX_SAVE][50] = { '\0' };  //当前的存档名称
int page = 0;  //存档读取页码

void sudokuCopy(int input1[][9], int input2[][9]);

void exitsudoku(void);  //退出界面

void BK_NumBlock_Paint(void);

void BK_Button_Paint(COLORREF color);

void BK_Settings_Paint(void);

void BK_Input_Paint(void);

void BK_Help_Paint(void);

void BK_SudokuChoose_Paint(void);

//按钮功能函数整合====================================================================================================
void SudokuInfo::button_generate(void) {

	sudoku.generate();
	//画初始方格
	BK_NumBlock_Paint();

	//填数
	sudoku.showsudokuPage();
}

void SudokuInfo::button_solve(void) {
	int row = 0, col = 0;

	bool ifs = ifDigsudoku ? sudoku.solve() : sudoku.Dlx_solve();

	if (!ifs) {
		HWND wnd = GetHWnd();
		MessageBox(wnd, "当前数独无解!", "数独", MB_OK | MB_ICONINFORMATION);
		return;
	}


	if (!findnextEmpty(0, &row, &col)) {//找到下一个为空的位置
		HWND wnd = GetHWnd();
		MessageBox(wnd, "求解完成.", "数独", MB_OK | MB_ICONINFORMATION);
		return;
	}

	if (ifs) { //判断是否有解
		
		sudokuCopy(solutiontable[0], showsudokutable);
		//画初始方格
		BK_NumBlock_Paint();

		//填数
		sudoku.showsudokuPage();
	}

}


//图形化函数区==========================================================================================================
/*
数字方格绘制
*/
void BK_NumBlock_Paint(void) {
	//画装有数字的方格

	//以下是大方格绘制=======================================================================================
	setlinecolor(RGB(240, 255, 255)); //规定边框色
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
	setfillcolor(RGB(65, 105, 225));  //规定填充色
	setfillstyle(BS_SOLID); //设置填充样式

	//循环画大方格
	for (int i = 0; i <= 2; i++) {
		for (int j = 0; j <= 2; j++) {
			//int bi = i / 3, bj = j / 3;
			fillrectangle(NUM_BASE_WID + 3 * i * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + 3 * j * BLOCK_SIZE + j * BLOCK_DISTANCE,
				NUM_BASE_WID + 3 * (i + 1) * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + 3 * (j + 1) * BLOCK_SIZE + j * BLOCK_DISTANCE);
		}
	}

	//以下是小方格绘制=========================================================================================
	setlinecolor(RGB(240, 255, 255));  //划线颜色
	setlinestyle(PS_SOLID, 2);  //划线样式

	for (int i = 0; i <= 2; i++) {
		for (int j = 0; j <= 2; j++) {
			line(NUM_BASE_WID + (3 * i + 1) * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + 3 * j * BLOCK_SIZE + j * BLOCK_DISTANCE,
				NUM_BASE_WID + (3 * i + 1) * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + 3 * (j + 1) * BLOCK_SIZE + j * BLOCK_DISTANCE
			);
			line(NUM_BASE_WID + (3 * i + 2) * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + 3 * j * BLOCK_SIZE + j * BLOCK_DISTANCE,
				NUM_BASE_WID + (3 * i + 2) * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + 3 * (j + 1) * BLOCK_SIZE + j * BLOCK_DISTANCE
			);
			line(NUM_BASE_WID + 3 * i * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + (3 * j + 1) * BLOCK_SIZE + j * BLOCK_DISTANCE,
				NUM_BASE_WID + 3 * (i + 1) * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + (3 * j + 1) * BLOCK_SIZE + j * BLOCK_DISTANCE
			);
			line(NUM_BASE_WID + 3 * i * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + (3 * j + 2) * BLOCK_SIZE + j * BLOCK_DISTANCE,
				NUM_BASE_WID + 3 * (i + 1) * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + (3 * j + 2) * BLOCK_SIZE + j * BLOCK_DISTANCE
			);
		}
	}

	//以下是logo绘制
	RECT r = { MAIN_LOGO_BASE_WID, MAIN_LOGO_BASE_HEI,MAIN_LOGO_BASE_WID + MAIN_BUT_WID, MAIN_LOGO_BASE_HEI + MAIN_BUT_HEI };
	//设置字体
	settextcolor(RGB(0, 191, 255));
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// 设置输出效果为抗锯齿  
	f.lfWeight = 500;
	f.lfHeight = 50;
	strcpy(f.lfFaceName, _T("Calibri"));
	f.lfItalic = false;
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //设置背景透明

	drawtext("Sudoku", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

}

void BK_Button_Paint(COLORREF color) {

	//以下是功能按钮绘制======================================================================================
	setlinecolor(RGB(240, 255, 255)); //规定边框色
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
	setfillcolor(color);  //规定填充色
	setfillstyle(BS_SOLID); //设置填充样式

	settextcolor(RGB(191, 239, 255));  //字体设色
	//设置字体
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// 设置输出效果为抗锯齿  
	f.lfWeight = 500;
	f.lfHeight = 18;
	strcpy(f.lfFaceName, _T("黑体"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //设置背景透明

	RECT r;
	for (int i = 0; i < NUMBER_OF_MAIN_BUTTON; i++) {
		fillrectangle(MAIN_BUT_BASE_WID, MAIN_BUT_BASE_HEI + i * (MAIN_BUT_HEI + MAIN_BUT_DISTANCE),
			MAIN_BUT_BASE_WID + MAIN_BUT_WID,
			MAIN_BUT_BASE_HEI + (i + 1) * MAIN_BUT_HEI + i * MAIN_BUT_DISTANCE);
		r = { MAIN_BUT_BASE_WID, MAIN_BUT_BASE_HEI + i * (MAIN_BUT_HEI + MAIN_BUT_DISTANCE),
					  MAIN_BUT_BASE_WID + MAIN_BUT_WID,
					  MAIN_BUT_BASE_HEI + (i + 1) * MAIN_BUT_HEI + i * MAIN_BUT_DISTANCE };
		drawtext(main_buttonwords[i], &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	}

	fillrectangle(TOSETTING_BUT_BASE_WID, TOSETTING_BUT_BASE_HEI,
				 TOSETTING_BUT_BASE_WID + TOSETTING_BUT_WID, TOSETTING_BUT_BASE_HEI + TOSETTING_BUT_HEI);
	r = { TOSETTING_BUT_BASE_WID, TOSETTING_BUT_BASE_HEI,
				 TOSETTING_BUT_BASE_WID + TOSETTING_BUT_WID, TOSETTING_BUT_BASE_HEI + TOSETTING_BUT_HEI };
	drawtext("?", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}

/*
绘制设置菜单的函数
*/
void BK_Settings_Paint(void) {
	RECT r;

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);  //加载图片

	setlinecolor(RGB(240, 255, 255)); //规定边框色
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
	setfillcolor(RGB(39, 64, 139));  //规定填充色
	setfillstyle(BS_SOLID); //设置填充样式

	settextcolor(RGB(191, 239, 255));  //字体设色
	//设置字体
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// 设置输出效果为抗锯齿  
	f.lfWeight = 500;
	f.lfHeight = 20;
	strcpy(f.lfFaceName, _T("黑体"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //设置背景透明

	f.lfHeight = 20;
	settextstyle(&f);

	for (int i = 0; i < NUMBER_OF_SETTING_BUTTON; i++) {  //按钮绘制
		fillrectangle(SETTING_BUT_BASE_WID, SETTING_BUT_BASE_HEI + i * (SETTING_BUT_HEI + SETTING_BUT_DISTANCE),
					  SETTING_BUT_BASE_WID + SETTING_BUT_WID,
					  SETTING_BUT_BASE_HEI + (i + 1) * SETTING_BUT_HEI + i * SETTING_BUT_DISTANCE);

		r = { SETTING_BUT_BASE_WID, SETTING_BUT_BASE_HEI + i * (SETTING_BUT_HEI + SETTING_BUT_DISTANCE),
			  SETTING_BUT_BASE_WID + SETTING_BUT_WID,
			  SETTING_BUT_BASE_HEI + (i + 1) * SETTING_BUT_HEI + i * SETTING_BUT_DISTANCE };
		drawtext(setting_buttonwords[i], &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	}

	fillrectangle(INPUT_BUT_BACKBUT_BASE_WID, INPUT_BUT_BACKBUT_BASE_HEI,
		INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID, INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI);  //返回按钮绘制
	r = { INPUT_BUT_BACKBUT_BASE_WID, INPUT_BUT_BACKBUT_BASE_HEI,
				 INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID, INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI };
	drawtext("主菜单", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	f.lfHeight = 40;
	settextstyle(&f);

	r = {SETTING_MENU_BASE_WID, SETTING_MENU_BASE_HEI, 
		SETTING_MENU_BASE_WID + SETTING_MENU_WID,  SETTING_MENU_BASE_HEI + SETTING_MENU_HEI };
	drawtext("游戏设置与帮助", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}


/*
绘制帮助菜单的函数
*/
void BK_Help_Paint(void) {

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);  //加载图片

	setlinecolor(RGB(240, 255, 255)); //规定边框色
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
	setfillcolor(RGB(39, 64, 139));  //规定填充色
	setfillstyle(BS_SOLID); //设置填充样式

	settextcolor(RGB(191, 239, 255));  //字体设色
	//设置字体
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// 设置输出效果为抗锯齿  
	f.lfWeight = 500;
	f.lfHeight = 20;
	strcpy(f.lfFaceName, _T("黑体"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //设置背景透明

	fillrectangle(HELP_BACK_BUT_BASE_WID, HELP_BACK_BUT_BASE_HEI,
		HELP_BACK_BUT_BASE_WID + HELP_BACK_BUT_WID, HELP_BACK_BUT_BASE_HEI + HELP_BACK_BUT_HEI);

	RECT r = { HELP_BACK_BUT_BASE_WID, HELP_BACK_BUT_BASE_HEI,
			  HELP_BACK_BUT_BASE_WID + HELP_BACK_BUT_WID, HELP_BACK_BUT_BASE_HEI + HELP_BACK_BUT_HEI };
	drawtext("返回", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	f.lfHeight = 22;
	f.lfOutPrecision = true;
	settextcolor(RGB(0 ,255 ,127));
	settextstyle(&f);

	for (int i = 0; i < NUMBER_OF_MAIN_BUTTON; i++) {  //绘制介绍文本

		r = { HELP_WORD_BASE_WID,
			  HELP_WORD_BASE_HEI + i * (HELP_WORD_HEI + HELP_WORD_DISTANCE),
			  HELP_WORD_BASE_WID + 1 * HELP_WORD_WID,
			  HELP_WORD_BASE_HEI + (i + 1) * HELP_WORD_HEI + i * HELP_WORD_DISTANCE };
		drawtext(help_words[i], &r, DT_LEFT | DT_VCENTER | DT_SINGLELINE);

	}

	settextcolor(RGB(191, 239, 255));  //字体设色
	f.lfHeight = 40;
	settextstyle(&f);

	r = { HELP_MENU_BASE_WID, HELP_MENU_BASE_HEI,
		HELP_MENU_BASE_WID + HELP_MENU_WID, HELP_MENU_BASE_HEI + HELP_MENU_HEI };
	drawtext("按钮功能说明", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}

/*
绘制模式选择菜单的函数
*/
void BK_SudokuChoose_Paint(void) {
	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);  //加载图片

	setlinecolor(RGB(240, 255, 255)); //规定边框色
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
	setfillcolor(RGB(39, 64, 139));  //规定填充色
	setfillstyle(BS_SOLID); //设置填充样式

	settextcolor(RGB(191, 239, 255));  //字体设色
	//设置字体
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// 设置输出效果为抗锯齿  
	f.lfWeight = 500;
	f.lfHeight = 20;
	strcpy(f.lfFaceName, _T("黑体"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //设置背景透明

	fillrectangle(MOD_BACK_BUT_BASE_WID, MOD_BACK_BUT_BASE_HEI,
		MOD_BACK_BUT_BASE_WID + MOD_BACK_BUT_WID, MOD_BACK_BUT_BASE_HEI + MOD_BACK_BUT_HEI);

	RECT r = { MOD_BACK_BUT_BASE_WID, MOD_BACK_BUT_BASE_HEI,
		MOD_BACK_BUT_BASE_WID + MOD_BACK_BUT_WID, MOD_BACK_BUT_BASE_HEI + MOD_BACK_BUT_HEI };
	drawtext("返回", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);


	settextcolor(RGB(191, 239, 255));  //字体设色
	f.lfHeight = 40;
	settextstyle(&f);

	r = { MOD_MENU_BASE_WID, MOD_MENU_BASE_HEI,
		MOD_MENU_BASE_WID + MOD_MENU_WID, MOD_MENU_BASE_HEI + MOD_MENU_HEI };
	drawtext("数独模式设置", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);


}


/*
绘制输入菜单的函数
*/
void BK_Input_Paint(void)  {

	setlinecolor(RGB(240, 255, 255)); //规定边框色
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
	setfillcolor(RGB(39, 64, 139));  //规定填充色
	setfillstyle(BS_SOLID); //设置填充样式

	settextcolor(RGB(191, 239, 255));  //字体设色
	//设置字体
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// 设置输出效果为抗锯齿  
	f.lfWeight = 500;
	f.lfHeight = 20;
	strcpy(f.lfFaceName, _T("黑体"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //设置背景透明

	fillrectangle(INPUT_BUT_BACKBUT_BASE_WID, INPUT_BUT_BACKBUT_BASE_HEI,
				 INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID, INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI);  //返回按钮绘制
	RECT r = { INPUT_BUT_BACKBUT_BASE_WID, INPUT_BUT_BACKBUT_BASE_HEI,
				 INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID, INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI };
	drawtext("主菜单", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}

/*
绘制加载菜单的函数
*/
void Loadsaves(void) {
	
	FILE *fnames = fopen("name.txt", "a+");
	int i = 0; //记录文件名数目

	if (fnames == NULL) {
		//printf("No available saved sudokus.\n");
		//return false;
	}

	while (1) {
		if (feof(fnames)) {
			numberofNames = i;
			fclose(fnames);
			break;
			//return true;
		}
		fscanf(fnames, "%s", savedfiles[i++]);
		if (i >= MAX_SAVE) {
			fclose(fnames);
			break;
			//return false;
		}
	}


}


void  SudokuInfo::LoadChoose(int page) {  //存档界面切换

	RECT r;

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);  //加载图片

	setlinecolor(RGB(240, 255, 255)); //规定边框色
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
	setfillcolor(RGB(39, 64, 139));  //规定填充色
	setfillstyle(BS_SOLID); //设置填充样式

	settextcolor(RGB(191, 239, 255));  //字体设色
	//设置字体
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// 设置输出效果为抗锯齿  
	f.lfWeight = 500;
	f.lfHeight = 20;
	strcpy(f.lfFaceName, _T("黑体"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //设置背景透明

	for (int i = 0; i <= 4; i++) {  //绘制五个存档按钮
		fillrectangle(LOAD_BUT_BASE_WID,
			LOAD_BUT_BASE_HEI + i * (LOAD_BUT_HEI + LOAD_BUT_DISTANCE),
			LOAD_BUT_BASE_WID + 1 * LOAD_BUT_WID,
			LOAD_BUT_BASE_HEI + (i + 1) * LOAD_BUT_HEI + i * LOAD_BUT_DISTANCE);
		r = { LOAD_BUT_BASE_WID,
					  LOAD_BUT_BASE_HEI + i * (LOAD_BUT_HEI + LOAD_BUT_DISTANCE),
					  LOAD_BUT_BASE_WID + 1 * LOAD_BUT_WID,
					  LOAD_BUT_BASE_HEI + (i + 1) * LOAD_BUT_HEI + i * LOAD_BUT_DISTANCE };
		drawtext(savedfiles[i + page * 5], &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	}

	fillrectangle(LOAD_BACKBUT_BASE_WID, LOAD_BACKBUT_BASE_HEI,
		LOAD_BACKBUT_BASE_WID + LOAD_BACKBUT_WID, LOAD_BACKBUT_BASE_HEI + LOAD_BAVKBUT_HEI);  //返回按钮绘制
	r = { LOAD_BACKBUT_BASE_WID, LOAD_BACKBUT_BASE_HEI,
				  LOAD_BACKBUT_BASE_WID + LOAD_BACKBUT_WID, LOAD_BACKBUT_BASE_HEI + LOAD_BAVKBUT_HEI };
	drawtext("主菜单", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	if (page == 0) {
		setfillcolor(RGB(105, 105, 105));  //规定填充色
	}
	else {
		setfillcolor(RGB(39, 64, 139));  //规定填充色
	}
	fillrectangle(LAST_PAGE_BASE_WID, LAST_PAGE_BASE_HEI, LAST_PAGE_BASE_WID + LAST_PAGE_WID, LAST_PAGE_BASE_HEI + LAST_PAGE_HEI);

	r = { LAST_PAGE_BASE_WID, LAST_PAGE_BASE_HEI, LAST_PAGE_BASE_WID + LAST_PAGE_WID, LAST_PAGE_BASE_HEI + LAST_PAGE_HEI };
	drawtext("上一页", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	if (page == 3) {
		setfillcolor(RGB(105, 105, 105));  //规定填充色
	}
	else {
		setfillcolor(RGB(39, 64, 139));  //规定填充色
	}
	fillrectangle(NEXT_PAGE_BASE_WID, NEXT_PAGE_BASE_HEI, NEXT_PAGE_BASE_WID + NEXT_PAGE_WID, NEXT_PAGE_BASE_HEI + NEXT_PAGE_HEI);

	r = { NEXT_PAGE_BASE_WID, NEXT_PAGE_BASE_HEI, NEXT_PAGE_BASE_WID + NEXT_PAGE_WID, NEXT_PAGE_BASE_HEI + NEXT_PAGE_HEI };
	drawtext("下一页", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	//相关文字绘制
	settextcolor(RGB(224, 255, 255));
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// 设置输出效果为抗锯齿  
	f.lfWeight = 500;
	f.lfHeight = 30;
	strcpy(f.lfFaceName, _T("Calibri"));
	f.lfItalic = false;
	settextstyle(&f);

	f.lfHeight = 40;
	settextstyle(&f);
	r = { LOAD_MENU_BASE_WID, LOAD_MENU_BASE_HEI, LOAD_MENU_BASE_WID + LOAD_MENU_WID, LOAD_MENU_BASE_HEI + LOAD_MENU_HEI };
	drawtext("存档选择", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	f.lfHeight = 20;
	settextstyle(&f);
	r = { LOAD_PAGE_BASE_WID, LOAD_PAGE_BASE_HEI, LOAD_PAGE_BASE_WID + LOAD_PAGE_WID, LOAD_PAGE_BASE_HEI + LOAD_PAGE_HEI };

	char output[40] = { "Page: " }, pagenum[3] = { '\0' };
	pagenum[0] = page + 49;
	strcat(output, pagenum);
	drawtext(output, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

}


/*
数字显示函数
将数独输出到当前界面上
*/
void SudokuInfo::showsudokuPage(void) {  //将数独输出到当前界面上
	int bi = 0, bj = 0;

	settextstyle(40, 0, _T("Consolas")); //设置字体
	setbkmode(TRANSPARENT);  //设置背景透明
	for (int i = 0; i <= 8; i++) {
		for (int j = 0; j <= 8; j++) {
			bi = i / 3;
			bj = j / 3;

			settextcolor(RGB(255, 255, 255));  //字体设为白色

			if (startstatetable[i][j]) {
				settextcolor(RGB(151, 255, 255));
			}

			RECT r = { NUM_BASE_WID + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
					   NUM_BASE_HEI + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
					   NUM_BASE_WID + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE,
					   NUM_BASE_HEI + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE };  //确定输出方格

			drawtext(showsudokutable[i][j] + 48, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		}
	}
}

int numberChoose(void) {  //选数窗口,返回选的数

	LPTSTR s = new char[10];
	InputBox(s, 10, (LPCTSTR)"请输入你要输入的数\n范围是1到9", (LPCTSTR)"输入数字");
	int r = _wtoi((wchar_t *)s);
	if (r >= 10 || r <= 0) r = 0;

	return r;
}

//每一帧更新函数================================================================================================

bool SudokuInfo::mainupdate()  // 主窗口每帧更新
{
	MOUSEMSG m;

	if (MouseHit()) {
		m = GetMouseMsg();

		if (m.uMsg == WM_RBUTTONDOWN) {  //右键为清零
			int bi = 0, bj = 0;
			for (int i = 0; i <= 8; i++) {
				for (int j = 0; j <= 8; j++) {
					bi = i / 3;
					bj = j / 3;

					//确定所点的方格
					if (m.x >= NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.x <= NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.y >= NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE &&
						m.y <= NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE) {

						if (!startstatetable[j][i]) { //判断该处是不是原始数字

							setlinecolor(RGB(240, 255, 255)); //规定边框色
							setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
							setfillcolor(RGB(65, 105, 225));  //规定填充色
							setfillstyle(BS_SOLID); //设置填充样式

							fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
								NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

							settextstyle(40, 0, _T("Consolas")); //设置字体
							settextcolor(RGB(255, 255, 255));  //字体设为白色
							setbkmode(TRANSPARENT);  //设置背景透明

							RECT r = { NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
							   NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
							   NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
							   NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE };  //确定输出方格

							drawtext(48, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
							showsudokutable[j][i] = 0;
						}


					}

				}
			}


		}


		if (m.uMsg == WM_LBUTTONDOWN) {
			int bi = 0, bj = 0;

			//判断是否点在按钮上
			for (int i = 0; i < NUMBER_OF_MAIN_BUTTON; i++) {
				if (m.x >= MAIN_BUT_BASE_WID && m.x <= MAIN_BUT_BASE_WID + MAIN_BUT_WID &&
					m.y >= MAIN_BUT_BASE_HEI + i * MAIN_BUT_HEI + i * MAIN_BUT_DISTANCE &&
					m.y <= MAIN_BUT_BASE_HEI + (i + 1) * MAIN_BUT_HEI + i * MAIN_BUT_DISTANCE) {

					if (i != NUMBER_OF_MAIN_BUTTON - 1) (this->*main_button[i])();  //非exit按钮判断
					else {
						return false;
					}
				}
			}

			//SETTING_BUT_BASE_WID, SETTING_BUT_BASE_HEI,
			//SETTING_BUT_BASE_WID + SETTING_BUT_WID, SETTING_BUT_BASE_HEI + SETTING_BUT_HEI
			if (m.x >= TOSETTING_BUT_BASE_WID && m.x <= TOSETTING_BUT_BASE_WID + TOSETTING_BUT_WID &&
				m.y >= TOSETTING_BUT_BASE_HEI && m.y <= TOSETTING_BUT_BASE_HEI + TOSETTING_BUT_HEI) {  //判断是否为设置按钮

				sudoku.settings();
			}

			//判断是否点在方格里，若是则代表修改数据
			for (int i = 0; i <= 8; i++) {
				for (int j = 0; j <= 8; j++) {
					bi = i / 3;
					bj = j / 3;

					//确定所点的方格
					if (m.x >= NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.x <= NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.y >= NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE &&
						m.y <= NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE) {

						if (!startstatetable[j][i]) {  //判断该处是不是原始数字
							int ans = numberChoose();

							showsudokutable[j][i] = ans;

							setlinecolor(RGB(240, 255, 255)); //规定边框色
							setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
							setfillcolor(RGB(65, 105, 225));  //规定填充色
							setfillstyle(BS_SOLID); //设置填充样式


							fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
								NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

							settextstyle(40, 0, _T("Consolas")); //设置字体
							setbkmode(TRANSPARENT);  //设置背景透明

							settextcolor(RGB(255, 255, 255));  //字体设为白色
							if (!sudoku.IfFitCheck(j, i, ans, false)) {  //判断该输入是否合法
								settextcolor(RGB(255, 69, 0));  //字体设为红色
								//sudoku.solve();
							}
							else {
								//sudoku.solve();
							}

							sudoku.solve();

							RECT r = { NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								   NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
								   NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								   NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE };  //确定输出方格

							drawtext(ans + 48, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
						}
					}

				}
			}
		}
	}
	return true;

}

bool SudokuInfo::loadupdate(void) {

	//0<= page <= 3
	MOUSEMSG m;


	if (MouseHit()) {
		m = GetMouseMsg();


		if (m.uMsg == WM_LBUTTONDOWN) {
			int bi = 0, bj = 0;

			//返回按钮判断

			if (m.x >= LOAD_BACKBUT_BASE_WID && m.x <= LOAD_BACKBUT_BASE_WID + LOAD_BACKBUT_WID &&
				m.y >= LOAD_BACKBUT_BASE_HEI && m.y <= LOAD_BACKBUT_BASE_HEI + LOAD_BAVKBUT_HEI) {

				return false;

			}

			for (int i = 0; i <= 4; i++) {  //判断点击存档按钮
				if (m.x >= LOAD_BUT_BASE_WID && m.x <= LOAD_BUT_BASE_WID + 1 * LOAD_BUT_WID &&
					m.y >= LOAD_BUT_BASE_HEI + i * (LOAD_BUT_HEI + LOAD_BUT_DISTANCE) &&
					m.y <= LOAD_BUT_BASE_HEI + (i + 1) * LOAD_BUT_HEI + i * LOAD_BUT_DISTANCE) {

					int saves = i + page * 4;
					if (saves <= numberofNames - 2) sudoku.readsave(i + page * 4);

					return false;
				}
			}

			if (m.x >= LAST_PAGE_BASE_WID && m.x <= LAST_PAGE_BASE_WID + NEXT_PAGE_WID &&
				m.y >= LAST_PAGE_BASE_HEI && m.y <= LAST_PAGE_BASE_HEI + NEXT_PAGE_HEI) {  //上一页按钮
				if (page > 0) page--;
				sudoku.LoadChoose(page);
				return true;
			}

			if (m.x >= NEXT_PAGE_BASE_WID && m.x <= NEXT_PAGE_BASE_WID + NEXT_PAGE_WID &&
				m.y >= NEXT_PAGE_BASE_HEI && m.y <= NEXT_PAGE_BASE_HEI + NEXT_PAGE_HEI) {  //下一页按钮
				if (page < 3) page++;
				sudoku.LoadChoose(page);
				return true;
			}
		}
	}

	return true;
}

bool SudokuInfo::settingupdate(void) {
	MOUSEMSG m;

	if (MouseHit()) {
		m = GetMouseMsg();

		if (m.uMsg == WM_LBUTTONDOWN) { //判断左键
			int bi = 0, bj = 0;

			//返回按钮判断

			//返回按钮判断
			if (m.x >= INPUT_BUT_BACKBUT_BASE_WID && m.x <= INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID &&
				m.y >= INPUT_BUT_BACKBUT_BASE_HEI && m.y <= INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI) {
				return false;
			}

			//判断是否点在按钮上
			for (int i = 0; i < NUMBER_OF_SETTING_BUTTON; i++) {
				if (m.x >= SETTING_BUT_BASE_WID && m.x <= SETTING_BUT_BASE_WID + SETTING_BUT_WID &&
					m.y >= SETTING_BUT_BASE_HEI + i * SETTING_BUT_HEI + i * SETTING_BUT_DISTANCE &&
					m.y <= SETTING_BUT_BASE_HEI + (i + 1) * SETTING_BUT_HEI + i * SETTING_BUT_DISTANCE) {

					(this->*setting_button[i])();  //按钮判断

				}
			}

		}
	}

	return true;
}

bool SudokuInfo::helpupdate(void) {
	MOUSEMSG m;

	if (MouseHit()) {
		m = GetMouseMsg();

		if (m.uMsg == WM_LBUTTONDOWN) { //判断左键
			int bi = 0, bj = 0;

			//返回按钮判断
			if (m.x >= HELP_BACK_BUT_BASE_WID && m.x <= HELP_BACK_BUT_BASE_WID + HELP_BACK_BUT_WID &&
				m.y >= HELP_BACK_BUT_BASE_HEI && m.y <= HELP_BACK_BUT_BASE_HEI + HELP_BACK_BUT_HEI) {
				return false;
			}
		}
	}
	return true;
}

bool SudokuInfo::sudokuSetupdate(void) {

	LOGFONT f;
	gettextstyle(&f);
	f.lfWeight = 500;
	f.lfHeight = 20;
	strcpy(f.lfFaceName, _T("黑体"));
	settextstyle(&f);

	MOUSEMSG m;

	if (!ifDigsudoku) setfillcolor(RGB(105, 105, 105));  //规定填充色
	else setfillcolor(RGB(39, 64, 139));  //规定填充色

	fillrectangle(MOD_BUT_BASE_WID, MOD_BUT_BASE_HEI,
		MOD_BUT_BASE_WID + MOD_BUT_WID, MOD_BUT_BASE_HEI + MOD_BUT_HEI);
	RECT r = { MOD_BUT_BASE_WID, MOD_BUT_BASE_HEI,
		MOD_BUT_BASE_WID + MOD_BUT_WID, MOD_BUT_BASE_HEI + MOD_BUT_HEI };
	drawtext("普通数独", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	if (ifDigsudoku) setfillcolor(RGB(105, 105, 105));  //规定填充色
	else setfillcolor(RGB(39, 64, 139));  //规定填充色

	fillrectangle(MOD_BUT_BASE_WID, MOD_BUT_BASE_HEI + MOD_BUT_HEI + MOD_BUT_DISTANCE,
		MOD_BUT_BASE_WID + MOD_BUT_WID, MOD_BUT_BASE_HEI + 2 * MOD_BUT_HEI + MOD_BUT_DISTANCE);
	r = { MOD_BUT_BASE_WID, MOD_BUT_BASE_HEI + MOD_BUT_HEI + MOD_BUT_DISTANCE,
		MOD_BUT_BASE_WID + MOD_BUT_WID , MOD_BUT_BASE_HEI + 2 * MOD_BUT_HEI + MOD_BUT_DISTANCE };
	drawtext("对角线数独", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	//Sleep(50);

	if (MouseHit()) {
		m = GetMouseMsg();

		if (m.uMsg == WM_LBUTTONDOWN) { //判断左键
			int bi = 0, bj = 0;

			//返回按钮判断
			if (m.x >= MOD_BACK_BUT_BASE_WID && m.x <= MOD_BACK_BUT_BASE_WID + HELP_BACK_BUT_WID &&
				m.y >= MOD_BACK_BUT_BASE_HEI && m.y <= MOD_BACK_BUT_BASE_HEI + HELP_BACK_BUT_HEI) {
				return false;
			}

			//对角线数独按钮判断

			if (m.x >= MOD_BUT_BASE_WID && m.x <= MOD_BUT_BASE_WID + MOD_BUT_WID &&
				m.y >= MOD_BUT_BASE_HEI && m.y <= MOD_BUT_BASE_HEI + MOD_BUT_HEI) {
				
				if (ifDigsudoku) {
					ifDigsudoku = false;
					return true;
				}
			}

			if (m.x >= MOD_BUT_BASE_WID && m.x <= MOD_BUT_BASE_WID + MOD_BUT_WID &&
				m.y >= MOD_BUT_BASE_HEI + MOD_BUT_HEI + MOD_BUT_DISTANCE && m.y <= MOD_BUT_BASE_HEI + 2 * MOD_BUT_HEI + MOD_BUT_DISTANCE) {

				if (!ifDigsudoku) {
					ifDigsudoku = true;
					return true;
				}
			}
		}
	}
	
	return true;
}

bool SudokuInfo::inputupdate(void) {

	MOUSEMSG m;

	if (MouseHit()) {

		bool ifnumberEnough = numberCount >= MIN_NUMNER ? true : false;


		int tempsudoku[9][9] = { 0 };  //暂存原始的数独
		sudokuCopy(showsudokutable, tempsudoku);  //空出主数独窗口

		m = GetMouseMsg();

		if (m.uMsg == WM_RBUTTONDOWN) {  //右键为清零

			int bi = 0, bj = 0;
			for (int i = 0; i <= 8; i++) {
				for (int j = 0; j <= 8; j++) {
					bi = i / 3;
					bj = j / 3;

					//确定所点的方格
					if (m.x >= NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.x <= NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.y >= NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE &&
						m.y <= NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE) {

						if (1) {

							setlinecolor(RGB(240, 255, 255)); //规定边框色
							setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
							setfillcolor(RGB(65, 105, 225));  //规定填充色
							setfillstyle(BS_SOLID); //设置填充样式

							fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
								NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

							settextstyle(40, 0, _T("Consolas")); //设置字体
							settextcolor(RGB(255, 255, 255));  //字体设为白色
							setbkmode(TRANSPARENT);  //设置背景透明

							RECT r = { NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
							   NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
							   NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
							   NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE };  //确定输出方格

							drawtext(48, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

							if (wrongState[j][i]) {
								wrongState[j][i] = 0;
								numberofwrongs--;
							}
							if (showsudokutable[j][i]) numberCount--;
							showsudokutable[j][i] = 0;
							startstatetable[j][i] = 0;

						}

					}
				}
			}
		}

		if (m.uMsg == WM_LBUTTONDOWN) {

			//返回按钮判断
			if (m.x >= INPUT_BUT_BACKBUT_BASE_WID && m.x <= INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID &&
				m.y >= INPUT_BUT_BACKBUT_BASE_HEI && m.y <= INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI) {

				if (!numberofwrongs && ifnumberEnough) ifinputaccept = true;  //这个判断要加在确定按钮那里
				else ifinputaccept = false;


				return false;
			}

			for (int i = 0; i <= 8; i++) {
				for (int j = 0; j <= 8; j++) {
					int bi = i / 3;
					int bj = j / 3;

					//确定所点的方格
					if (m.x >= NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.x <= NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.y >= NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE &&
						m.y <= NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE) {

						if (1) {  //判断该处是不是原始数字
							int ans = numberChoose();

							setlinecolor(RGB(240, 255, 255)); //规定边框色
							setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
							setfillcolor(RGB(65, 105, 225));  //规定填充色
							setfillstyle(BS_SOLID); //设置填充样式


							fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
								NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

							settextstyle(40, 0, _T("Consolas")); //设置字体
							setbkmode(TRANSPARENT);  //设置背景透明

							settextcolor(RGB(255, 255, 255));  //字体设为白色
							if (!sudoku.IfFitCheck(j, i, ans, false)) {  //判断该输入是否合法
								settextcolor(RGB(255, 69, 0));  //字体设为红色

								if (!wrongState[j][i]) numberofwrongs++;

								wrongState[j][i] = 1;

							}
							else {
								if (!showsudokutable[j][i]) numberCount++;
								showsudokutable[j][i] = ans;
								if (showsudokutable[j][i]) startstatetable[j][i] = 1;
							}

							RECT r = { NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								   NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
								   NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								   NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE };  //确定输出方格

							drawtext(ans + 48, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
						}
					}

				}
			}
		}
	}

	return true;
}


/*
数独初始窗口
*/
void entersudoku(void) {
	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);

	//设置字体
	settextcolor(RGB(0, 191, 255));
	LOGFONT f;
	gettextstyle(&f);
	f.lfWeight = 500;
	f.lfHeight = 70;
	strcpy(f.lfFaceName, _T("Calibri"));
	f.lfItalic = true;
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //设置背景透明

	RECT r = { EXIT_BASE_WID, EXIT_BASE_HEI, EXIT_BASE_WID + EXIT_WID, EXIT_BASE_HEI + EXIT_BASE_HEI };

	drawtext("Welcome to my Sudoku world!", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	//设置字体
	settextcolor(RGB(224, 255, 255));
	gettextstyle(&f);
	f.lfWeight = 500;
	f.lfHeight = 30;
	strcpy(f.lfFaceName, _T("Calibri"));
	f.lfItalic = true;
	settextstyle(&f);

	r = { EXIT_BASE_WID + 200, EXIT_BASE_HEI + 150, EXIT_BASE_WID + EXIT_WID + 200, EXIT_BASE_HEI + EXIT_BASE_HEI + 150 };

	drawtext("Produced by wintermelon", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	r = { EXIT_BASE_WID + 220, EXIT_BASE_HEI + 200, EXIT_BASE_WID + EXIT_WID + 220, EXIT_BASE_HEI + EXIT_BASE_HEI + 200 };

	f.lfHeight = 25;
	f.lfItalic = false;
	settextstyle(&f);

	drawtext("2021.6", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}

/*
退出数独窗口
*/
void exitsudoku(void) {  
	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);

	//设置字体
	settextcolor(RGB(0 ,191 ,255));
	LOGFONT f;
	gettextstyle(&f);
	f.lfWeight = 500;
	f.lfHeight = 50;
	strcpy(f.lfFaceName, _T("Calibri"));
	f.lfItalic = false;
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //设置背景透明

	RECT r = { EXIT_BASE_WID, EXIT_BASE_HEI, EXIT_BASE_WID + EXIT_WID, EXIT_BASE_HEI + EXIT_BASE_HEI };

	drawtext("Thanks for your playing!", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	//设置字体
	settextcolor(RGB(224, 255, 255));
	gettextstyle(&f);
	f.lfWeight = 500;
	f.lfHeight = 30;
	strcpy(f.lfFaceName, _T("Calibri"));
	f.lfItalic = true;
	settextstyle(&f);

	r = { EXIT_BASE_WID + 200, EXIT_BASE_HEI + 150, EXIT_BASE_WID + EXIT_WID + 200, EXIT_BASE_HEI + EXIT_BASE_HEI + 150 };

	drawtext("Produced by wintermelon", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	r = { EXIT_BASE_WID + 220, EXIT_BASE_HEI + 200, EXIT_BASE_WID + EXIT_WID + 220, EXIT_BASE_HEI + EXIT_BASE_HEI + 200 };

	f.lfHeight = 25;
	f.lfItalic = false;
	settextstyle(&f);

	drawtext("2021.6", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);


}

//======================================================================================================================




//=====================================================================================================
//外接调用函数细节部分
//=====================================================================================================

//DLX算法=======================================================================================================

struct Node {
	Node *up, *down, *left, *right, *colRoot, *rowRoot;//上下左右四个指针以及指向行列对象的指针
	int Num;//行对象特有,记录行数
	int Size;//列对象特有,记录该列元素数
	Node(int i = -1) : Num(i), Size(0) {};//构造函数
};

class DLX {
public:
	DLX(vector<vector<int> > &matrix, int m, int n);
	~DLX() { delete Head; };//析构有点难写
	void init();
	void link(vector<vector<int> > &matrix);
	void cover(Node *cRoot);
	void recover(Node *cRoot);
	bool Search(int k = 0);
	vector<int> getResult() const { return result; }
	int getUpdates() const { return _updates; }
private:
	Node *Head;
	vector<int> result;//结果存放在这里
	int _row, _col, _updates;//记录行列数,更新次数
};

DLX::DLX(vector<vector<int> > &matrix, int m, int n)
	:_row(m), _col(n), _updates(0)
{
	Head = new Node;
	Head->up = Head;
	Head->down = Head;
	Head->right = Head;
	Head->left = Head;
	init();
	link(matrix);
}

void DLX::init()
{
	Node *newNode;
	for (int ix = 0; ix < _col; ++ix)//表头位置向后插入,构造列对象
	{
		newNode = new Node;
		newNode->up = newNode;
		newNode->down = newNode;
		newNode->right = Head->right;
		newNode->left = Head;
		newNode->right->left = newNode;
		Head->right = newNode;
	}
	for (int ix = 0; ix < _row; ++ix)//表头位置向下插入,构造行对象
	{
		newNode = new Node(_row - ix);//注意序号是_row-ix
		newNode->down = Head->down;
		newNode->up = Head;
		newNode->down->up = newNode;
		Head->down = newNode;
	}
}

void DLX::link(vector<vector<int> > &matrix)
{
	Node *current_row, *current_col, *newNode, *current;//当前行对象,当前列对象,新节点,当前节点
	current_row = Head;
	for (int row = 0; row < _row; ++row)
	{
		current_row = current_row->down;
		current_col = Head;
		for (int col = 0; col < _col; ++col)
		{
			current_col = current_col->right;

			if (matrix[row][col] == 0)//矩阵上为0的位置不设置节点
				continue;

			newNode = new Node;

			newNode->colRoot = current_col;
			newNode->rowRoot = current_row;//设置当前节点对应的行列对象

			newNode->down = current_col;
			newNode->up = current_col->up;
			newNode->up->down = newNode;
			current_col->up = newNode;//链接当前节点到列双向链尾端

			if (current_row->Size == 0)//行双向链不应该把行对象包含进来
			{
				current_row->right = newNode;
				newNode->left = newNode;
				newNode->right = newNode;
				current_row->Size++;
			}
			current = current_row->right;//设置当前节点(即行对象右的节点)
			newNode->left = current->left;
			newNode->right = current;
			newNode->left->right = newNode;
			current->left = newNode;//链接当前节点到行双向链尾端

			current_col->Size++;
		}
	}
}

void DLX::cover(Node *cRoot)//覆盖列
{
	++_updates;
	cRoot->left->right = cRoot->right;
	cRoot->right->left = cRoot->left;//删除该列对象
	Node *i, *j;
	i = cRoot->down;
	while (i != cRoot)
	{
		j = i->right;
		while (j != i)
		{
			j->down->up = j->up;
			j->up->down = j->down;
			j->colRoot->Size--;
			j = j->right;
		}
		i = i->down;
	}
}

void DLX::recover(Node *cRoot)//整个算法的精髓!!
{
	Node *i, *j;
	i = cRoot->up;
	while (i != cRoot)
	{
		j = i->left;
		while (j != i)
		{
			j->colRoot->Size++;
			j->down->up = j;
			j->up->down = j;
			j = j->left;
		}
		i = i->up;
	}
	cRoot->right->left = cRoot;
	cRoot->left->right = cRoot;
}

bool DLX::Search(int k)
{
	if (Head->right == Head)//表空,则成功找到一组行的集合
		return true;

	Node *cRoot = new Node, *c;
	int minSize = INT_MAX;
	for (c = Head->right; c != Head; c = c->right)//根据启发条件选择列对象
	{
		if (c->Size < minSize)
		{
			minSize = c->Size;
			cRoot = c;
			if (minSize == 1)
				break;
			if (minSize == 0)//有一列为空,失败
				return false;
		}
	}
	cover(cRoot);

	Node *current_row, *current;
	for (current_row = cRoot->down; current_row != cRoot; current_row = current_row->down)
	{
		result.push_back(current_row->rowRoot->Num);//将该行加入result中
		for (current = current_row->right; current != current_row; current = current->right)
		{
			cover(current->colRoot);
		}
		if (Search(k + 1))
			return true;
		for (current = current_row->left; current != current_row; current = current->left)
			recover(current->colRoot);
		result.pop_back();//发现该行不符合要求,还原result
	}
	recover(cRoot);
	return false;
}

vector<vector<int> > sudoku2matrix(string &problem)//将数独转换为01矩阵
{
	vector<vector<int> > matrix;
	for (int ix = 0; ix < 81; ++ix)
	{
		int val = problem[ix] - '0';
		vector<int> current_row(324, 0);
		if (val != 0)
		{
			current_row[ix] = 1;
			current_row[81 + ix / 9 * 9 + val - 1] = 1;
			current_row[162 + ix % 9 * 9 + val - 1] = 1;
			current_row[243 + (ix / 9 / 3 * 3 + ix % 9 / 3) * 9 + val - 1] = 1;
			matrix.push_back(current_row);
			continue;
		}
		for (int jx = 0; jx < 9; ++jx)
		{
			vector<int> current_row2(324, 0);
			current_row2[ix] = 1;
			current_row2[81 + ix / 9 * 9 + jx] = 1;
			current_row2[162 + ix % 9 * 9 + jx] = 1;
			current_row2[243 + (ix / 9 / 3 * 3 + ix % 9 / 3) * 9 + jx] = 1;
			matrix.push_back(current_row2);
		}
	}
	return matrix;
}

vector<int> matrix2sudoku(vector<vector<int> > &matrix, vector<int> result)//将01矩阵翻译为数独
{
	vector<int> solution(81);
	for (int ix = 0; ix < 81; ++ix)
	{
		vector<int> current = matrix[result[ix] - 1];
		int pos = 0, val = 0;
		for (int jx = 0; jx < 81; ++jx)
		{
			if (current[jx] == 1)
				break;
			++pos;
		}
		for (int kx = 81; kx < 162; ++kx)
		{
			if (current[kx] == 1)
				break;
			++val;
		}
		solution[pos] = val % 9 + 1;
	}
	return solution;
}

void SudokuInfo::solve_sudoku(string &problem)
{
	clock_t start_1 = clock();
	vector<vector<int> > matrix = sudoku2matrix(problem);
	clock_t end_1 = clock();
	float time_1 = (float)(end_1 - start_1) / CLOCKS_PER_SEC;

	clock_t start_2 = clock();
	DLX sudoku(matrix, matrix.size(), 324);
	clock_t end_2 = clock();
	float time_2 = (float)(end_2 - start_2) / CLOCKS_PER_SEC;

	clock_t start_3 = clock();
	if (!sudoku.Search())
	{
		cout << "该数独无解!\n\n";
		return;
	}
	clock_t end_3 = clock();
	float time_3 = (float)(end_3 - start_3) / CLOCKS_PER_SEC;

	clock_t start_4 = clock();
	vector<int> solution = matrix2sudoku(matrix, sudoku.getResult());
	clock_t end_4 = clock();
	float time_4 = (float)(end_4 - start_4) / CLOCKS_PER_SEC;

	for (int i = 0; i <= 8; i++) {
		for (int j = 0; j <= 8; j++) {
			solutiontable[0][i][j] = solution[i * 9 + j];
		}
	}
}

bool SudokuInfo::Dlx_solve()
{
	string problem;
	// ofstream outfile("solution.txt");
	

	FILE *fp = fopen("problem.txt", "w+");
	for (int i = 0; i <= 8; i++) {
		for (int j = 0; j <= 8; j++) {
			fprintf(fp, "%d", showsudokutable[i][j]);
		}

	}
	fclose(fp);

	ifstream infile("problem.txt");

	while (infile >> problem)
	{
		
		if (problem.size() != 81)
		{
			return false;
		}
		sudoku.solve_sudoku(problem);
	}

	/*
	*/
	return true;
}


//通用功能性函数区
//=======================================================================================================================


/*
随机数函数
范围从 min 到 max 之间随机生成
*/
int random(int min, int max) {
	int t;
	t = rand() % (max - min) + min;
	return t;
}

/*
方阵复制函数
将input 1内容复制到input 2之中
*/
void sudokuCopy(int input1[][9], int input2[][9]) {
	for (int i = 0; i <= 8; i++) {
		for (int j = 0; j <= 8; j++) {
			input2[i][j] = input1[i][j];
		}
	}
	return;
}


/*
数独方阵初始化函数,初始化至number
mods choose: 1-7
1-showsudokutable
2-solutiontable
4-startstatetable
*/
void SudokuInfo::allclear(int mod, int number) {
	if (mod <= 0 || mod >= 8) mod = 7;

	if (mod & 1) memset(showsudokutable, number, 81 * sizeof(int));
	mod >>= 1;
	if (mod & 1) memset(solutiontable, number, MAX_SOLUTION * 81 * sizeof(int));
	mod >>= 1;
	if (mod & 1) memset(startstatetable, number, 81 * sizeof(int));
}

/*
填入合法性函数
检查第x行第y列能否填入number
ifself控制是否检查(x,y)
*/
bool SudokuInfo::IfFitCheck(int x, int y, int number, bool ifCheckself) {
	if (number == 0) return true;  //0为自检数

	if (ifCheckself && showsudokutable[x][y]) return false; //若当前位置有数则视为不可填入

	for (int i = 0; i <= 8; i++) { //检查目标列是否有重复
		if (i == x) continue;
		if (showsudokutable[i][y] == number) return false;
	}

	for (int j = 0; j <= 8; j++) { //检查目标行是否有重复
		if (j == y) continue;
		if (showsudokutable[x][j] == number) return false;
	}

	for (int i = (x / 3) * 3; i <= (x / 3) * 3 + 2; i++) {  //检查目标所在九宫格是否有重复
		for (int j = (y / 3) * 3; j <= (y / 3) * 3 + 2; j++) {
			if (i == x && j == y) continue;
			if (showsudokutable[i][j] == number) return false;
		}
	}

	if (ifDigsudoku && x == y) {
		for (int i = 0; i <= 8; i++) {  //检查对角线元素是否有重复
			if (i == x) continue;
			if (showsudokutable[i][i] == number) {
				return false;
			}
		}
	}
	if (ifDigsudoku && x + y == 8) {
		for (int i = 0; i <= 8; i++) {  //检查对角线元素是否有重复
			if (i == x) continue;
			if (showsudokutable[i][8 - i] == number) {
				return false;
			}
		}
	}

	return true;
}


//模块功能性函数区
//========================================================================================================================

/*
输入函数
由用户输入一个完整的数独
如果合法则取代原showsudokutable，否则指出错误并保持原状
*/
void SudokuInfo::input(void) {
	int temp[9][9] = { 0 };
	int statetemp[9][9] = { 0 };

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);
	
	sudokuCopy(showsudokutable, temp);
	sudokuCopy(startstatetable, statetemp);

	sudoku.allclear(7, 0);

	ifinputaccept = true;
	BK_NumBlock_Paint();
	BK_Input_Paint();
	sudoku.showsudokuPage();

	numberCount = 0;
	numberofwrongs = 0;
	memset(wrongState, 0, 81 * sizeof(int));

	while (1) {
		if (!sudoku.inputupdate()) {
			break;
		}
	}
	
	if (!ifinputaccept) {
		sudokuCopy(temp, showsudokutable);
		sudokuCopy(statetemp, startstatetable);
	}

	//if(!ifDigsudoku) sudoku.Dlx_solve();
	//else sudoku.solve();

	FlushMouseMsgBuffer();

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);
	BK_NumBlock_Paint();
	BK_Button_Paint(RGB(39, 64, 139));
	sudoku.showsudokuPage();

	return;
}

//数独生成模块=====================================================================================

/*
随机生成数独表的第 row 行
*/
void SudokuInfo::row_random(int row) {
	int rowtable[9] = { 1,2,3,4,5,6,7,8,9 };  //原始行模板
	int temp = 0, rdmnumber;
	srand((unsigned)time(NULL));

	///*
	for (int i = 0; i <= 8; i++) {
		rdmnumber = random(0, 8);
		temp = rowtable[i];
		rowtable[i] = rowtable[rdmnumber];
		rowtable[rdmnumber] = temp;
	}
	//*/
	
	for (int i = 0; i <= 8; i++) {
		showsudokutable[row][i] = rowtable[i];
	}
}


/*
挖空函数：在生成好的数独方阵中随机挖空(0替换)
difficulty = 3; 2; 1
挖去55-60; 45-50; 35-40;
*/
void SudokuInfo::Holedigging(int difficulty) {
	
	int temp = difficulty * 10 + 15, numberofHoles;
	int x, y;

	allclear(4, 1);
	srand((unsigned)time(NULL));
	numberofHoles = random(temp, temp + 5);
	srand((unsigned)time(NULL));
	for (int i = 1; i <= numberofHoles; i++) {
		x = random(0, 27);
		y = random(0, 27);
		x %= 9;
		y %= 9;
		if (showsudokutable[x][y]) {
			showsudokutable[x][y] = 0;
			startstatetable[x][y] = 0;
		}
		else {
			i--;
			continue;
		}
	}
	return;
}


/*
随机生成主函数
1.随机生成一行的元素
2.以该行元素为模板求解数独
3.随机挖空，保存至输出
*/
void SudokuInfo::generate(void) {

	allclear(7, 0);
	row_random(0);

	if(!ifDigsudoku) sudoku.Dlx_solve();  //求解数独
	else sudoku.solve();

	sudokuCopy(solutiontable[0], showsudokutable);  //复制解
	//ifneedsolve = false;  //此后不需要解了

	Holedigging(DIFFICLUTY);  //该函数的参数为难度

	return;
}

/*
清空当前的已输入部分
*/
void SudokuInfo::reset(void) {

	for (int i = 0; i <= 8; i++) {
		for (int j = 0; j <= 8; j++) {
			if (!startstatetable[i][j]) showsudokutable[i][j] = 0;
		}
	}

	//sudoku.solve();

	BK_NumBlock_Paint();
	showsudokuPage();
}




//数独求解模块====================================================================================================

/*
找空函数
在showsudokutable中返回第row行开始第一个为空的坐标 0~8
*/
bool SudokuInfo::findnextEmpty(int row, int *nextRow, int *nextCol) {
	for (int i = row; i <= 8; i++) {
		for (int j = 0; j <= 8; j++) {
			if (!showsudokutable[i][j]) {
				*nextRow = i;
				*nextCol = j;
				return true;
			}
		}
	}
	return false;
}

/*
求解函数
从第row行第col列开始逐空求解数独
并将解存储到showsudokutable中
*/
bool SudokuInfo::solvesudoku(int row, int col) {
	int number = 0;
	int nextRow, nextCol;

	if (row == -1 && col == -1) return false; //停止求解

solvestart:

	while (1) {
		number++;
		if (number >= 10) break;

		if (!IfFitCheck(row, col, number, false)) {
			goto solvestart;
		}

		showsudokutable[row][col] = number;

		if (!findnextEmpty(row, &nextRow, &nextCol)) {
			return true;  //表示数独求解完成，无剩余空位
		}

		if (!solvesudoku(nextRow, nextCol)) {  //下一个位置无解
			showsudokutable[row][col] = 0;
			continue;
		}
		else {
			return true;
		}
	}
	return false; //所有数字都填不进去
}

/*
搜索优化算法:基于当前可以填入的数字进行优化求解
启发式搜索代码优化
*/
bool SudokuInfo::New_solve(int row, int col) {

	int number = 0;
	int nextRow = 0, nextCol = 0;

	for (int s = 0; s < availableCount[row][col]; s++) {
		if (!IfFitCheck(row, col, availableNumbers[row][col][s], false)) {
			continue;  //如果填不进去就填下一个
		}
		showsudokutable[row][col] = availableNumbers[row][col][s];

		if (!findnextEmpty(row, &nextRow, &nextCol)) {
			return true;  //表示数独求解完成，无剩余空位
		}

		//开始修正available统计
		memset(availableNumbers, 0, 729 * sizeof(int));
		memset(availableCount, 0, 81 * sizeof(int));

		for (int i = 0; i <= 8; i++) {	//进行评估
			for (int j = 0; j <= 8; j++) {
				for (int n = 1; n <= 9; n++) {
					if (IfFitCheck(i, j, n, false)) {  //记录该处可以填的数
						availableNumbers[i][j][availableCount[i][j]++] = n;

						if (minAvailable > availableCount[i][j]) {
							minAvailable = availableCount[i][j];
							min_row = i;
							min_col = j;
						}
					}
				}
			}
		}

		if (!solvesudoku(nextRow, nextCol)) {  //下一个位置无解
			showsudokutable[row][col] = 0;
			continue;
		}
		else {
			return true;
		}

	}

	return false;
}

/*
求解模块封装函数
可以直接求解当前的showsudokutable，并且将结果存入solutiontable[0]
*/
bool SudokuInfo::solve(void) {
	int row = -1, col = -1;  //初始化行列
	int temp = 0;
	int tempsudokutable[9][9] = { 0 };
	//allclear(2, 0);

	for (int i = 0; i <= 8; i++) {  //优化部分
		for (int j = 0; j <= 8; j++) {
			for (int n = 1; n <= 9; n++) {
				if (IfFitCheck(i, j, n, false)) {  //记录该处可以填的数
					availableNumbers[i][j][availableCount[i][j]++] = n;

					if (minAvailable > availableCount[i][j]) {
						minAvailable = availableCount[i][j];
						min_row = i;
						min_col = j;
					}
				}
			}
		}
	}

	for (int i = 0; i <= 8; i++) {
		for (int j = 0; j <= 8; j++) {
			if (!IfFitCheck(i, j, showsudokutable[i][j], false)) return false;
		}
	}

	sudokuCopy(showsudokutable, tempsudokutable);

	//New_solve(min_row, min_col);  

	//启发式求解
	
	findnextEmpty(0, &row, &col); 
	solvesudoku(row, col); //传统求解

	if (findnextEmpty(0, &row, &col)) {
		sudokuCopy(tempsudokutable, showsudokutable);
		return false;
	}

	sudokuCopy(showsudokutable, solutiontable[0]);  //保存解
	sudokuCopy(tempsudokutable, showsudokutable);
	return true;
}

//数独提示模块===============================================================================================================

void SudokuInfo::hint(void) {

	int col = 0, row = 0;

	bool ifs = ifDigsudoku ? sudoku.solve() : sudoku.Dlx_solve();

	if (!ifs) {
		HWND wnd = GetHWnd();
		MessageBox(wnd, "当前数独无解.", "数独", MB_OK | MB_ICONWARNING);
		return;
	}
	
	if (!findnextEmpty(0, &row, &col)) {//找到下一个为空的位置
		HWND wnd = GetHWnd();
		MessageBox(wnd, "求解完成.", "数独", MB_OK | MB_ICONINFORMATION);
		return;
	}

	int i = col, j = row, bi = col / 3, bj = row / 3;
	showsudokutable[row][col] = solutiontable[0][row][col];

	setlinecolor(RGB(240, 255, 255)); //规定边框色
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
	setfillcolor(RGB(65, 105, 225));  //规定填充色
	setfillstyle(BS_SOLID); //设置填充样式


	fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
		NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

	settextstyle(40, 0, _T("Consolas")); //设置字体
	setbkmode(TRANSPARENT);  //设置背景透明

	settextcolor(RGB(255, 106, 106));  //字体设为绿色

	RECT r = { NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		   NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
		   NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		   NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE };  //确定输出方格

	drawtext(showsudokutable[row][col] + 48, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	Sleep(350);

	setlinecolor(RGB(240, 255, 255)); //规定边框色
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //规定外边框线形
	setfillcolor(RGB(65, 105, 225));  //规定填充色
	setfillstyle(BS_SOLID); //设置填充样式


	fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
		NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

	settextstyle(40, 0, _T("Consolas")); //设置字体
	setbkmode(TRANSPARENT);  //设置背景透明

	settextcolor(RGB(255, 255, 255));  //字体设为白色

	drawtext(showsudokutable[row][col] + 48, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}

//数独存储与读取模块===============================================================================================================

void SudokuInfo::save(void) {

	time_t t;

	char savename[40];
	char backname[20] = ".txt";
	char nowtime[20];

	LPTSTR s = new char[20];
	InputBox(s, 20, (LPCTSTR)"请输入存档名\n(不超过10个字)\n(仅限字母与数字)", (LPCTSTR)"保存数独");

	time(&t);
	
	strcpy(savename, (char *)s);
	strftime(nowtime, sizeof(nowtime), "%Y-%m-%d-%H-%M-%S", localtime(&t));
	strcat(savename, "-");
	strcat(savename, nowtime);
	strcat(savename, backname);

	HWND wnd = GetHWnd();
	MessageBox(wnd, "    保存成功    ", "保存数独", MB_OK | MB_ICONINFORMATION);


	FILE *fp = fopen("name.txt", "a+"); //指向文件名的文件指针
	if (fp == NULL) {
		fp = fopen("name.txt", "w+");
		if (fp == NULL) {
			HWND wnd = GetHWnd();
			MessageBox(wnd, "Cannot save the name.", "Save sudoku", MB_OK | MB_ICONWARNING);

		}
	}

	fprintf(fp, "%s", savename);
	fprintf(fp, "\n");
	fclose(fp);

	FILE *fnewsave = fopen(savename, "w+");  //指向待写入数独的文件指针
	if (fnewsave == NULL) {
		HWND wnd = GetHWnd();
		MessageBox(wnd, "Cannot make a new save.", "Save sudoku", MB_OK | MB_ICONWARNING);

	}

	for (int i = 0; i <= 8; i++) {
		for (int j = 0; j <= 8; j++) {
			fprintf(fnewsave, "%d ", showsudokutable[i][j]);
		}
		fprintf(fnewsave, "\n");
	}
	fclose(fnewsave);

}

void SudokuInfo::load(void) {  //读取存档界面
	
	Loadsaves();
	page = 0;
	sudoku.LoadChoose(page);

	FlushMouseMsgBuffer();
	while (1) {
		if (!sudoku.loadupdate()) break;
	}

	FlushMouseMsgBuffer();

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);
	BK_NumBlock_Paint();
	BK_Button_Paint(RGB(39, 64, 139));
	sudoku.showsudokuPage();
}

void SudokuInfo::readsave(int input) {  //读入第input个数独,之前需要读入存档表 0 <= input <= 19


	FILE *fp = fopen(savedfiles[input], "r+");

	if (fp == NULL) {
		printf("Cannot open this sudoku!\n");
	}

	sudoku.allclear(7, 0);
	//ifneedsolve = true;

	for (int i = 0; i <= 8; i++) {
		for (int j = 0; j <= 8; j++) {
			fscanf(fp, "%d", &showsudokutable[i][j]);
			if (showsudokutable[i][j] < 0 || showsudokutable[i][j] > 9) showsudokutable[i][j] = 0;
			if (showsudokutable[i][j]) startstatetable[i][j] = 1;
		}
	}
	if (!ifDigsudoku) sudoku.Dlx_solve();
	else sudoku.solve();

	fclose(fp);

}

//设置模块=======================================================================================================

void SudokuInfo::settings(void) {

	BK_Settings_Paint();

	FlushMouseMsgBuffer();
	while (1) {
		if (!sudoku.settingupdate()) break;
	}

	FlushMouseMsgBuffer();

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);
	BK_NumBlock_Paint();
	BK_Button_Paint(RGB(39, 64, 139));
	sudoku.showsudokuPage();

}

void SudokuInfo::help(void) {

	BK_Help_Paint();

	FlushMouseMsgBuffer();
	while (1) {
		if (!sudoku.helpupdate()) break;
	}

	FlushMouseMsgBuffer();

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);
	BK_Settings_Paint();
}

void SudokuInfo::sudokuChoose(void) {

	BK_SudokuChoose_Paint();

	FlushMouseMsgBuffer();
	while (1) {
		if (!sudoku.sudokuSetupdate()) break;
		Sleep(10);
	}

	FlushMouseMsgBuffer();

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);
	BK_Settings_Paint();
}


//==============================================================================================================
//主函数部分
//==============================================================================================================

int main() {
	MOUSEMSG *mouse = new MOUSEMSG;

	sudoku.allclear(7, 0);

	//初始化游戏窗口
	initgraph(STARTWID, STARTHEI);
	HWND hWnd = GetHWnd();
	SetWindowText(hWnd, "Sudoku");

	entersudoku();
	Sleep(3000);

	//画初始方格
	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);
	sudoku.generate();
	BK_NumBlock_Paint();
	BK_Button_Paint(RGB(39, 64, 139));

	
	//填数
	sudoku.showsudokuPage();

	FlushMouseMsgBuffer();  //主菜单
	while (1) {
		if (!sudoku.mainupdate()) break;
	}

	exitsudoku();
	Sleep(3000);
	closegraph();
	//Dlx();

	return 0;
}