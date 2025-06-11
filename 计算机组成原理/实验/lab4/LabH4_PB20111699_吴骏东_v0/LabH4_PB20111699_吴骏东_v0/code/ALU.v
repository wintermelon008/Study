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
 * 
 * 
 * Author:      wintermelon
 * Last edit:   2022.3.18
*/


module ALU 
#(
    parameter WIDTH = 32                          
)
(
    input [WIDTH-1 : 0] num1, num2,               // 
    input [3:0] sel,                              // 
    output reg [WIDTH-1 : 0] ans,                 // 
    output [2:0] sub_flag,                        // 
    output reg error                              // [     
);

    reg [3:0] counter;      //
    reg [WIDTH-1 : 0] temp;


    localparam SUB = 4'd00;
    localparam ADD = 4'd01;
    localparam AND = 4'd02;
    localparam OR = 4'd03;
    localparam XOR = 4'd04;
    localparam RMV = 4'd05;      //
    localparam LMV = 4'd06;     
    localparam ARMV = 4'd07;     //
    localparam TEST = 4'd15;


    assign sub_flag[0] = (num1 == num2 ? 1 : 0);         
    assign sub_flag[1] = ((num1[WIDTH-1] == 1 && num2[WIDTH-1] == 1 && num1 > num2) || (num1[WIDTH-1] == 0 && num2[WIDTH-1] == 0 && num1 < num2) ||
                            (num1[WIDTH-1] == 1 && num2[WIDTH-1] == 0) )? 1 : 0;       
    assign sub_flag[2] = ((num1[WIDTH-1] == 0 && num2[WIDTH-1] == 1) || (num1[WIDTH - 1] == num2[WIDTH-1] && num1 < num2)) ? 1 : 0;
  

    always @(*) begin
        error = 0;
        case(sel)
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

            default : begin
                ans = 0;
                error = 1;
            end
                
        endcase
    end

endmodule