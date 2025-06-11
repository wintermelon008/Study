`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 09:47:01
// Design Name: 
// Module Name: MUX4
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
    ================================   MUX4 module   ================================
    Author:         Wintermelon
    Last Edit:      2022.3.31

    This is a very simple 4-1 mux.
    case(signal)
        00 - data1
        01 - data2
        10 - data3
        11 - data4
*/

module MUX4
#(
    parameter DATA_WIDTH = 32           
)
(
    input [DATA_WIDTH-1 : 0] data1, data2, data3, data4,
    input [1:0] sel,
    output reg [DATA_WIDTH-1 : 0] out
);

    always @(*) begin
        case (sel)
            2'b00: out = data1;
            2'b01: out = data2;
            2'b10: out = data3;
            2'b11: out = data4;
        endcase
    end
endmodule