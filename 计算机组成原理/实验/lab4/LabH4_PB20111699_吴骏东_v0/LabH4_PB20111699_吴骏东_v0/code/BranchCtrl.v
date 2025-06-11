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
    The branch control unit

    last edit: 2022.4.7
*/

module BranchCtrl(
    input [3:0] branch_sel,
    input [2:0] sub_flag,
    output reg [1:0] npcmux
);

/* Subflag Meaning Table
    sub_flag[0] equal
    sub_flag[1] signed less than
    sub_flag[2] unsigned less than
*/

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
localparam JALR = 4'h6;

always @(*) begin
    case (branch_sel) 
        NPC: npcmux = 2'b00;
        OFFPC: npcmux = 2'b01;
        JALR: npcmux = 2'b10;

        EQ: begin
            if (sub_flag[0])
                npcmux = 2'b01;
            else
                npcmux = 2'b00;
        end

        NEQ: begin
            if (~sub_flag[0])
                npcmux = 2'b01;
            else
                npcmux = 2'b00;
        end

        SLT: begin
            if (sub_flag[1])
                npcmux = 2'b01;
            else
                npcmux = 2'b00;
        end

        ULT: begin
            if (sub_flag[2])
                npcmux = 2'b01;
            else
                npcmux = 2'b00;
        end

        default: begin
            npcmux = 2'b00;
        end
    endcase
end

endmodule
