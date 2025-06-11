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
    A common register

 * Author:      wintermelon
 * Last edit:   2022.4.11
*/

module Reg#(
    parameter DATA_WIDTH = 32           // data width
)
(
    input [DATA_WIDTH-1 : 0] din,
    input clk, rstn, en,
    output reg [DATA_WIDTH-1 : 0] dout
);
    initial begin
        dout <= 0;
    end
    
    always @(posedge clk or negedge rstn) begin 
        if (~rstn) begin
            dout <= 0;
        end
        else begin
            if (en) 
                dout <= din;
        end
    end
endmodule
