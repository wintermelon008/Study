`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 09:42:28
// Design Name: 
// Module Name: lab2top
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
    This is the top module for lab2
    with many sub modules.

    last edit: 2022.3.28
*/

module lab2top(
    input [15:0] sw,
    input butc,         //data
    input butr,         //check
    input butl,         //del
    input butu,         //address
    input butd,         //run sort
    input sys_rst,
    input sys_clk,
    output [7:0] an,
    output [6:0] seg,
    output busy,  //busy
    output [15:0] led   //time count
);

// common data path
wire [15:0] outdata;
reg [15:0] zeros;

// control signals
wire [7:0] mux;

// dpe wires
wire [3:0] hex;
wire plus;

// datamove wires
wire [15:0] data_shift_i, data_shift_o;
wire del_m;  //直接和but相连
wire del;
wire input_en;
wire plus_m;

// mem wires
wire [15:0] mem_out_1, mem_out_2;
wire [7:0] mem_add_1, mem_radd_2;
wire [7:0] mem_max_add;
wire mem_we;

//mux wires
wire [7:0] mux1_i1, mux1_i2;
wire [7:0] mux1_o;
wire [15:0] mux6_1;

// ctrl wires
wire [4:0] sys_but;
wire sort_done, sort_start, sort_error;
wire [10:0] sort_cnt;
wire wen;
wire move_en;
wire [1:0] reg_en;

// sort wires
wire sort_we;
wire [15:0] sortdata_o;

//segout wires
wire [7:0] seg_add;
wire [15:0] seg_data;


initial begin
    zeros <= 0;
end


DPE dpe(sw, sys_clk, sys_rst, hex, plus);
/*
    input [15:0] sw,
    input sys_clk,
    input sys_rst,
    output reg [3:0] hex,
    output reg plus 
*/

assign plus_m = plus && move_en;
assign del_m = del && move_en;
DataMove datamove(data_shift_i, hex, plus_m, del_m, input_en, sys_clk, data_shift_o);
/*
    input [15:0] data_i,
    input [3:0] hex,
    input add,
    input del,
    input input_en,
    input sys_clk
    output reg [15:0] data_o
*/


MUX4 #(8) mux_1(mux1_i1, mux1_i2, zeros[7:0], data_shift_o[7:0], mux[1:0], mux1_o);
MUX2 #(16) mux_2(outdata, zeros, mux[2], data_shift_i);
MUX2 #(8) mux_3(mem_add_1, zeros[7:0], mux[3], seg_add);
MUX2 #(16) mux_4(mem_out_1, mem_out_2, mux[4], mux6_1);
MUX4 #(16) mux_5(data_shift_o, zeros, zeros, mux6_1, mux[6:5], seg_data);
MUX2 #(16) mux_6(mux6_1, sortdata_o, mux[7], outdata);

/*====MUX2====
#( 信号�????? 1 选择 data1
    parameter DATA_WIDTH = 32           // 数据信号宽度
)
(
    input [DATA_WIDTH-1 : 0] data1, data2,
    input  sel,
    output [DATA_WIDTH-1 : 0] out
);
=====MUX4=====
#( 信号�????? 00 选择 data1
    parameter DATA_WIDTH = 32           // 数据信号宽度
)
(
    input [DATA_WIDTH-1 : 0] data1, data2, data3, data4,
    input [1:0] sel,
    output reg [DATA_WIDTH-1 : 0] out
);
*/

assign mem_we = wen || sort_we;
MEM mem(sys_clk, mem_add_1, data_shift_o, mem_we, mem_radd_2, mem_out_1, mem_out_2, mem_max_add);
/*
module MEM(
    input sys_clk,
    input [7:0] add_1,
    input [15:0] data_1,
    input we_1,
    input [7:0] radd_2,
    output reg [15:0] out_1, out_2,
    output reg [7:0] highest_add
);
*/


Dff #(8) mar_1 (mux1_o, sys_clk, sys_rst, reg_en[0], mem_add_1);
Dff #(8) mar_2 (mux1_i2, sys_clk, sys_rst, reg_en[1], mem_radd_2);
/*
#(
    parameter DATA_WIDTH = 32           // 数据信号宽度
)
(
    input [DATA_WIDTH-1 : 0] d,
    input  clk, rst_n, en,
    output reg [DATA_WIDTH-1 : 0] q
);
*/



control ctrl(sys_but, sys_clk, sys_rst, sort_done, sort_error, sort_cnt, mux, input_en, wen, move_en, reg_en, sort_start, busy, led);
/*
module control(
    input [4:0] sys_but,
    input sys_clk,
    input sys_rst,
    input sort_done,
    input sort_error,
    input sort_cnt,
    output reg [6:0] mux,
    output reg input_en,
    output reg we_mux,
    output reg [1:0] reg_en,
    output reg sort_start,
    output reg busy
    );
*/



Sort sort(sys_clk, sys_rst, sort_start, mem_out_2, mem_max_add, sortdata_o, mux1_i2, sort_error, sort_done, sort_cnt, sort_we);
/*
module Sort(
    input sys_clk,
    input sys_rst,
    input start,
    input [15:0] data_i,        // the input data
    input [7:0] max_addr_i,       // the max used address of MEM 
    output reg [15:0] data_o,   
    output reg [7:0] add_o,
    output reg error,
    output reg done,
    output reg [15:0] time_cnt,
    output reg write_en

);
*/


seg_out out(sys_clk, sys_rst, seg_add, seg_data, an, seg);
/*
module seg_out(
    input sys_clk,
    input sys_rst,
    input [7:0] address,
    input [15:0] data,
    output reg [7:0] an,
    output reg [6:0] seg
    );
*/


Debouncer but_c (butc, sys_rst, sys_clk, sys_but[0]);
Debouncer but_u (butu, sys_rst, sys_clk, sys_but[1]);
Debouncer but_d (butd, sys_rst, sys_clk, sys_but[2]);
Debouncer but_l (butl, sys_rst, sys_clk, del);
Debouncer but_r (butr, sys_rst, sys_clk, sys_but[4]);
/*

sys_but table:
    sys_but[0] c save data
    sys_but[1] u set address
    sys_but[2] d run sort
    sys_but[3] l del data
    sys_but[4] r check next

module Debouncer(
    input ori_but,
    input sys_rst,
    input sys_clk,      //enable when low voltage
    output reg deb_but
);
*/


Plus1 #(8) plus1(mem_add_1, mux1_i1);
/*
module Plus1
#(
    parameter WIDTH = 32                          //数据宽度
)
(
    input [WIDTH-1:0] data_i,
    output reg [WIDTH-1:0] data_o
);
*/

endmodule
