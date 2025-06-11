`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/22 14:47:00
// Design Name: 
// Module Name: SR_MUX_CTRL
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
    ================================  SR_MUX_CTRL module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.22

    This is the module for sr1_mux and sr2_mux control signals
    
*/

module SR_MUX_CTRL(
    input [2:0] sr1_mux_sel_cu,
    input [2:0] sr2_mux_sel_cu,
    input [2:0] sr1_mux_sel_fh,
    input [2:0] sr2_mux_sel_fh,

    output reg [2:0] sr1_mux_sel,
    output reg [2:0] sr2_mux_sel
);

// Below is the mux_sel list
    localparam NO_FORWARD = 3'b000;
    localparam ALU_EX = 3'b100;
    localparam ALU_MEM = 3'b101;
    localparam DM_MEM = 3'b110;
    localparam NPC = 3'b111;

    always @(*) begin
        if (sr1_mux_sel_fh[2] == 1'b1)
            sr1_mux_sel = sr1_mux_sel_fh;
        else
            sr1_mux_sel = sr1_mux_sel_cu;
    end

    always @(*) begin
        if (sr2_mux_sel_fh[2] == 1'b1)
            sr2_mux_sel = sr2_mux_sel_fh;
        else
            sr2_mux_sel = sr2_mux_sel_cu;
    end
    
endmodule
