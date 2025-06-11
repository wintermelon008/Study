`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 15:54:07
// Design Name: 
// Module Name: Flow_CPU
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
    ================================  Flow_CPU module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.20

    This is the cpu topmodule for flow-line

    Used sub-modules:
        * ALU
        * Instruction_MEM
        * Data_MEM
        * REG_FILE
        * Control
        * BranchCtrl
        * Signextend
        * Forwarding_Hazard
        * SR_MUX_CTRL
        * PC
        * REG
        * IF_ID_REG
        * ID_EX_REG
        * EX_MEM_REG
        * MEM_WB_REG
        * MUX2
        * MUX4
        * MUX8
        * DEBUG
*/

module Flow_CPU(
    // cpu control form PDU
    input clk, 
    input rstn,

    // IO_BUS
    output [15:0]  io_addr,	// I/O address
    output [31:0]  io_dout,	// I/O data output
    output  io_we,		    // I/O write enable
    output  io_rd,		    // I/O read enable
    input [31:0] io_din,	// I/O data input

    // Debug_BUS
    output [31:0] chk_pc, 	// Current pc
    input [15:0] chk_addr,	// Debug address
    output [31:0] chk_data  // Debug data

);

// Below is some consts =============================================================================================================
reg [31:0] zero;
reg one;

// Below is the wires and regs declaration ==========================================================================================

// Memoryss
wire [7:0] im_din;
wire [31:0] im_dout;
wire [7:0] dm_addr;
wire [31:0] dm_din, dm_dout;
wire dm_wen;

// RF
wire [4:0] rf_sr1_add, rf_sr2_add, rf_dr_add;
wire [31:0] rf_sr1_data, rf_sr2_data, rf_dr_data;
wire rf_wen;


// PC register
wire [31:0] pc_in, pc_out;
wire pc_wen;

// Iter-segment Registers
wire id_ex_clear, if_id_en;
wire [31:0] id_is, id_pc, id_imm;
wire [31:0] ex_is, ex_pc, ex_imm, ex_sr1, ex_sr2;
wire [31:0] mem_is, mem_pc, mem_alu_ans, mem_sr2;
wire [31:0] wb_is, wb_pc, wb_alu_ans, wb_dm_data;
wire [31:0] alu_ex, alu_mem, dm_mem, npc_mem;
wire [3:0] ex_ctrl_wb, mem_ctrl_wb;
wire [3:0] ex_ctrl_mem;
wire [1:0] ex_npc_mux_sel;
wire ex_jalr_flag;

wire [18:0] sr_mux_dout;
wire [14:0] ctrl_ex_dout;
wire [3:0] ctrl_mem_dout;
wire [3:0] ctrl_wb_dout;

// CU
wire [24:0] control_signals;
wire [3:0] jump_ctrl;
wire jalr_flag; // when 1, the is is jalr
wire [2:0] sr1_mux_sel_cu, sr2_mux_sel_cu;
wire [2:0] ex_sr1_mux_sel_cu, ex_sr2_mux_sel_cu;

// ALU
wire [31:0] alu_ans;
wire [3:0] alu_mode;
wire alu_error;
wire [2:0] alu_subflag;

// MUXs
wire [1:0] npc_mux_sel, rf_mux_sel;
wire [2:0] b_sr1_mux_sel, b_sr2_mux_sel;
wire [31:0] b_sr1_mux_out, b_sr2_mux_out;
wire [2:0] sr1_mux_sel, sr2_mux_sel, dm_sr2_mux_sel;
wire [31:0] sr1_mux_out, sr2_mux_out, dm_sr2_mux_out, io_dm_mux_out;
wire io_dm_mux_sel;

// FH
wire [2:0] b_sr1_mux_sel_fh, b_sr2_mux_sel_fh, sr1_mux_sel_fh, sr2_mux_sel_fh, dm_sr2_mux_sel_fh;
wire [2:0] ex_b_sr1_mux_sel_fh, ex_b_sr2_mux_sel_fh, ex_sr1_mux_sel_fh, ex_sr2_mux_sel_fh, ex_dm_sr2_mux_sel_fh;

// Debug lines
wire [15:0] im_debug_din;
wire [31:0] im_debug_dout;
wire [15:0] dm_debug_din;
wire [31:0] dm_debug_dout;
wire [4:0] rf_debug_din;
wire [31:0] rf_debug_dout;

// Below is the wires and regs connection ===========================================================================================
initial begin
    zero <= 32'b0;
    one <= 1'b1;
end

assign im_din = pc_out[9:2];
assign rf_sr1_add = id_is[19:15];
assign rf_sr2_add = id_is[24:20];
assign rf_dr_add = wb_is[11:7];
assign dm_addr = mem_alu_ans[9:2];
assign dm_din = mem_sr2;

/*
    MUX Ctrl signal:

    control_signals[2:0] - rs1mux
    control_signals[5:3] - rs2mux
    control_signals[7:6] - rfmux

    ALU mode signal:
    control_signals[13:10] - alusel

    Regfile writing enable:
    control_signals[15] - rf_we

    Data memory and I/O writing enable:
    control_signals[16] - dm_we

    I/O reading enable
    control_signals[18] - io_re

    Jump control signal:
    control_signals[22:19] - jump_ctrl
*/
assign jump_ctrl = control_signals[22:19];
assign b_sr1_mux_sel = ex_b_sr1_mux_sel_fh;
assign b_sr2_mux_sel = ex_b_sr2_mux_sel_fh;
assign dm_sr2_mux_sel = ex_dm_sr2_mux_sel_fh;
assign jalr_flag = (jump_ctrl == 4'h6) ? 1'b1 : 1'b0;

assign io_dm_mux_sel = (mem_alu_ans[15:8] == 8'hff)? 1'b1 : 1'b0;   
assign io_we = dm_wen;
assign io_addr = mem_alu_ans[15:0];
assign io_dout = mem_sr2;



assign ex_npc_mux_sel = sr_mux_dout[16:15];
assign ex_sr1_mux_sel_fh = sr_mux_dout[14:12];
assign ex_sr2_mux_sel_fh = sr_mux_dout[11:9];
assign ex_b_sr1_mux_sel_fh = sr_mux_dout[8:6];
assign ex_b_sr2_mux_sel_fh = sr_mux_dout[5:3];
assign ex_dm_sr2_mux_sel_fh = sr_mux_dout[2:0];

assign ex_jalr_flag = ctrl_ex_dout[10];
assign ex_sr1_mux_sel_cu = ctrl_ex_dout[9:7];
assign ex_sr2_mux_sel_cu = ctrl_ex_dout[6:4];
assign alu_mode = ctrl_ex_dout[3:0];

assign dm_wen = ctrl_mem_dout[1];
assign io_rd = ctrl_mem_dout[0];

assign rf_mux_sel = ctrl_wb_dout[2:1];
assign rf_wen = ctrl_wb_dout[0];
// Below is the sub-module declaration ==============================================================================================

// Memorys
Instruction_MEM im (
    .clk(clk),
    .add_1(im_din),
    .data_1(zero),
    .we_1(zero[0]),
    .radd_2(im_debug_din),
    .out_1(im_dout), 
    .out_2(im_debug_dout)
);

Data_MEM dm (
    .clk(clk),
    .add_1(dm_addr),
    .data_1(dm_din),
    .we_1(dm_wen),
    .radd_2(dm_debug_din),
    .out_1(dm_dout), 
    .out_2(dm_debug_dout)
);

// Reg file

REG_FILE rf (
    .clk(clk),			           
    .ra0(rf_sr1_add), 
    .ra1(rf_sr2_add), 
    .ra2(rf_debug_din),	
    .rd0(rf_sr1_data), 
    .rd1(rf_sr2_data), 
    .rd2(rf_debug_dout),	
    .wa(rf_dr_add),		        
    .wd(rf_dr_data),		        
    .we(rf_wen)			            
);

// PC register
PC pc (
    .clk(clk),
    .wen(pc_wen),
    .din(pc_in),
    .dout(pc_out)
);

// Iter-segment Registers

IF_ID_REG if_id_reg(
    // signals
    .clk(clk),
    .rstn(rstn),
    .if_id_wen(if_id_en),
    // data
    .is_din(im_dout),
    .pc_din(pc_out),
    .is_dout(id_is),
    .pc_dout(id_pc)
);


ID_EX_REG id_ex_reg(
    // signals
    .clk(clk),
    .rstn(rstn),
    .clear(id_ex_clear),    // 1 is clear
    // data
    .is_din(id_is),
    .pc_din(id_pc),
    .imm_din(id_imm),
    .sr1_din(rf_sr1_data),
    .sr2_din(rf_sr2_data),
    .ctrl_ex_din({{4'b0}, {jalr_flag}, {control_signals[2:0]}, {control_signals[5:3]}, {control_signals[13:10]}}),   
    // 15-bit: 0000+ jalr_flag + sr1_mux + sr2_mux + alu_mode
    .ctrl_mem_din({{2'b0}, {control_signals[16]}, {control_signals[18]}}),       
    // 4-bit: 00 + dm_we + io_rd
    .ctrl_wb_din({{1'b0}, {control_signals[7:6]}, {control_signals[15]}}),     
    // 4-bit: 0 + rf_mux + rf_we
    .alu_ex_din(alu_ans),
    .alu_mem_din(mem_alu_ans),
    .npc_mem_din(mem_pc + 32'h4),
    .dm_mem_din(io_dm_mux_out),
    .sr_mux_din({{2'b0}, {npc_mux_sel}, {sr1_mux_sel_fh}, {sr2_mux_sel_fh}, {b_sr1_mux_sel_fh}, {b_sr2_mux_sel_fh}, {dm_sr2_mux_sel_fh}}),
    // 19-bit: 00 + npc_mux + sr1 + sr2 + b_sr1 + b_sr2 (fh) + dm_sr2
 
    .is_dout(ex_is),
    .pc_dout(ex_pc),
    .imm_dout(ex_imm),
    .sr1_dout(ex_sr1),
    .sr2_dout(ex_sr2),
    //.ctrl_ex_dout({{4'b0}, {ex_jalr_flag}, {ex_sr1_mux_sel_cu}, {ex_sr2_mux_sel_cu}, {alu_mode}}),
    .ctrl_ex_dout(ctrl_ex_dout),
    // 15-bit: 0000 + jalr_flag + sr1_mux + sr2_mux + alu_mode
    .ctrl_mem_dout(ex_ctrl_mem),
    .ctrl_wb_dout(ex_ctrl_wb),
    .alu_ex_dout(alu_ex),
    .alu_mem_dout(alu_mem),
    .npc_mem_dout(npc_mem),
    .dm_mem_dout(dm_mem),
    .sr_mux_dout(sr_mux_dout)
    // 19-bit: 00 + npc_mux + sr1 + sr2 + b_sr1 + b_sr2 (fh) + dm_sr2
);



//assign sr_mux_dout = {{2'b0}, {ex_npc_mux_sel}, {ex_sr1_mux_sel_fh}, {ex_sr2_mux_sel_fh}, {ex_b_sr1_mux_sel_fh}, {ex_b_sr2_mux_sel_fh}, {ex_dm_sr2_mux_sel_fh}};

EX_MEM_REG ex_mem_reg(
    // signals
    .clk(clk),
    .rstn(rstn),

    // data
    .is_din(ex_is),
    .pc_din(ex_pc),
    .ctrl_mem_din(ex_ctrl_mem),
    .ctrl_wb_din(ex_ctrl_wb),
    .alu_ans_din(alu_ans),
    .sr2_din(dm_sr2_mux_out),

    .is_dout(mem_is),
    .pc_dout(mem_pc),
    //.ctrl_mem_dout({{2'b0}, {dm_wen}, {io_rd}}),
    .ctrl_mem_dout(ctrl_mem_dout),
    // 4-bit: 00 + dm_we + io_rd
    .ctrl_wb_dout(mem_ctrl_wb),
    .alu_ans_dout(mem_alu_ans),
    .sr2_dout(mem_sr2)

);



MEM_WB_REG mem_wb_reg(
    // signals
    .clk(clk),
    .rstn(rstn),

    // data
    .is_din(mem_is),
    .pc_din(mem_pc),
    .ctrl_wb_din(mem_ctrl_wb),
    .alu_ans_din(mem_alu_ans),
    .dm_data_din(io_dm_mux_out),

    .is_dout(wb_is),
    .pc_dout(wb_pc),
    //.ctrl_wb_dout({{1'b0}, {rf_mux_sel}, {rf_wen}}),
    .ctrl_wb_dout(ctrl_wb_dout),
    // 4-bit: 0 + rf_mux + rf_we
    .alu_ans_dout(wb_alu_ans),
    .dm_data_dout(wb_dm_data)
);



// The control unit

Control #(25) cu(
    .instruction(id_is),
    .control_signal(control_signals)
);

// The sign extend unit

Signextend sext(
    .instruction(id_is),
    .imm(id_imm)
);

// The branch control
BranchCtrl bcu(
    .branch_sel(jump_ctrl),  // from control
    .jalr_flag(ex_jalr_flag),
    .sr1(b_sr1_mux_out), 
    .sr2(b_sr2_mux_out),
    .npcmux(npc_mux_sel)
);

// ALU

ALU #(32) alu (
    .num1(sr1_mux_out), 
    .num2(sr2_mux_out),               
    .mode_sel(alu_mode),                        
    .ans(alu_ans),                 
    .sub_flag(alu_subflag),                        
    .error(alu_error)                               
);


// MUXs

MUX2 #(32) io_dm_mux(
    .data1(dm_dout),
    .data2(io_din),
    .sel(io_dm_mux_sel),
    .out(io_dm_mux_out)
);

MUX4 #(32) npc_mux(
    .data1(pc_out + 32'd4),       
    .data2(id_pc + id_imm),       
    .data3(alu_ans),       
    .data4(zero),       
    .sel(npc_mux_sel),
    .out(pc_in)
);

MUX4 #(32) rf_mux(
    .data1(wb_alu_ans),
    .data2(wb_pc + 32'h4),
    .data3(wb_dm_data),
    .data4(zero),
    .sel(rf_mux_sel),
    .out(rf_dr_data)
);


MUX8 #(32) b_sr1_mux(
    .data1(rf_sr1_data),
    .data2(zero),
    .data3(zero),
    .data4(zero),
    .data5(alu_ex),
    .data6(alu_mem),
    .data7(dm_mem),
    .data8(npc_mem),
    .sel(b_sr1_mux_sel),
    .out(b_sr1_mux_out)
);

MUX8 #(32) b_sr2_mux(
    .data1(rf_sr2_data),
    .data2(zero),
    .data3(zero),
    .data4(zero),
    .data5(alu_ex),
    .data6(alu_mem),
    .data7(dm_mem),
    .data8(npc_mem),
    .sel(b_sr2_mux_sel),
    .out(b_sr2_mux_out)
);

MUX8 #(32) sr1_mux(
    .data1(ex_sr1),
    .data2(ex_pc),
    .data3(zero),
    .data4(zero),
    .data5(alu_ex),
    .data6(alu_mem),
    .data7(dm_mem),
    .data8(npc_mem),
    .sel(sr1_mux_sel),
    .out(sr1_mux_out)
);

MUX8 #(32) sr2_mux(
    .data1(ex_sr2),
    .data2(ex_imm),
    .data3(zero),
    .data4(zero),
    .data5(alu_ex),
    .data6(alu_mem),
    .data7(dm_mem),
    .data8(npc_mem),
    .sel(sr2_mux_sel),
    .out(sr2_mux_out)
);

MUX8 #(32) dm_sr2_mux(
    .data1(ex_sr2),
    .data2(zero),
    .data3(zero),
    .data4(zero),
    .data5(alu_ex),
    .data6(alu_mem),
    .data7(dm_mem),
    .data8(npc_mem),
    .sel(dm_sr2_mux_sel),
    .out(dm_sr2_mux_out)
);

// FH

Forwarding_Hazard fh(
    .id_is(id_is),
    .ex_is(ex_is),
    .mem_is(mem_is),
    .wb_is(wb_is),
    .npc_mux_sel(ex_npc_mux_sel),

    // forwarding
    .b_sr1_mux_sel_fh(b_sr1_mux_sel_fh),
    .b_sr2_mux_sel_fh(b_sr2_mux_sel_fh),
    .sr1_mux_sel_fh(sr1_mux_sel_fh),
    .sr2_mux_sel_fh(sr2_mux_sel_fh),
    .dm_sr2_mux_sel_fh(dm_sr2_mux_sel_fh),

    // hazard -- dealing with cpu's stop
    .pc_en(pc_wen),
    .if_id_en(if_id_en),
    .id_ex_clear(id_ex_clear)
);

// SR mux sel
SR_MUX_CTRL sr_mux_cu(
    .sr1_mux_sel_cu(ex_sr1_mux_sel_cu),
    .sr2_mux_sel_cu(ex_sr2_mux_sel_cu),
    .sr1_mux_sel_fh(ex_sr1_mux_sel_fh),
    .sr2_mux_sel_fh(ex_sr2_mux_sel_fh),

    .sr1_mux_sel(sr1_mux_sel),
    .sr2_mux_sel(sr2_mux_sel)
);

// Debuger
DEBUG debug(
    // Debug_BUS
    .chk_addr(chk_addr),	// debug address
    .chk_data(chk_data),  // debug data
    .chk_pc(chk_pc), 	// current pc

    // cpu info
    // IF PART
    .if_npc(pc_in),
    .if_pc(pc_out),
    .if_is(im_dout),

    // ID PART
    .id_pc(id_pc),
    .id_is(id_is),

    .id_ctrl(control_signals),

    .id_sr1_addr(rf_sr1_add),
    .id_sr2_addr(rf_sr2_add),
    .id_sr1(rf_sr1_data),
    .id_sr2(rf_sr2_data),
    .id_b_sr1(b_sr1_mux_out),
    .id_b_sr2(b_sr2_mux_out),
    .id_b_sr1_mux_sel(b_sr1_mux_sel),
    .id_b_sr2_mux_sel(b_sr2_mux_sel),

    .id_npc_mux_sel(npc_mux_sel),
    .id_imm(id_imm),
    .id_jalr_flag(jalr_flag),

    // EX PART
    .ex_pc(ex_pc),
    .ex_is(ex_is),

    .ex_sr1_mux_sel_cu(ex_sr1_mux_sel_cu),
    .ex_sr2_mux_sel_cu(ex_sr2_mux_sel_cu),
    .ex_sr1_mux_sel_fh(ex_sr1_mux_sel_fh),
    .ex_sr2_mux_sel_fh(ex_sr2_mux_sel_fh),
    .ex_dm_sr2_mux_sel(dm_sr2_mux_sel_fh),
    .ex_sr1_mux_sel(sr1_mux_sel),
    .ex_sr2_mux_sel(sr2_mux_sel),

    .ex_sr1(ex_sr1),
    .ex_sr2(ex_sr2),
    .ex_dm_sr2(dm_sr2_mux_out),

    .ex_alu_number1(sr1_mux_out),
    .ex_alu_number2(sr2_mux_out),
    .ex_alu_mode(alu_mode),
    .ex_alu_ans(alu_ans),

    .ex_alu_ex(alu_ex),
    .ex_alu_mem(alu_mem),
    .ex_dm_mem(dm_mem),
    .ex_npc_mem(npc_mem),

    .ex_ctrl_mem(ex_ctrl_mem),
    .ex_ctrl_wb(ex_ctrl_wb),
    .ex_npc_mux_sel(ex_npc_mux_sel),

    // MEM PART
    .mem_pc(mem_pc),
    .mem_is(mem_is),

    .mem_alu_ans(mem_alu_ans),
    .mem_sr2(mem_sr2),
    .mem_dm_wen(dm_wen),
    .mem_io_rd(io_rd),
    .mem_dm_dout(dm_dout),
    .mem_io_dout(io_din),
    .mem_io_dm_mux_sel(io_dm_mux_sel),
    
    // WB PART
    .wb_pc(wb_pc),
    .wb_is(wb_is),

    .wb_rf_mux_sel(rf_mux_sel),
    .wb_alu_ans(wb_alu_ans),
    .wb_dm_dout(wb_dm_data),
    .rf_write_addr(rf_dr_add),
    .rf_din(rf_dr_data),
    .rf_wen(rf_wen),

    // FH 
    .pc_wen(pc_wen),
    .if_id_is_wen(if_id_en),
    .id_ex_reg_clear(id_ex_clear),
    .sr1_mux_sel_fh(sr1_mux_sel_fh),
    .sr2_mux_sel_fh(sr2_mux_sel_fh),
    .b_sr1_mux_sel_fh(b_sr1_mux_sel_fh),
    .b_sr2_mux_sel_fh(b_sr2_mux_sel_fh),
    .dm_sr2_mux_sel_fh(dm_sr2_mux_sel_fh),

    // RF data
    .rf_debug_addr(rf_debug_din),
    .rf_debug_data(rf_debug_dout),

    // DM data
    .dm_debug_addr(dm_debug_din),
    .dm_debug_data(dm_debug_dout)
);

endmodule
