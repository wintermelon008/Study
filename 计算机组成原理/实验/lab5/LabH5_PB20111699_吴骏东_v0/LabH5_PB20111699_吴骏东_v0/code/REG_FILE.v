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
    ================================   REG_FILE module   ================================
    Author:         Wintermelon
    Last Edit:      2022.3.27

    This is the register file module.
    The register file is the same as RISC-V.
    As a result, Reg[0] is forever 0, Reg[2] is initialized to 32'h2ffc, Reg[3] is initialized to 32'h1800.
    The other registers are initialized to 0.
    
    Register file is write-first.
    Synchronous wirting number, asynchronous reading number.

    In order to make it easy to debug, RF specially provides the read-address-2 and read-data-2. 
    Remember: RF doesn't have the reset signal, which means you can not initialize them as you like while programming!
*/


module REG_FILE (
    input clk,			            // clk
    input [4:0]   ra0, ra1, ra2,	// read address
    output [31:0]  rd0, rd1, rd2,	// read data output
    input [4:0]  wa,		        // write address
    input [31:0]  wd,		        // write data input
    input we			            // writing enable
);
    integer i;
    reg [31:0]  rf [0: 31]; 	    // regfile

    initial begin
        i = 0;
        while (i < 32) begin
            rf[i] = 32'b0;
            i = i + 1;
        end
        rf[2] = 'h2ffc;
        rf[3] = 'h1800;
    end

    assign rd0 = (ra0 == wa && ra0 && we) ? wd : rf[ra0];   // read
    assign rd1 = (ra1 == wa && ra1 && we) ? wd : rf[ra1];   // read	
    assign rd2 = rf[ra2];	

    always @(posedge clk)
        if (we && wa != 'b0)  
            rf[wa] <=  wd;		    // write
            
endmodule

