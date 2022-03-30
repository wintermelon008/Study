`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/24 18:35:03
// Design Name: 
// Module Name: RegFile
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
 Module for regfile
 The number in rf[0] is always 0
 last edit: 2022.3.27
*/

module RegFile #(
    parameter AW = 5,		//Address width
    parameter DW = 32		//Data width
)(
    input sys_clk,			//clk
    input [AW-1:0]   ra0, ra1,	//read address
    output [DW-1:0]  rd0, rd1,	//read data output
    input [AW-1:0]  wa,		//write address
    input [DW-1:0]  wd,		//write data input
    input we			//writing enable
);
    
    reg [DW-1:0]  rf [0: (1<<AW)-1]; 	    //regfile
    initial begin
       rf[0] <= 'b0; 
    end
    assign rd0 = rf[ra0], rd1 = rf[ra1];	//read
    always  @(posedge sys_clk)
        if (we && wa != 'b0)  rf[wa] <=  wd;		    //write
endmodule

