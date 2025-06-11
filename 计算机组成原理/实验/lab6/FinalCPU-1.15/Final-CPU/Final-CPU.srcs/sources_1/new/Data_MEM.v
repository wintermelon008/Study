`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 10:40:19
// Design Name: 
// Module Name: Data_MEM
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
    ================================   Data_MEM module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.20

    This is the data memory.
    Use 4096 x 32bit dist RAM


*/

module Data_MEM(
    input clk,
    input [15:0] add_1,
    input [31:0] data_1,
    input we_1,
    input [19:0] radd_2,    // debug
    output reg [31:0] out_1, out_2,
    output reg dm_error
);

wire dm_we, stack_we;
wire [31:0] dm_dout, stack_dout;
wire [31:0] dm_debug_dout, stack_debug_dout;
wire [11:0] dm_addr, dm_debug_addr;
wire [7:0] stack_addr, stack_debug_addr;

assign dm_we = (add_1 < 16'h2C00 && we_1 == 1'b1) ? 1'b1 : 1'b0;
assign stack_we = (add_1[15:10] == 6'b001011 && we_1 == 1'b1) ? 1'b1 : 1'b0;

assign dm_addr = (add_1 >> 2);
assign dm_debug_addr = radd_2[11:0];

assign stack_addr = ((add_1 - 16'h2C00) >> 2);
assign stack_debug_addr = radd_2[7:0];

    data_mem data_m (
        .a(dm_addr),        // input wire [11 : 0] a
        .d(data_1),        // input wire [31 : 0] d
        .dpra(dm_debug_addr),  // input wire [11 : 0] dpra
        .clk(clk),    // input wire clk
        .we(dm_we),      // input wire we
        .spo(dm_dout),    // output wire [31 : 0] spo
        .dpo(dm_debug_dout)    // output wire [31 : 0] dpo
    );

    user_stack stack_m (
        .a(stack_addr),        // input wire [7 : 0] a
        .d(data_1),        // input wire [31 : 0] d
        .dpra(stack_debug_addr),  // input wire [7 : 0] dpra
        .clk(clk),    // input wire clk
        .we(stack_we),      // input wire we
        .spo(stack_dout),    // output wire [31 : 0] spo
        .dpo(stack_debug_dout)    // output wire [31 : 0] dpo
    );

// User data: From 0x0000 - 0x2BFC (2816 x 32bit) 
//         00 0000 0000 0000 00 -> 0000 0000 0000
//         00 1010 1111 1111 00 -> 1010 1111 1111

// User stack: From 0x2C00 - 0x2FFC (256 x 32bit)
//         0010 11 0000 0000 00 -> 0000 0000
//         0010 11 1111 1111 00 -> 1111 1111

always @(*) begin
    dm_error = 1'b0;
    if (add_1[15:10] == 6'b001011) begin// stack
        out_1 = stack_dout;
    end
    else if (add_1 < 16'h2C00) begin    // user data
        out_1 = dm_dout;
    end
    else begin
        out_1 = 32'h0;
        if (we_1)
            dm_error = 1'b1;
        // access error
    end
end

always @(*) begin
    if (radd_2[19:15] == 4'h3) begin    // stack
        out_2 = stack_debug_dout;
    end
    else begin    // user data
        out_2 = dm_debug_dout;
    end
end


endmodule
