`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/27 14:38:05
// Design Name: 
// Module Name: Debouncer
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
    ================================   Debouncer module   ================================
    Author:         Wintermelon
    Last Edit:      2022.3.27
    A module used to debounce.
    Input:  original button signal
        The signal should always at 0, enable at 1.
    Output: debounced button signal
*/

module Debouncer(
    input ori_but,
    input rstn,
    input clk,     
    output reg deb_but
);


    localparam TIME_100MS = 10000000;

    reg [25:0] cnt;
    reg but_tmp1, but_tmp2;
    wire cnt_en;

    initial begin
        deb_but <= 0;
        cnt <= 0;
        but_tmp1 <= 0;
        but_tmp2 <= 0;
    end

    assign cnt_en = but_tmp1 & ~but_tmp2;

    always @(posedge clk or negedge rstn) begin
        if (rstn == 0) begin
            deb_but <= 0;
            cnt <= 0;
            but_tmp1 <= 0;
            but_tmp2 <= 0;
        end
        else begin
            but_tmp1 <= ori_but;
            but_tmp2 <= but_tmp1;
            if (cnt == TIME_100MS - 1) begin
                cnt <= 0;
                deb_but <= 1;
            end
            else if (cnt_en == 1 || cnt != 0) begin
                cnt <= cnt + 1'b1;
                deb_but <= 0;
            end
            else
                deb_but <= 0;
        end
    end


endmodule
