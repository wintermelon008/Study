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
    input [31:0] chk_addr,	        // debug address
    output reg [31:0] chk_data,     // debug data
    output reg [31:0] chk_pc, 	    // current pc

    // CPU info
//================================== IF PART ==================================
    input [31:0] if_pc,
    input [31:0] if_is,
    input [31:0] if_npc,
//================================== ID PART ==================================
    input [31:0] id_pc,
    input [31:0] id_is,
    input [31:0] id_sr1_addr,
    input [31:0] id_sr1_dout,
    input [31:0] id_sr2_addr,
    input [31:0] id_sr2_dout,
    input [31:0] id_dr_addr,
    input [31:0] id_dr_din,
    input [31:0] id_rfi_we,
    input [31:0] id_ctrl_jumpctrl,
    input [31:0] id_is_dr,
    input [31:0] id_b_sr1_mux_sel,
    input [31:0] id_b_sr2_mux_sel,
    input [31:0] id_b_sr1,
    input [31:0] id_b_sr2,
    input [31:0] id_npc_mux_sel,
    input [31:0] id_pc_offset,
    input [31:0] id_reg_offset,
    input [31:0] id_imm,
//================================== EX PART ==================================
    input [31:0] ex_pc,
    input [31:0] ex_is,
    input [31:0] ex_sr1,
    input [31:0] ex_sr2,
    input [31:0] ex_ccu_ex,
    input [31:0] ex_ccu_mem,
    input [31:0] ex_dmu_mem,
    input [31:0] ex_npc_mem,
    input [31:0] ex_sr1_mux_sel_cu,
    input [31:0] ex_sr2_mux_sel_cu,
    input [31:0] ex_sr1_mux_sel_fh,
    input [31:0] ex_sr2_mux_sel_fh,
    input [31:0] ex_dm_sr2_mux_sel,
    input [31:0] ex_sr1_mux_sel,
    input [31:0] ex_sr2_mux_sel,
    input [31:0] ex_ccu_number1,
    input [31:0] ex_ccu_number2,
    input [31:0] ex_ccu_mode,
    input [31:0] ex_ccu_fast_ans,
    input [31:0] ex_ccu_error,
//================================== MEM PART ==================================
    input [31:0] mem_pc,
    input [31:0] mem_is,
    input [31:0] mem_dmu_addr,
    input [31:0] mem_dmu_din,
    input [31:0] mem_dmu_dout,
    input [31:0] mem_dmu_rd,
    input [31:0] mem_dmu_we,
    input [31:0] mem_ccu_fast_ans,
    input [31:0] mem_ccu_slow_ans,
    input [31:0] mem_ccu_ans_mux_sel,
    input [31:0] mem_ccu_ans,
//================================== WB PART ==================================
    input [31:0] wb_pc,
    input [31:0] wb_is,
    input [31:0] wb_ccu_ans,
    input [31:0] wb_dmu_dout,
    input [31:0] wb_rfi_mux_sel,
    input [31:0] wb_rfi_dr_addr,
    input [31:0] wb_rfi_dr_din,
    input [31:0] wb_rfi_we,
//================================== PCU ==================================
    input [31:0] pc_wen,
    input [31:0] if_id_wen,
    input [31:0] id_ex_wen,
    input [31:0] ex_mem_wen,
    input [31:0] mem_wb_wen,
    input [31:0] if_id_clear,
    input [31:0] id_ex_clear,
    input [31:0] ex_mem_clear,
    input [31:0] mem_wb_clear,
    input [31:0] sr1_mux_sel_fh,
    input [31:0] sr2_mux_sel_fh,
    input [31:0] b_sr1_mux_sel_fh,
    input [31:0] b_sr2_mux_sel_fh,
    input [31:0] dm_sr2_mux_sel_fh,

    // RF data
    output reg [4:0] rf_debug_addr,
    input [31:0] rf_debug_data,

    // IMU data
    output reg [19:0] imu_debug_addr,
    input [31:0] imu_debug_data,

    // DMU data
    output reg [19:0] dmu_debug_addr,
    input [31:0] dmu_debug_data,

    // CSR data
    output reg [11:0] csr_debug_addr,
    input [31:0] csr_debug_data
);
/*
    The debug address table
        check_address:
*/

always @(*) begin
    chk_pc = id_pc;
    rf_debug_addr = chk_addr[4:0];
    imu_debug_addr = chk_addr[19:0];
    dmu_debug_addr = chk_addr[19:0];
    csr_debug_addr = chk_addr[11:0];
end

always @(*) begin

    case (chk_addr[19:16]) 
        4'h0: begin
            case (chk_addr[11:0])
//================================== IF PART ==================================
                12'h001: chk_data = if_pc;
                12'h002: chk_data = if_is;
                12'h003: chk_data = if_npc;
