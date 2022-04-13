`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/11 12:24:41
// Design Name: 
// Module Name: Reg
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
    ================================   REG module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.11

    This is a common register.
    Synchronous setting number, asynchronous reset.  
*/

module Reg 
#(
    parameter DATA_WIDTH = 32           // data width
)
(
    input [DATA_WIDTH-1 : 0] din,       // data input
    input clk, rstn, wen,               // control signals
    output reg [DATA_WIDTH-1 : 0] dout  // data output and storage
);
    initial begin
        dout <= 0;
    end
    
    always @(posedge clk or negedge rstn) begin 
        if (~rstn) begin
            dout <= 0;
        end
        else begin
            if (wen) 
                dout <= din;
        end
    end
endmodule
