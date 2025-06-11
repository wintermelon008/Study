`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/07 22:19:21
// Design Name: 
// Module Name: BranchCtrl
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
    ================================   BranchCtrl module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.21

    This is the branch control unit
    Add the function of comparing 2 numbers
*/


module BranchCtrl(
    input [3:0] branch_sel,
    input jalr_flag,
    input [31:0] sr1, sr2,
    output reg [1:0] npcmux
);


/* Branchsel Meaning Table
    NPC (pc + 4)            ---- 0
    OFFPC (pc + offset)     ---- 1
    NEQ (not equal)         ---- 2
    EQ (equal)              ---- 3
    SLT (sign less than)    ---- 4
    ULT (unsign less than)  ---- 5
    JALR (jalr)             ---- 6
*/

localparam NPC = 4'h0;
localparam OFFPC = 4'h1;
localparam NEQ = 4'h2;
localparam EQ = 4'h3;
localparam SLT = 4'h4;
localparam ULT = 4'h5;
//localparam JALR = 4'h6;

wire equal, sign_less_than, unsign_less_than;

assign equal = (sr1 == sr2 ? 1 : 0); 
assign sign_less_than = ((sr1[31] == 1 && sr2[31] == 0) || 
                          (sr1[31] == sr2[31] && sr1 < sr2)) ? 1 : 0;  
assign unsign_less_than = ((sr1[31] == 0 && sr2[31] == 1) || 
                          (sr1[31] == sr2[31] && sr1 < sr2)) ? 1 : 0;

always @(*) begin
    if (jalr_flag == 1) begin
        npcmux = 2'b10;
    end
    else begin
        case (branch_sel) 
            NPC: npcmux = 2'b00;
            OFFPC: npcmux = 2'b01;
            EQ: begin
                if (equal)
                    npcmux = 2'b01;
                else
                    npcmux = 2'b00;
            end

            NEQ: begin
                if (~equal)
                    npcmux = 2'b01;
                else
                    npcmux = 2'b00;
            end

            SLT: begin
                if (sign_less_than)
                    npcmux = 2'b01;
                else
                    npcmux = 2'b00;
            end

            ULT: begin
                if (unsign_less_than)
                    npcmux = 2'b01;
                else
                    npcmux = 2'b00;
            end

            default: begin
                npcmux = 2'b00;
            end
        endcase
    end
end

endmodule
