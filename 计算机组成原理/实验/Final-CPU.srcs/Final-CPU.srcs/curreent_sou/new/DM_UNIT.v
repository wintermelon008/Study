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
    input slow_clk,
    input rd,   // read enable
    input we,   // write enable
    input [2:0] mode,   // dmu mode
    input [2:0] screen_mux_sel,

// DATA
    input [31:0] dmu_addr,
    input [31:0] dmu_din,
    output [31:0] dmu_dout,

// Screen
    input [14:0] screen_addr,
    output [11:0] screen_data,

    output dmu_error
);



Data_MEM dm (
    .clk(clk),
    .slow_clk(slow_clk),
    .screen_mux_sel(screen_mux_sel),
    
    .add_1(dmu_addr),
    .data_1(dmu_din),
    .we_1(we),
    .mode(mode),
    .radd_2(screen_addr),
    .out_1(dmu_dout), 
    .out_2(screen_data),
    .dm_error(dmu_error)
);


endmodule
