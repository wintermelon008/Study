`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/11 14:25:08
// Design Name: 
// Module Name: MemoryMap
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
    ================================  MemoryMap module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.20

    This is the memory map inside the pdu   
*/


module MemoryMap(

    input clk,
    input rstn,

    // I/O bus with CPU
    input [7:0] io_addr,
    input [31:0] io_dout,
    input io_we,
    input io_rd,
    output reg [31:0] io_din,

    // Set number from PDU
    input sw_we,                    // Enter from user, means data has been entered 
    input [31:0] switches_din,      // The data from datamove

    input seg_rd,                   // Enter from user, means segdata has been read
    output [31:0] segment_dout,

    input [31:0] buttons_din, counter_din,
    output [15:0] led_dout

);

// Memory regs
reg [31:0] switches_data, buttons_data, counter_data, led_data, segment_data;
reg [31:0] segment_ready, switches_available;

assign segment_dout = segment_data;
assign led_dout = led_data[15:0];


// Set io_din: the data from I/O devices ============================================================================================
always @(*) begin
    case(io_addr) 
        8'h04: begin
            io_din = buttons_data;
        end
        8'h08: begin
            io_din = segment_ready;
        end
        8'h10: begin
            io_din = switches_available;
        end
        8'h14: begin
            io_din = switches_data;
        end
        8'h18: begin
            io_din = counter_data;
        end

        default:
            io_din = 32'h0;
    endcase
end


// Change Memory regs =====================================================================================================
// switches 
always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        switches_available <= 32'b0;
        switches_data <= 0;
    end
    else begin
        if (io_rd && io_addr == 8'h14) begin
            switches_available <= 32'h0000_0000;
        end
        else if (sw_we) begin
            switches_data <= switches_din;
            switches_available <= 32'h0000_0001;
        end
    end
end

// segments
always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        segment_ready <= 'b1;
        segment_data <= 32'h1234_5678;
    end
    else begin
        if(io_we && io_addr == 32'h0C) begin
            segment_data <= io_dout;
            segment_ready <= 32'h0000_0000;
        end
        else if (seg_rd) begin
            segment_ready <= 32'h0000_0001;
        end
    end
end

// led
always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        led_data <= 32'hFFFF_FFFF;       
    end
    else begin
        if (io_we && io_addr == 8'h00) begin
            led_data <= io_dout;
        end   
    end
end

// counter and buttons

always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        counter_data <= 0;
        buttons_data <= 0;     
    end
    else begin
        counter_data <= counter_din;
        buttons_data <= buttons_din;
    end
end

endmodule
