`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 14:51:57
// Design Name: 
// Module Name: Plus1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/*
 Add 1 to input
 last edit 2022.3.28
*/

module Plus1
#(
    parameter WIDTH = 32                          //数据宽度
)
(
    input [WIDTH-1:0] data_i,
    output [WIDTH-1:0] data_o
);

    reg [WIDTH-1:0] one;
    reg [3:0] sel;
    wire [2:0] sub_flag;
    wire error;

    initial begin
        one <= 'b1;
        sel <= 4'b0001;
    end

    ALU #(WIDTH) plus1_alu (one, data_i, sel, data_o, sub_flag, error);
    /*
    #(
    parameter WIDTH = 32                          //数据宽度
)
(
    input [WIDTH-1 : 0] num1, num2,               // [数据] 两操作数
    input [3:0] sel,                              // [信号] 功能选择    //改成了四�?
    output reg [WIDTH-1 : 0] ans,                 // [数据] 运算结果
    output [2:0] sub_flag,                        // [信号] 减法大小标志
    output reg error                              // [信号] 错误标志，为 1 代表运算出错     
);*/
endmodule
