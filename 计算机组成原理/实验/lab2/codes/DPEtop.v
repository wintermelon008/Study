`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 20:08:13
// Design Name: 
// Module Name: DPEtop
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


module DPEtop(
    input [15:0] sw,
    input butc,         //data
    input butr,         //check
    input butl,         //del
    input butu,         //address
    input butd,         //run sort
    input sys_rst,
    input sys_clk,
    output [7:0] an,
    output [6:0] seg,
    output busy,  //busy
    output [15:0] led   //time count
);


    wire [7:0] seg_add;
    wire [15:0] seg_data;
    wire [3:0] hex;
    wire plus;

    assign seg_add = sw[7:0];
    assign seg_data = {{8'd0}, {hex + 4'b1}, hex};
    assign led[3:0] = hex;
    assign led[15:4] = sw[11:0];


    DPE dpe(sw, sys_clk, sys_rst, hex, plus);
    seg_out out(sys_clk, sys_rst, seg_add, seg_data, an, seg);

endmodule
