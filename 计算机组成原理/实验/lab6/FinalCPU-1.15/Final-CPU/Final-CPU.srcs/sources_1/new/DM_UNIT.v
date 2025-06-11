`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 15:20:23
// Design Name: 
// Module Name: DM_UNIT
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
    ================================   DM_UNIT module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.6

    This is the DataMemory unit
    With I/O
    With Data Memory
*/


module DM_UNIT(
// SIGNALS
    input clk,
    input rd,   // read enable
    input we,   // write enable

// DATA
    input [15:0] dmu_addr,
    input [31:0] dmu_din,
    output [31:0] dmu_dout,

// IO_BUS
    output [15:0]  io_addr,	// I/O address
    output [31:0]  io_dout,	// I/O data output
    output  io_we,		    // I/O write enable
    output  io_rd,		    // I/O read enable
    input [31:0] io_din,	// I/O data input

// DEBUG
    input [19:0] debug_addr,
    output [31:0] debug_dout,

    output dmu_error
);

wire [31:0] dm_din, dm_dout;
wire [15:0] dm_addr;
wire dm_wen;
wire dmu_dout_mux_sel;


assign io_we = we;
assign io_rd = rd;
assign io_addr = dmu_addr;
assign io_dout = dmu_din;
assign dm_wen = we;
assign dm_addr = dmu_addr;
assign dm_din = dmu_din;

assign dmu_dout_mux_sel = (dmu_addr[15:8] == 8'hFF) ? 1'b1 : 1'b0;


Data_MEM dm (
    .clk(clk),
    .add_1(dm_addr),
    .data_1(dm_din),
    .we_1(dm_wen),
    .radd_2(debug_addr),
    .out_1(dm_dout), 
    .out_2(debug_dout),
    .dm_error(dmu_error)
);

MUX2 #(32) dmu_dout_mux(
    .data1(dm_dout),
    .data2(io_din),
    .sel(dmu_dout_mux_sel),
    .out(dmu_dout)
);


endmodule
