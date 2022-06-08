#include <iostream>
#include <string>
#include <vector>

#define VECTOR_EMPTY -2
#define DEFAULT_CMD_LOG_FILENAME "/command_log.txt"
#define MAX_CMD_NUM 1000

// 历史命令保存
class HistoryCmd {
  private:
    std::string filename;
    std::vector<std::string> history_command;
  public:
    HistoryCmd(std::string name = DEFAULT_CMD_LOG_FILENAME) {
      filename = name;
      //this->Load_command();
    }
    ~HistoryCmd() {
      //this->Save_commmand();
    };
    int Set_filename(std::string name);
    std::string Get_filename();
    int Get_size();
    int Add_command(std::string command);
    std::string Get_command(int id = 0);
    // 返回第 @id 条指令

    int Save_commmand();
    int Load_command();
    void Printcmd(int num = 1);
    // 打印倒数 @num 条指令

    void PrintcmdId(int id = 0);
    // 打印第 @id 条指令
    
    int Delete_Lastcommand();
};

typedef class HistoryCmd HisCMD;