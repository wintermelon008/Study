`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 10:40:19
// Design Name: 
// Module Name: Data_MEM
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
    ================================   Data_MEM module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.20

    This is the data memory.
    Use 4096 x 32bit dist RAM


*/

module Data_MEM(
    input clk,
    input [31:0] add_1,
    input [31:0] data_1,
    input we_1,
    input [2:0] mode,
    input [2:0] screen_mux_sel,

    input [14:0] radd_2,    // debug
    input slow_clk,
    output reg [31:0] out_1, 
    output reg [11:0] out_2,

    output reg dm_error
);


// Below is the DMU_mode list
    localparam BY_WORD = 3'h0;
    localparam BY_HALF = 3'h1;
    localparam BY_HALF_U = 3'h2;
    localparam BY_BYTE = 3'h3;
    localparam BY_BYTE_U = 4'h4;


wire dm_we;
wire [31:0] dm_din;
wire [31:0] dm_dout, stack_dout;
wire [11:0] screen_dout, screen_dout_map, screen_dout_finish_pic;
wire [14:0] dm_addr, screen_addr;

reg [31:0] din, dout;

assign dm_we = we_1;
assign dm_addr = add_1[14:0];
assign dm_din = din[11:0];
assign screen_addr = radd_2[14:0];


screen_data dm_block (
    .clka(clk),    // input wire clka
    .wea(dm_we),      // input wire [0 : 0] wea
    .addra(dm_addr),  // input wire [14 : 0] addra
    .dina(dm_din),    // input wire [11 : 0] dina
    .douta(dm_dout),

    .clkb(slow_clk),    // input wire clkb
    .addrb(screen_addr),  // input wire [14 : 0] addrb
    .web(1'b0),
    .dinb(12'b0),
    .doutb(screen_dout_map)  // output wire [11 : 0] doutb
);

success_data finish_pic (
    .clka(clk),    // input wire clka
    .wea(1'b0),      // input wire [0 : 0] wea
    .addra(15'b0),  // input wire [14 : 0] addra
    .dina(11'b0),    // input wire [11 : 0] dina
    .douta(),

    .clkb(slow_clk),    // input wire clkb
    .addrb(screen_addr),  // input wire [14 : 0] addrb
    .web(1'b0),
    .dinb(12'b0),
    .doutb(screen_dout_finish_pic)  // output wire [11 : 0] doutb
);

assign screen_dout = (screen_mux_sel == 3'b0) ? screen_dout_map : screen_dout_finish_pic;


always @(*) begin
    // store data
    din = data_1;
    case (mode)
        BY_WORD: begin
            din = data_1;
        end

        BY_HALF: begin
            if (data_1[15] == 1'b1)
                din = {{16{1'b1}}, {data_1[15:0]}};
            else
                din = {{16{1'b0}}, {data_1[15:0]}};
        end

        BY_BYTE: begin
            if (data_1[7] == 1'b1)
                din = {{24{1'b1}}, {data_1[7:0]}};
            else
                din = {{24{1'b0}}, {data_1[7:0]}};
        end

    endcase
end

always @(*) begin
    // load data
    out_1 = dout;
    case (mode)
        BY_WORD: begin
            out_1 = dout;
        end

        BY_BYTE: begin
            if (dout[7] == 1'b1)
                out_1 = {{24{1'b1}}, {dout[7:0]}};
            else
                out_1 = {{24{1'b0}}, {dout[7:0]}};
        end

        BY_BYTE_U: begin
            out_1 = {{24'b0}, {dout[7:0]}};
        end

        BY_HALF: begin
            if (dout[15] == 1'b1)
                out_1 = {{16{1'b1}}, {dout[15:0]}};
            else
                out_1 = {{16{1'b0}}, {dout[15:0]}};
        end

        BY_HALF_U: begin
            out_1 = {{16'b0}, {dout[15:0]}};
        end
    endcase
end


always @(*) begin
    dm_error = 1'b0;
    dout = {{20'b0}, {dm_dout[11:0]}};
end

always @(*) begin
    out_2 = screen_dout;
end


endmodule
