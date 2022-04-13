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
    Last Edit:      2022.3.18

    This is a basic arithmetic logic unit.
    User can change the data width while instantiating.
*/

module ALU 
#(
    parameter WIDTH = 32                          
)
(
    input [WIDTH-1 : 0] num1, num2,               // The source data
    input [3:0] mode_sel,                         // ALU working mode sel
    output reg [WIDTH-1 : 0] ans,                 // The answer
    output [2:0] sub_flag,                        // The flag for sub mode: equal, less than, unsigned less than
    output reg error                              // The error signal     
);

    // Some used variables
    reg [3:0] counter;      
    reg [WIDTH-1 : 0] temp;

    // Below is the ALU working mode table
    localparam SUB = 4'h0;
    localparam ADD = 4'h1;
    localparam AND = 4'h2;
    localparam OR = 4'h3;
    localparam XOR = 4'h4;
    localparam RMV = 4'h5;      // Right shift (logic)
    localparam LMV = 4'h6;      // Left shift  (logic)
    localparam ARMV = 4'h7;     // Right shift (arithmetic)
    localparam TEST = 4'hF;


    // equal 
    assign sub_flag[0] = (num1 == num2 ? 1 : 0);       
    // signed less than
    assign sub_flag[1] = ((num1[WIDTH-1] == 1 && num2[WIDTH-1] == 1 && num1 > num2) || 
                          (num1[WIDTH-1] == 0 && num2[WIDTH-1] == 0 && num1 < num2) ||
                          (num1[WIDTH-1] == 1 && num2[WIDTH-1] == 0) ) ? 1 : 0;     
    // unsigned less than  
    assign sub_flag[2] = ((num1[WIDTH-1] == 0 && num2[WIDTH-1] == 1) || 
                          (num1[WIDTH-1] == num2[WIDTH-1] && num1 < num2)) ? 1 : 0;
  

    always @(*) begin
        error = 0;
        case(mode_sel)
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
                if (num2 >= WIDTH) begin
                    ans = {WIDTH{1'b0}};
                end
                else begin
                    ans = num1 >> num2;
                end
            end

            LMV: begin
                if (num2 >= WIDTH) begin
                    ans = {WIDTH{1'b0}};
                end
                else begin
                    ans = num1 << num2;
                end
            end

            ARMV: begin
                temp = 'b0;
                counter = num1[WIDTH-1];   
                if (num2 >= WIDTH) begin
                    if (counter == 0)
                        ans = {WIDTH{1'b0}};
                    else
                        ans = {WIDTH{1'b1}};
                end
                else begin
                    temp = num1 >> num2;
                              
                    if (counter == 1)
                        ans = temp | ({WIDTH{1'b1}} << num2);
                    else begin
                        ans = temp | ({WIDTH{1'b0}} << num2);
                    end
                end
            end

            TEST: begin
                ans = {WIDTH{1'b1}};        // All 1
            end

            default : begin
                ans = 'b0;
                error = 1'b1;
            end
                
        endcase
    end

endmodule