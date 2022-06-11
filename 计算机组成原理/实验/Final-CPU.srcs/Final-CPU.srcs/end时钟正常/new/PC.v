`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 15:57:45
// Design Name: 
// Module Name: PC
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
    ================================   PC module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.20

    This is a special register.
    The initial number is 3000.
    Synchronous setting number, never reset.  
*/


module PC 
(
    input [31 : 0] din,             // data input
    input clk, wen,                 // control signals
    output reg [31 : 0] dout        // data output and storage
);
    initial begin
        dout <= 32'h3000;
    end
    always @(posedge clk) begin 
        if (wen) begin
            dout <= din;
        end
            
    end
endmodule
