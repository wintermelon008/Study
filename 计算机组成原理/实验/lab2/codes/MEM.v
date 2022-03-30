`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 10:40:19
// Design Name: 
// Module Name: MEM
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
    The memory unit 
    use a dist_mem
    add a reg to record the highest address

    last edit: 2022.3.28
*/

module MEM(
    input sys_clk,
    input [7:0] add_1,
    input [15:0] data_1,
    input we_1,
    input [7:0] radd_2,
    output [15:0] out_1, out_2,
    output reg [7:0] highest_add
);

    reg [3:0] sel;
    wire [7:0] ans;
    wire [2:0] sub_flag;
    wire error;

    initial begin
        highest_add <= 0;
        sel <= 0;
    end

    always @(posedge sys_clk) begin
        if (add_1 > highest_add)
            highest_add <= add_1;
    end

    ALU #(8) mem_alu(highest_add, add_1, sel, ans, sub_flag, error);
    /*
        module ALU 
    #(
        parameter WIDTH = 32                          //数据宽度
    )
    (
        input [WIDTH-1 : 0] num1, num2,               // [数据] 两操作数
        input [3:0] sel,                              // [信号] 功能选择    //改成了四�?
        output reg [WIDTH-1 : 0] ans,                 // [数据] 运算结果
        output [2:0] sub_flag,                        // [信号] 减法大小标志
        output reg error                              // [信号] 错误标志，为 1 代表运算出错     
    );
    */

    dist_mem_gen_1 dist_mem (
    .a(add_1),        // input wire [7 : 0] a
    .d(data_1),        // input wire [15 : 0] d
    .dpra(radd_2),  // input wire [7 : 0] dpra
    .clk(sys_clk),    // input wire clk
    .we(we_1),      // input wire we
    .spo(out_1),    // output wire [15 : 0] spo
    .dpo(out_2)    // output wire [15 : 0] dpo
    );
endmodule
