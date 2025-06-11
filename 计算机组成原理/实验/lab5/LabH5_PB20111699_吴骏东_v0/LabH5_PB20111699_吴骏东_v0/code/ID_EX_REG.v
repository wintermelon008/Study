`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 18:41:50
// Design Name: 
// Module Name: ID_EX_REG
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

    This is the inter-segment register between ID and EX
    Include the regs below:
        *PC: current PC
        *Imm: the immediate number
        *Ctr-WB: the control signals for WB
        *Ctrl-MEM: the control signals for MEM
        *Ctrl-EX: the control signals for EX
        *IS: current instruction
        *SR1: the source number A
        *SR2: the source number B
        *ALU-EX: the alu answer from EX
        *ALU-MEM: the alu answer form MEM
        *NPC-MEM: the pc+4 from MEM 
        *DM-MEM: the dm-out form MEM
        *SR-MUX-SEL: the mux control signals
    
*/

module ID_EX_REG(
    // signals
    input clk,
    input rstn,
    input clear,    // 1 is clear: all the ctrls and is
    // data
    input [31:0] is_din,
    input [31:0] pc_din,
    input [31:0] imm_din,
    input [31:0] sr1_din,
    input [31:0] sr2_din,
    input [14:0] ctrl_ex_din,
    input [3:0] ctrl_mem_din,
    input [3:0] ctrl_wb_din,
    input [31:0] alu_ex_din,
    input [31:0] alu_mem_din,
    input [31:0] npc_mem_din,
    input [31:0] dm_mem_din,
    input [18:0] sr_mux_din,

    output [31:0] is_dout,
    output [31:0] pc_dout,
    output [31:0] imm_dout,
    output [31:0] sr1_dout,
    output [31:0] sr2_dout,
    output [14:0] ctrl_ex_dout,
    output [3:0] ctrl_mem_dout,
    output [3:0] ctrl_wb_dout,
    output [31:0] alu_ex_dout,
    output [31:0] alu_mem_dout,
    output [31:0] npc_mem_dout,
    output [31:0] dm_mem_dout,
    output [18:0] sr_mux_dout
);

reg one;
initial begin
    one <= 1'b1;
end

REG #(32) id_ex_pc(
    .din(pc_din),
    .dout(pc_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_is(
    .din(is_din & ({32{~clear}})),
    .dout(is_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_imm(
    .din(imm_din),
    .dout(imm_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(15) id_ex_ctrl_ex(
    .din(ctrl_ex_din & ({16{~clear}})),
    .dout(ctrl_ex_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(4) id_ex_ctrl_mem(
    .din(ctrl_mem_din & ({4{~clear}})),
    .dout(ctrl_mem_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(4) id_ex_ctrl_wb(
    .din(ctrl_wb_din & ({4{~clear}})),
    .dout(ctrl_wb_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_sr1(
    .din(sr1_din),
    .dout(sr1_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_sr2(
    .din(sr2_din),
    .dout(sr2_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_alu_ex(
    .din(alu_ex_din),
    .dout(alu_ex_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_alu_mem(
    .din(alu_mem_din),
    .dout(alu_mem_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_npc_mem(
    .din(npc_mem_din),
    .dout(npc_mem_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_dm_mem(
    .din(dm_mem_din),
    .dout(dm_mem_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(19) id_ex_sr_mux(
    .din(sr_mux_din),
    .dout(sr_mux_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);



endmodule
