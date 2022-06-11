`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/05 10:00:54
// Design Name: 
// Module Name: BALU
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
    ================================   BALU module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.5

    This is a basic bit-calculate unit.
    Designed for RISCV 32I
*/

module BALU(
    input [31:0] num1, num2,                      // The source data
    input [7:0] mode_sel,                         // BALU working mode sel
    output reg [31:0] ans,                        // The answer
    output reg error  
);

reg [31:0] mask;
reg [31:0] temp;
wire [31:0] add_11, add_12, add_13, add_14, add_15, add_16, add_17, add_18, add_19, add_110, add_111, add_112, add_113, add_114, add_115, add_116;
wire [31:0] add_21, add_22, add_23, add_24, add_25, add_26, add_27, add_28;
wire [31:0] add_31, add_32, add_33, add_34;
wire [31:0] add_41, add_42;


                       
assign add_11 = num1[1] + num1[0];
assign add_12 = num1[3] + num1[2];
assign add_13 = num1[5] + num1[4];
assign add_14 = num1[7] + num1[6];
assign add_15 = num1[9] + num1[8];
assign add_16 = num1[11] + num1[10];
assign add_17 = num1[13] + num1[12];
assign add_18 = num1[15] + num1[14];
assign add_19 = num1[17] + num1[16];
assign add_110 = num1[19] + num1[18];
assign add_111 = num1[21] + num1[20];
assign add_112 = num1[23] + num1[22];
assign add_113 = num1[25] + num1[24];
assign add_114 = num1[27] + num1[26];
assign add_115 = num1[29] + num1[28];
assign add_116 = num1[31] + num1[30];

assign add_21 = add_11 + add_12;
assign add_22 = add_13 + add_14;
assign add_23 = add_15 + add_16;
assign add_24 = add_17 + add_18;
assign add_25 = add_19 + add_110;
assign add_26 = add_111 + add_112;
assign add_27 = add_113 + add_114;
assign add_28 = add_115 + add_116;

assign add_31 = add_21 + add_22;
assign add_32 = add_23 + add_24;
assign add_33 = add_25 + add_26;
assign add_34 = add_27 + add_28;

assign add_41 = add_31 + add_32;
assign add_42 = add_33 + add_34; 


/*                                              Below is the BALU working mode table 
    ========================================================================================================================
*/
    // Integer Bit Calculate Unit
    // Code begin with 8'h3

    // RISCV 32B ALU
    localparam BCLR = 8'h30;     // Clear single bit
    localparam BEXT = 8'h31;     // Get single bit
    localparam BINV = 8'h32;     // Not single bit
    localparam BSET = 8'h33;     // Set single bit
    localparam CLZ = 8'h34;      // Leading zeros count
    localparam CPOP = 8'h35;     // Set bits count     
    localparam CTZ = 8'h36;      // Suffix zeros count
    localparam ROL = 8'h37;      // High bits reverse
    localparam ROR = 8'h38;      // Low bits reverse

    always @(*) begin
        ans = 0;
        mask = (32'b1) << num2[4:0];
        error = 0;
        case(mode_sel)

            BCLR: begin
                ans = num1 & (~mask);
            end

            BEXT: begin
                ans = (num1 >> num2[4:0]) & (32'b1);
            end

            BINV: begin
                ans = num1 ^ mask;
            end

            BSET: begin
                ans = num1 | mask;
            end

            CLZ: begin
                if (num1 >> 16 == 0)
                    if (num1 >> 8 == 0)
                        if (num1 >> 4 == 0)
                            if (num1 >> 2 == 0)
                                if (num1 >> 1 == 0)
                                    if (num1 == 0)
                                        ans = 32'd32;
                                    else
                                        ans = 32'd31;
                                else
                                    ans = 32'd30; 
                            else 
                                if (num1 >> 3 == 0)
                                    ans = 32'd29;
                                else
                                    ans = 32'd28;
                        else 
                            if (num1 >> 6 == 0)
                                if (num1 >> 5 == 0)
                                    ans = 32'd27;
                                else
                                    ans = 32'd26;
                            else 
                                if (num1 >> 7 == 0)
                                    ans = 32'd25;
                                else
                                    ans = 32'd24;
                    else
                        if (num1 >> 12 == 0)
                            if (num1 >> 10 == 0)
                                if (num1 >> 9 == 0)
                                    ans = 32'd23;
                                else
                                    ans = 32'd22;
                            else 
                                if (num1 >> 11 == 0)
                                    ans = 32'd21;
                                else
                                    ans = 32'd20;
                        else 
                            if (num1 >> 14 == 0)
                                if (num1 >> 13 == 0)
                                    ans = 32'd19;
                                else
                                    ans = 32'd18;
                            else 
                                if (num1 >> 15 == 0)
                                    ans = 32'd17;
                                else
                                    ans = 32'd16;
                else
                    if (num1 >> 24 == 0)
                        if (num1 >> 20 == 0)
                            if (num1 >> 18 == 0)
                                if (num1 >> 17 == 0)
                                    ans = 32'd15;
                                else
                                    ans = 32'd14;
                            else
                                if (num1 >> 19 == 0)
                                    ans = 32'd13;
                                else
                                    ans = 32'd12;
                        else
                            if (num1 >> 22 == 0)
                                if (num1 >> 21 == 0)
                                    ans = 32'd11;
                                else
                                    ans = 32'd10;
                            else
                                if (num1 >> 23 == 0)
                                    ans = 32'd9;
                                else
                                    ans = 32'd8;
                    else
                        if (num1 >> 28 == 0)
                            if (num1 >> 26 == 0)
                                if (num1 > 25 == 0)
                                    ans = 32'd7;
                                else
                                    ans = 32'd6;
                            else
                                if (num1 >> 27 == 0)
                                    ans = 32'd5;
                                else
                                    ans = 32'd4;
                        else
                            if (num1 >> 30 == 0)
                                if (num1 >> 29 == 0)
                                    ans = 32'd3;
                                else
                                    ans = 32'd2;
                            else 
                                if (num1 >> 31 == 0)
                                    ans = 32'd1;
                                else
                                    ans = 32'd0;
            end

            CPOP: begin
                ans = add_41 + add_42;
            end

            CTZ: begin
                temp = num1 & (-num1);
                case(temp)
                    32'h0: ans = 32'd32;
                    32'h1: ans = 32'd0;
                    32'h2: ans = 32'd1;
                    32'h4: ans = 32'd2;
                    32'h8: ans = 32'd3;
                    32'h10: ans = 32'd4;
                    32'h20: ans = 32'd5;
                    32'h40: ans = 32'd6;
                    32'h80: ans = 32'd7;
                    32'h100: ans = 32'd8;
                    32'h200: ans = 32'd9;
                    32'h400: ans = 32'd10;
                    32'h800: ans = 32'd11;
                    32'h1000: ans = 32'd12;
                    32'h2000: ans = 32'd13;
                    32'h4000: ans = 32'd14;
                    32'h8000: ans = 32'd15;
                    32'h10000: ans = 32'd16;
                    32'h20000: ans = 32'd17;
                    32'h40000: ans = 32'd18;
                    32'h80000: ans = 32'd19;
                    32'h100000: ans = 32'd20;
                    32'h200000: ans = 32'd21;
                    32'h400000: ans = 32'd22;
                    32'h800000: ans = 32'd23;
                    32'h1000000: ans = 32'd24;
                    32'h2000000: ans = 32'd25;
                    32'h4000000: ans = 32'd26;
                    32'h8000000: ans = 32'd27;
                    32'h10000000: ans = 32'd28;
                    32'h20000000: ans = 32'd29;
                    32'h40000000: ans = 32'd30;
                    32'h80000000: ans = 32'd31;
                    default: begin
                        ans = 0;
                        error = 1;
                    end
                endcase

            end

            ROL: begin
                ans = (num1 << num2[4:0]) | (num1 >> (32'd32 - num2[4:0]));
            end

            ROR: begin
                ans = (num1 >> num2[4:0] | num1 << (32'd32 - num2[4:0]));
            end

        default: begin
            ans = 0;
            error = 1;
        end
        endcase 
    end
endmodule
