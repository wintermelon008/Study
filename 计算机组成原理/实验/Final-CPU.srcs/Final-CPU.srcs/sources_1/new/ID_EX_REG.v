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
    Last Edit:      2022.5.4

    This is the inter-segment register between ID and EX
    Include the regs below:
        *PC: current PC
        *IS: current instruction
        *Imm: the immediate number

        *Ctrl-WB: the control signals for WB (0000 + rfmux(3), rffwe(1))
        *Ctrl-MEM: the control signals for MEM (00 + dmu_mode(3) ccu_ans_mux(1) + dmwe(1), dmrd(1))
        *Ctrl-EX: the control signals for EX (0 + ebreak(1) + sr1mux(3), sr2mux(3), alumode(8)
        
        *SR1: the source number A
        *SR2: the source number B
        *CSR: the CSR from ID
        *DR: the dr

        *ALU-EX: the alu answer from EX
        *ALU-MEM: the alu answer form MEM
        *NPC-MEM: the pc+4 from MEM 
        *DM-MEM: the dm-out form MEM
        *MUX-SEL: the mux control signals (0000 + sr1(3), sr2(3), sr3(3), bsr1(3), bsr2(3), dsr2(3), npc(2))

*/

module ID_EX_REG(
    // signals
    input clk,
    input rstn,
    input wen,
    input clear,    // 1 is clear: all the ctrls and is
    // data
    input [31:0] is_din,
    input [31:0] pc_din,
    input [31:0] imm_din,
    input [31:0] sr1_din,
    input [31:0] sr2_din,
    input [31:0] csr_din,
    input [31:0] dr_din,
    input [15:0] ctrl_ex_din,
    input [7:0] ctrl_mem_din,
    input [7:0] ctrl_wb_din,
    input [31:0] ccu_ex_din,
    input [31:0] ccu_mem_din,
    input [31:0] ccu_wb_din,
    input [31:0] npc_mem_din,
    input [31:0] dm_mem_din,
    input [23:0] mux_sel_din,

    output [31:0] is_dout,
    output [31:0] pc_dout,
    output [31:0] imm_dout,
    output [31:0] sr1_dout,
    output [31:0] sr2_dout,
    output [31:0] csr_dout,
    output [31:0] dr_dout,
    output [15:0] ctrl_ex_dout,
    output [7:0] ctrl_mem_dout,
    output [7:0] ctrl_wb_dout,
    output [31:0] ccu_ex_dout,
    output [31:0] ccu_mem_dout,
    output [31:0] ccu_wb_dout,
    output [31:0] npc_mem_dout,
    output [31:0] dm_mem_dout,
    output [23:0] mux_sel_dout
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

REG #(16) id_ex_ctrl_ex(
    .din(ctrl_ex_din & ({16{~clear}})),
    .dout(ctrl_ex_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(8) id_ex_ctrl_mem(
    .din(ctrl_mem_din & ({8{~clear}})),
    .dout(ctrl_mem_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(8) id_ex_ctrl_wb(
    .din(ctrl_wb_din & ({8{~clear}})),
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

REG #(32) id_ex_csr(
    .din(csr_din),
    .dout(csr_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_dr(
    .din(dr_din),
    .dout(dr_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_ccu_ex(
    .din(ccu_ex_din),
    .dout(ccu_ex_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_ccu_mem(
    .din(ccu_mem_din),
    .dout(ccu_mem_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);

REG #(32) id_ex_ccu_wb(
    .din(ccu_wb_din),
    .dout(ccu_wb_dout),
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

REG #(24) id_ex_sr_mux(
    .din(mux_sel_din),
    .dout(mux_sel_dout),
    .clk(clk),
    .rstn(rstn),
    .wen(one)
);



endmodule
