`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/21 10:37:06
// Design Name: 
// Module Name: EX_MEM_REG
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
    ================================  ID_EX_REG module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.20

    This is the inter-segment register between EX and MEM
    Include the regs below:
        *PC: current PC
        *Ctr-WB: the control signals for WB
        *Ctrl-MEM: the control signals for MEM
        *IS: current instruction
        *SR2: the source number B
        *ALU-ANS: the alu answer
    
*/

module EX_MEM_REG(
    // signals
    input clk,
    input rstn,

    // data
    input [31:0] is_din,
    input [31:0] pc_din,
    input [3:0] ctrl_mem_din,
    input [3:0] ctrl_wb_din,
    input [31:0] alu_ans_din,
    input [31:0] sr2_din,

    output [31:0] is_dout,
    output [31:0] pc_dout,
    output [3:0] ctrl_mem_dout,
    output [3:0] ctrl_wb_dout,
    output [31:0] alu_ans_dout,
    output [31:0] sr2_dout

);

    reg one;
    initial begin
        one <= 1'b1;
    end

REG #(32) ex_mem_pc(
    .din(pc_din),
    .dout(pc_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) ex_mem_is(
    .din(is_din),
    .dout(is_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(4) ex_mem_ctrl_mem(
    .din(ctrl_mem_din),
    .dout(ctrl_mem_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(4) ex_mem_ctrl_wb(
    .din(ctrl_wb_din),
    .dout(ctrl_wb_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) ex_mem_sr2(
    .din(sr2_din),
    .dout(sr2_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) ex_mem_alu_ans(
    .din(alu_ans_din),
    .dout(alu_ans_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);
endmodule
