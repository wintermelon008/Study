`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 15:54:29
// Design Name: 
// Module Name: MUX8
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
    ================================   MUX8 module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.20

    This is a very simple 8-1 mux.
    case(signal)
        000 - data1
        001 - data2
        010 - data3
        011 - data4
        100 - data5
        101 - data6
        110 - data7
        111 - data8
*/

module MUX8
#(
    parameter DATA_WIDTH = 32           
)
(
    input [DATA_WIDTH-1 : 0] data1, data2, data3, data4, data5, data6, data7, data8,
    input [2:0] sel,
    output reg [DATA_WIDTH-1 : 0] out
);

    always @(*) begin
        case (sel)
            3'b000: out = data1;
            3'b001: out = data2;
            3'b010: out = data3;
            3'b011: out = data4;
            3'b100: out = data5;
            3'b101: out = data6;
            3'b110: out = data7;
            3'b111: out = data8;
        endcase
    end
endmodule