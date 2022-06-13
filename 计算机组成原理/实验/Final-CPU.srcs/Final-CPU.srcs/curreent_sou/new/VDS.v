`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/12 20:28:16
// Design Name: 
// Module Name: VDS
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


module VDS(
    input hen,
    input ven,
    input pclk,
    input rst,
    input [11:0] rdata,

    output reg [14:0] raddr,
    output reg [11:0] prgb
);
reg [19:0] cnt;
always@(posedge pclk) begin
    if (hen && ven) begin
        prgb = rdata;
    end
    else begin
        prgb = 12'b0;
    end
end

always@(posedge pclk) begin
    if (!rst) begin
        cnt <= 20'b0;
    end
    else if (cnt == 480000 - 1) begin
        cnt <= 20'b0;
    end
    else if (hen && ven) begin
        cnt <= cnt + 1'b1;
    end
    else begin
        cnt <= cnt;
    end
end

always@(posedge pclk) begin
    if (hen && ven) begin
        //raddr <= (cnt / 3200) * 200 + (cnt % 800) / 4;      // 画布和显示屏的关系
        raddr <= (cnt / 6400) * 100 + (cnt % 800) / 8;      // 画布和显示屏的关系
    end
    else begin
        //raddr <= 30000;
        raddr <= 7500;
    end
end
endmodule
