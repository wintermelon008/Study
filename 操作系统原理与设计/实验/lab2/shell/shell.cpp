// IO
#include <iostream>
#include <stdio.h>
#include <string.h>
// std::string
#include <string>
// std::vector
#include <vector>
// std::string 转 int
#include <sstream>
// PATH_MAX 等常量
#include <climits>
// POSIX API
#include <unistd.h>
// wait
#include <sys/wait.h>
// signals
#include <signal.h>
// r/w
#include <fcntl.h>
#include <cstdlib>
#include "shell.h"
#include "history.h"
// 非标准库

const char *workpath = "";
HisCMD hiscmd;
std::string nextcommand;

int main() {
  // 不同步 iostream 和 cstdio 的 buffer
  //std::ios::sync_with_stdio(false);
  FILE *fp = fopen("name.txt", "w+");
  fclose(fp);

  pid_t pid = fork();
  char *arg_ptrs[2];
  const char *arg1 = "whoami";
  const char *arg2 = ">";
  const char *arg3 = "name.txt";
  arg_ptrs[0] = (char *)arg1;
  arg_ptrs[1] = nullptr;
  

  if (pid == 0) {
    freopen("name.txt", "w", stdout);
    execvp("whoami", arg_ptrs);
    exit(0);
  }
  wait(nullptr);

  fp = fopen("name.txt", "r+");
  char username1[20] = {0};
  fread(username1, sizeof(char), 20, fp);


  fclose(fp);
  username1[strlen(username1) - 1] = '\0';
  std::string username = username1;
  std::string filename;

  // std::string username, filename;
  // std::cout << "Please Enter your username:\n";
  // std::getline(std::cin, username);

  
  filename = "/home/" + username + hiscmd.Get_filename();
  hiscmd.Set_filename(filename);

  struct sigaction sig;
  sig.sa_handler = CtrlC_handler;
  sig.sa_flags = 0;
  sigaction(SIGINT, &sig, NULL);

  hiscmd.Load_command();

  while (true) {

    if (false) {
      whilestart:
      ;
    }

    CtrlC_flag = 0;
    char ch;
    std::cout << "[Shell] # ";		// TODO: add workpath info
    std::cin.clear();
    //std::cout << "New while!\n";

    // 用来存储读入的一行命令
    std::string cmd_input;
    
    
    
    // 打印提示符
    //std::cout << "[Shell:~/" << workpath << "]: # ";
    // 按照字符读入一行
    while ((ch = getchar()) != '\n' && !CtrlC_flag) {
      if (ch == EOF && !CtrlC_flag) {
        std::cout << "Goodbye!\n";
        hiscmd.Save_commmand();
        exit(0);
      }
      cmd_input.push_back(ch);
    }

    if (false) {
      nextcmd:
      cmd_input = nextcommand;
    }

    
    if (cmd_input.size())
      hiscmd.Add_command(cmd_input);

    if (CtrlC_flag) {
      //std::cout << "CtrlC flag change!\n";
      CtrlC_flag = 0;
      std::cin.clear();
      continue;
    }

    std::vector<struct command> cmd;
    // 根据 "|" 对可能输入的管道进行指令分割
    std::vector<std::string> cmds = split(cmd_input, "|");
    for (auto i = cmds.begin(); i != cmds.end(); ++i) {
      std::string thiscmd_string = *i; 
      // 去除前导空格
        thiscmd_string.erase(0, thiscmd_string.find_first_not_of(" "));
      // 去除后续空格
        thiscmd_string.erase(thiscmd_string.find_last_not_of(" ") + 1);
      // 处理每一部分的指令
      std::vector<std::string> args = split(thiscmd_string, " ");  
      struct command thiscmd;
      for (auto j = args.begin(); j != args.end(); ++j) {
        std::string thiscmd_words = *j;
        if (j == args.begin()) {
          thiscmd.command = thiscmd_words;
        }
        else {
          thiscmd.parameter.push_back(thiscmd_words);
        }
      }
      cmd.push_back(thiscmd);
    }

    // Debug
    //std::cout << "Current command has " << cmd.size() << " parts.\n";
    //system("pause");

    int state = 0;
    
    // 处理多条管道
    int fd[MAX_PIPE_NUM][2] = {0};  // 管道文件
    pid_t pid, wpid;
    for (int i = 0; i < cmd.size() - 1; ++i) {
      // 创建对应的管道
      pipe(fd[i]);
    }

    int thread_i = 0;
    int last_pid = 0;
    for (thread_i = 0; thread_i < cmd.size(); ++thread_i) {
      // 创建进程
      pid = fork();
      if (!pid) {
        // 子进程
        break;
      }
      else if (pid < 0) {
        exit(FORK_ERROR);
      }
      last_pid = pid;
    }

    // 进程处理
    if (thread_i < cmd.size()) {
      // Son
      Pipe_apply(thread_i, cmd.size(), fd);
      int ret = do_command(cmd[thread_i]);
      if (ret < 0)
        exit(0);
    }
    else {
      // Father
      // 关闭所有管道
      for (int i = 0; i < cmd.size() - 1; ++i) {
        close(fd[i][0]);
        close(fd[i][1]);
      }
      while ((wpid = waitpid(-1, &state, WNOHANG)) != -1) {
        if (wpid == last_pid && WEXITSTATUS(state) == EXIT) {
          hiscmd.Save_commmand();
          std::cout << "Goodbye!\n";
          exit(0);
        }
        else if (wpid == last_pid && WEXITSTATUS(state) >= HISTORY_COMMAND_BASE) {
          int id = WEXITSTATUS(state) - HISTORY_COMMAND_BASE + 1;
          nextcommand = hiscmd.Get_command(id);
          hiscmd.PrintcmdId(id);
          goto nextcmd;
        }
        else if (wpid == last_pid && WEXITSTATUS(state) == LAST_ONE_COMMAND) {
          hiscmd.Delete_Lastcommand();
          int id = hiscmd.Get_size();
          nextcommand = hiscmd.Get_command(id);
          hiscmd.PrintcmdId(id);
          goto nextcmd;
        }
        else if (wpid == last_pid && WEXITSTATUS(state) == CHANGE_WORKPATH) {
          //std::cout << "Debug: the "
          if (cmd[thread_i - 1].parameter.size() == 0) {
          // 输出的信息尽量为英文，非英文输出（其实是非 ASCII 输出）在没有特别配置的情况下（特别是 Windows 下）会乱码
          // 如感兴趣可以自行搜索 GBK Unicode UTF-8 Codepage UTF-16 等进行学习
            std::cout << "cd failed: Insufficient arguments\n";
          // 不要用 std::encddl，std::endl = "\n" + fflush(stdout)
            break;
          }
          // 调用系统 API
          int ret = chdir(cmd[thread_i - 1].parameter[0].c_str());
          if (ret < 0) {
            std::cout << "cd failed: Illegal path\n";
          }
          break;
          //std::cout << "A son thread has been ended: No." << wpid << "\n";
        }

        else if (wpid == last_pid && WEXITSTATUS(state) == SET_ENV) {
          for (auto i = cmd[thread_i - 1].parameter.begin(); i != cmd[thread_i - 1].parameter.end(); i++) {
            std::string key = *i;

            // std::string 默认为空
            std::string value;

            // std::string::npos = std::string end
            // std::string 不是 nullptr 结尾的，但确实会有一个结尾字符 npos
            size_t pos;
            if ((pos = i->find('=')) != std::string::npos) {
              key = i->substr(0, pos);
              value = i->substr(pos + 1);
            }

            int ret = setenv(key.c_str(), value.c_str(), 1);
            if (ret < 0) {
              std::cout << "export failed\n";
            }
          }
        }

        else if (wpid == last_pid && WEXITSTATUS(state) == GET_ENV) {
         
          char *name = (char *)cmd[thread_i - 1].parameter[0].c_str();
          name++;

          char* x = getenv(name);
          if (!x)
            std::cout << "Not found.\n";
          else
            std::cout << x << "\n";
        }
      //wpid = waitpid(-1, NULL, WNOHANG);
      }
    
    }

  }
}
// 根据进程编号选择连接 or 关闭管道
int Pipe_apply(int thread_i, int thread_num, int fd[][2]) {
  // 关闭
  if (thread_i == 0) {
    close(fd[thread_i][0]);
  }
  else if (thread_i == thread_num - 1) {
    close(fd[thread_i - 1][1]);
  }
  else {
    close(fd[thread_i - 1][1]);
    close(fd[thread_i][0]);
  }

  for (int i = 0; i < thread_num - 1; ++i) {
    if (i == thread_i - 1 || i == thread_i) 
      continue;
    close(fd[i][0]);
    close(fd[i][1]);
  }
  // 连接
  if (thread_i == 0) {
    dup2(fd[thread_i][1], STDOUT_FILENO);
    close(fd[thread_i][1]);
  }
  else if (thread_i == thread_num - 1) {
    dup2(fd[thread_i - 1][0], STDIN_FILENO);
    close(fd[thread_i - 1][0]);
  }
  else {
    dup2(fd[thread_i - 1][0], STDIN_FILENO);
    dup2(fd[thread_i][1], STDOUT_FILENO);
    close(fd[thread_i - 1][0]);
    close(fd[thread_i][1]);
  }
  return 0;
}
  // 对于指令分割的测试，无用。
  //   for (auto i = cmd.begin(); i != cmd.end(); ++i) {
  //     struct command thiscmd = *i;
  //     std::cout << thiscmd.command << " " << thiscmd.parameter << "\n";
  //   }



