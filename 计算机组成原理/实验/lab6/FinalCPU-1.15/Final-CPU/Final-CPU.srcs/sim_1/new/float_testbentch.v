`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/05 08:21:31
// Design Name: 
// Module Name: float_testbentch
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


module float_testbentch();

reg clk;
reg [31:0] num1, num2, ans;
reg ans_valid;

initial begin
    clk <= 1'b0;
    num1 <= 0;
    num2 <= 0;
    num1 <= 32'h3FC0_0000;  // 1.1 x 2^0
    num2 <= 32'h3FE0_0000;  // 1.11 x 2^0
end

always #2 clk <= ~clk;

FADD fadd (
  .aclk(clk),                                  // input wire aclk
  .s_axis_a_tvalid(32'b1),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(num1),              // input wire [31 : 0] s_axis_a_tdata

  .s_axis_b_tvalid(32'b1),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(num1),              // input wire [31 : 0] s_axis_b_tdata

  .m_axis_result_tvalid(ans_valid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(ans)    // output wire [31 : 0] m_axis_result_tdata
);
endmodule
