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
    ================================   REG_FILE_F module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.4

    This is the register file module.
    The register file is designed as RISCV F-extension.
    All the registers are initialized to 0.
    
    Register file is write-first.
    Synchronous wirting number, asynchronous reading number.

    In order to make it easy to debug, RF specially provides the read-address-3 and read-data-3. 
    Remember: RF doesn't have the reset signal, which means you can not initialize them as you like while programming!
*/


module REG_FILE_F (
    input clk,			                // clk
    input [4:0]   ra0, ra1, ra2, ra3,	// read address
    output [31:0]  rd0, rd1, rd2, rd3,	// read data output
    input [4:0]  wa,		            // write address
    input [31:0]  wd,		            // write data input
    input we			                // writing enable
);
    integer i;
    reg [31:0]  rf [0: 31]; 	    // regfile

    initial begin
        i = 0;
        while (i < 32) begin
            rf[i] = 32'b0;
            i = i + 1;
        end
    end

    assign rd0 = (ra0 == wa && we) ? wd : rf[ra0];   // read
    assign rd1 = (ra1 == wa && we) ? wd : rf[ra1];   // read	
    assign rd2 = (ra2 == wa && we) ? wd : rf[ra2];   // read	
    assign rd3 = rf[ra3];	    // debug

    always @(posedge clk)
        if (we)  
            rf[wa] <=  wd;		    // write
            
endmodule

