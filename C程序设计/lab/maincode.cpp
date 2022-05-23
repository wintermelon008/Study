
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

int numberofNames = 0; //�浵��Ŀ
char savedfiles[MAX_SAVE][50] = { '\0' };  //��ǰ�Ĵ浵����
int page = 0;  //�浵��ȡҳ��

void sudokuCopy(int input1[][9], int input2[][9]);

void exitsudoku(void);  //�˳�����

void BK_NumBlock_Paint(void);

void BK_Button_Paint(COLORREF color);

void BK_Settings_Paint(void);

void BK_Input_Paint(void);

void BK_Help_Paint(void);

void BK_SudokuChoose_Paint(void);

//��ť���ܺ�������====================================================================================================
void SudokuInfo::button_generate(void) {

	sudoku.generate();
	//����ʼ����
	BK_NumBlock_Paint();

	//����
	sudoku.showsudokuPage();
}

void SudokuInfo::button_solve(void) {
	int row = 0, col = 0;

	bool ifs = ifDigsudoku ? sudoku.solve() : sudoku.Dlx_solve();

	if (!ifs) {
		HWND wnd = GetHWnd();
		MessageBox(wnd, "��ǰ�����޽�!", "����", MB_OK | MB_ICONINFORMATION);
		return;
	}


	if (!findnextEmpty(0, &row, &col)) {//�ҵ���һ��Ϊ�յ�λ��
		HWND wnd = GetHWnd();
		MessageBox(wnd, "������.", "����", MB_OK | MB_ICONINFORMATION);
		return;
	}

	if (ifs) { //�ж��Ƿ��н�
		
		sudokuCopy(solutiontable[0], showsudokutable);
		//����ʼ����
		BK_NumBlock_Paint();

		//����
		sudoku.showsudokuPage();
	}

}


