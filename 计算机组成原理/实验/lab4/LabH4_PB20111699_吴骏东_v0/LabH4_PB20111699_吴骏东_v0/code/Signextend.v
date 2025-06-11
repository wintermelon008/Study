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
    Sign Extend unit

    last edit: 2022.4.6
*/

module Signextend #(
    parameter WIDTH = 32
)
(
    input [WIDTH-1: 0] instruction,
    output reg [WIDTH-1: 0] n12bitout,
    output reg [WIDTH-1: 0] n20bitout,
    output reg [WIDTH-1: 0] left12out
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
                    n12bitout = {{20{1'b1}}, {instruction[31:20]}};
                else
                    n12bitout = {{20{1'b0}}, {instruction[31:20]}};
            end
            else begin
                // slli, srai, srli           
                n12bitout = {{26{1'b0}}, {instruction[25:20]}};
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
                n12bitout = {{19{1'b1}}, {instruction[31]}, {instruction[7]}, {instruction[30:25]}, {instruction[11:8]}, {1'b0}};
            else
                n12bitout = {{19{1'b0}}, {instruction[31]}, {instruction[7]}, {instruction[30:25]}, {instruction[11:8]}, {1'b0}};
        end

        JumpandlinkR: begin
            // jalr
            if (instruction[31] == 1)
                n12bitout = {{20{1'b1}}, {instruction[31:20]}};
            else
                n12bitout = {{20{1'b0}}, {instruction[31:20]}};
        end

        // Lw, sw:
        // format: is[31:25] -> imm[11:5]                  // 12
        //        is[11:7] -> imm[4:0]

        MemoryLoad: begin
            n12bitout = {{20'b0}, {instruction[31:20]}};
        end

        MemoryStore: begin
            n12bitout = {{20'b0}, {instruction[31:25]}, {instruction[11:7]}};
        end


        default: begin
            n12bitout = 0;
        end

    endcase
end

// This is the 20-bit sign_extend imm
always @(*) begin
    
    if (instruction[6:0] == JumpandlinkI) begin
        // jal
        if (instruction[31] == 1) 
            n20bitout = {{11{1'b1}}, {instruction[31]}, {instruction[19:12]}, {instruction[20]}, {instruction[30:21]}, {1'b0}};
        else
            n20bitout = {{11{1'b0}}, {instruction[31]}, {instruction[19:12]}, {instruction[20]}, {instruction[30:21]}, {1'b0}};
    end

    else
        n20bitout = 0;

end

// This is the << 12 sign_extend imm
always @(*) begin
    if (instruction[6:0] == Adduppertopc || instruction[6:0] == Loadupperimm) 
        // auipc, lui
        left12out = {{instruction[31:12]}, {12'b0}};
    else
        left12out = 0;
end

endmodule


