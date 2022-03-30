`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 10:20:27
// Design Name: 
// Module Name: DataMove
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
    A 16-bit Shift Register
    when add: d = {d[11:0], hex}
    when del: d = {0, d[15:4]}
    else d = d

    last edit 2022.3.28
*/

module DataMove(
    input [15:0] data_i,
    input [3:0] hex,
    input add,
    input del,
    input input_en,
    input sys_clk,
    output reg [15:0] data_o
);
    initial begin
        data_o <= 0;
    end

    localparam TIMELIMIT = 10000000;
    reg [25:0] enable_cnt;
    reg enable_flag;
    reg add_1, del_1;

    initial begin
        enable_flag <= 1;
        enable_cnt <= 0;
        add_1 <= 0;
        del_1 <= 0;
        data_o <= 0;
    end

    always @(posedge sys_clk) begin
        add_1 <= add;
        del_1 <= del;
    end

    always @(posedge sys_clk) begin
        if (input_en == 1) 
            data_o <= data_i;
        else if (add_1 && enable_flag) begin          
            enable_flag = 0;
            data_o = {{data_o[11:0]}, {hex}};
        end
        else if (del_1 && enable_flag) begin          
            enable_flag = 0;
            data_o = {{4'b0}, {data_o[15:4]}};
        end
            
        if (enable_flag == 0) begin
            enable_cnt <= enable_cnt + 1'b1;
            if (enable_cnt > TIMELIMIT - 1) begin
                enable_cnt <= 0;
                enable_flag <= 1;
            end
        end
    end


endmodule
