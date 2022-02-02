#pragma once
class SudokuInfo {
public:

	//通用功能性函数区
	//=======================================================================================================================

	void allclear(int mod, int number);  //初始化函数

	bool IfFitCheck(int x, int y, int number, bool ifCheckself);  //填入合法性检查函数

	bool mainupdate(void);  //主窗口每一帧更新

	bool loadupdate(void);  //加载窗口每一帧更新

	bool settingupdate(void); //设置窗口每一帧更新

	bool inputupdate(void);  //输入窗口每帧更新

	bool helpupdate(void);  //帮助窗口每一帧更新

	bool sudokuSetupdate(void);  //数独设置窗口每一帧更新

	//模块功能性函数区
	//========================================================================================================================

	void input(void);  //整体输入函数

	//==============================================================================

	void row_random(int row);  //行随机函数

	void Holedigging(int difficulty);  //挖空

	void generate(void);  //生成函数

	void button_generate(void);

	//=============================================================================

	void reset(void);  //重新输入当前的数独

	bool findnextEmpty(int row, int *nextRow, int *nextCol);  //找空函数

	bool solvesudoku(int row, int col);   //求解子函数

	bool solve(void);  //求解封装函数

	void showsudokuPage(void); //将数独输出到当前界面上

	void button_solve(void);

	bool New_solve(int row, int col); //优化求解

	bool Dlx_solve();  //DLX求解

	void solve_sudoku(std::string &problem);

	//===============================================================================

	void settings(void);  //设置函数

	void help(void);  //按钮功能说明

	void sudokuChoose(void);  //数独选择函数

	//===============================================================================

	void hint(void);  //提示函数

	//=================================================================================

	void save(void);  //保存函数

	void load(void);  //载入函数

	void readsave(int input);  //存档读入函数

	void LoadChoose(int page);  //存档界面切换函数


	//================================================================================
	void(SudokuInfo :: *main_button[NUMBER_OF_MAIN_BUTTON - 1])(void) = {   //函数指针数组

		&SudokuInfo::button_generate,  //0

		&SudokuInfo::reset, //1

		&SudokuInfo::button_solve, //2

		&SudokuInfo::hint,  //3

		&SudokuInfo::input,  //4

		&SudokuInfo::save, //5

		&SudokuInfo::load  //6

	};

	void(SudokuInfo :: *setting_button[NUMBER_OF_SETTING_BUTTON])(void) = {

		&SudokuInfo::help,  //0

		&SudokuInfo::sudokuChoose  //1

	};

private:

	int showsudokutable[9][9];  //显示出来的数独
	int solutiontable[MAX_SOLUTION][9][9];  //存储当前解的数独
	int startstatetable[9][9];  //数独初始状态下的非零数字


} sudoku;