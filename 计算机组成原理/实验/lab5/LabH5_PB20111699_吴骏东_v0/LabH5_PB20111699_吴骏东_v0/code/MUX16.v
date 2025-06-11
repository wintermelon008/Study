`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/21 22:25:36
// Design Name: 
// Module Name: MUX16
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
    ================================   MUX16 module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.21

    This is a very simple 16-1 mux.
    case(signal)
        0000 - data1
        0001 - data2
        0010 - data3
        0011 - data4
        0100 - data5
        0101 - data6
        0110 - data7
        0111 - data8
        1000 - data9
        1001 - data10
        1010 - data11
        1011 - data12
        1100 - data13
        1101 - data14
        1110 - data15
        1111 - data16
*/

module MUX16
#(
    parameter DATA_WIDTH = 32           
)
(
    input [DATA_WIDTH-1 : 0] data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12, data13, data14, data15, data16,
    input [3:0] sel,
    output reg [DATA_WIDTH-1 : 0] out
);

    always @(*) begin
        case (sel)
            4'b0000: out = data1;
            4'b0001: out = data2;
            4'b0010: out = data3;
            4'b0011: out = data4;
            4'b0100: out = data5;
            4'b0101: out = data6;
            4'b0110: out = data7;
            4'b0111: out = data8;
            4'b1000: out = data9;
            4'b1001: out = data10;
            4'b1010: out = data11;
            4'b1011: out = data12;
            4'b1100: out = data13;
            4'b1101: out = data14;
            4'b1110: out = data15;
            4'b1111: out = data16;
        endcase
    end
endmodule
