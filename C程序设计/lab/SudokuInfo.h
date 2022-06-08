
class SudokuInfo {
public:

	//ͨ�ù����Ժ�����
	//=======================================================================================================================

	void allclear(int mod, int number);  //��ʼ������

	bool IfFitCheck(int x, int y, int number, bool ifCheckself);  //����Ϸ��Լ�麯��

	bool mainupdate(void);  //������ÿһ֡����

	bool loadupdate(void);  //���ش���ÿһ֡����

	bool settingupdate(void); //���ô���ÿһ֡����

	bool inputupdate(void);  //���봰��ÿ֡����

	bool helpupdate(void);  //��������ÿһ֡����

	bool sudokuSetupdate(void);  //�������ô���ÿһ֡����

	//ģ�鹦���Ժ�����
	//========================================================================================================================

	void input(void);  //�������뺯��

	//==============================================================================

	void row_random(int row);  //���������

	void Holedigging(int difficulty);  //�ڿ�

	void generate(void);  //���ɺ���

	void button_generate(void);

	//=============================================================================

	void reset(void);  //�������뵱ǰ������

	bool findnextEmpty(int row, int *nextRow, int *nextCol);  //�ҿպ���

	bool solvesudoku(int row, int col);   //����Ӻ���

	bool solve(void);  //����װ����

	void showsudokuPage(void); //�������������ǰ������

	void button_solve(void);

	bool New_solve(int row, int col); //�Ż����

	bool Dlx_solve();  //DLX���

	void solve_sudoku(std::string &problem);

	//===============================================================================

	void settings(void);  //���ú���

	void help(void);  //��ť����˵��

	void sudokuChoose(void);  //����ѡ����

	//===============================================================================

	void hint(void);  //��ʾ����

	//=================================================================================

	void save(void);  //���溯��

	void load(void);  //���뺯��

	void readsave(int input);  //�浵���뺯��

	void LoadChoose(int page);  //�浵�����л�����


	//================================================================================
	void(SudokuInfo :: *main_button[NUMBER_OF_MAIN_BUTTON - 1])(void) = {   //����ָ������

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

	int showsudokutable[9][9];  //��ʾ����������
	int solutiontable[MAX_SOLUTION][9][9];  //�洢��ǰ�������
	int startstatetable[9][9];  //������ʼ״̬�µķ�������


} sudoku;