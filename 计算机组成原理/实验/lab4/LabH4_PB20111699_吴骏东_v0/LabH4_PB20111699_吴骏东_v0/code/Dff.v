`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/21 19:23:38
// Design Name: 
// Module Name: Dff
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
  The special design for PC
  Can not be removed!!!

 * Author:      wintermelon
 * Last edit:   2022.3.23
*/

module Dff 
#(
    parameter DATA_WIDTH = 32           // �����źſ���
)
(
    input [DATA_WIDTH-1 : 0] d,
    input  clk, en,
    output reg [DATA_WIDTH-1 : 0] q
);
    initial begin
        q <= 'h2ffc;
    end
    
    always @(posedge clk) begin 
        if (en) 
            q <= d;
    end
endmodule

