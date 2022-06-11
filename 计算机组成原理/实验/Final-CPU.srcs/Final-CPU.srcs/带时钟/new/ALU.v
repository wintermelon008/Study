`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/16 22:10:30
// Design Name: 
// Module Name: ALU
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
    ================================   ALU module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.5

    This is a basic arithmetic logic unit.
    Designed for RISCV 32I
*/

module ALU (
    input [31:0] num1, num2,                      // The source data
    input [7:0] mode_sel,                         // ALU working mode sel
    output reg [31:0] ans,                        // The answer
    output reg error                              // The error signal     
);

// Some used variables
    reg [3:0] counter;      
    reg [31:0] temp;
    wire equal, sign_lessthan, unsign_lessthan;

/*                                              Below is the ALU working mode table 
    ========================================================================================================================
*/
    // RISCV 32I
    localparam SUB = 8'h00;
    localparam ADD = 8'h01;
    localparam AND = 8'h02;
    localparam OR = 8'h03;
    localparam XOR = 8'h04;
    localparam RMV = 8'h05;      // Right shift (logic)
    localparam LMV = 8'h06;      // Left shift  (logic)
    localparam ARMV = 8'h07;     // Right shift (arithmetic)
    localparam SLTS = 8'h08;      // Sign less then set bit
    localparam SLTUS = 8'h09;     // Unsign less then set bit

    // RISCV 32B
    localparam ANDN = 8'h10;     // Not then and
    localparam MAX = 8'h11;      
    localparam MAXU = 8'h12;
    localparam MIN = 8'h13;
    localparam MINU = 8'h14;
    localparam ORN = 8'h15;      // Not then or
    localparam SH1ADD = 8'h16;
    localparam SH2ADD = 8'h17;
    localparam SH3ADD = 8'h18;
    localparam XNOR = 8'h19;

 
    assign equal = (num1 == num2 ? 1 : 0);       
    assign sign_lessthan = ((num1[31] == 1 && num2[31] == 0) || 
                          (num1[31] == num2[31] && num1 < num2)) ? 1 : 0; 
    assign unsign_lessthan = ((num1[31] == 0 && num2[31] == 1) || 
                          (num1[31] == num2[31] && num1 < num2)) ? 1 : 0;
  

    always @(*) begin
        error = 0;
        case(mode_sel)

        // RISCV 32I PART ======================================================================================================================
            SUB: begin
                ans = num1 - num2;
            end

            ADD: begin
                ans = num1 + num2;
            end

            AND: begin
                ans = num1 & num2;
            end

            OR: begin
                ans = num1 | num2;
            end

            XOR: begin
                ans = num1 ^ num2;
            end

            RMV: begin 
                if (num2 >= 32) begin
                    ans = {32{1'b0}};
                end
                else begin
                    ans = num1 >> num2;
                end
            end

            LMV: begin
                if (num2 >= 32) begin
                    ans = {32{1'b0}};
                end
                else begin
                    ans = num1 << num2;
                end
            end

            ARMV: begin
                temp = 32'b0;
                counter = num1[31];   
                if (num2 >= 32) begin
                    if (counter == 0)
                        ans = {32{1'b0}};
                    else
                        ans = {32{1'b1}};
                end
                else begin
                    temp = num1 >> num2;
                              
                    if (counter == 1)
                        ans = temp | ({32{1'b1}} << num2);
                    else begin
                        ans = temp | ({32{1'b0}} << num2);
                    end
                end
            end

            SLTS: begin
                if (sign_lessthan)
                    ans = 32'b1;
                else
                    ans = 32'b0;
            end

            SLTUS: begin
                if (unsign_lessthan)
                    ans = 32'b1;
                else
                    ans = 32'b0;
            end

            ANDN: begin
                ans = num1 & (~num2);
            end

            MAX: begin
                if (sign_lessthan) 
                    ans = num2;
                else
                    ans = num1;
            end

            MAXU: begin
                if (unsign_lessthan)
                    ans = num2;
                else
                    ans = num1;
            end

            MIN: begin
                if (sign_lessthan) 
                    ans = num1;
                else
                    ans = num2;
            end

            MINU: begin
                if (unsign_lessthan)
                    ans = num1;
                else
                    ans = num2;
            end

            ORN: begin
                ans = num1 | (~num2);
            end

            SH1ADD: begin
                ans = (num1 << 1) + num2;
            end

            SH2ADD: begin
                ans = (num1 << 2) + num2;
            end

            SH3ADD: begin
                ans = (num1 << 3) + num2;
            end

        // ELSE ======================================================================================================================

            // TEST: begin
            //     ans = {32{1'b1}};        // All 1
            // end

            default : begin
                ans = 'b0;
                error = 1'b1;
            end
                
        endcase
    end

endmodule