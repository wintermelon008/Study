`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/25 23:16:02
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
    output [2:0] led17, 	    //led17

    // Screen
    output [11:0] prgb,
    output hs,
    output vs
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
wire [31:0] if_pc, id_pc;
wire [15:0] chk_addr;
wire [31:0] chk_data;

wire pdu_run;
wire cpu_stop;
wire pdu_rstn;
wire [31:0] pdu_breakpoint;

// // PDU
// PDU_v2 pdu(
//     .clk(clk),	//clk100mhz
//     .rstn(rstn),

//     .butu(butu),        //btnu
//     .butd(butd),	    //btnd
//     .butr(butr),	        //btnr
//     .butc(butc),	    //btnc
//     .butl(butl),	        //btnl
//     .sw(sw),	        //sw15-0

//     .stop(led16r), 		//led16r
//     .led(led),	        //led15-0
//     .an(an),		    //an7-0
//     .seg(seg),		    //ca-cg 
//     .seg_sel(led17), 	//led17

//     // CTRL_BUS
//     .pdu_rstn(pdu_rstn),
//     .pdu_breakpoint(pdu_breakpoint),      
//     .pdu_run(pdu_run),           
//     .cpu_stop(cpu_stop),           

//     //IO_BUS
//     .io_addr(io_addr),
//     .io_dout(io_dout),
//     .io_we(io_we),		
//     .io_rd(io_rd),	
//     .io_din(io_din),	

//     //Debug_BUS
//     .chk_if_pc(if_pc), 	
//     .chk_id_pc(id_pc), 	    
//     .chk_addr(chk_addr),	
//     .chk_data(chk_data)    
// );


Pipeline_CPU cpu(
    // cpu control form PDU
    .clk(clk), 
    .rstn(1'b1),

    // outside signals
    .butc(butc),
    .butu(butu),
    .butl(butl),
    .butd(butd),
    .butr(butr),

    .prgb(prgb),
    .hs(hs), 
    .vs(vs)
);

timer time_cnt(
    .clk(clk),
    .rstn(1'b1),
    .butc(butc),      // when 1, then timer clear
    .an(an),    // Connecting segments display
    .seg(seg)    // Connecting segments display
);




endmodule
