`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/21 10:53:44
// Design Name: 
// Module Name: MEM_WB_REG
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
    ================================  MEM_WB_REG module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.21

    This is the inter-segment register between MEM and WB
    Include the regs below:
        *PC: current PC
        *IS: current instruction
        *Ctr-WB: the control signals for WB
        *ALU-ANS: the alu answer
        *MDR: the data from dm
    
*/

module MEM_WB_REG(
    // signals
    input clk,
    input rstn,

    // data
    input [31:0] is_din,
    input [31:0] pc_din,
    input [3:0] ctrl_wb_din,
    input [31:0] alu_ans_din,
    input [31:0] dm_data_din,

    output [31:0] is_dout,
    output [31:0] pc_dout,
    output [3:0] ctrl_wb_dout,
    output [31:0] alu_ans_dout,
    output [31:0] dm_data_dout
);

    reg one;
    initial begin
        one <= 1'b1;
    end

REG #(32) mem_wb_pc(
    .din(pc_din),
    .dout(pc_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) mem_wb_is(
    .din(is_din),
    .dout(is_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(4) mem_wb_ctrl_wb(
    .din(ctrl_wb_din),
    .dout(ctrl_wb_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) mem_wb_dm_data(
    .din(dm_data_din),
    .dout(dm_data_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) mem_wb_alu_ans(
    .din(alu_ans_din),
    .dout(alu_ans_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);
endmodule
