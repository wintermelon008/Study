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
    Last Edit:      2022.5.4

    This is the inter-segment register between MEM and WB
    Include the regs below:
        *PC: current PC
        *IS: current instruction
        *Ctr-WB: the control signals for WB (000 + rfmux(3), rfiwe(1), rffwe(1))
        *ALU-ANS: the alu answer
        *MDR: the data from dm unit
        *CSE: the data from csr unit
        *DR: the dr
    
*/

module MEM_WB_REG(
    // signals
    input clk,
    input rstn,
    input wen,
    input clear,

    // data
    input [31:0] is_din,
    input [31:0] pc_din,
    input [7:0] ctrl_wb_din,
    input [31:0] alu_ans_din,
    input [31:0] mdr_din,
    input [31:0] csr_din,
    input [31:0] dr_din,

    output [31:0] is_dout,
    output [31:0] pc_dout,
    output [7:0] ctrl_wb_dout,
    output [31:0] alu_ans_dout,
    output [31:0] mdr_dout,
    output [31:0] csr_dout,
    output [31:0] dr_dout
);

reg one;
initial begin
    one <= 1'b1;
end

REG #(32) mem_wb_pc(
    .din(pc_din & ({32{~clear}})),
    .dout(pc_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) mem_wb_is(
    .din(is_din & ({32{~clear}})),
    .dout(is_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(8) mem_wb_ctrl_wb(
    .din(ctrl_wb_din & ({8{~clear}})),
    .dout(ctrl_wb_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) mem_wb_mdr(
    .din(mdr_din & ({32{~clear}})),
    .dout(mdr_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) mem_wb_alu_ans(
    .din(alu_ans_din & ({32{~clear}})),
    .dout(alu_ans_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) mem_wb_csr(
    .din(csr_din & ({32{~clear}})),
    .dout(csrs_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) mem_wb_dr(
    .din(dr_din & ({32{~clear}})),
    .dout(dr_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);
endmodule
