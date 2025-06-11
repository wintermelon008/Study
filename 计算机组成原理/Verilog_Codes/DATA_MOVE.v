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
    ================================   DATA_MOVE module   ================================
    Author:         Wintermelon
    Last Edit:      2022.3.28

    This is a special 32-bit number register
    Function:
        1.[Synchronous] When signal add comes, the number in register will left shift 4 bits and add the input hex number at last.
            dout = {{dout[27:0]}, {hex}}

        2.[Synchronous] When signal del comes, the number in register will right shift 4 bis (logical) and add 0 at first.
            dout = {{4'b0}, {dout[31:4]}}

        3.[Synchronous] When signal set comes, the number in register will be set as the input data.
            dout <= din

        4.[Asynchronous] When signal rstn comes, the number in register will be set as 0. 
            dout <= 0

        5. When no signal comes, the number in register will keep itself.

    In order to prevent protential data error, there will be a 100ms refractory period after each signal.

*/



module DATA_MOVE(
    input rstn,
    input clk,                  // work at 100MHz clock

    input [31:0] din,
    input [3:0] hex,
    input add,
    input del,
    input set,
    
    output reg [31:0] dout
);
    localparam TIMELIMIT = 10000000;
    reg [25:0] enable_cnt;
    reg enable_flag;
    reg add_1, del_1;

    initial begin
        enable_flag <= 1;
        enable_cnt <= 0;
        add_1 <= 0;
        del_1 <= 0;
        dout <= 0;
    end

    always @(posedge clk) begin
        add_1 <= add;
        del_1 <= del;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            dout <= 0;   
        else begin
            if (set == 1) 
                dout <= din;
            else if (add_1 && enable_flag) begin          
                enable_flag = 0;
                dout = {{dout[27:0]}, {hex}};
            end
            else if (del_1 && enable_flag) begin          
                enable_flag = 0;
                dout = {{4'b0}, {dout[31:4]}};
            end            
            if (enable_flag == 0) begin
                enable_cnt <= enable_cnt + 1'b1;
                if (enable_cnt > TIMELIMIT - 1) begin
                    enable_cnt <= 0;
                    enable_flag <= 1;
                end
            end
        end
    end


endmodule