// 执行指令
int do_command(struct command cmd) {
  std::string input_filename = "";
  std::string output_filename = "";
  std::string output_add_filename = "";
  FILE *fp1, *fp2, *fp3;
  int rd_place = cmd.parameter.size();
  int rd_ret = Check_Redirect(cmd.parameter, input_filename, output_filename, output_add_filename, rd_place);
  //std::cout << "Debug: the rd_place is: " << rd_place << "\n";
  if (rd_ret != NO_REDIRECT) {
    if (input_filename.length()) {
      fp1 = freopen(input_filename.c_str(), "r", stdin);
      if (!fp1) {
        std::cout << "Redirect ERROR!\n";
        exit(REDIRECT_ERROR);
      }
    }
    if (output_filename.length()) {
      fp2 = freopen(output_filename.c_str(), "w", stdout);
      if (!fp2) {
        std::cout << "Redirect ERROR!\n";
        exit(REDIRECT_ERROR);
      }
    }
    if (output_add_filename.length()) {
      fp3 = freopen(output_add_filename.c_str(), "a", stdout);
      if (!fp3) {
        std::cout << "Redirect ERROR!\n";
        exit(REDIRECT_ERROR);
      }
    }
  }
  
  
  // 进行截断，删去 rd_place 及其后的参数内容
  
  if (rd_place < cmd.parameter.size()) {
    cmd.parameter.erase(cmd.parameter.begin() + rd_place, cmd.parameter.end());
  }



  // 没有可处理的命令 ==============================================================================
  if (cmd.command.empty()) {
    exit(COMMAND_DONE);
  }

  if (cmd.command == "hello"){
    // A test output
    std::cout << "Hello! My first Shell!\n";
    // if (rd_ret != NO_REDIRECT) {
    //   fclose(fp1);
    //   fclose(fp2);
    //   fclose(fp3);
    // }
    exit(COMMAND_DONE);
  }

  // 处理历史指令问题 ===============================================================================
  if (cmd.command == "history") {
    // std::string 转 int
    std::stringstream code_stream(cmd.parameter[0]);
    int code = 0;
    code_stream >> code;

    // 转换失败
    if (!code_stream.eof() || code_stream.fail()) {
      std::cout << "Invalid history code\n";
      exit(NUMBER_TRANS_ERROR);
    }
    hiscmd.Printcmd(code);
    exit(COMMAND_DONE);
  }

  if (cmd.command == "!") {
    // std::string 转 int
    std::stringstream code_stream(cmd.parameter[0]);
    int code = 0;
    code_stream >> code;

    // 转换失败
    if (!code_stream.eof() || code_stream.fail()) {
      std::cout << "Invalid history code\n";
      exit(NUMBER_TRANS_ERROR);
    }
    exit(HISTORY_COMMAND_BASE + code - 1);
  }

  if (cmd.command == "!!") {
    exit(LAST_ONE_COMMAND);
  }

  // 更改工作目录为目标目录 ==========================================================================
  if (cmd.command == "cd") {
    exit(CHANGE_WORKPATH);
  }

  // 显示当前工作目录 ==========================================================================
  if (cmd.command == "pwd") {
    std::string cwd;
    // 预先分配好空间
    cwd.resize(PATH_MAX);
    // std::string to char *: &s[0]（C++17 以上可以用 s.data()）
    // std::string 保证其内存是连续的
    const char *ret = getcwd(&cwd[0], PATH_MAX);
    if (ret == nullptr) {
      std::cout << "cwd failed\n";
    } else {
      std::cout << ret << "\n";
    }
    exit(COMMAND_DONE);
  }

  // 设置环境变量 ==========================================================================
  if (cmd.command == "export") {
    exit(SET_ENV);
  }

  // 读取变量值 ======================================================================
  if (cmd.command == "echo") {
    if (cmd.parameter[0][0] == '$') {
      exit(GET_ENV);
    }
  }

  // 退出 ==========================================================================
  if (cmd.command == "exit") {
    if (cmd.parameter.size() <= 0) {
      exit(EXIT);
    }
    // std::string 转 int
    std::stringstream code_stream(cmd.parameter[0]);
    int code = 0;
    code_stream >> code;

    // 转换失败
    if (!code_stream.eof() || code_stream.fail()) {
      std::cout << "Invalid exit code\n";
      exit(EXIT);
    }
    exit(EXIT); // TODO 增加提示code
  }

  // 外部命令 ==========================================================================
  pid_t pid = fork();

  // std::vector<std::string> 转 char **
  char *arg_ptrs[cmd.parameter.size() + 2];
  arg_ptrs[0] = (char *)cmd.command.c_str();

  for (auto i = 0; i < cmd.parameter.size(); i++) {
    arg_ptrs[i + 1] = (char *)cmd.parameter[i].c_str();
  }
  // exec p 系列的 argv 需要以 nullptr 结尾
  arg_ptrs[cmd.parameter.size() + 1] = nullptr;

  if (pid == 0) {
    // 这里只有子进程才会进入
    // execvp 会完全更换子进程接下来的代码，所以正常情况下 execvp 之后这里的代码就没意义了
    // 如果 execvp 之后的代码被运行了，那就是 execvp 出问题了
    execvp(cmd.command.c_str(), arg_ptrs);

    // 所以这里直接报错
    exit(255);
  }

  // 这里只有父进程（原进程）才会进入
  wait(nullptr);
  exit(COMMAND_DONE);
}




