`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/21 19:18:30
// Design Name: 
// Module Name: MUX2
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
    ================================   MUX2 module   ================================
    Author:         Wintermelon
    Last Edit:      2022.3.31

    This is a very simple 2-1 mux.
    case(signal)
        0 - data1
        1 - data2
*/

module MUX2 
#(
    parameter DATA_WIDTH = 32           
)
(
    input [DATA_WIDTH-1 : 0] data1, data2,
    input  sel,
    output [DATA_WIDTH-1 : 0] out
);

    assign out = (sel) ? data2 : data1;
endmodule


