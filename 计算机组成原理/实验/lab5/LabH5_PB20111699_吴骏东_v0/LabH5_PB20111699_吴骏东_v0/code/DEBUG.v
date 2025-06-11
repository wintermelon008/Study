`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/22 16:48:45
// Design Name: 
// Module Name: DEBUG
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
    ================================  DEBUG module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.20

    This is the debug module
        input: checkaddr
        output: checkdata
    
*/

module DEBUG(
    // Debug_BUS
    input [15:0] chk_addr,	        // debug address
    output reg [31:0] chk_data,     // debug data
    output reg [31:0] chk_pc, 	    // current pc

    // CPU info
    input [31:0] if_pc,
    input [31:0] if_is,
    input [31:0] if_npc,
    input [31:0] id_pc,
    input [31:0] id_is,
    input [31:0] id_sr1_addr,
    input [31:0] id_sr2_addr,
    input [31:0] id_sr1,
    input [31:0] id_sr2,
    input [31:0] id_ctrl,
    input [31:0] id_b_sr1_mux_sel,
    input [31:0] id_b_sr2_mux_sel,
    input [31:0] id_b_sr1,
    input [31:0] id_b_sr2,
    input [31:0] id_npc_mux_sel,
    input [31:0] id_jalr_flag,
    input [31:0] id_imm,
    input [31:0] ex_pc,
    input [31:0] ex_is,
    input [31:0] ex_sr1_mux_sel_cu,
    input [31:0] ex_sr2_mux_sel_cu,
    input [31:0] ex_sr1_mux_sel_fh,
    input [31:0] ex_sr2_mux_sel_fh,
    input [31:0] ex_dm_sr2_mux_sel,
    input [31:0] ex_sr1_mux_sel,
    input [31:0] ex_sr2_mux_sel,
    input [31:0] ex_sr1,
    input [31:0] ex_sr2,
    input [31:0] ex_dm_sr2,
    input [31:0] ex_alu_ex,
    input [31:0] ex_alu_mem,
    input [31:0] ex_dm_mem,
    input [31:0] ex_npc_mem,
    input [31:0] ex_alu_number1,
    input [31:0] ex_alu_number2,
    input [31:0] ex_alu_mode,
    input [31:0] ex_alu_ans,
    input [31:0] ex_ctrl_mem,
    input [31:0] ex_ctrl_wb,
    input [31:0] ex_npc_mux_sel,
    input [31:0] mem_pc,
    input [31:0] mem_is,
    input [31:0] mem_alu_ans,
    input [31:0] mem_sr2,
    input [31:0] mem_io_dm_mux_sel,
    input [31:0] mem_dm_wen,
    input [31:0] mem_io_rd,
    input [31:0] mem_dm_dout,
    input [31:0] mem_io_dout,
    input [31:0] wb_pc,
    input [31:0] wb_is,
    input [31:0] wb_alu_ans,
    input [31:0] wb_dm_dout,
    input [31:0] wb_rf_mux_sel,
    input [31:0] rf_write_addr,
    input [31:0] rf_din,
    input [31:0] rf_wen,
    input [31:0] pc_wen,
    input [31:0] if_id_is_wen,
    input [31:0] id_ex_reg_clear,
    input [31:0] sr1_mux_sel_fh,
    input [31:0] sr2_mux_sel_fh,
    input [31:0] b_sr1_mux_sel_fh,
    input [31:0] b_sr2_mux_sel_fh,
    input [31:0] dm_sr2_mux_sel_fh,


    // RF data
    output reg [4:0] rf_debug_addr,
    input [31:0] rf_debug_data,

    // DM data
    output reg [7:0] dm_debug_addr,
    input [31:0] dm_debug_data
);
/*
    The debug address table
        check_address:
            0000 - if_pc
            0001 - if_is
            0002 - if_npc
            0003 - id_pc
            0004 - id_is
            0005 - id_sr1_addr
            0006 - id_sr2_addr
            0007 - id_sr1
            0008 - id_sr2
            0009 - id_ctrl
            000A - id_b_sr1_mux_sel
            000B - id_b_sr2_mux_sel
            000C - id_b_sr1
            000D - id_b_sr2
            000E - id_npc_mux_sel
            000F - id_jalr_flag
            0010 - id_imm
            0011 - ex_pc
            0012 - ex_is
            0013 - ex_sr1_mux_sel_cu
            0014 - ex_sr2_mux_sel_cu
            0015 - ex_sr1_mux_sel_fh
            0016 - ex_sr2_mux_sel_fh
            0017 - ex_dm_sr2_mux_sel
            0018 - ex_sr1_mux_sel
            0019 - ex_sr2_mux_sel
            001A - ex_sr1
            001B - ex_sr2
            001C - ex_dm_sr2
            001D - ex_alu_ex
            001E - ex_alu_mem
            001F - ex_dm_mem
            0020 - ex_npc_mem
            0021 - ex_alu_number1
            0022 - ex_alu_number2
            0023 - ex_alu_mode
            0024 - ex_alu_ans
            0025 - ex_ctrl_mem
            0026 - ex_ctrl_wb
            0027 - ex_npc_mux_sel
            0028 - mem_pc
            0029 - mem_is
            002A - mem_alu_ans
            002B - mem_sr2
            002C - mem_io_dm_mux_sel
            002D - mem_dm_wen
            002E - mem_io_rd
            002F - mem_dm_dout
            0030 - mem_io_dout
            0031 - wb_pc
            0032 - wb_is
            0033 - wb_alu_ans
            0034 - wb_dm_dout
            0035 - wb_rf_mux_sel
            0036 - rf_write_addr
            0037 - rf_din
            0038 - rf_wen
            0039 - pc_wen
            003A - if_id_is_wen
            003B - id_ex_reg_clear
            003C - sr1_mux_sel_fh
            003D - sr2_mux_sel_fh
            003E - b_sr1_mux_sel_fh
            003F - b_sr2_mux_sel_fh
            0040 - dm_sr2_mux_sel_fh
*/

always @(*) begin
    chk_pc = wb_pc;
    rf_debug_addr = chk_addr[4:0];
    dm_debug_addr = chk_addr[7:0];
end

always @(*) begin

    case (chk_addr[15:12]) 
        4'h0: begin
            case (chk_addr[11:0])
                12'h000: chk_data = if_pc;
                12'h001: chk_data = if_is;
                12'h002: chk_data = if_npc;
                12'h003: chk_data = id_pc;
                12'h004: chk_data = id_is;
                12'h005: chk_data = id_sr1_addr;
                12'h006: chk_data = id_sr2_addr;
                12'h007: chk_data = id_sr1;
                12'h008: chk_data = id_sr2;
                12'h009: chk_data = id_ctrl;
                12'h00A: chk_data = id_b_sr1_mux_sel;
                12'h00B: chk_data = id_b_sr2_mux_sel;
                12'h00C: chk_data = id_b_sr1;
                12'h00D: chk_data = id_b_sr2;
                12'h00E: chk_data = id_npc_mux_sel;
                12'h00F: chk_data = id_jalr_flag;
                12'h010: chk_data = id_imm;
                12'h011: chk_data = ex_pc;
                12'h012: chk_data = ex_is;
                12'h013: chk_data = ex_sr1_mux_sel_cu;
                12'h014: chk_data = ex_sr2_mux_sel_cu;
                12'h015: chk_data = ex_sr1_mux_sel_fh;
                12'h016: chk_data = ex_sr2_mux_sel_fh;
                12'h017: chk_data = ex_dm_sr2_mux_sel;
                12'h018: chk_data = ex_sr1_mux_sel;
                12'h019: chk_data = ex_sr2_mux_sel;
                12'h01A: chk_data = ex_sr1;
                12'h01B: chk_data = ex_sr2;
                12'h01C: chk_data = ex_dm_sr2;
                12'h01D: chk_data = ex_alu_ex;
                12'h01E: chk_data = ex_alu_mem;
                12'h01F: chk_data = ex_dm_mem;
                12'h020: chk_data = ex_npc_mem;
                12'h021: chk_data = ex_alu_number1;
                12'h022: chk_data = ex_alu_number2;
                12'h023: chk_data = ex_alu_mode;
                12'h024: chk_data = ex_alu_ans;
                12'h025: chk_data = ex_ctrl_mem;
                12'h026: chk_data = ex_ctrl_wb;
                12'h027: chk_data = ex_npc_mux_sel;
                12'h028: chk_data = mem_pc;
                12'h029: chk_data = mem_is;
                12'h02A: chk_data = mem_alu_ans;
                12'h02B: chk_data = mem_sr2;
                12'h02C: chk_data = mem_io_dm_mux_sel;
                12'h02D: chk_data = mem_dm_wen;
                12'h02E: chk_data = mem_io_rd;
                12'h02F: chk_data = mem_dm_dout;
                12'h030: chk_data = mem_io_dout;
                12'h031: chk_data = wb_pc;
                12'h032: chk_data = wb_is;
                12'h033: chk_data = wb_alu_ans;
                12'h034: chk_data = wb_dm_dout;
                12'h035: chk_data = wb_rf_mux_sel;
                12'h036: chk_data = rf_write_addr;
                12'h037: chk_data = rf_din;
                12'h038: chk_data = rf_wen;
                12'h039: chk_data = pc_wen;
                12'h03A: chk_data = if_id_is_wen;
                12'h03B: chk_data = id_ex_reg_clear;
                12'h03C: chk_data = sr1_mux_sel_fh;
                12'h03D: chk_data = sr2_mux_sel_fh;
                12'h03E: chk_data = b_sr1_mux_sel_fh;
                12'h03F: chk_data = b_sr2_mux_sel_fh;
                12'h040: chk_data = dm_sr2_mux_sel_fh;

                default: chk_data = 32'h0;
            endcase
        end

        4'h1: begin
            chk_data = rf_debug_data;
        end
        4'h2: begin
            chk_data = dm_debug_data;
        end
        default: chk_data = 32'h0;

    endcase
end
endmodule
