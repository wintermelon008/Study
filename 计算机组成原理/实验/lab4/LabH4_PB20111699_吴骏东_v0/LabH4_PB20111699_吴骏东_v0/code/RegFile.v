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
    Write first
    The number in rf[0] is always 0
    last edit: 2022.3.27
*/

module RegFile #(
    parameter AW = 5,		//Address width
    parameter DW = 32		//Data width
)(
    input sys_clk,			//clk
    input [AW-1:0]   ra0, ra1, ra2,	//read address
    output [DW-1:0]  rd0, rd1, rd2,	//read data output
    input [AW-1:0]  wa,		//write address
    input [DW-1:0]  wd,		//write data input
    input we			//writing enable
);
    integer i;
    reg [DW-1:0]  rf [0: (1<<AW)-1]; 	    //regfile
    initial begin
        i = 0;
        while (i < 32) begin
            rf[i] = 32'b0;
            i = i + 1;
        end
        rf[2] = 'h2ffc;
        rf[3] = 'h1800;
    end

    assign rd0 = rf[ra0];  
    assign rd1 = rf[ra1];	
    assign rd2 = rf[ra2];	//read

    always @(posedge sys_clk)
        if (we && wa != 'b0)  rf[wa] <=  wd;		    //write
endmodule

