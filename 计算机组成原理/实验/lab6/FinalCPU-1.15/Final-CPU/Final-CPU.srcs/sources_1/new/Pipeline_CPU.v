`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 15:54:07
// Design Name: 
// Module Name: Pipeline_CPU
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
    ================================  Pipeline_CPU module   ================================
    Author:         Wintermelon
    Version:        1.1.5
    Last Edit:      2022.5.9

    This is the cpu topmodule for Pipeline

    Used sub-modules:
        * CCU
        * IMU
        * DMU
        * REG_FILE
        * Control
        * BranchCtrl
        * Signextend
        * PCU
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

// ### Version 1.1.5 update ###
// Change the CPU memory structure
// Add the user stack, interrupt program memory

// ### Version 1.1.2 update ###
// Bugs fixed: MDU mux_sel delay

// ### Version 1.1.0 update ###
// Changes for RISCV 32I basic, M & B extension CPU

// ### Version 1.0.8 update ###
// Big changes to datapath

// ### Version 1.0.4 update ###
// Add multiplier for datapath
// Change the data width
// Change some pins

/* ============================================ CPU Memory List ============================================
    User data: From 0x0000 - 0x2BFC (2816 x 32bit) 
                00 0000 0000 0000 00 -> 0000 0000 0000
                00 1010 1111 1111 00 -> 1010 1111 1111

    User stack: From 0x2C00 - 0x2FFC (256 x 32bit)
                0010 11 0000 0000 00 -> 0000 0000
                0010 11 1111 1111 00 -> 1111 1111
    
    User program: From 0x3000 - 0x4FFC (2048 x 32bit)
                00 1100 0000 0000 00 -> 0000 0000 0000
                01 0011 1111 1111 00 -> 0111 1111 1111

    Interrupt program: From 0xF000 - 0xFEFC (960 x 32bit)
                11 11 00 0000 0000 00 -> 00 0000 0000
                11 11 11 1011 1111 00 -> 11 1011 1111

    I/O devices: From 0xFF00 - 0xFFFC
*/

module Pipeline_CPU(
    // cpu control form PDU
    input sys_clk, 
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
wire clk;

// Memorys
wire [15:0] imu_addr;
wire [31:0] imu_dout;
wire [15:0] dmu_addr;
wire [31:0] dmu_din, dmu_dout;
wire dmu_we, dmu_rd;

// RFI
wire [4:0] rfi_sr1_add, rfi_sr2_add, rfi_dr_add;
wire [31:0] rfi_sr1_data, rfi_sr2_data, rfi_dr_data;
wire rfi_wen;

// PC register
wire [31:0] pc_in, pc_out;
wire pc_wen;
wire [31:0] pc_offset, reg_offset;

// Iter-segment Registers
wire [31:0] if_pc;
// ID part
wire [15:0] id_ctrl_ex;
wire [3:0] id_ctrl_mem;
wire [7:0] id_ctrl_wb;
wire [23:0] id_mux_sel;
wire [31:0] id_rf_dr, id_is, id_pc, id_imm;
// EX part
wire [3:0] ex_ctrl_mem;
wire [7:0] ex_ctrl_wb;
wire [31:0] ex_is, ex_pc, ex_imm, ex_sr1, ex_sr2, ex_sr3, ex_dr;
wire [31:0] ccu_ex, ccu_mem, dmu_mem, npc_mem;           // Forward
wire [1:0] ex_npc_mux_sel;
// MEM part
wire [7:0] mem_ctrl_wb;
wire [31:0] mem_is, mem_pc, mem_ccu_fast_ans, mem_dmu_data, mem_dmu_addr, mem_dr;
// WB part
wire [31:0] wb_is, wb_pc, wb_ccu_ans, wb_dmu_dout, wb_csr, wb_dr;

wire [18:0] sr_mux_dout;
wire [14:0] ctrl_ex_dout;
wire [3:0] ctrl_mem_dout;
wire [3:0] ctrl_wb_dout;

// CU
wire [34:0] control_signals;
wire [3:0] jump_ctrl;
wire [2:0] sr1_mux_sel_cu, sr2_mux_sel_cu;
wire [2:0] ex_sr1_mux_sel_cu, ex_sr2_mux_sel_cu;

// CCU
wire [31:0] ccu_fast_ans, ccu_slow_ans;
wire [3:0] ccu_error;
wire [7:0] ccu_mode;
wire [31:0] ccu_ans;


// MUXs
// npc-mux & rf(WB)-mux
wire [1:0] npc_mux_sel;
wire [2:0] rf_mux_sel;
// b-sr-mux
wire [2:0] b_sr1_mux_sel, b_sr2_mux_sel;
wire [31:0] b_sr1_mux_out, b_sr2_mux_out;
// sr-mux
wire [2:0] sr1_mux_sel, sr2_mux_sel, sr3_mux_sel, dm_sr2_mux_sel;
wire [31:0] sr1_mux_out, sr2_mux_out, sr3_mux_out, dm_sr2_mux_out;

// ccu-ans-mux
wire ccu_ans_mux_sel;


// FH
wire [2:0] b_sr1_mux_sel_fh, b_sr2_mux_sel_fh, sr1_mux_sel_fh, sr2_mux_sel_fh, dm_sr2_mux_sel_fh;
wire [2:0] ex_b_sr1_mux_sel_fh, ex_b_sr2_mux_sel_fh, ex_sr1_mux_sel_fh, ex_sr2_mux_sel_fh, ex_dm_sr2_mux_sel_fh;

// Pipeline  unit
wire if_id_wen, id_ex_wen, ex_mem_wen, mem_wb_wen;
wire if_id_clear, id_ex_clear, ex_mem_clear, mem_wb_clear;

// Debug data lines
wire [19:0] imu_debug_addr;
wire [31:0] imu_debug_dout;
wire [19:0] dmu_debug_addr;
wire [31:0] dmu_debug_dout;
wire [4:0] rfi_debug_add;
wire [31:0] rfi_debug_data;
// wire [4:0] rff_debug_add;
// wire [31:0] rff_debug_data;

// Below is the wires and regs connection ===========================================================================================
initial begin
    zero <= 32'b0;
    one <= 1'b1;
end

// Below is the memory and register-files connection:
assign rfi_sr1_add = id_is[19:15];
assign rfi_sr2_add = id_is[24:20];
assign rfi_dr_add = wb_dr[4:0];
assign imu_addr = pc_out[15:0];
assign dmu_addr = mem_dmu_addr[15:0];
assign dmu_din = mem_dmu_data;

/*===================================== Control Unit signals table =====================================
    control_signals - 35 bit
    
    MUX Ctrl signal:
        control_signals[2:0] - alu-sr1mux (3)
        control_signals[5:3] - alu-sr2mux (3)
        control_signals[8:6] - rfmux (3)
        control_signals[9] - rf-sr1mux (1)
        control_signals[10] - rf-sr2mux (1)
        control_signals[11] - ccu-ansmux (1)

    CCU mode signal:
        control_signals[21:14] - alumode (8)

    Regfile writing enable:
        control_signals[24] - rfi_we (1)

    Data memory unit reading and writing enable:
        control_signals[27] - dm_we (1)
        control_signals[28] - dmu_rd (1)

    B & J control signal:
        control_signals[33:30] - jump_ctrl (4)

*/ //===================================================================================================
// CTRL-EX (00 + sr1mux(3), sr2mux(3), alumode(8))
// CTRL-MEM (0 + ccu_ans_mux(1) + dmwe(1), dmrd(1))
// CTRL-WB (0000 + rfmux(3), rffwe(1))
// MUX-SEL (0000000 + sr1(3), sr2(3), bsr1(3), bsr2(3), dsr2(3), npc(2))

// Below is the control signals connection (ID)
assign id_ctrl_ex = {{2'b0}, {control_signals[2:0]}, {control_signals[5:3]}, {control_signals[21:14]}};
assign id_ctrl_mem = {{1'b0}, {control_signals[11]}, {control_signals[27]}, {control_signals[28]}};
assign id_ctrl_wb = {{4'b0}, {control_signals[8:6]}, {control_signals[24]}};
assign id_mux_sel = {{7'b0}, {sr1_mux_sel_fh}, {sr2_mux_sel_fh}, {b_sr1_mux_sel_fh}, {b_sr2_mux_sel_fh}, {dm_sr2_mux_sel_fh}, {npc_mux_sel}};
assign jump_ctrl = control_signals[33:30];
assign id_rf_dr = {{27'b0}, {id_is[11:7]}};

// Below is the control signals connection (EX)
// CTRL-EX (00 + sr1mux(3), sr2mux(3), alumode(8))
assign ex_sr1_mux_sel_cu = ctrl_ex_dout[13:11];
assign ex_sr2_mux_sel_cu = ctrl_ex_dout[10:8];
assign ccu_mode = ctrl_ex_dout[7:0];

// Below is the control signals connection (MEM)
// CTRL-MEM (0 + ccu_ans_mux(1) + dmwe(1), dmrd(1))
assign ccu_ans_mux_sel = ctrl_mem_dout[2];
assign dmu_we = ctrl_mem_dout[1];
assign dmu_rd = ctrl_mem_dout[0];

// Below is the control signals connection (WB)
// CTRL-WB (0000 + rfmux(3), rffwe(1))
assign rf_mux_sel = ctrl_wb_dout[3:1];
assign rfi_wen = ctrl_wb_dout[0];

// Below is the EX part mux-sel connection
// MUX-SEL (0000000 + sr1(3), sr2(3), bsr1(3), bsr2(3), dsr2(3), npc(2))
assign ex_sr1_mux_sel_fh = sr_mux_dout[16:14];
assign ex_sr2_mux_sel_fh = sr_mux_dout[13:11];
assign ex_b_sr1_mux_sel_fh = sr_mux_dout[10:8];
assign ex_b_sr2_mux_sel_fh = sr_mux_dout[7:5];
assign ex_dm_sr2_mux_sel_fh = sr_mux_dout[4:2];
assign ex_npc_mux_sel = sr_mux_dout[1:0];

// Below is the MUX SEL connection
assign b_sr1_mux_sel = ex_b_sr1_mux_sel_fh;
assign b_sr2_mux_sel = ex_b_sr2_mux_sel_fh;
assign dm_sr2_mux_sel = ex_dm_sr2_mux_sel_fh;

assign if_pc = pc_out;



// Below is the sub-module declaration ==============================================================================================

// Memorys
IM_UNIT imu(
    .clk(clk),
// DATA
    .imu_addr(imu_addr),
    .imu_dout(imu_dout),

// DEBUG
    .debug_addr(imu_debug_addr),
    .debug_dout(imu_debug_dout)
);


DM_UNIT dmu(
// SIGNALS
    .clk(clk),
    .rd(dmu_rd),   // read enable
    .we(dmu_we),   // write enable

// DATA
    .dmu_addr(dmu_addr),
    .dmu_din(dmu_din),
    .dmu_dout(dmu_dout),

// IO_BUS
    .io_addr(io_addr),	// I/O address
    .io_dout(io_dout),	// I/O data output
    .io_we(io_we),		    // I/O write enable
    .io_rd(io_rd),		    // I/O read enable
    .io_din(io_din),	// I/O data input

// DEBUG
    .debug_addr(dmu_debug_addr),
    .debug_dout(dmu_debug_dout)
);

// Reg file
REG_FILE_I rfi (
    .clk(clk),			           
    .ra0(rfi_sr1_add), 
    .ra1(rfi_sr2_add), 
    .ra2(rfi_debug_add),	
    .rd0(rfi_sr1_data), 
    .rd1(rfi_sr2_data), 
    .rd2(rfi_debug_data),	
    .wa(rfi_dr_add),		        
    .wd(rfi_dr_data),		        
    .we(rfi_wen)			            
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
    .wen(if_id_wen),
    .clear(if_id_clear),

    // data
    .is_din(imu_dout),
    .pc_din(pc_out),

    .is_dout(id_is),
    .pc_dout(id_pc)
);

ID_EX_REG id_ex_reg(
    // signals
    .clk(clk),
    .rstn(rstn),
    .wen(id_ex_wen),
    .clear(id_ex_clear),   

    // data
    .is_din(id_is),
    .pc_din(id_pc),
    .imm_din(id_imm),
    .sr1_din(rfi_sr1_data),
    .sr2_din(rfi_sr2_data),
    .dr_din(id_rf_dr),
    .ctrl_ex_din(id_ctrl_ex),
    .ctrl_mem_din(id_ctrl_mem),       
    .ctrl_wb_din(id_ctrl_wb),     
    .ccu_ex_din(ccu_fast_ans),
    .ccu_mem_din(ccu_ans),
    .npc_mem_din(mem_pc + 32'h4),
    .dm_mem_din(dmu_dout),
    .mux_sel_din(id_mux_sel),
 
    .is_dout(ex_is),
    .pc_dout(ex_pc),
    .imm_dout(ex_imm),
    .sr1_dout(ex_sr1),
    .sr2_dout(ex_sr2),
    .dr_dout(ex_dr),
    .ctrl_ex_dout(ctrl_ex_dout),
    .ctrl_mem_dout(ex_ctrl_mem),
    .ctrl_wb_dout(ex_ctrl_wb),
    .ccu_ex_dout(ccu_ex),
    .ccu_mem_dout(ccu_mem),
    .npc_mem_dout(npc_mem),
    .dm_mem_dout(dmu_mem),
    .mux_sel_dout(sr_mux_dout)
);

EX_MEM_REG ex_mem_reg(
    // signals
    .clk(clk),
    .rstn(rstn),
    .wen(ex_mem_wen),
    .clear(ex_mem_clear),

    // data
    .is_din(ex_is),
    .pc_din(ex_pc),
    .ctrl_mem_din(ex_ctrl_mem),
    .ctrl_wb_din(ex_ctrl_wb),
    .alu_ans_din(ccu_fast_ans),
    .dm_addr_din(sr1_mux_out + sr2_mux_out),
    .dm_data_din(dm_sr2_mux_out),
    .dr_din(ex_dr),

    .is_dout(mem_is),
    .pc_dout(mem_pc),
    .ctrl_mem_dout(ctrl_mem_dout),
    .ctrl_wb_dout(mem_ctrl_wb),
    .alu_ans_dout(mem_ccu_fast_ans),
    .dm_addr_dout(mem_dmu_addr),
    .dm_data_dout(mem_dmu_data),
    .dr_dout(mem_dr)

);

MEM_WB_REG mem_wb_reg(
    // signals
    .clk(clk),
    .rstn(rstn),
    .wen(mem_wb_wen),
    .clear(mem_wb_clear),

    // data
    .is_din(mem_is),
    .pc_din(mem_pc),
    .ctrl_wb_din(mem_ctrl_wb),
    .alu_ans_din(ccu_ans),
    .mdr_din(dmu_dout),
    .csr_din(),
    .dr_din(mem_dr),

    .is_dout(wb_is),
    .pc_dout(wb_pc),
    .ctrl_wb_dout(ctrl_wb_dout),
    .alu_ans_dout(wb_ccu_ans),
    .mdr_dout(wb_dmu_dout),
    .csr_dout(),
    .dr_dout(wb_dr)
);



// The control unit
Control #(35) cu(
    .instruction(id_is),
    .control_signals(control_signals)
);

// The sign extend unit

Signextend sext(
    .instruction(id_is),
    .imm(id_imm)
);

// The branch control
Branch_CTRL bcu(
    .branch_sel(jump_ctrl),
    .sr1(b_sr1_mux_out), 
    .sr2(b_sr2_mux_out),
    .imm(id_imm),
    .pc(id_pc),
    .npc_mux_sel(npc_mux_sel),
    .pc_offset(pc_offset), 
    .reg_offset(reg_offset)
);

// CCU

CalculateUnit ccu(
    .clk(clk),

    .number1(sr1_mux_out),
    .number2(sr2_mux_out),
    .mode(ccu_mode),

    .fast_answer(ccu_fast_ans),
    .slow_answer(ccu_slow_ans),      // After a clock cycle
    .error(ccu_error)
);

// PCU
Pipline_CTRL pcu(
    .clk(sys_clk),    // 100Mhz
    .rstn(rstn),
    .if_is(imu_dout), 
    .id_is(id_is), 
    .ex_is(ex_is), 
    .mem_is(mem_is), 
    .wb_is(wb_is),
    .if_pc(pc_out), 
    .id_pc(id_pc), 
    .ex_pc(ex_pc), 
    .mem_pc(mem_pc), 
    .wb_pc(wb_pc),
    .ex_npc_mux_sel(ex_npc_mux_sel),
    .error(ccu_error),

    .cpu_clk(clk),
    .if_id_wen(if_id_wen), 
    .id_ex_wen(id_ex_wen), 
    .ex_mem_wen(ex_mem_wen), 
    .mem_wb_wen(mem_wb_wen),
    .if_id_clear(if_id_clear), 
    .id_ex_clear(id_ex_clear), 
    .ex_mem_clear(ex_mem_clear), 
    .mem_wb_clear(mem_wb_clear),
    .pc_wen(pc_wen),
    .b_sr1_mux_sel_fh(b_sr1_mux_sel_fh),
    .b_sr2_mux_sel_fh(b_sr2_mux_sel_fh),
    .sr1_mux_sel_fh(sr1_mux_sel_fh),
    .sr2_mux_sel_fh(sr2_mux_sel_fh),
    .dm_sr2_mux_sel_fh(dm_sr2_mux_sel_fh)
);


// MUXs

MUX2 #(32) ccu_ans_mux(
    .data1(mem_ccu_fast_ans),
    .data2(ccu_slow_ans),
    .sel(ccu_ans_mux_sel),
    .out(ccu_ans)
);


MUX4 #(32) npc_mux(
    .data1(pc_out + 32'd4),       
    .data2(pc_offset),       
    .data3(reg_offset),       
    .data4(32'h0),       
    .sel(npc_mux_sel),
    .out(pc_in)
);

MUX8 #(32) rf_mux(
    .data1(wb_ccu_ans),
    .data2(wb_pc + 32'h4),
    .data3(wb_dmu_dout),
    .data4(zero),
    .data5(zero),
    .data6(zero),
    .data7(zero),
    .data8(32'b1),
    .sel(rf_mux_sel),
    .out(rfi_dr_data)
);


MUX8 #(32) b_sr1_mux(
    .data1(rfi_sr1_data),
    .data2(zero),
    .data3(zero),
    .data4(zero),
    .data5(ccu_ex),
    .data6(ccu_mem),
    .data7(dmu_mem),
    .data8(npc_mem),
    .sel(b_sr1_mux_sel),
    .out(b_sr1_mux_out)
);

MUX8 #(32) b_sr2_mux(
    .data1(rfi_sr2_data),
    .data2(zero),
    .data3(zero),
    .data4(zero),
    .data5(ccu_ex),
    .data6(ccu_mem),
    .data7(dmu_mem),
    .data8(npc_mem),
    .sel(b_sr2_mux_sel),
    .out(b_sr2_mux_out)
);

MUX8 #(32) sr1_mux(
    .data1(ex_sr1),
    .data2(ex_pc),
    .data3(zero),
    .data4(zero),
    .data5(ccu_ex),
    .data6(ccu_mem),
    .data7(dmu_mem),
    .data8(npc_mem),
    .sel(sr1_mux_sel),
    .out(sr1_mux_out)
);

MUX8 #(32) sr2_mux(
    .data1(ex_sr2),
    .data2(ex_imm),
    .data3(zero),
    .data4(zero),
    .data5(ccu_ex),
    .data6(ccu_mem),
    .data7(dmu_mem),
    .data8(npc_mem),
    .sel(sr2_mux_sel),
    .out(sr2_mux_out)
);


MUX8 #(32) dm_sr2_mux(
    .data1(ex_sr2),
    .data2(zero),
    .data3(zero),
    .data4(zero),
    .data5(ccu_ex),
    .data6(ccu_mem),
    .data7(dmu_mem),
    .data8(npc_mem),
    .sel(dm_sr2_mux_sel),
    .out(dm_sr2_mux_out)
);





// SR1&2 mux sel
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
    .chk_addr(chk_addr),    // debug address
    .chk_data(chk_data),    // debug data
    .chk_pc(chk_pc),        // current pc

    // DataPath state
//================================== IF PART ==================================
    .if_pc(pc_in),
    .if_is(pc_out),
    .if_npc(imu_dout),
//================================== ID PART ==================================
    .id_pc(id_pc),
    .id_is(id_is),
    .id_sr1_addr(rfi_sr1_add),
    .id_sr1_dout(rfi_sr1_data),
    .id_sr2_addr(rfi_sr2_add),
    .id_sr2_dout(rfi_sr2_data),
    .id_dr_addr(rfi_dr_add),
    .id_dr_din(rfi_dr_data),
    .id_rfi_we(rfi_wen),
    .id_ctrl_jumpctrl(jump_ctrl),
    .id_is_dr(id_rf_dr),
    .id_b_sr1_mux_sel(b_sr1_mux_sel),
    .id_b_sr2_mux_sel(b_sr2_mux_sel),
    .id_b_sr1(b_sr1_mux_out),
    .id_b_sr2(b_sr2_mux_out),
    .id_npc_mux_sel(npc_mux_sel),
    .id_pc_offset(pc_offset),
    .id_reg_offset(reg_offset),
    .id_imm(id_imm),
//================================== EX PART ==================================
    .ex_pc(ex_pc),
    .ex_is(ex_is),
    .ex_sr1(ex_sr1),
    .ex_sr2(ex_sr2),
    .ex_ccu_ex(ccu_ex),
    .ex_ccu_mem(ccu_mem),
    .ex_dmu_mem(dmu_mem),
    .ex_npc_mem(npc_mem),
    .ex_sr1_mux_sel_cu(ex_sr1_mux_sel_cu),
    .ex_sr2_mux_sel_cu(ex_sr2_mux_sel_cu),
    .ex_sr1_mux_sel_fh(ex_sr1_mux_sel_fh),
    .ex_sr2_mux_sel_fh(ex_sr2_mux_sel_fh),
    .ex_dm_sr2_mux_sel(dm_sr2_mux_sel),
    .ex_sr1_mux_sel(sr1_mux_sel),
    .ex_sr2_mux_sel(sr2_mux_sel),
    .ex_ccu_number1(sr1_mux_out),
    .ex_ccu_number2(sr2_mux_out),
    .ex_ccu_mode(ccu_mode),
    .ex_ccu_fast_ans(ccu_fast_ans),
    .ex_ccu_error(ccu_error),
//================================== MEM PART ==================================
    .mem_pc(mem_pc),
    .mem_is(mem_is),
    .mem_dmu_addr(dmu_addr),
    .mem_dmu_din(dmu_din),
    .mem_dmu_dout(dmu_dout),
    .mem_dmu_rd(dmu_rd),
    .mem_dmu_we(dmu_we),
    .mem_ccu_fast_ans(mem_ccu_fast_ans),
    .mem_ccu_slow_ans(ccu_slow_ans),
    .mem_ccu_ans_mux_sel(ccu_ans_mux_sel),
    .mem_ccu_ans(ccu_ans),
//================================== WB PART ==================================
    .wb_pc(wb_pc),
    .wb_is(wb_is),
    .wb_ccu_ans(wb_ccu_ans),
    .wb_dmu_dout(wb_dmu_dout),
    .wb_rfi_mux_sel(rf_mux_sel),
    .wb_rfi_dr_addr(rfi_dr_add),
    .wb_rfi_dr_din(rfi_dr_data),
    .wb_rfi_we(rfi_wen),
//================================== PCU ==================================
    .pc_wen(pc_wen),
    .if_id_wen(if_id_wen),
    .id_ex_wen(id_ex_wen),
    .ex_mem_wen(ex_mem_wen),
    .mem_wb_wen(mem_wb_wen),
    .if_id_clear(if_id_clear),
    .id_ex_clear(id_ex_clear),
    .ex_mem_clear(ex_mem_clear),
    .mem_wb_clear(mem_wb_clear),
    .sr1_mux_sel_fh(sr1_mux_sel_fh),
    .sr2_mux_sel_fh(sr2_mux_sel_fh),
    .b_sr1_mux_sel_fh(b_sr1_mux_sel_fh),
    .b_sr2_mux_sel_fh(b_sr2_mux_sel_fh),
    .dm_sr2_mux_sel_fh(dm_sr2_mux_sel_fh),

    // RF data
    .rf_debug_addr(rfi_debug_add),
    .rf_debug_data(rfi_debug_data),

    // IMU data
    .imu_debug_addr(imu_debug_addr),
    .imu_debug_data(imu_debug_dout),

    // DMU data
    .dmu_debug_addr(dmu_debug_addr),
    .dmu_debug_data(dmu_debug_dout)
);

endmodule
