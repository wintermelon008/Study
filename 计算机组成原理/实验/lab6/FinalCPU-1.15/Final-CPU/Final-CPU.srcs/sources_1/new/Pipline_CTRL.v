`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 18:58:17
// Design Name: 
// Module Name: Pipline_CTRL
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
    ================================   Pipline_CTRL module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.9

    This is the PCU
    Function: 1. Solve the interrupt (with CSRs inside)
              2. Solve the data hazard (with the forwarding control, pipeline stop etc.)
*/

module Pipline_CTRL(
    input clk,    // 100Mhz
    input rstn,
    input [31:0] if_is, id_is, ex_is, mem_is, wb_is,
    input [31:0] if_pc, id_pc, ex_pc, mem_pc, wb_pc,
    input [2:0] ex_npc_mux_sel,
    input [3:0] error,
    input [31:0] error_info,
    input [31:0] error_pc,   

    output cpu_clk,
    output reg if_id_wen, id_ex_wen, ex_mem_wen, mem_wb_wen,
    output reg if_id_clear, id_ex_clear, ex_mem_clear, mem_wb_clear,
    output reg pc_wen,
    output [2:0] b_sr1_mux_sel_fh,
    output [2:0] b_sr2_mux_sel_fh,
    output [2:0] sr1_mux_sel_fh,
    output [2:0] sr2_mux_sel_fh,
    output [2:0] dm_sr2_mux_sel_fh
);

/*  ================================= CPU Interrupt table =================================

    1. User Interrupt (We make it as breakpoint)
    2. Divide by 0
    3. Memory access error
    4. Instruction decode error
    ......
*/

localparam No_Error = 4'h0;
localparam Breakpoint = 4'h1;
localparam Divide_By_Zero = 4'h2;
localparam Memory_Access_Error = 4'h3;
localparam Is_Decode_Error = 4'h4;


/*  ================================= PCU State machine table =================================

    1. Wait (CPU continue working)
    2. Set mtevc (CPU stop)
    3. Set mtval (CPU start working, clear the is between new pc and error pc)
    4. Set mepc
    5. Set mcause
    6. Wait for interrupt solveing program finish
    7. Reload PC (CPU stop)
    8. Wait(1.) (CPU continue working)
    ......
*/

localparam Reset = 4'h0;
localparam Wait = 4'h1;
localparam Set_mtevc = 4'h2;
localparam Set_mtval = 4'h3;
localparam Set_mepc = 4'h4;
localparam Set_mcause = 4'h5;
localparam Wait_done = 4'h6;
localparam Reload_PC = 4'h7;








wire if_id_en_fh, id_ex_clear_fh, pc_wen_fh;




// Below is the wires connection
assign cpu_clk = clk;
always @(*) begin
    if_id_wen = if_id_en_fh;
    id_ex_wen = 1'b1;
    ex_mem_wen = 1'b1;
    mem_wb_wen = 1'b1;

    if_id_clear = 1'b0;
    id_ex_clear = id_ex_clear_fh;
    ex_mem_clear = 1'b0;
    mem_wb_clear = 1'b0;

    pc_wen = pc_wen_fh;
end




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
    .pc_en(pc_wen_fh),
    .if_id_en(if_id_en_fh),
    .id_ex_clear(id_ex_clear_fh)
);

endmodule
