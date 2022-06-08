
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include "history.h"


int HistoryCmd::Set_filename(std::string name) {
    if (name.length()) {
        filename = name;
        return 0;
    }
    return -1;
}
std::string HistoryCmd::Get_filename() {
    return filename;
}

int HistoryCmd::Get_size() {
    if (history_command.size() > 0)
        return history_command.size();
    return 0;
}

int HistoryCmd::Add_command(std::string command) {
    if (history_command.size() >= MAX_CMD_NUM - 1) {
        auto it = history_command.begin();
        history_command.erase(it);
        history_command.push_back(command);
    }
    else {
        history_command.push_back(command);
    }
    return 0;
}

int HistoryCmd::Save_commmand() {
    std::ofstream outfile;
    outfile.open(filename.c_str(), std::ios::out);
    for (int i = 0; i < history_command.size(); ++i) {
        outfile << history_command[i].c_str() << "\n";
    }
    outfile.close();
    return 0;
}

int HistoryCmd::Load_command() {
    FILE *fp = fopen(filename.c_str(), "a");
    fclose(fp);
    std::ifstream infile;
    infile.open(filename.c_str(), std::ios::in);
    while (!infile.eof()) {
        std::string cmd_input;
        std::getline(infile, cmd_input);
        history_command.push_back(cmd_input);
    }
    infile.close();
    return 0;
}

std::string HistoryCmd::Get_command(int id) {
    std::string command = "";
    if (id <= 0) {
        id = history_command.size();
    } 
    if (history_command.size() < id) {
        std::cout << "No enough commands\n";
        return command;
    }
    command = history_command[id - 1];
    return command;
}

void HistoryCmd::Printcmd(int num) {
    if (num <= 0) {
        num = 1;
    } 
    if (history_command.size() < num) {
        std::cout << "No enough commands\n";
        return;
    }
    for (int i = history_command.size() - num; i <= history_command.size() - 1; ++i) {
        std::cout << "  Command [" << i + 1 << "]: " << history_command[i] << "\n";
    }
    return;
}

void HistoryCmd::PrintcmdId(int id) {
    if (id <= 0) {
        id = history_command.size();
    }
    else if (id > history_command.size()) {
        return;
    }
    else 
        std::cout << history_command[id - 1] << "\n";
    return;
}

int HistoryCmd::Delete_Lastcommand() {
    if (history_command.size() <= 0) {
        return -1;
    }
    history_command.erase(history_command.end());
    return 0;
}