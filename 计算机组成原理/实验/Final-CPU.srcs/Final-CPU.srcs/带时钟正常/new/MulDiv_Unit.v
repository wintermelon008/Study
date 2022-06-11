`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 10:29:43
// Design Name: 
// Module Name: MulDiv_Unit
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
    ================================  MulDiv_Unit module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.6

    This is the top module for RISCV 32M Multiplier and Divider
*/

module MulDiv_Unit(
    input clk,
    input rstn,

    input [31:0] num1,
    input [31:0] num2,
    input [7:0] mode,

    output [31:0] ans,
    output reg [1:0] error
);

/*                                              Below is the MDU working mode table 
    ========================================================================================================================
*/
// RISCV 32M ALU
    localparam MUL = 8'h40;      // Multiply
    localparam MULH = 8'h41;     // High bit multiply
    localparam MULHSU = 8'h42;   // High bit sign - unsign multiply
    localparam MULHU = 8'h43;    // High bit unsign multiply
    localparam DIV = 8'h44;      // Divide
    localparam DIVU = 8'h45;     // Unsigned Divide
    localparam REM = 8'h46;      // Remind number
    localparam REMU = 8'h47;     // Unsigned remide number

// MDU ERROR table
    localparam NO_ERROR = 2'b00;
    localparam DIVID_BY_ZERO = 2'b01;
    localparam MODE_ERROR = 2'b11;

// DIVIDER SIGN MODE table
    localparam SIGNED = 1'b0;
    localparam UNSIGNED = 1'b1;

wire div_ans_ready;
reg [2:0] mdu_mux_sel;
reg sign_mode;
wire [2:0] mdu_mux_sel_delay;

wire [31:0] mul_ans_l, mul_ans_h, div_ans, div_rem; 
wire [63:0] mul_ans;

assign mul_ans_l = mul_ans[31:0];
assign mul_ans_h = mul_ans[63:32];

always @(*) begin
    sign_mode = SIGNED;
    error = NO_ERROR;
    mdu_mux_sel = 3'h7;     // zero
    case (mode)
        MUL: begin
            mdu_mux_sel = 3'h0;
        end

        MULH: begin
            mdu_mux_sel = 3'h1;
        end

        DIV: begin
            if (num2 == 0)
                error = DIVID_BY_ZERO;
            mdu_mux_sel = 3'h2;
        end

        DIVU: begin
            if (num2 == 0)
                error = DIVID_BY_ZERO;
            mdu_mux_sel = 3'h2;
            sign_mode = UNSIGNED;               
        end

        REM: begin
            if (num2 == 0)
                error = DIVID_BY_ZERO;
            mdu_mux_sel = 3'h3;
        end

        REMU: begin
            if (num2 == 0)
                error = DIVID_BY_ZERO;
            mdu_mux_sel = 3'h3;
            sign_mode = UNSIGNED;
        end

        default: begin
            error = MODE_ERROR;         // mul mode error(not M instruction)
        end
    endcase
end


FAST_MUL mul(
    .number1(num1),
    .number2(num2),  
    .clk(clk),
    .ans(mul_ans)
);

FAST_DIV div(
    .number1(num1),
    .number2(num2),  
    .sign_mode(sign_mode),

    .clk(clk),
    .ans(div_ans),
    .remind(div_rem),
    .ans_ready(div_ans_ready)
);

MUX8 #(32) mdu_mux (
    .data1(mul_ans_l),
    .data2(mul_ans_h),
    .data3(div_ans),
    .data4(div_rem),
    .data5(32'h0),
    .data6(32'h0),
    .data7(32'h0),
    .data8(32'h0),
    .sel(mdu_mux_sel_delay),
    .out(ans)
);

REG #(3) sel_delay(
    .din(mdu_mux_sel),
    .clk(clk),
    .rstn(rstn),
    .wen(1'b1),
    .dout(mdu_mux_sel_delay)
);

endmodule
