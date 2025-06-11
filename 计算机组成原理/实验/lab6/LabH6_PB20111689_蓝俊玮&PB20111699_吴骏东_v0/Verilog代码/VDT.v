`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/12 19:53:29
// Design Name: 
// Module Name: VDT
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


module VDT(
    input pclk,
    input rst,

    output reg hen,
    output reg ven,
    output reg hs,
    output reg vs
);

parameter HSW = 120;
parameter HBP = 64;
parameter HEN = 800;
parameter HFP = 56;
parameter VSW = 6;
parameter VBP = 23;
parameter VEN = 600;
parameter VFP = 37;

reg [10:0] hcnt;
reg [9:0] vcnt;

initial begin
    hcnt <= 'd856;
    vcnt <= 'd637;
    vs <= 'b0;
    hs <= 'b0;
end

always@(posedge pclk) begin
    if (!rst) begin
        hcnt <= HEN + HFP;
    end
    else if (hcnt == HSW + HBP + HEN + HFP - 1) begin
        hcnt <= 0;
    end
    else begin
        hcnt <= hcnt + 1'b1;
    end
end

always@(posedge pclk) begin
    if (!rst) begin
        vcnt <= VEN + VFP;
    end
    else if (vcnt == VSW + VBP + VEN + VFP - 1) begin
        vcnt <= 0;
    end
    else if (hcnt == HEN + HFP - 1) begin
        vcnt <= vcnt + 1'b1;
    end
    else begin
        vcnt <= vcnt;
    end
end

always@(posedge pclk) begin
    if (!rst) begin
        hs <= 1'b0;
    end
    else if (hcnt == HEN + HFP + HSW - 1) begin
        hs <= 1'b0;
    end
    else if (hcnt == HEN + HFP -1) begin
        hs <= 1'b1;
    end
    else begin
        hs <= hs;
    end
end

always@(posedge pclk) begin
    if (!rst) begin
        vs <= 1'b0;
    end
    else if (vcnt == VEN + VFP + VSW - 1) begin
        vs <= 1'b0;
    end
    else if (vcnt == VEN + VFP - 1) begin
        vs <= 1'b1;
    end
    else begin
        vs <= vs;
    end
end

always@(*) begin
    if (hcnt < HEN) begin
        hen = 1'b1;
    end
    else begin
        hen = 1'b0;
    end
    if (vcnt < VEN) begin
        ven = 1'b1;
    end
    else begin
        ven = 1'b0;
    end
end
endmodule
