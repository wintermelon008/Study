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
    A module used to debounce.
    input:  original button signal
    output: debounced button signal
    last edit: 2022.3.27
*/

module Debouncer(
    input ori_but,
    input sys_rst,
    input sys_clk,      //enable when low voltage
    output reg deb_but
);

    //localparam TIME_20MS = 2000000;
    localparam TIME_20MS = 2000000;
    //localparam TIME_20MS = 5;
    reg [20:0] cnt;
    reg but_tmp1, but_tmp2;
    wire cnt_en;

    initial begin
        deb_but <= 0;
        cnt <= 0;
        but_tmp1 <= 0;
        but_tmp2 <= 0;
    end

    assign cnt_en = but_tmp1 & ~but_tmp2;

    always @(posedge sys_clk or negedge sys_rst) begin
        if (sys_rst == 0) begin
            deb_but <= 0;
            cnt <= 0;
            but_tmp1 <= 0;
            but_tmp2 <= 0;
        end
        else begin
            but_tmp1 <= ori_but;
            but_tmp2 <= but_tmp1;
            if (cnt == TIME_20MS - 1) begin
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

/*
    
    always @(posedge sys_clk or negedge sys_rst) begin
        if (sys_rst == 0)
            but_tmp <= 0;
        else
            but_tmp <= ori_but;
    end

    always @(posedge sys_clk or negedge sys_rst) begin
        if (sys_rst == 0)
            cnt <= 0;
        else if (cnt == TIME_20MS - 1 || ori_but != but_tmp)
            cnt <= 0;
        else if(cnt_en)
            cnt <= cnt + 1'b1;
        else   
            cnt <= 0;
    end
    
    always @(posedge sys_clk or negedge sys_rst) begin
        if (sys_rst == 0) begin
            cnt_en <= 1;
            done <= 0;
        end
        else if (ori_but != but_tmp) begin
            cnt_en <= 1;
            done <= 0;
        end
        else if (cnt == TIME_20MS - 1) begin
            cnt_en <= 0;
            done <= 1;
        end
        else if (done == 1)
            done <= 0;
            
    end

    always @(posedge sys_clk) begin
        if (done == 1)
            deb_but <= 1;
        else
            deb_but <= 0;
    end
*/

endmodule
