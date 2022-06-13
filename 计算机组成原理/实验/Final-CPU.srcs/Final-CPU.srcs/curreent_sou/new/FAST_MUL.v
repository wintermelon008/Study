`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/27 14:58:44
// Design Name: 
// Module Name: FAST_MUL
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
    ================================  FAST_MUL module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.27

    This is a simple but fast multiply calculate module
*/

module FAST_MUL(
    input clk,  // 100 Mhz

    input [31:0] number1,
    input [31:0] number2,  
    
    output [63:0] ans
    );

mult_gen_0 multiplier (
  .CLK(clk),        // input wire CLK
  .A(number1),      // input wire [31 : 0] A
  .B(number2),      // input wire [31 : 0] B
  .P(ans)           // output wire [63 : 0] P
);

endmodule
