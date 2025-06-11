`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 15:52:13
// Design Name: 
// Module Name: topmodule
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
    ================================  TOP module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.22
    
*/


module topmodule(
    input clk,	
    input rstn,	    //cpu_resetn

    // Input: buttons and switches
    input butu, 	//btnu
    input butd,	    //btnd
    input butr,	    //btnr
    input butc,	    //btnc
    input butl,	    //btnl
    input [15:0] sw,	//sw15-0

    // Output: leds and segments
    output led16r, 		
    output [15:0] led,	    //led15-0
    output [7:0] an,		//an7-0
    output [6:0] seg,		//ca-cg 
    output [2:0] led17 	    //led17
);

reg one;
initial begin
    one <= 1'b1;
end

//IO_BUS
wire [15:0] io_addr;
wire [31:0] io_dout;
wire io_we;
wire io_rd;
wire [31:0] io_din;

//Debug_BUS
wire [31:0] pc;
wire [15:0] chk_addr;
wire [31:0] chk_data;

wire cpu_clk;
wire rst_cpu;

// PDU
PDU_v2 pdu(
    .clk(clk),	//clk100mhz
    .rstn(rstn),	//cpu_resetn

    .butu(butu),        //btnu
    .butd(butd),	    //btnd
    .butr(butr),	        //btnr
    .butc(butc),	    //btnc
    .butl(butl),	        //btnl
    .sw(sw),	        //sw15-0

    .cpu_stop(led16r), 		//led16r
    .led(led),	        //led15-0
    .an(an),		    //an7-0
    .seg(seg),		    //ca-cg 
    .seg_sel(led17), 	//led17
    .clk_cpu(cpu_clk),
    .rstn_cpu(rst_cpu),

    //IO_BUS
    .io_addr(io_addr),
    .io_dout(io_dout),
    .io_we(io_we),		
    .io_rd(io_rd),	
    .io_din(io_din),	

    //Debug_BUS
    .current_pc(pc), 	    
    .chk_addr(chk_addr),	
    .chk_data(chk_data)    
);

// CPU
Flow_CPU cpu (
    .clk(cpu_clk), 
    .rstn(one),

    //IO_BUS
    .io_addr(io_addr),
    .io_dout(io_dout),
    .io_we(io_we),		
    .io_rd(io_rd),	
    .io_din(io_din),	

    //Debug_BUS
    .chk_pc(pc), 	    
    .chk_addr(chk_addr),	
    .chk_data(chk_data)    
);

endmodule
