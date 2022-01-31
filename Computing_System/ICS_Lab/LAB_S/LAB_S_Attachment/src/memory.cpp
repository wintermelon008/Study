/*
 * @Author       : Chivier Humber
 * @Date         : 2021-09-15 21:15:24
 * @LastEditors  : Chivier Humber
 * @LastEditTime : 2021-11-23 16:08:51
 * @Description  : file content
 */
#include "common.h"
#include "memory.h"
#include <stdlib.h>

namespace virtual_machine_nsp {
    void memory_tp::ReadMemoryFromFile(std::string filename, int beginning_address) {
        // Read from the file
        std::ifstream input_file;
        input_file.open(filename);
        if (input_file.is_open()) {
            const int line_length = 20;
            char read_in_line[line_length];
            while(input_file.getline(read_in_line, line_length)){    
                read_in_line[16] = '\0';
                memory[beginning_address++] = strtol(read_in_line, NULL, 2);
            }
        }
    }

    int16_t memory_tp::GetContent(int address) const {
        // get the content
        return memory[address];
    }

    int16_t& memory_tp::operator[](int address) {
        // get the content
        return memory[address];
    }    
}; // virtual machine namespace
