`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/11 12:06:18
// Design Name: 
// Module Name: PDU_v2
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
    ================================  PDU module   ================================
    Author:         Wintermelon
    Version: 2.1.4
    Last Edit:      2022.5.10

    This is the PDU top module

    Used sub-module:   
        * DPE
        * DATA_MOVE
        * Debouncer
        * MemoryMap
        * SEG_OUT
        * MUX4
        * REG
*/

// ### Version 2.1.4 update ###
// Change the structure to go with CPU

// ### Version 2.1.2 update ###
// Change the debug function.
// Now The program will stop at breakpoint.

// TODO: pdu_breakpoint

module PDU_v2(
    input clk,            //clk100mhz
    input rstn,           //cpu_reset_n

    input butu,           //butu
    input butd,           //butd
    input butr,            //butr
    input butc,           //butc
    input butl,            //butl
    input [15:0] sw,      //sw15-0

    output reg stop,            //led16r
    output [15:0] led,              //led15-0
    output [7:0] an,                //an7-0
    output [6:0] seg,               //ca-cg 
    output reg [2:0] seg_sel,       //led17

    // CTRL_BUS
    // cpu control form PDU
    output pdu_rstn,
    output [31:0] pdu_breakpoint,      
    output reg pdu_run,             // PDU's signal to enable CPU clock

    // cpu signials to PDU
    input cpu_stop,           // CPU's signal when CPU clock stops

    //IO_BUS
    input [15:0] io_addr,
    input [31:0] io_dout,
    input io_we,
    input io_rd,
    output [31:0] io_din,       // The data sending into CPU

    //Debug_BUS
    input [31:0] chk_if_pc, 	
    input [31:0] chk_id_pc,
    output [15:0] chk_addr,
    input [31:0] chk_data
);

// Below is the declaration of wires and regs ==========================================================================================

// Some consts
reg [3:0] ones;
reg [31:0] zero;

// DPE and Datamove wires
wire [3:0] hex;
wire plus;
reg datamove_en;
wire [31:0] datamove_din, datamove_dout;

// Buttons debounce
wire del;           //butu
wire cont;           //butd
wire chk_r;            //butr
wire data;           //butc
wire chk_l;            //butl

// Registers
reg breakpoint_address_reg_en;
reg check_address_reg_en;
wire [31:0] breakpoint_address_reg_din;


// Memory map
wire [31:0] mp_segment_dout;
wire [15:0] mp_led_dout;
wire [31:0] mp_buttons_din, mp_counter_din;

// Control
reg [1:0] chk_mux_sel;
reg check_enable;
reg cpu_clk_enable;
reg [1:0] segment_data_mux_sel, led_data_mux_sel;

// Counter and clocks
reg [31:0] counter;
wire clk_3M;
reg [10:0] cpu_clk_conter;

// Segments display

wire [31:0] segment_data;

// State machine
reg [7:0] current_state, next_state;



// Below is the connection of wires and regs ===============================================================================

initial begin
    ones <= 4'b1111;
    breakpoint_address_reg_en <= 1'b0;
    zero <= 32'h0;
end
assign pdu_rstn = rstn;
assign breakpoint_address_reg_din = (datamove_dout == 32'h0) ? chk_if_pc : datamove_dout;
// DPE and DataMove
// clock: system clock


//Below is the submodule declaration =====================================================================================

DPE dpe (
    .sw(sw),
    .clk(clk),
    .rstn(rstn),
    .hex(hex),
    .pulse(plus)
);

DATA_MOVE datamove(
    .din(datamove_din),
    .hex(hex),
    .add(plus), 
    .del(del),
    .set(datamove_en),
    .clk(clk),
    .rstn(rstn),
    .dout(datamove_dout)
);

// Buttons debounce

Debouncer db_butu(
    .ori_but(butu),
    .rstn(rstn),
    .clk(clk),
    .deb_but(del)
);

Debouncer db_butl(
    .ori_but(butl),
    .rstn(rstn),
    .clk(clk),
    .deb_but(chk_l)
);

Debouncer db_butd(
    .ori_but(butd),
    .rstn(rstn),
    .clk(clk),
    .deb_but(cont)
);

Debouncer db_butr(
    .ori_but(butr),
    .rstn(rstn),
    .clk(clk),
    .deb_but(chk_r)
);

Debouncer db_butc(
    .ori_but(butc),
    .rstn(rstn),
    .clk(clk),
    .deb_but(data)
);

// Memory map

MemoryMap mp (
    .clk(clk),
    .rstn(rstn),

    .io_addr(io_addr[7:0]),
    .io_dout(io_dout),
    .io_we(io_we),
    .io_rd(io_rd),
    .io_din(io_din),

    .sw_we(data),
    .switches_din(datamove_dout),
    .seg_rd(data),
    .segment_dout(mp_segment_dout),
    .buttons_din(mp_buttons_din),
    .counter_din(mp_counter_din),
    .led_dout(mp_led_dout)
);


// Output MUX


MUX4 #(32) datamove_din_mux(
    .data1(datamove_dout - 32'h1),
    .data2(datamove_dout + 32'h1),
    .data3(zero),
    .data4(datamove_dout),
    .sel(chk_mux_sel),
    .out(datamove_din)
);

MUX4 #(32) segment_data_mux(
    .data1(datamove_dout),
    .data2(mp_segment_dout),
    .data3(chk_data),
    .data4(32'b0),
    .sel(segment_data_mux_sel),
    .out(segment_data)
);

MUX4 #(16) led_data_mux(
    .data1(mp_led_dout),
    .data2(chk_addr),
    .data3(16'b0),
    .data4(16'b0),
    .sel(led_data_mux_sel),
    .out(led)
);

// Segments
SEG_OUT sg(
    .clk(clk),
    .rstn(rstn),
    .data(segment_data),
    //.data({{current_pc[15:0]}, {segment_data[15:0]}}),
    //.data(current_state),   // debug only
    //.data(mp_led_dout),     // debug only
    .an(an),
    .seg(seg)
);


// single Registers

REG #(16) check_address_reg(
    .din(datamove_dout[15:0]),
    .clk(clk),
    .rstn(rstn),
    .wen(check_address_reg_en),
    .dout(chk_addr)
);


REG #(32) breakpoint_address_reg(
    .din(breakpoint_address_reg_din),
    .clk(clk),
    .rstn(rstn),
    .wen(breakpoint_address_reg_en),
    .dout(pdu_breakpoint)
);

/*
    The PDU state machine =============================================================================================================

    CPU Running State: x0_

    Data edit state: x1_

    Debug state: x2_
        
*/
localparam Reset = 8'h00;
localparam Stop = 8'h11;

localparam RUN_CPU_ready = 8'h01;
localparam RUN_CPU = 8'h02;

localparam Run_UserInput_ready = 8'h03;
// # Run_UserInput
localparam Run_UserInput = 8'h04;
// This state will make cpu wait for users data input.
// After user press button[data], the cpu will continue running.


localparam Debug_ready = 8'h20;
localparam Debug = 8'h21;
localparam Debug_sub_do = 8'h22;
localparam Debug_sub_ready = 8'h23;
localparam Debug_add_do = 8'h24;
localparam Debug_add_ready = 8'h25;



// part1
always @(posedge clk or negedge rstn) begin
    if (~rstn)
        current_state <= Reset;
    else 
        current_state <= next_state;       
end

// part2
always @(*) begin
    case(current_state)
        Reset: next_state = Stop;
        Stop: begin
            if (cont) 
                next_state = RUN_CPU_ready;
            else if (chk_l)
                next_state = Debug_ready;
            else if (chk_r) 
                next_state = Debug_ready;
            else
                next_state = Stop;
        end

        RUN_CPU_ready: next_state = RUN_CPU;

        RUN_CPU: begin
            if (cpu_stop)
                next_state = Stop;
            else if (io_addr == 16'hFF10 && io_rd) 
            // cpu reads sw_available
                next_state = Run_UserInput_ready;
            else
                next_state = RUN_CPU;
        end

        Run_UserInput_ready: next_state = Run_UserInput;

        Run_UserInput: begin
            if (cpu_stop)
                next_state = Stop;            
            else if (data) begin
                next_state = RUN_CPU;
            end             
            else
                next_state = Run_UserInput;
        end

        Debug_ready: next_state = Debug;

        Debug: begin
            if (cont) 
                next_state = RUN_CPU_ready;
            else if (chk_l)
                next_state = Debug_sub_ready;
            else if (chk_r) 
                next_state = Debug_add_ready;
            else
                next_state = Debug;
        end

        Debug_sub_ready: next_state = Debug_sub_do;

        Debug_sub_do: begin
            next_state = Debug;
        end

        Debug_add_ready: next_state = Debug_add_do;

        Debug_add_do: begin
            next_state = Debug;
        end

        default: next_state = Reset;
    endcase
end

// part3
always @(posedge clk or negedge rstn) begin
    // The PDU signals
    pdu_run = 1'b0;
    if (~rstn) begin
        cpu_clk_enable <= 1'b0;
        datamove_en <= 1'b0;
        check_address_reg_en <= 1'b0;
        segment_data_mux_sel <= 2'b11;
        led_data_mux_sel <= 2'b11;
        stop <= 1'b1;
        seg_sel <= 3'b000;
        chk_mux_sel <= 2'b00;
        breakpoint_address_reg_en <= 1'b0;
    end
    else begin
        case(next_state) 
            Stop: begin
                cpu_clk_enable <= 1'b0;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b00;
                led_data_mux_sel <= 2'b11;
                stop <= 1'b1;
                seg_sel <= 3'b010;
                chk_mux_sel <= 2'b00;
                breakpoint_address_reg_en <= 1'b0;
            end

            Debug: begin      
                cpu_clk_enable <= 1'b0;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b10;
                led_data_mux_sel <= 2'b01;
                stop <= 1'b1;
                seg_sel <= 3'b100;
                chk_mux_sel <= 2'b11;
                breakpoint_address_reg_en <= 1'b0;
            end

            Debug_ready: begin      
                cpu_clk_enable <= 1'b0;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b1;
                segment_data_mux_sel <= 2'b10;
                led_data_mux_sel <= 2'b01;
                stop <= 1'b1;
                seg_sel <= 3'b100;
                chk_mux_sel <= 2'b11;
                breakpoint_address_reg_en <= 1'b0;
            end

            Debug_add_ready: begin      
                cpu_clk_enable <= 1'b0;
                datamove_en <= 1'b1;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b10;
                led_data_mux_sel <= 2'b01;
                stop <= 1'b1;
                seg_sel <= 3'b100;
                chk_mux_sel <= 2'b01;
                breakpoint_address_reg_en <= 1'b0;
            end
            
            Debug_add_do: begin          
                cpu_clk_enable <= 1'b0;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b1;
                segment_data_mux_sel <= 2'b10;
                led_data_mux_sel <= 2'b01;
                stop <= 1'b1;
                seg_sel <= 3'b100;
                chk_mux_sel <= 2'b01;
                breakpoint_address_reg_en <= 1'b0;
            end

            Debug_sub_ready: begin     
                cpu_clk_enable <= 1'b0;
                datamove_en <= 1'b1;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b10;
                led_data_mux_sel <= 2'b01;
                stop <= 1'b1;
                seg_sel <= 3'b100;
                chk_mux_sel <= 2'b00;
                breakpoint_address_reg_en <= 1'b0;
            end

            Debug_sub_do: begin          
                cpu_clk_enable <= 1'b0;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b1;
                segment_data_mux_sel <= 2'b10;
                led_data_mux_sel <= 2'b01;
                stop <= 1'b1;
                seg_sel <= 3'b100;
                chk_mux_sel <= 2'b00;
                breakpoint_address_reg_en <= 1'b0;
            end

            RUN_CPU_ready: begin
                cpu_clk_enable <= 1'b1;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b01;
                led_data_mux_sel <= 2'b00;
                stop <= 1'b0;
                seg_sel <= 3'b001;
                chk_mux_sel <= 2'b10;
                breakpoint_address_reg_en <= 1'b1;
            end

            RUN_CPU: begin        
                pdu_run = 1'b1;
                
                cpu_clk_enable <= 1'b1;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b01;
                led_data_mux_sel <= 2'b00;
                stop <= 1'b0;
                seg_sel <= 3'b001;
                chk_mux_sel <= 2'b10;
                breakpoint_address_reg_en <= 1'b0;
            end

            Run_UserInput_ready: begin     
                cpu_clk_enable <= 1'b1;
                datamove_en <= 1'b1;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b00;
                led_data_mux_sel <= 2'b10;
                stop <= 1'b0;
                seg_sel <= 3'b011;
                chk_mux_sel <= 2'b10;
                breakpoint_address_reg_en <= 1'b0;
            end

            Run_UserInput: begin        
                cpu_clk_enable <= 1'b1;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b00;
                led_data_mux_sel <= 2'b10;
                stop <= 1'b0;
                seg_sel <= 3'b011;
                chk_mux_sel <= 2'b10;
                breakpoint_address_reg_en <= 1'b0;
            end

            Reset: begin
                cpu_clk_enable <= 1'b0;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b11;
                led_data_mux_sel <= 2'b11;
                stop <= 1'b1;
                seg_sel <= 3'b000;
                chk_mux_sel <= 2'b00;
                breakpoint_address_reg_en <= 1'b0;
            end
        endcase
    end
end





// Clocks ==================================================================================================================
// Basic counter: plus1 every system_clk(100MHz)

always @(posedge clk or negedge rstn) begin
    if (~rstn)
        counter <= 0;
    else
        counter <= counter + 32'h1;
end





endmodule
