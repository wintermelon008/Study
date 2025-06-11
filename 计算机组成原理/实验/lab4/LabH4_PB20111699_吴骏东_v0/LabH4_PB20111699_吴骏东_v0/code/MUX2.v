`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/21 19:18:30
// Design Name: 
// Module Name: MUX2
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
 * һ��������ѡһ����ѡ����
 * ���� data1, data2, ��� out
 * �ź�Ϊ 1 ѡ�� data1
 * Author:      wintermelon
 * Last edit:   2022.3.21
*/


module MUX2 
#(
    parameter DATA_WIDTH = 32           // �����źſ��
)
(
    input [DATA_WIDTH-1 : 0] data1, data2,
    input  sel,
    output [DATA_WIDTH-1 : 0] out
);

    assign out = (sel) ? data1 : data2;
endmodule


