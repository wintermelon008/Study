`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/27 15:00:58
// Design Name: 
// Module Name: DPE
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
    ================================   DPE module   ================================
    Author:         Wintermelon
    Last Edit:      2022.3.27

    This is a switches double edge detector.
    Function:
        1. Detect the change of the switches. (suppose only one switch change at one time)
        2. Coding for switches difference. (in hex)
        3. Send a pulse whenever the switched change. The pulse sustains one clock cycle.
*/

module DPE(
    input [15:0] sw,            // The switches 
    input clk,
    input rstn,
    output reg [3:0] hex,       // The code
    output reg pulse            
);
    reg [15:0] sw_change;
    reg [15:0] sw_1, sw_2, sw_3;

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            sw_1 <= sw;
            sw_2 <= sw;
            sw_3 <= sw;
        end
        else begin
            sw_1 <= sw;
            sw_2 <= sw_1;
            sw_3 <= sw_2;
        end
    end

    always @(*) begin
        sw_change[0] = (sw_3[0] ^ sw_2[0]);
        sw_change[1] = (sw_3[1] ^ sw_2[1]);
        sw_change[2] = (sw_3[2] ^ sw_2[2]);
        sw_change[3] = (sw_3[3] ^ sw_2[3]);
        sw_change[4] = (sw_3[4] ^ sw_2[4]);
        sw_change[5] = (sw_3[5] ^ sw_2[5]);
        sw_change[6] = (sw_3[6] ^ sw_2[6]);
        sw_change[7] = (sw_3[7] ^ sw_2[7]);
        sw_change[8] = (sw_3[8] ^ sw_2[8]);
        sw_change[9] = (sw_3[9] ^ sw_2[9]);
        sw_change[10] = (sw_3[10] ^ sw_2[10]);
        sw_change[11] = (sw_3[11] ^ sw_2[11]);
        sw_change[12] = (sw_3[12] ^ sw_2[12]);
        sw_change[13] = (sw_3[13] ^ sw_2[13]);
        sw_change[14] = (sw_3[14] ^ sw_2[14]);
        sw_change[15] = (sw_3[15] ^ sw_2[15]);
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            hex <= 4'h0;
        else begin
            if (sw_change[0] == 1)
                hex <= 4'h0;
            else if (sw_change[1] == 1)
                hex <= 4'h1;
            else if (sw_change[2] == 1)
                hex <= 4'h2;
            else if (sw_change[3] == 1)
                hex <= 4'h3;
            else if (sw_change[4] == 1)
                hex <= 4'h4;
            else if (sw_change[5] == 1)
                hex <= 4'h5;
            else if (sw_change[6] == 1)
                hex <= 4'h6;
            else if (sw_change[7] == 1)
                hex <= 4'h7;
            else if (sw_change[8] == 1)
                hex <= 4'h8;
            else if (sw_change[9] == 1)
                hex <= 4'h9;
            else if (sw_change[10] == 1)
                hex <= 4'ha;
            else if (sw_change[11] == 1)
                hex <= 4'hb;
            else if (sw_change[12] == 1)
                hex <= 4'hc;
            else if (sw_change[13] == 1)
                hex <= 4'hd;
            else if (sw_change[14] == 1)
                hex <= 4'he;
            else if (sw_change[15] == 1)
                hex <= 4'hf;
        end
    end

    always @(*) begin
        pulse = sw_change[0] || sw_change[1] || sw_change[2] || sw_change[3] ||
                sw_change[4] || sw_change[5] || sw_change[6] || sw_change[7] ||
                sw_change[8] || sw_change[9] || sw_change[10] || sw_change[11] ||
                sw_change[12] || sw_change[13] || sw_change[14] || sw_change[15];
    end

endmodule