//================================== ID PART ==================================
                12'h005: chk_data = id_pc;
                12'h006: chk_data = id_is;
                12'h007: chk_data = id_sr1_addr;
                12'h008: chk_data = id_sr1_dout;
                12'h009: chk_data = id_sr2_addr;
                12'h00A: chk_data = id_sr2_dout;
                12'h00B: chk_data = id_dr_addr;
                12'h00C: chk_data = id_dr_din;
                12'h00D: chk_data = id_rfi_we;
                12'h00E: chk_data = id_ctrl_jumpctrl;
                12'h00F: chk_data = id_is_dr;
                12'h010: chk_data = id_b_sr1_mux_sel;
                12'h011: chk_data = id_b_sr2_mux_sel;
                12'h012: chk_data = id_b_sr1;
                12'h013: chk_data = id_b_sr2;
                12'h014: chk_data = id_npc_mux_sel;
                12'h015: chk_data = id_pc_offset;
                12'h016: chk_data = id_reg_offset;
                12'h017: chk_data = id_imm;
//================================== EX PART ==================================
                12'h019: chk_data = ex_pc;
                12'h01A: chk_data = ex_is;
                12'h01B: chk_data = ex_sr1;
                12'h01C: chk_data = ex_sr2;
                12'h01D: chk_data = ex_ccu_ex;
                12'h01E: chk_data = ex_ccu_mem;
                12'h01F: chk_data = ex_dmu_mem;
                12'h020: chk_data = ex_npc_mem;
                12'h021: chk_data = ex_sr1_mux_sel_cu;
                12'h022: chk_data = ex_sr2_mux_sel_cu;
                12'h023: chk_data = ex_sr1_mux_sel_fh;
                12'h024: chk_data = ex_sr2_mux_sel_fh;
                12'h025: chk_data = ex_dm_sr2_mux_sel;
                12'h026: chk_data = ex_sr1_mux_sel;
                12'h027: chk_data = ex_sr2_mux_sel;
                12'h028: chk_data = ex_ccu_number1;
                12'h029: chk_data = ex_ccu_number2;
                12'h02A: chk_data = ex_ccu_mode;
                12'h02B: chk_data = ex_ccu_fast_ans;
                12'h02C: chk_data = ex_ccu_error;
//================================== MEM PART ==================================
                12'h02E: chk_data = mem_pc;
                12'h02F: chk_data = mem_is;
                12'h030: chk_data = mem_dmu_addr;
                12'h031: chk_data = mem_dmu_din;
                12'h032: chk_data = mem_dmu_dout;
                12'h033: chk_data = mem_dmu_rd;
                12'h034: chk_data = mem_dmu_we;
                12'h035: chk_data = mem_ccu_fast_ans;
                12'h036: chk_data = mem_ccu_slow_ans;
                12'h037: chk_data = mem_ccu_ans_mux_sel;
                12'h038: chk_data = mem_ccu_ans;
//================================== WB PART ==================================
                12'h03A: chk_data = wb_pc;
                12'h03B: chk_data = wb_is;
                12'h03C: chk_data = wb_ccu_ans;
                12'h03D: chk_data = wb_dmu_dout;
                12'h03E: chk_data = wb_rfi_mux_sel;
                12'h03F: chk_data = wb_rfi_dr_addr;
                12'h040: chk_data = wb_rfi_dr_din;
                12'h041: chk_data = wb_rfi_we;
//================================== PCU ==================================
                12'h043: chk_data = pc_wen;
                12'h044: chk_data = if_id_wen;
                12'h045: chk_data = id_ex_wen;
                12'h046: chk_data = ex_mem_wen;
                12'h047: chk_data = mem_wb_wen;
                12'h048: chk_data = if_id_clear;
                12'h049: chk_data = id_ex_clear;
                12'h04A: chk_data = ex_mem_clear;
                12'h04B: chk_data = mem_wb_clear;
                12'h04C: chk_data = sr1_mux_sel_fh;
                12'h04D: chk_data = sr2_mux_sel_fh;
                12'h04E: chk_data = b_sr1_mux_sel_fh;
                12'h04F: chk_data = b_sr2_mux_sel_fh;
                12'h050: chk_data = dm_sr2_mux_sel_fh;
                default: chk_data = 32'h0;
            endcase
        end
 
        4'h1: begin
            chk_data = rf_debug_data;
        end
        4'h2: begin // User program memory
            chk_data = imu_debug_data;
        end
        4'h3: begin // Interrupt solve program memory
            chk_data = imu_debug_data;
        end
        4'h4: begin // User data memory
            chk_data = dmu_debug_data;
        end
        4'h5: begin // User stack
            chk_data = dmu_debug_data;
        end
        4'h6: begin // CSR
            chk_data = csr_debug_data;
        end
        default: chk_data = 32'h0;
 
    endcase
end
endmodule
