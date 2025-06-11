`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/06 18:42:16
// Design Name: 
// Module Name: Signextend
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
    ================================   Signextend module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.21

    This is the immediate number sign extend module
*/


module Signextend 
(
    input [31: 0] instruction,
    output reg [31: 0] imm
);

// Attention: instruction srai will specially take the imm num

// Below is the instruction opcode list ================================================================================================

    localparam ArithmeticR = 7'b0110011;
    localparam ArithmeticI = 7'b0010011;
    localparam Conditionjump = 7'b1100011;
    localparam MemoryLoad = 7'b0000011;
    localparam MemoryStore = 7'b0100011;
    localparam JumpandlinkR = 7'b1100111;
    localparam JumpandlinkI = 7'b1101111;
    localparam Adduppertopc = 7'b0010111;
    localparam Loadupperimm = 7'b0110111;
    

/*
    The instruction used imm contains:

    ArithmeticI, like addi, xori, ori, andi
        format: is[31:20] -> 12bit imm                  // 12

    Data Shift, like slli, srai, srli
        format: is[24:20] -> 5bit imm       <RV32I>     // 12

    Condition jump, like beq, bne, blt, bltu
        format: is[31] -> imm[12]
                is[30:25] -> imm[10:5]
                is[11:8] -> imm[4:1]
                is[7] -> imm[11]
                imm[0] = 0

                13bit imm                               // 12

    Upper imm, like auipc, lui
        format: is[31:12] << 12 -> imm[31:0]            // <<

    Jal, jal
        format: is[31] -> imm[20]
                is[30:21] -> imm[10:1]
                is[20] -> imm[11]
                is[19:12] -> imm[19:12]
                imm[0] = 0

                21bit imm
                                                        // 20
    Jalr, jalr
        format: is[31:20] -> 12 bit imm                 // 12

    Lw, sw:
        format: is[31:25] -> imm[11:5]                  // 12
                is[11:7] -> imm[4:0]
*/   


// This is the 12-bit sign_extend imm
always @(*) begin
    case (instruction[6:0]) // Check the opcode
        ArithmeticI: begin
        /*
            ArithmeticI, like addi, xori, ori, andi
            format: is[31:20] -> 12bit imm                  // 12

            Data Shift, like slli, srai, srli
            format: is[24:20] -> 5bit imm       <RV32I>     // 12
        */

        // Check the func3
        
            if (instruction[14:12] == 3'b000 || instruction[14:12] == 3'b100 ||
                instruction[14:12] == 3'b110 || instruction[14:12] == 3'b111) begin
                // addi,  xori, ori, andi
                if (instruction[31] == 1)
                    imm = {{20{1'b1}}, {instruction[31:20]}};
                else
                    imm = {{20{1'b0}}, {instruction[31:20]}};
            end
            else begin
                // slli, srai, srli           
                imm = {{26{1'b0}}, {instruction[25:20]}};
            end
        end

        Conditionjump: begin
        /*
            Condition jump, like beq, bne, blt, bltu
            format: is[31] -> imm[12]
                    is[30:25] -> imm[10:5]
                    is[11:8] -> imm[4:1]
                    is[7] -> imm[11]
                    imm[0] = 0

                    13bit imm                               // 12
        */
            if (instruction[31] == 1) 
                imm = {{19{1'b1}}, {instruction[31]}, {instruction[7]}, {instruction[30:25]}, {instruction[11:8]}, {1'b0}};
            else
                imm = {{19{1'b0}}, {instruction[31]}, {instruction[7]}, {instruction[30:25]}, {instruction[11:8]}, {1'b0}};
        end

        JumpandlinkR: begin
            // jalr
            if (instruction[31] == 1)
                imm = {{20{1'b1}}, {instruction[31:20]}};
            else
                imm = {{20{1'b0}}, {instruction[31:20]}};
        end

        // Lw, sw:
        // format: is[31:25] -> imm[11:5]                  // 12
        //        is[11:7] -> imm[4:0]

        MemoryLoad: begin
            if (instruction[31] == 1)
                imm = {{20{1'b1}}, {instruction[31:20]}};
            else
                imm = {{20'b0}, {instruction[31:20]}};
        end

        MemoryStore: begin
            if (instruction[31] == 1)
                imm = {{20{1'b1}}, {instruction[31:25]}, {instruction[11:7]}};
            else
                imm = {{20'b0}, {instruction[31:25]}, {instruction[11:7]}};
        end

        JumpandlinkI: begin
            // jal
            if (instruction[31] == 1) 
                imm = {{11{1'b1}}, {instruction[31]}, {instruction[19:12]}, {instruction[20]}, {instruction[30:21]}, {1'b0}};
            else
                imm = {{11{1'b0}}, {instruction[31]}, {instruction[19:12]}, {instruction[20]}, {instruction[30:21]}, {1'b0}};
        end

        Adduppertopc: begin
            // auipc
            imm = {{instruction[31:12]}, {12'b0}};
        end

        Loadupperimm: begin
            // lui
            imm = {{instruction[31:12]}, {12'b0}};
        end

        default: begin
            imm = 0;
        end

    endcase
end


endmodule


