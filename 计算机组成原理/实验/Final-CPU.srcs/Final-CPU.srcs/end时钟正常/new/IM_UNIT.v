`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 15:20:23
// Design Name: 
// Module Name: IM_UNIT
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
    ================================   IM_UNIT module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.6

    This is the Instruction Memory unit
    With Interrupt programs
    With Instruction Memory
*/

module IM_UNIT(
    input clk,
// DATA
    input [15:0] imu_addr,
    output reg [31:0] imu_dout,

// DEBUG
    input [19:0] debug_addr,
    output reg [31:0] debug_dout,

    output reg imu_error    // when 1, the imu address access error
);

    wire [31:0] interrupt_dout, im_dout;
    wire [31:0] interrupt_debug_dout, im_debug_dout;
    wire [11:0] im_addr, im_debug_addr;
    wire [9:0] interrupt_addr, interrupt_debug_addr;

    assign im_addr = (imu_addr - 16'h3000) >> 2;
    assign im_debug_addr = debug_addr[11:0];
    assign interrupt_addr = (imu_addr - 16'hF000) >> 2;
    assign interrupt_debug_addr = debug_addr[9:0];

    Instruction_MEM im (
        .clk(clk),
        .add_1(im_addr),
        .data_1(32'b0),
        .we_1(1'b0),
        .radd_2(im_debug_addr),
        .out_1(im_dout), 
        .out_2(im_debug_dout)
    );

    interrupt ipt_mem (
        .a(interrupt_addr),        // input wire [9 : 0] a
        .d(32'b0),        // input wire [31 : 0] d
        .dpra(interrupt_debug_addr),  // input wire [9 : 0] dpra
        .clk(clk),    // input wire clk
        .we(1'b0),      // input wire we
        .spo(interrupt_dout),    // output wire [31 : 0] spo
        .dpo(interrupt_debug_dout)    // output wire [31 : 0] dpo
    );

// User program: From 0x3000 - 0x4FFC (2048 x 32bit)
//             00 1100 0000 0000 00 -> 0000 0000 0000
//             01 0011 1111 1111 00 -> 0111 1111 1111

// Interrupt program: From 0xF000 - 0xFEFC (960 x 32bit)
//             11 11 00 0000 0000 00 -> 00 0000 0000
//             11 11 11 1011 1111 00 -> 11 1011 1111


    always @(*) begin
        imu_dout = 32'b0;

        if (imu_addr >= 32'h3000 && imu_addr < 32'h4FFC) begin
            // user program
            imu_dout = im_dout;
        end
        else if (imu_addr >= 32'hF000 && imu_addr < 32'hFF00) begin
            // interrupt program
            imu_dout = interrupt_dout;
        end
    end

    always @(*) begin
        debug_dout = 32'b0;

        if (debug_addr[19:16] == 4'h2) begin
            debug_dout = im_debug_dout;
        end

        else if (debug_addr[19:16] == 4'h3) begin
            debug_dout = interrupt_debug_dout;
        end
            
    end


    always @(*) begin
        imu_error = 1'b0;
        if (imu_addr < 32'h3000 || imu_addr > 32'h4FFC && imu_addr < 32'HF000 || imu_addr > 32'HFEFC) begin
            imu_error = 1'b1;
        end
    end
endmodule