// 经典的 cpp string split 实现
// https://stackoverflow.com/a/14266139/11691878
std::vector<std::string> split(std::string s, const std::string &delimiter) {
  std::vector<std::string> res;
  size_t pos = 0;
  std::string token;
  while ((pos = s.find(delimiter)) != std::string::npos) {
    token = s.substr(0, pos);
    res.push_back(token);
    s = s.substr(pos + delimiter.length());
  }
  res.push_back(s);
  return res;
}


// 处理 ctrlc
static void CtrlC_handler(int sig) {
  CtrlC_flag = 1;
  std::cout << "\n";
}

// 检查重定向
// 目前仅支持单个重定向符号解析
int Check_Redirect(const std::vector<std::string> &parameter, std::string &input_filename, 
                         std::string &output_filename, std::string &output_add_filename ,int &rd_place){
  const std::string out_rd = ">";
  const std::string in_rd = "<";
  const std::string out_add_rd = ">>";

  int i = 0;
  if (parameter.size() == 0)
    return NO_REDIRECT;
  for (i = 0; i < parameter.size() - 1; ++i) {
    if (parameter[i] == out_rd) {
      output_filename = parameter[i + 1];
      rd_place = i < rd_place ? i : rd_place;
    }
    else if (parameter[i] == in_rd) {
      input_filename = parameter[i + 1];
      rd_place = i < rd_place ? i : rd_place;
    }
    else if (parameter[i] == out_add_rd) {
      output_add_filename = parameter[i + 1];
      rd_place = i < rd_place ? i : rd_place;
    }
  }
  return 0;
}