//ͼ�λ�������==========================================================================================================
/*
���ַ������
*/
void BK_NumBlock_Paint(void) {
	//��װ�����ֵķ���

	//�����Ǵ󷽸����=======================================================================================
	setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
	setfillcolor(RGB(65, 105, 225));  //�涨���ɫ
	setfillstyle(BS_SOLID); //���������ʽ

	//ѭ�����󷽸�
	for (int i = 0; i <= 2; i++) {
		for (int j = 0; j <= 2; j++) {
			//int bi = i / 3, bj = j / 3;
			fillrectangle(NUM_BASE_WID + 3 * i * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + 3 * j * BLOCK_SIZE + j * BLOCK_DISTANCE,
				NUM_BASE_WID + 3 * (i + 1) * BLOCK_SIZE + i * BLOCK_DISTANCE,
				NUM_BASE_HEI + 3 * (j + 1) * BLOCK_SIZE + j * BLOCK_DISTANCE);
		}
	}

	//������С�������=========================================================================================
	setlinecolor(RGB(240, 255, 255));  //������ɫ
	setlinestyle(PS_SOLID, 2);  //������ʽ

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

	//������logo����
	RECT r = { MAIN_LOGO_BASE_WID, MAIN_LOGO_BASE_HEI,MAIN_LOGO_BASE_WID + MAIN_BUT_WID, MAIN_LOGO_BASE_HEI + MAIN_BUT_HEI };
	//��������
	settextcolor(RGB(0, 191, 255));
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// �������Ч��Ϊ�����  
	f.lfWeight = 500;
	f.lfHeight = 50;
	strcpy(f.lfFaceName, _T("Calibri"));
	f.lfItalic = false;
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //���ñ���͸��

	drawtext("Sudoku", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

}

void BK_Button_Paint(COLORREF color) {

	//�����ǹ��ܰ�ť����======================================================================================
	setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
	setfillcolor(color);  //�涨���ɫ
	setfillstyle(BS_SOLID); //���������ʽ

	settextcolor(RGB(191, 239, 255));  //������ɫ
	//��������
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// �������Ч��Ϊ�����  
	f.lfWeight = 500;
	f.lfHeight = 18;
	strcpy(f.lfFaceName, _T("����"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //���ñ���͸��

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
�������ò˵��ĺ���
*/
void BK_Settings_Paint(void) {
	RECT r;

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);  //����ͼƬ

	setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
	setfillcolor(RGB(39, 64, 139));  //�涨���ɫ
	setfillstyle(BS_SOLID); //���������ʽ

	settextcolor(RGB(191, 239, 255));  //������ɫ
	//��������
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// �������Ч��Ϊ�����  
	f.lfWeight = 500;
	f.lfHeight = 20;
	strcpy(f.lfFaceName, _T("����"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //���ñ���͸��

	f.lfHeight = 20;
	settextstyle(&f);

	for (int i = 0; i < NUMBER_OF_SETTING_BUTTON; i++) {  //��ť����
		fillrectangle(SETTING_BUT_BASE_WID, SETTING_BUT_BASE_HEI + i * (SETTING_BUT_HEI + SETTING_BUT_DISTANCE),
					  SETTING_BUT_BASE_WID + SETTING_BUT_WID,
					  SETTING_BUT_BASE_HEI + (i + 1) * SETTING_BUT_HEI + i * SETTING_BUT_DISTANCE);

		r = { SETTING_BUT_BASE_WID, SETTING_BUT_BASE_HEI + i * (SETTING_BUT_HEI + SETTING_BUT_DISTANCE),
			  SETTING_BUT_BASE_WID + SETTING_BUT_WID,
			  SETTING_BUT_BASE_HEI + (i + 1) * SETTING_BUT_HEI + i * SETTING_BUT_DISTANCE };
		drawtext(setting_buttonwords[i], &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	}

	fillrectangle(INPUT_BUT_BACKBUT_BASE_WID, INPUT_BUT_BACKBUT_BASE_HEI,
		INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID, INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI);  //���ذ�ť����
	r = { INPUT_BUT_BACKBUT_BASE_WID, INPUT_BUT_BACKBUT_BASE_HEI,
				 INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID, INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI };
	drawtext("���˵�", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	f.lfHeight = 40;
	settextstyle(&f);

	r = {SETTING_MENU_BASE_WID, SETTING_MENU_BASE_HEI, 
		SETTING_MENU_BASE_WID + SETTING_MENU_WID,  SETTING_MENU_BASE_HEI + SETTING_MENU_HEI };
	drawtext("��Ϸ���������", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}


/*
���ư����˵��ĺ���
*/
void BK_Help_Paint(void) {

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);  //����ͼƬ

	setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
	setfillcolor(RGB(39, 64, 139));  //�涨���ɫ
	setfillstyle(BS_SOLID); //���������ʽ

	settextcolor(RGB(191, 239, 255));  //������ɫ
	//��������
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// �������Ч��Ϊ�����  
	f.lfWeight = 500;
	f.lfHeight = 20;
	strcpy(f.lfFaceName, _T("����"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //���ñ���͸��

	fillrectangle(HELP_BACK_BUT_BASE_WID, HELP_BACK_BUT_BASE_HEI,
		HELP_BACK_BUT_BASE_WID + HELP_BACK_BUT_WID, HELP_BACK_BUT_BASE_HEI + HELP_BACK_BUT_HEI);

	RECT r = { HELP_BACK_BUT_BASE_WID, HELP_BACK_BUT_BASE_HEI,
			  HELP_BACK_BUT_BASE_WID + HELP_BACK_BUT_WID, HELP_BACK_BUT_BASE_HEI + HELP_BACK_BUT_HEI };
	drawtext("����", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	f.lfHeight = 22;
	f.lfOutPrecision = true;
	settextcolor(RGB(0 ,255 ,127));
	settextstyle(&f);

	for (int i = 0; i < NUMBER_OF_MAIN_BUTTON; i++) {  //���ƽ����ı�

		r = { HELP_WORD_BASE_WID,
			  HELP_WORD_BASE_HEI + i * (HELP_WORD_HEI + HELP_WORD_DISTANCE),
			  HELP_WORD_BASE_WID + 1 * HELP_WORD_WID,
			  HELP_WORD_BASE_HEI + (i + 1) * HELP_WORD_HEI + i * HELP_WORD_DISTANCE };
		drawtext(help_words[i], &r, DT_LEFT | DT_VCENTER | DT_SINGLELINE);

	}

	settextcolor(RGB(191, 239, 255));  //������ɫ
	f.lfHeight = 40;
	settextstyle(&f);

	r = { HELP_MENU_BASE_WID, HELP_MENU_BASE_HEI,
		HELP_MENU_BASE_WID + HELP_MENU_WID, HELP_MENU_BASE_HEI + HELP_MENU_HEI };
	drawtext("��ť����˵��", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}

/*
����ģʽѡ��˵��ĺ���
*/
void BK_SudokuChoose_Paint(void) {
	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);  //����ͼƬ

	setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
	setfillcolor(RGB(39, 64, 139));  //�涨���ɫ
	setfillstyle(BS_SOLID); //���������ʽ

	settextcolor(RGB(191, 239, 255));  //������ɫ
	//��������
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// �������Ч��Ϊ�����  
	f.lfWeight = 500;
	f.lfHeight = 20;
	strcpy(f.lfFaceName, _T("����"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //���ñ���͸��

	fillrectangle(MOD_BACK_BUT_BASE_WID, MOD_BACK_BUT_BASE_HEI,
		MOD_BACK_BUT_BASE_WID + MOD_BACK_BUT_WID, MOD_BACK_BUT_BASE_HEI + MOD_BACK_BUT_HEI);

	RECT r = { MOD_BACK_BUT_BASE_WID, MOD_BACK_BUT_BASE_HEI,
		MOD_BACK_BUT_BASE_WID + MOD_BACK_BUT_WID, MOD_BACK_BUT_BASE_HEI + MOD_BACK_BUT_HEI };
	drawtext("����", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);


	settextcolor(RGB(191, 239, 255));  //������ɫ
	f.lfHeight = 40;
	settextstyle(&f);

	r = { MOD_MENU_BASE_WID, MOD_MENU_BASE_HEI,
		MOD_MENU_BASE_WID + MOD_MENU_WID, MOD_MENU_BASE_HEI + MOD_MENU_HEI };
	drawtext("����ģʽ����", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);


}


/*
��������˵��ĺ���
*/
void BK_Input_Paint(void)  {

	setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
	setfillcolor(RGB(39, 64, 139));  //�涨���ɫ
	setfillstyle(BS_SOLID); //���������ʽ

	settextcolor(RGB(191, 239, 255));  //������ɫ
	//��������
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// �������Ч��Ϊ�����  
	f.lfWeight = 500;
	f.lfHeight = 20;
	strcpy(f.lfFaceName, _T("����"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //���ñ���͸��

	fillrectangle(INPUT_BUT_BACKBUT_BASE_WID, INPUT_BUT_BACKBUT_BASE_HEI,
				 INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID, INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI);  //���ذ�ť����
	RECT r = { INPUT_BUT_BACKBUT_BASE_WID, INPUT_BUT_BACKBUT_BASE_HEI,
				 INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID, INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI };
	drawtext("���˵�", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}

/*
���Ƽ��ز˵��ĺ���
*/
void Loadsaves(void) {
	
	FILE *fnames = fopen("name.txt", "a+");
	int i = 0; //��¼�ļ�����Ŀ

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


void  SudokuInfo::LoadChoose(int page) {  //�浵�����л�

	RECT r;

	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);  //����ͼƬ

	setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
	setfillcolor(RGB(39, 64, 139));  //�涨���ɫ
	setfillstyle(BS_SOLID); //���������ʽ

	settextcolor(RGB(191, 239, 255));  //������ɫ
	//��������
	LOGFONT f;
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// �������Ч��Ϊ�����  
	f.lfWeight = 500;
	f.lfHeight = 20;
	strcpy(f.lfFaceName, _T("����"));
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //���ñ���͸��

	for (int i = 0; i <= 4; i++) {  //��������浵��ť
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
		LOAD_BACKBUT_BASE_WID + LOAD_BACKBUT_WID, LOAD_BACKBUT_BASE_HEI + LOAD_BAVKBUT_HEI);  //���ذ�ť����
	r = { LOAD_BACKBUT_BASE_WID, LOAD_BACKBUT_BASE_HEI,
				  LOAD_BACKBUT_BASE_WID + LOAD_BACKBUT_WID, LOAD_BACKBUT_BASE_HEI + LOAD_BAVKBUT_HEI };
	drawtext("���˵�", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	if (page == 0) {
		setfillcolor(RGB(105, 105, 105));  //�涨���ɫ
	}
	else {
		setfillcolor(RGB(39, 64, 139));  //�涨���ɫ
	}
	fillrectangle(LAST_PAGE_BASE_WID, LAST_PAGE_BASE_HEI, LAST_PAGE_BASE_WID + LAST_PAGE_WID, LAST_PAGE_BASE_HEI + LAST_PAGE_HEI);

	r = { LAST_PAGE_BASE_WID, LAST_PAGE_BASE_HEI, LAST_PAGE_BASE_WID + LAST_PAGE_WID, LAST_PAGE_BASE_HEI + LAST_PAGE_HEI };
	drawtext("��һҳ", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	if (page == 3) {
		setfillcolor(RGB(105, 105, 105));  //�涨���ɫ
	}
	else {
		setfillcolor(RGB(39, 64, 139));  //�涨���ɫ
	}
	fillrectangle(NEXT_PAGE_BASE_WID, NEXT_PAGE_BASE_HEI, NEXT_PAGE_BASE_WID + NEXT_PAGE_WID, NEXT_PAGE_BASE_HEI + NEXT_PAGE_HEI);

	r = { NEXT_PAGE_BASE_WID, NEXT_PAGE_BASE_HEI, NEXT_PAGE_BASE_WID + NEXT_PAGE_WID, NEXT_PAGE_BASE_HEI + NEXT_PAGE_HEI };
	drawtext("��һҳ", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	//������ֻ���
	settextcolor(RGB(224, 255, 255));
	gettextstyle(&f);
	f.lfQuality = ANTIALIASED_QUALITY;		// �������Ч��Ϊ�����  
	f.lfWeight = 500;
	f.lfHeight = 30;
	strcpy(f.lfFaceName, _T("Calibri"));
	f.lfItalic = false;
	settextstyle(&f);

	f.lfHeight = 40;
	settextstyle(&f);
	r = { LOAD_MENU_BASE_WID, LOAD_MENU_BASE_HEI, LOAD_MENU_BASE_WID + LOAD_MENU_WID, LOAD_MENU_BASE_HEI + LOAD_MENU_HEI };
	drawtext("�浵ѡ��", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	f.lfHeight = 20;
	settextstyle(&f);
	r = { LOAD_PAGE_BASE_WID, LOAD_PAGE_BASE_HEI, LOAD_PAGE_BASE_WID + LOAD_PAGE_WID, LOAD_PAGE_BASE_HEI + LOAD_PAGE_HEI };

	char output[40] = { "Page: " }, pagenum[3] = { '\0' };
	pagenum[0] = page + 49;
	strcat(output, pagenum);
	drawtext(output, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

}


/*
������ʾ����
�������������ǰ������
*/
void SudokuInfo::showsudokuPage(void) {  //�������������ǰ������
	int bi = 0, bj = 0;

	settextstyle(40, 0, _T("Consolas")); //��������
	setbkmode(TRANSPARENT);  //���ñ���͸��
	for (int i = 0; i <= 8; i++) {
		for (int j = 0; j <= 8; j++) {
			bi = i / 3;
			bj = j / 3;

			settextcolor(RGB(255, 255, 255));  //������Ϊ��ɫ

			if (startstatetable[i][j]) {
				settextcolor(RGB(151, 255, 255));
			}

			RECT r = { NUM_BASE_WID + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
					   NUM_BASE_HEI + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
					   NUM_BASE_WID + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE,
					   NUM_BASE_HEI + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE };  //ȷ���������

			drawtext(showsudokutable[i][j] + 48, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		}
	}
}

int numberChoose(void) {  //ѡ������,����ѡ����

	LPTSTR s = new char[10];
	InputBox(s, 10, (LPCTSTR)"��������Ҫ�������\n��Χ��1��9", (LPCTSTR)"��������");
	int r = _wtoi((wchar_t *)s);
	if (r >= 10 || r <= 0) r = 0;

	return r;
}

//ÿһ֡���º���================================================================================================

bool SudokuInfo::mainupdate()  // ������ÿ֡����
{
	MOUSEMSG m;

	if (MouseHit()) {
		m = GetMouseMsg();

		if (m.uMsg == WM_RBUTTONDOWN) {  //�Ҽ�Ϊ����
			int bi = 0, bj = 0;
			for (int i = 0; i <= 8; i++) {
				for (int j = 0; j <= 8; j++) {
					bi = i / 3;
					bj = j / 3;

					//ȷ������ķ���
					if (m.x >= NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.x <= NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.y >= NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE &&
						m.y <= NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE) {

						if (!startstatetable[j][i]) { //�жϸô��ǲ���ԭʼ����

							setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
							setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
							setfillcolor(RGB(65, 105, 225));  //�涨���ɫ
							setfillstyle(BS_SOLID); //���������ʽ

							fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
								NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

							settextstyle(40, 0, _T("Consolas")); //��������
							settextcolor(RGB(255, 255, 255));  //������Ϊ��ɫ
							setbkmode(TRANSPARENT);  //���ñ���͸��

							RECT r = { NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
							   NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
							   NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
							   NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE };  //ȷ���������

							drawtext(48, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
							showsudokutable[j][i] = 0;
						}


					}

				}
			}


		}


		if (m.uMsg == WM_LBUTTONDOWN) {
			int bi = 0, bj = 0;

			//�ж��Ƿ���ڰ�ť��
			for (int i = 0; i < NUMBER_OF_MAIN_BUTTON; i++) {
				if (m.x >= MAIN_BUT_BASE_WID && m.x <= MAIN_BUT_BASE_WID + MAIN_BUT_WID &&
					m.y >= MAIN_BUT_BASE_HEI + i * MAIN_BUT_HEI + i * MAIN_BUT_DISTANCE &&
					m.y <= MAIN_BUT_BASE_HEI + (i + 1) * MAIN_BUT_HEI + i * MAIN_BUT_DISTANCE) {

					if (i != NUMBER_OF_MAIN_BUTTON - 1) (this->*main_button[i])();  //��exit��ť�ж�
					else {
						return false;
					}
				}
			}

			//SETTING_BUT_BASE_WID, SETTING_BUT_BASE_HEI,
			//SETTING_BUT_BASE_WID + SETTING_BUT_WID, SETTING_BUT_BASE_HEI + SETTING_BUT_HEI
			if (m.x >= TOSETTING_BUT_BASE_WID && m.x <= TOSETTING_BUT_BASE_WID + TOSETTING_BUT_WID &&
				m.y >= TOSETTING_BUT_BASE_HEI && m.y <= TOSETTING_BUT_BASE_HEI + TOSETTING_BUT_HEI) {  //�ж��Ƿ�Ϊ���ð�ť

				sudoku.settings();
			}

			//�ж��Ƿ���ڷ��������������޸�����
			for (int i = 0; i <= 8; i++) {
				for (int j = 0; j <= 8; j++) {
					bi = i / 3;
					bj = j / 3;

					//ȷ������ķ���
					if (m.x >= NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.x <= NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.y >= NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE &&
						m.y <= NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE) {

						if (!startstatetable[j][i]) {  //�жϸô��ǲ���ԭʼ����
							int ans = numberChoose();

							showsudokutable[j][i] = ans;

							setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
							setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
							setfillcolor(RGB(65, 105, 225));  //�涨���ɫ
							setfillstyle(BS_SOLID); //���������ʽ


							fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
								NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

							settextstyle(40, 0, _T("Consolas")); //��������
							setbkmode(TRANSPARENT);  //���ñ���͸��

							settextcolor(RGB(255, 255, 255));  //������Ϊ��ɫ
							if (!sudoku.IfFitCheck(j, i, ans, false)) {  //�жϸ������Ƿ�Ϸ�
								settextcolor(RGB(255, 69, 0));  //������Ϊ��ɫ
								//sudoku.solve();
							}
							else {
								//sudoku.solve();
							}

							sudoku.solve();

							RECT r = { NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								   NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
								   NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								   NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE };  //ȷ���������

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

			//���ذ�ť�ж�

			if (m.x >= LOAD_BACKBUT_BASE_WID && m.x <= LOAD_BACKBUT_BASE_WID + LOAD_BACKBUT_WID &&
				m.y >= LOAD_BACKBUT_BASE_HEI && m.y <= LOAD_BACKBUT_BASE_HEI + LOAD_BAVKBUT_HEI) {

				return false;

			}

			for (int i = 0; i <= 4; i++) {  //�жϵ���浵��ť
				if (m.x >= LOAD_BUT_BASE_WID && m.x <= LOAD_BUT_BASE_WID + 1 * LOAD_BUT_WID &&
					m.y >= LOAD_BUT_BASE_HEI + i * (LOAD_BUT_HEI + LOAD_BUT_DISTANCE) &&
					m.y <= LOAD_BUT_BASE_HEI + (i + 1) * LOAD_BUT_HEI + i * LOAD_BUT_DISTANCE) {

					int saves = i + page * 4;
					if (saves <= numberofNames - 2) sudoku.readsave(i + page * 4);

					return false;
				}
			}

			if (m.x >= LAST_PAGE_BASE_WID && m.x <= LAST_PAGE_BASE_WID + NEXT_PAGE_WID &&
				m.y >= LAST_PAGE_BASE_HEI && m.y <= LAST_PAGE_BASE_HEI + NEXT_PAGE_HEI) {  //��һҳ��ť
				if (page > 0) page--;
				sudoku.LoadChoose(page);
				return true;
			}

			if (m.x >= NEXT_PAGE_BASE_WID && m.x <= NEXT_PAGE_BASE_WID + NEXT_PAGE_WID &&
				m.y >= NEXT_PAGE_BASE_HEI && m.y <= NEXT_PAGE_BASE_HEI + NEXT_PAGE_HEI) {  //��һҳ��ť
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

		if (m.uMsg == WM_LBUTTONDOWN) { //�ж����
			int bi = 0, bj = 0;

			//���ذ�ť�ж�

			//���ذ�ť�ж�
			if (m.x >= INPUT_BUT_BACKBUT_BASE_WID && m.x <= INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID &&
				m.y >= INPUT_BUT_BACKBUT_BASE_HEI && m.y <= INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI) {
				return false;
			}

			//�ж��Ƿ���ڰ�ť��
			for (int i = 0; i < NUMBER_OF_SETTING_BUTTON; i++) {
				if (m.x >= SETTING_BUT_BASE_WID && m.x <= SETTING_BUT_BASE_WID + SETTING_BUT_WID &&
					m.y >= SETTING_BUT_BASE_HEI + i * SETTING_BUT_HEI + i * SETTING_BUT_DISTANCE &&
					m.y <= SETTING_BUT_BASE_HEI + (i + 1) * SETTING_BUT_HEI + i * SETTING_BUT_DISTANCE) {

					(this->*setting_button[i])();  //��ť�ж�

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

		if (m.uMsg == WM_LBUTTONDOWN) { //�ж����
			int bi = 0, bj = 0;

			//���ذ�ť�ж�
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
	strcpy(f.lfFaceName, _T("����"));
	settextstyle(&f);

	MOUSEMSG m;

	if (!ifDigsudoku) setfillcolor(RGB(105, 105, 105));  //�涨���ɫ
	else setfillcolor(RGB(39, 64, 139));  //�涨���ɫ

	fillrectangle(MOD_BUT_BASE_WID, MOD_BUT_BASE_HEI,
		MOD_BUT_BASE_WID + MOD_BUT_WID, MOD_BUT_BASE_HEI + MOD_BUT_HEI);
	RECT r = { MOD_BUT_BASE_WID, MOD_BUT_BASE_HEI,
		MOD_BUT_BASE_WID + MOD_BUT_WID, MOD_BUT_BASE_HEI + MOD_BUT_HEI };
	drawtext("��ͨ����", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	if (ifDigsudoku) setfillcolor(RGB(105, 105, 105));  //�涨���ɫ
	else setfillcolor(RGB(39, 64, 139));  //�涨���ɫ

	fillrectangle(MOD_BUT_BASE_WID, MOD_BUT_BASE_HEI + MOD_BUT_HEI + MOD_BUT_DISTANCE,
		MOD_BUT_BASE_WID + MOD_BUT_WID, MOD_BUT_BASE_HEI + 2 * MOD_BUT_HEI + MOD_BUT_DISTANCE);
	r = { MOD_BUT_BASE_WID, MOD_BUT_BASE_HEI + MOD_BUT_HEI + MOD_BUT_DISTANCE,
		MOD_BUT_BASE_WID + MOD_BUT_WID , MOD_BUT_BASE_HEI + 2 * MOD_BUT_HEI + MOD_BUT_DISTANCE };
	drawtext("�Խ�������", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	//Sleep(50);

	if (MouseHit()) {
		m = GetMouseMsg();

		if (m.uMsg == WM_LBUTTONDOWN) { //�ж����
			int bi = 0, bj = 0;

			//���ذ�ť�ж�
			if (m.x >= MOD_BACK_BUT_BASE_WID && m.x <= MOD_BACK_BUT_BASE_WID + HELP_BACK_BUT_WID &&
				m.y >= MOD_BACK_BUT_BASE_HEI && m.y <= MOD_BACK_BUT_BASE_HEI + HELP_BACK_BUT_HEI) {
				return false;
			}

			//�Խ���������ť�ж�

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


		int tempsudoku[9][9] = { 0 };  //�ݴ�ԭʼ������
		sudokuCopy(showsudokutable, tempsudoku);  //�ճ�����������

		m = GetMouseMsg();

		if (m.uMsg == WM_RBUTTONDOWN) {  //�Ҽ�Ϊ����

			int bi = 0, bj = 0;
			for (int i = 0; i <= 8; i++) {
				for (int j = 0; j <= 8; j++) {
					bi = i / 3;
					bj = j / 3;

					//ȷ������ķ���
					if (m.x >= NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.x <= NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.y >= NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE &&
						m.y <= NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE) {

						if (1) {

							setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
							setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
							setfillcolor(RGB(65, 105, 225));  //�涨���ɫ
							setfillstyle(BS_SOLID); //���������ʽ

							fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
								NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

							settextstyle(40, 0, _T("Consolas")); //��������
							settextcolor(RGB(255, 255, 255));  //������Ϊ��ɫ
							setbkmode(TRANSPARENT);  //���ñ���͸��

							RECT r = { NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
							   NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
							   NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
							   NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE };  //ȷ���������

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

			//���ذ�ť�ж�
			if (m.x >= INPUT_BUT_BACKBUT_BASE_WID && m.x <= INPUT_BUT_BACKBUT_BASE_WID + INPUT_BUT_BACKBUT_WID &&
				m.y >= INPUT_BUT_BACKBUT_BASE_HEI && m.y <= INPUT_BUT_BACKBUT_BASE_HEI + INPUT_BUT_BAVKBUT_HEI) {

				if (!numberofwrongs && ifnumberEnough) ifinputaccept = true;  //����ж�Ҫ����ȷ����ť����
				else ifinputaccept = false;


				return false;
			}

			for (int i = 0; i <= 8; i++) {
				for (int j = 0; j <= 8; j++) {
					int bi = i / 3;
					int bj = j / 3;

					//ȷ������ķ���
					if (m.x >= NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.x <= NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE &&
						m.y >= NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE &&
						m.y <= NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE) {

						if (1) {  //�жϸô��ǲ���ԭʼ����
							int ans = numberChoose();

							setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
							setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
							setfillcolor(RGB(65, 105, 225));  //�涨���ɫ
							setfillstyle(BS_SOLID); //���������ʽ


							fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
								NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
								NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

							settextstyle(40, 0, _T("Consolas")); //��������
							setbkmode(TRANSPARENT);  //���ñ���͸��

							settextcolor(RGB(255, 255, 255));  //������Ϊ��ɫ
							if (!sudoku.IfFitCheck(j, i, ans, false)) {  //�жϸ������Ƿ�Ϸ�
								settextcolor(RGB(255, 69, 0));  //������Ϊ��ɫ

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
								   NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE };  //ȷ���������

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
������ʼ����
*/
void entersudoku(void) {
	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);

	//��������
	settextcolor(RGB(0, 191, 255));
	LOGFONT f;
	gettextstyle(&f);
	f.lfWeight = 500;
	f.lfHeight = 70;
	strcpy(f.lfFaceName, _T("Calibri"));
	f.lfItalic = true;
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //���ñ���͸��

	RECT r = { EXIT_BASE_WID, EXIT_BASE_HEI, EXIT_BASE_WID + EXIT_WID, EXIT_BASE_HEI + EXIT_BASE_HEI };

	drawtext("Welcome to my Sudoku world!", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	//��������
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
�˳���������
*/
void exitsudoku(void) {  
	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);

	//��������
	settextcolor(RGB(0 ,191 ,255));
	LOGFONT f;
	gettextstyle(&f);
	f.lfWeight = 500;
	f.lfHeight = 50;
	strcpy(f.lfFaceName, _T("Calibri"));
	f.lfItalic = false;
	settextstyle(&f);

	setbkmode(TRANSPARENT);  //���ñ���͸��

	RECT r = { EXIT_BASE_WID, EXIT_BASE_HEI, EXIT_BASE_WID + EXIT_WID, EXIT_BASE_HEI + EXIT_BASE_HEI };

	drawtext("Thanks for your playing!", &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	//��������
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
//��ӵ��ú���ϸ�ڲ���
//=====================================================================================================

//DLX�㷨=======================================================================================================

struct Node {
	Node *up, *down, *left, *right, *colRoot, *rowRoot;//���������ĸ�ָ���Լ�ָ�����ж����ָ��
	int Num;//�ж�������,��¼����
	int Size;//�ж�������,��¼����Ԫ����
	Node(int i = -1) : Num(i), Size(0) {};//���캯��
};

class DLX {
public:
	DLX(vector<vector<int> > &matrix, int m, int n);
	~DLX() { delete Head; };//�����е���д
	void init();
	void link(vector<vector<int> > &matrix);
	void cover(Node *cRoot);
	void recover(Node *cRoot);
	bool Search(int k = 0);
	vector<int> getResult() const { return result; }
	int getUpdates() const { return _updates; }
private:
	Node *Head;
	vector<int> result;//������������
	int _row, _col, _updates;//��¼������,���´���
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
	for (int ix = 0; ix < _col; ++ix)//��ͷλ��������,�����ж���
	{
		newNode = new Node;
		newNode->up = newNode;
		newNode->down = newNode;
		newNode->right = Head->right;
		newNode->left = Head;
		newNode->right->left = newNode;
		Head->right = newNode;
	}
	for (int ix = 0; ix < _row; ++ix)//��ͷλ�����²���,�����ж���
	{
		newNode = new Node(_row - ix);//ע�������_row-ix
		newNode->down = Head->down;
		newNode->up = Head;
		newNode->down->up = newNode;
		Head->down = newNode;
	}
}

void DLX::link(vector<vector<int> > &matrix)
{
	Node *current_row, *current_col, *newNode, *current;//��ǰ�ж���,��ǰ�ж���,�½ڵ�,��ǰ�ڵ�
	current_row = Head;
	for (int row = 0; row < _row; ++row)
	{
		current_row = current_row->down;
		current_col = Head;
		for (int col = 0; col < _col; ++col)
		{
			current_col = current_col->right;

			if (matrix[row][col] == 0)//������Ϊ0��λ�ò����ýڵ�
				continue;

			newNode = new Node;

			newNode->colRoot = current_col;
			newNode->rowRoot = current_row;//���õ�ǰ�ڵ��Ӧ�����ж���

			newNode->down = current_col;
			newNode->up = current_col->up;
			newNode->up->down = newNode;
			current_col->up = newNode;//���ӵ�ǰ�ڵ㵽��˫����β��

			if (current_row->Size == 0)//��˫������Ӧ�ð��ж����������
			{
				current_row->right = newNode;
				newNode->left = newNode;
				newNode->right = newNode;
				current_row->Size++;
			}
			current = current_row->right;//���õ�ǰ�ڵ�(���ж����ҵĽڵ�)
			newNode->left = current->left;
			newNode->right = current;
			newNode->left->right = newNode;
			current->left = newNode;//���ӵ�ǰ�ڵ㵽��˫����β��

			current_col->Size++;
		}
	}
}

void DLX::cover(Node *cRoot)//������
{
	++_updates;
	cRoot->left->right = cRoot->right;
	cRoot->right->left = cRoot->left;//ɾ�����ж���
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

void DLX::recover(Node *cRoot)//�����㷨�ľ���!!
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
	if (Head->right == Head)//����,��ɹ��ҵ�һ���еļ���
		return true;

	Node *cRoot = new Node, *c;
	int minSize = INT_MAX;
	for (c = Head->right; c != Head; c = c->right)//������������ѡ���ж���
	{
		if (c->Size < minSize)
		{
			minSize = c->Size;
			cRoot = c;
			if (minSize == 1)
				break;
			if (minSize == 0)//��һ��Ϊ��,ʧ��
				return false;
		}
	}
	cover(cRoot);

	Node *current_row, *current;
	for (current_row = cRoot->down; current_row != cRoot; current_row = current_row->down)
	{
		result.push_back(current_row->rowRoot->Num);//�����м���result��
		for (current = current_row->right; current != current_row; current = current->right)
		{
			cover(current->colRoot);
		}
		if (Search(k + 1))
			return true;
		for (current = current_row->left; current != current_row; current = current->left)
			recover(current->colRoot);
		result.pop_back();//���ָ��в�����Ҫ��,��ԭresult
	}
	recover(cRoot);
	return false;
}

vector<vector<int> > sudoku2matrix(string &problem)//������ת��Ϊ01����
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

vector<int> matrix2sudoku(vector<vector<int> > &matrix, vector<int> result)//��01������Ϊ����
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
		cout << "�������޽�!\n\n";
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


//ͨ�ù����Ժ�����
//=======================================================================================================================


/*
���������
��Χ�� min �� max ֮���������
*/
int random(int min, int max) {
	int t;
	t = rand() % (max - min) + min;
	return t;
}

/*
�����ƺ���
��input 1���ݸ��Ƶ�input 2֮��
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
���������ʼ������,��ʼ����number
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
����Ϸ��Ժ���
����x�е�y���ܷ�����number
ifself�����Ƿ���(x,y)
*/
bool SudokuInfo::IfFitCheck(int x, int y, int number, bool ifCheckself) {
	if (number == 0) return true;  //0Ϊ�Լ���

	if (ifCheckself && showsudokutable[x][y]) return false; //����ǰλ����������Ϊ��������

	for (int i = 0; i <= 8; i++) { //���Ŀ�����Ƿ����ظ�
		if (i == x) continue;
		if (showsudokutable[i][y] == number) return false;
	}

	for (int j = 0; j <= 8; j++) { //���Ŀ�����Ƿ����ظ�
		if (j == y) continue;
		if (showsudokutable[x][j] == number) return false;
	}

	for (int i = (x / 3) * 3; i <= (x / 3) * 3 + 2; i++) {  //���Ŀ�����ھŹ����Ƿ����ظ�
		for (int j = (y / 3) * 3; j <= (y / 3) * 3 + 2; j++) {
			if (i == x && j == y) continue;
			if (showsudokutable[i][j] == number) return false;
		}
	}

	if (ifDigsudoku && x == y) {
		for (int i = 0; i <= 8; i++) {  //���Խ���Ԫ���Ƿ����ظ�
			if (i == x) continue;
			if (showsudokutable[i][i] == number) {
				return false;
			}
		}
	}
	if (ifDigsudoku && x + y == 8) {
		for (int i = 0; i <= 8; i++) {  //���Խ���Ԫ���Ƿ����ظ�
			if (i == x) continue;
			if (showsudokutable[i][8 - i] == number) {
				return false;
			}
		}
	}

	return true;
}


//ģ�鹦���Ժ�����
//========================================================================================================================

/*
���뺯��
���û�����һ������������
����Ϸ���ȡ��ԭshowsudokutable������ָ�����󲢱���ԭ״
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

//��������ģ��=====================================================================================

/*
��������������ĵ� row ��
*/
void SudokuInfo::row_random(int row) {
	int rowtable[9] = { 1,2,3,4,5,6,7,8,9 };  //ԭʼ��ģ��
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
�ڿպ����������ɺõ���������������ڿ�(0�滻)
difficulty = 3; 2; 1
��ȥ55-60; 45-50; 35-40;
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
�������������
1.�������һ�е�Ԫ��
2.�Ը���Ԫ��Ϊģ���������
3.����ڿգ����������
*/
void SudokuInfo::generate(void) {

	allclear(7, 0);
	row_random(0);

	if(!ifDigsudoku) sudoku.Dlx_solve();  //�������
	else sudoku.solve();

	sudokuCopy(solutiontable[0], showsudokutable);  //���ƽ�
	//ifneedsolve = false;  //�˺���Ҫ����

	Holedigging(DIFFICLUTY);  //�ú����Ĳ���Ϊ�Ѷ�

	return;
}

/*
��յ�ǰ�������벿��
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




//�������ģ��====================================================================================================

/*
�ҿպ���
��showsudokutable�з��ص�row�п�ʼ��һ��Ϊ�յ����� 0~8
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
��⺯��
�ӵ�row�е�col�п�ʼ����������
������洢��showsudokutable��
*/
bool SudokuInfo::solvesudoku(int row, int col) {
	int number = 0;
	int nextRow, nextCol;

	if (row == -1 && col == -1) return false; //ֹͣ���

solvestart:

	while (1) {
		number++;
		if (number >= 10) break;

		if (!IfFitCheck(row, col, number, false)) {
			goto solvestart;
		}

		showsudokutable[row][col] = number;

		if (!findnextEmpty(row, &nextRow, &nextCol)) {
			return true;  //��ʾ���������ɣ���ʣ���λ
		}

		if (!solvesudoku(nextRow, nextCol)) {  //��һ��λ���޽�
			showsudokutable[row][col] = 0;
			continue;
		}
		else {
			return true;
		}
	}
	return false; //�������ֶ����ȥ
}

/*
�����Ż��㷨:���ڵ�ǰ������������ֽ����Ż����
����ʽ���������Ż�
*/
bool SudokuInfo::New_solve(int row, int col) {

	int number = 0;
	int nextRow = 0, nextCol = 0;

	for (int s = 0; s < availableCount[row][col]; s++) {
		if (!IfFitCheck(row, col, availableNumbers[row][col][s], false)) {
			continue;  //������ȥ������һ��
		}
		showsudokutable[row][col] = availableNumbers[row][col][s];

		if (!findnextEmpty(row, &nextRow, &nextCol)) {
			return true;  //��ʾ���������ɣ���ʣ���λ
		}

		//��ʼ����availableͳ��
		memset(availableNumbers, 0, 729 * sizeof(int));
		memset(availableCount, 0, 81 * sizeof(int));

		for (int i = 0; i <= 8; i++) {	//��������
			for (int j = 0; j <= 8; j++) {
				for (int n = 1; n <= 9; n++) {
					if (IfFitCheck(i, j, n, false)) {  //��¼�ô����������
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

		if (!solvesudoku(nextRow, nextCol)) {  //��һ��λ���޽�
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
���ģ���װ����
����ֱ����⵱ǰ��showsudokutable�����ҽ��������solutiontable[0]
*/
bool SudokuInfo::solve(void) {
	int row = -1, col = -1;  //��ʼ������
	int temp = 0;
	int tempsudokutable[9][9] = { 0 };
	//allclear(2, 0);

	for (int i = 0; i <= 8; i++) {  //�Ż�����
		for (int j = 0; j <= 8; j++) {
			for (int n = 1; n <= 9; n++) {
				if (IfFitCheck(i, j, n, false)) {  //��¼�ô����������
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

	//����ʽ���
	
	findnextEmpty(0, &row, &col); 
	solvesudoku(row, col); //��ͳ���

	if (findnextEmpty(0, &row, &col)) {
		sudokuCopy(tempsudokutable, showsudokutable);
		return false;
	}

	sudokuCopy(showsudokutable, solutiontable[0]);  //�����
	sudokuCopy(tempsudokutable, showsudokutable);
	return true;
}

//������ʾģ��===============================================================================================================

void SudokuInfo::hint(void) {

	int col = 0, row = 0;

	bool ifs = ifDigsudoku ? sudoku.solve() : sudoku.Dlx_solve();

	if (!ifs) {
		HWND wnd = GetHWnd();
		MessageBox(wnd, "��ǰ�����޽�.", "����", MB_OK | MB_ICONWARNING);
		return;
	}
	
	if (!findnextEmpty(0, &row, &col)) {//�ҵ���һ��Ϊ�յ�λ��
		HWND wnd = GetHWnd();
		MessageBox(wnd, "������.", "����", MB_OK | MB_ICONINFORMATION);
		return;
	}

	int i = col, j = row, bi = col / 3, bj = row / 3;
	showsudokutable[row][col] = solutiontable[0][row][col];

	setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
	setfillcolor(RGB(65, 105, 225));  //�涨���ɫ
	setfillstyle(BS_SOLID); //���������ʽ


	fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
		NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

	settextstyle(40, 0, _T("Consolas")); //��������
	setbkmode(TRANSPARENT);  //���ñ���͸��

	settextcolor(RGB(255, 106, 106));  //������Ϊ��ɫ

	RECT r = { NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		   NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
		   NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		   NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE };  //ȷ���������

	drawtext(showsudokutable[row][col] + 48, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);

	Sleep(350);

	setlinecolor(RGB(240, 255, 255)); //�涨�߿�ɫ
	setlinestyle(PS_SOLID | PS_JOIN_ROUND, 2); //�涨��߿�����
	setfillcolor(RGB(65, 105, 225));  //�涨���ɫ
	setfillstyle(BS_SOLID); //���������ʽ


	fillrectangle(NUM_BASE_WID + i * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		NUM_BASE_HEI + j * BLOCK_SIZE + bj * BLOCK_DISTANCE,
		NUM_BASE_WID + (i + 1) * BLOCK_SIZE + bi * BLOCK_DISTANCE,
		NUM_BASE_HEI + (j + 1) * BLOCK_SIZE + bj * BLOCK_DISTANCE);

	settextstyle(40, 0, _T("Consolas")); //��������
	setbkmode(TRANSPARENT);  //���ñ���͸��

	settextcolor(RGB(255, 255, 255));  //������Ϊ��ɫ

	drawtext(showsudokutable[row][col] + 48, &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}

//�����洢���ȡģ��===============================================================================================================

void SudokuInfo::save(void) {

	time_t t;

	char savename[40];
	char backname[20] = ".txt";
	char nowtime[20];

	LPTSTR s = new char[20];
	InputBox(s, 20, (LPCTSTR)"������浵��\n(������10����)\n(������ĸ������)", (LPCTSTR)"��������");

	time(&t);
	
	strcpy(savename, (char *)s);
	strftime(nowtime, sizeof(nowtime), "%Y-%m-%d-%H-%M-%S", localtime(&t));
	strcat(savename, "-");
	strcat(savename, nowtime);
	strcat(savename, backname);

	HWND wnd = GetHWnd();
	MessageBox(wnd, "    ����ɹ�    ", "��������", MB_OK | MB_ICONINFORMATION);


	FILE *fp = fopen("name.txt", "a+"); //ָ���ļ������ļ�ָ��
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

	FILE *fnewsave = fopen(savename, "w+");  //ָ���д���������ļ�ָ��
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

void SudokuInfo::load(void) {  //��ȡ�浵����
	
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

void SudokuInfo::readsave(int input) {  //�����input������,֮ǰ��Ҫ����浵�� 0 <= input <= 19


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

//����ģ��=======================================================================================================

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
//����������
//==============================================================================================================

int main() {
	MOUSEMSG *mouse = new MOUSEMSG;

	sudoku.allclear(7, 0);

	//��ʼ����Ϸ����
	initgraph(STARTWID, STARTHEI);
	HWND hWnd = GetHWnd();
	SetWindowText(hWnd, "Sudoku");

	entersudoku();
	Sleep(3000);

	//����ʼ����
	loadimage(NULL, _T(STARTPIC), STARTWID, STARTHEI, false);
	sudoku.generate();
	BK_NumBlock_Paint();
	BK_Button_Paint(RGB(39, 64, 139));

	
	//����
	sudoku.showsudokuPage();

	FlushMouseMsgBuffer();  //���˵�
	while (1) {
		if (!sudoku.mainupdate()) break;
	}

	exitsudoku();
	Sleep(3000);
	closegraph();
	//Dlx();

	return 0;
}