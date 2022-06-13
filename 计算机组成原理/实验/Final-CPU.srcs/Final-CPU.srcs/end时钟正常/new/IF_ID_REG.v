`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/20 17:12:08
// Design Name: 
// Module Name: IF_ID_REG
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
    ================================  IF_ID_REG module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.4

    This is the inter-segment register between IF and ID
    Include the regs below:
        *PC: current PC
        *IS: current instruction
    
*/

module IF_ID_REG(

    // signals
    input clk,
    input rstn,
    input wen,
    input clear,
    // data
    input [31:0] is_din,
    input [31:0] pc_din,
    output [31:0] is_dout,
    output [31:0] pc_dout
);


    REG #(32) if_id_pc (
        .clk(clk),
        .rstn(rstn),
        .wen(wen),
        .din(pc_din & ({32{~clear}})),
        .dout(pc_dout)
    );

    REG #(32) if_id_is (
        .clk(clk),
        .rstn(rstn),
        .wen(wen),
        .din(is_din & ({32{~clear}})),
        .dout(is_dout)
    );

endmodule
