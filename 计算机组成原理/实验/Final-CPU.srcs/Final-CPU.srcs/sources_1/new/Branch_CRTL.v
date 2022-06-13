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
    ================================   Branch_CTRL module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.5

    This is the branch control unit
    Add the function of comparing 2 numbers
    Add the function of add 2 numbers
*/


module Branch_CTRL(
    input [3:0] branch_sel,
    input [31:0] sr1, sr2,
    input [31:0] imm,
    input [31:0] pc,
    output reg [1:0] npc_mux_sel,
    output reg [31:0] pc_offset, reg_offset
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

// B-state list
localparam NPC = 4'h0;
localparam OFFPC = 4'h1;
localparam NEQ = 4'h2;
localparam EQ = 4'h3;
localparam SLT = 4'h4;  // sign less than
localparam ULT = 4'h5;  // unsign less than
localparam SGT = 4'h6;  // sign greater than
localparam UGT = 4'h7;  // unsign greater than
localparam JALR = 4'h8;

// NPC mux list
localparam PLUS4 = 2'b00;
localparam PC_OFFSET = 2'b01;
localparam REG_OFFSET = 2'b10;
localparam INTERRUPT = 2'b11;

wire equal, sign_less_than, unsign_less_than;

assign equal = (sr1 == sr2 ? 1 : 0); 
assign sign_less_than = ((sr1[31] == 1 && sr2[31] == 0) || 
                          (sr1[31] == sr2[31] && sr1 < sr2)) ? 1 : 0;  
assign unsign_less_than = ((sr1[31] == 0 && sr2[31] == 1) || 
                          (sr1[31] == sr2[31] && sr1 < sr2)) ? 1 : 0;

always @(*) begin
    case (branch_sel) 
        NPC: npc_mux_sel = PLUS4;
        OFFPC: npc_mux_sel = PC_OFFSET;

        EQ: begin   // equal
            if (equal)
                npc_mux_sel = PC_OFFSET;
            else
                npc_mux_sel = PLUS4;
        end

        NEQ: begin  // not equal
            if (~equal)
                npc_mux_sel = PC_OFFSET;
            else
                npc_mux_sel = PLUS4;
        end

        SLT: begin  // sign less than
            if (sign_less_than)
                npc_mux_sel = PC_OFFSET;
            else
                npc_mux_sel = PLUS4;
        end

        ULT: begin  // unsign less than
            if (unsign_less_than)
                npc_mux_sel = PC_OFFSET;
            else
                npc_mux_sel = PLUS4;
        end

        SGT: begin  // sign greater than
            if (~sign_less_than && ~equal)
                npc_mux_sel = PC_OFFSET;
            else
                npc_mux_sel = PLUS4;
        end

        UGT: begin  // unsign greater than
            if (~unsign_less_than && ~equal)
                npc_mux_sel = PC_OFFSET;
            else
                npc_mux_sel = PLUS4;
        end

        JALR: begin   // jump and link R
            npc_mux_sel = REG_OFFSET;
        end

        default: begin
            npc_mux_sel = PLUS4;
        end
    endcase
end


always @(*) begin
    pc_offset = pc + imm;
    reg_offset = sr1 + imm;
end

endmodule
