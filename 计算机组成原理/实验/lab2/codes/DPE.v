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
    A double edge detector
    When input change, it will figure out which switch has changed.
    The number will be outputed in hex

    last edit: 2022.3.27
*/

module DPE(
    input [15:0] sw,
    input sys_clk,
    input sys_rst,
    output reg [3:0] hex,
    output reg plus 
);
    reg [15:0] sw_change;
    reg [15:0] sw_1, sw_2, sw_3;

    always @(posedge sys_clk) begin

            sw_1 <= sw;
            sw_2 <= sw_1;
            sw_3 <= sw_2;
            //sw_change[1] <= (~sw_1) & sw;

    end
/*
    always @(posedge sys_clk) begin //test
        sw_change[1] <= sw;
    end
//*/

///*

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

    //assign sw_change[0] = (sw_1[0] & ~sw_2[0]) | (~sw_1[0] & sw_2[0]);
    
    /*
    always @(sw_change) begin
        if (sw_change[0] == 1)
            hex <= 4'h0;
        else
            hex <= hex;
    end
    always @(sw_change[1]) begin
        if (sw_change[1] == 1)
            hex <= 4'h1;
        else
            hex <= hex;
    end
    always @(sw_change[2]) begin
        if (sw_change[2] == 1)
            hex <= 4'h2;
        else
            hex <= hex;
    end
    always @(sw_change[3]) begin
        if (sw_change[3] == 1)
            hex <= 4'h3;
        else
            hex <= hex;
    end
    always @(sw_change[4]) begin
        if (sw_change[4] == 1)
            hex <= 4'h4;
        else
            hex <= hex;
    end
    always @(sw_change[5]) begin
        if (sw_change[5] == 1)
            hex <= 4'h5;
        else
            hex <= hex;
    end
    always @(sw_change[6]) begin
        if (sw_change[6] == 1)
            hex <= 4'h6;
        else
            hex <= hex;
    end
    always @(sw_change[7]) begin
        if (sw_change[7] == 1)
            hex <= 4'h7;
        else
            hex <= hex;
    end
    always @(sw_change[8]) begin
        if (sw_change[8] == 1)
            hex <= 4'h8;
        else
            hex <= hex;
    end
    always @(sw_change[9]) begin
        if (sw_change[9] == 1)
            hex <= 4'h9;
        else
            hex <= hex;
    end
    always @(sw_change[10]) begin
        if (sw_change[10] == 1)
            hex <= 4'ha;
        else
            hex <= hex;
    end
    always @(sw_change[11]) begin
        if (sw_change[11] == 1)
            hex <= 4'hb;
        else
            hex <= hex;
    end
    always @(sw_change[12]) begin
        if (sw_change[12] == 1)
            hex <= 4'hc;
        else
            hex <= hex;
    end
    always @(sw_change[13]) begin
        if (sw_change[13] == 1)
            hex <= 4'hd;
        else
            hex <= hex;
    end
    always @(sw_change[14]) begin
        if (sw_change[14] == 1)
            hex <= 4'he;
        else
            hex <= hex;
    end
    always @(sw_change[15]) begin
        if (sw_change[15] == 1)
            hex <= 4'hf;
        else
            hex <= hex;
    end

*/
///*
    always @(posedge sys_clk) begin
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
//*/
    always @(*) begin
        plus = sw_change[0] || sw_change[1] || sw_change[2] || sw_change[3] ||
                sw_change[4] || sw_change[5] || sw_change[6] || sw_change[7] ||
                sw_change[8] || sw_change[9] || sw_change[10] || sw_change[11] ||
                sw_change[12] || sw_change[13] || sw_change[14] || sw_change[15];
    end

endmodule
