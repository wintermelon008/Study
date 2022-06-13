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
    ================================  EX_MEM_REG module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.4

    This is the inter-segment register between EX and MEM
    Include the regs below:
        *PC: current PC
        *IS: current instruction

        *Ctr-WB: the control signals for WB (000 + rfmux(3), rfiwe(1), rffwe(1))
        *Ctrl-MEM: the control signals for MEM (00 + dmu_mode(3) ccu_ans_mux(1) + dmwe(1), dmrd(1))

        *ALU-ANS-CTRL: the mux control for alu answer in MEM
        *ALU-ANS: the alu answer
        *DR: the dr
        *DM-ADDR: the address for dm unit
        *DM-DATA: the data for dm unit
        
    
*/

module EX_MEM_REG(
    // signals
    input clk,
    input rstn,
    input wen,
    input clear,

    // data
    input [31:0] is_din,
    input [31:0] pc_din,
    input [7:0] ctrl_mem_din,
    input [7:0] ctrl_wb_din,
    input [31:0] alu_ans_din,
    input [31:0] dm_addr_din,
    input [31:0] dm_data_din,
    input [31:0] csr_din,
    input [31:0] dr_din,


    output [31:0] is_dout,
    output [31:0] pc_dout,
    output [7:0] ctrl_mem_dout,
    output [7:0] ctrl_wb_dout,
    output [31:0] alu_ans_dout,
    output [31:0] dm_addr_dout,
    output [31:0] dm_data_dout,
    output [31:0] csr_dout,
    output [31:0] dr_dout

);

reg one;
initial begin
    one <= 1'b1;
end

REG #(32) ex_mem_pc(
    .din(pc_din & ({32{~clear}})),
    .dout(pc_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) ex_mem_is(
    .din(is_din & ({32{~clear}})),
    .dout(is_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(8) ex_mem_ctrl_mem(
    .din(ctrl_mem_din & ({8{~clear}})),
    .dout(ctrl_mem_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(8) ex_mem_ctrl_wb(
    .din(ctrl_wb_din & ({8{~clear}})),
    .dout(ctrl_wb_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) ex_mem_dm_addr(
    .din(dm_addr_din & ({32{~clear}})),
    .dout(dm_addr_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) ex_mem_dm_data(
    .din(dm_data_din & ({32{~clear}})),
    .dout(dm_data_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) ex_mem_alu_ans(
    .din(alu_ans_din & ({32{~clear}})),
    .dout(alu_ans_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) ex_mem_dr(
    .din(dr_din & ({32{~clear}})),
    .dout(dr_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) ex_mem_csr(
    .din(csr_din & ({32{~clear}})),
    .dout(csr_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

endmodule
