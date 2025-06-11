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
    The modulized PDU
    Author: wintermelon
    last edit: 2022.4.11
*/
module PDU_v2(
    input clk,            //clk100mhz
    input rstn,           //cpu_reset_n

    input butu,           //butu
    input butd,           //butd
    input butr,            //butr
    input butc,           //butc
    input butl,            //butl
    input [15:0] sw,      //sw15-0

    output reg cpu_stop,            //led16r
    output [15:0] led,          //led15-0
    output [7:0] an,        //an7-0
    output [6:0] seg,       //ca-cg 
    output reg [2:0] seg_sel,   //led17

    output reg clk_cpu,       //cpu's clk
    output rstn_cpu,       //cpu's rst

    //IO_BUS
    input [7:0] io_addr,
    input [31:0] io_dout,
    input io_we,
    input io_rd,
    output [31:0] io_din,       // The data sending into CPU

    //Debug_BUS
    input [31:0] current_pc,
    output [15:0] chk_addr,
    input [31:0] chk_data
);

// Below is the declaration of wires and regs ==========================================================================================

// Some consts
reg [3:0] ones;

// DPE and Datamove wires
wire [3:0] hex;
wire plus;
reg datamove_en;
wire [31:0] datamove_din, datamove_dout;

// Buttons debounce
wire step;           //butu
wire cont;           //butd
wire chk;            //butr
wire data;           //butc
wire del;            //butl

// Registers
reg breakpoint_address_reg_en;
reg check_address_reg_en;
wire [31:0] breakpoint_address;

// Memory map
wire [31:0] mp_segment_dout;
wire [15:0] mp_led_dout;
wire [31:0] mp_buttons_din, mp_counter_din;

// Control
reg check_enable;
reg cpu_clk_enable;
reg cpu_clk_continue;
wire seg_rd;
reg [1:0] segment_data_mux_sel, led_data_mux_sel;

// Counter and clocks
reg [31:0] counter;
wire clk_3M;
reg [10:0] clk_3M_counter;
reg cpu_stop_flag;      // cpu has run 1 clock, and it's time to stop

// Segments display

wire [31:0] segment_data;

// State machine
reg [7:0] current_state, next_state;



// Below is the connection of wires and regs ===============================================================================

initial begin
    ones <= 4'b1111;
    breakpoint_address_reg_en <= 1'b0;
end
assign rstn_cpu = rstn;
assign datamove_din = datamove_dout + 1'b1;
// DPE and DataMove
// clock: system clock

// The control signals
assign seg_rd = (plus | del ) | data;

//Below is the submodule declaration =====================================================================================

DPE dpe (
    .sw(sw),
    .clk(clk),
    .rstn(rstn),
    .hex(hex),
    .plus(plus)
);

DataMove datamove(
    .data_i(datamove_din),
    .hex(hex),
    .add(plus),
    .del(del),
    .input_en(datamove_en),
    .clk(clk),
    .rstn(rstn),
    .data_o(datamove_dout)
);

// Buttons debounce

Debouncer db_butu(
    .ori_but(butu),
    .rstn(rstn),
    .clk(clk),
    .deb_but(step)
);

Debouncer db_butl(
    .ori_but(butl),
    .rstn(rstn),
    .clk(clk),
    .deb_but(del)
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
    .deb_but(chk)
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

    .io_addr(io_addr),
    .io_dout(io_dout),
    .io_we(io_we),
    .io_rd(io_rd),
    .io_din(io_din),

    .sw_we(data),
    .switches_din(datamove_dout),
    .seg_rd(seg_rd),
    .segment_dout(mp_segment_dout),
    .buttons_din(mp_buttons_din),
    .counter_din(mp_counter_din),
    .led_dout(mp_led_dout)
);


// Output MUX
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
seg_out sg(
    .clk(clk),
    .rstn(rstn),
    .data(segment_data),
    //.data(current_state),   // debug only
    //.data(mp_led_dout),     // debug only
    .an(an),
    .seg(seg)
);


// single Registers

Reg #(16) check_address_reg(
    .din(datamove_dout[15:0]),
    .clk(clk),
    .rstn(rstn),
    .en(check_address_reg_en),
    .dout(chk_addr)
);

Reg #(32) breakpoint_address_reg(
    .din(datamove_dout),
    .clk(clk),
    .rstn(rstn),
    .en(breakpoint_address_reg_en),
    .dout(breakpoint_address)
);

/*
    The PDU state machine =============================================================================================================

    CPU Running State: x0_
        00: CPU reset
        01: CPU ready
        02: CPU run

    Data edit state: x1_
        10: editing data

    Debug state: x2_
        20
*/
localparam Reset = 8'h00;
localparam Stop = 8'h11;
localparam Run_Single = 8'h01;
localparam Run_Breakpoint = 8'h02;
localparam Debug_continue = 8'h22;



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
            if (step)
                next_state = Run_Single;
            else if (cont) 
                next_state = Run_Breakpoint;
            else if (chk) 
                next_state = Debug_continue;
            else
                next_state = Stop;
        end

        Run_Single: begin
            if (cpu_stop_flag)
                next_state = Stop;
            else
                next_state = Run_Single;    
        end

        Run_Breakpoint: begin
            if (current_pc == breakpoint_address || current_pc > breakpoint_address)
                next_state = Stop;
            else
                next_state = Run_Breakpoint;
        end

        Debug_continue: begin
            if (step)
                next_state = Run_Single;
            else if (cont) 
                next_state = Run_Breakpoint;
            else if (chk) 
                next_state = Debug_continue;
            else
                next_state = Debug_continue;
        end

        default: next_state = Reset;
    endcase
end

// part3
always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        cpu_clk_continue <= 1'b0;
        cpu_clk_enable <= 1'b0;
        datamove_en <= 1'b0;
        check_address_reg_en <= 1'b0;
        segment_data_mux_sel <= 2'b11;
        led_data_mux_sel <= 2'b11;
        cpu_stop <= 1'b0;
        seg_sel <= 3'b000;
    end
    else begin
        case(next_state) 
            Stop: begin
                cpu_clk_continue <= 1'b0;
                cpu_clk_enable <= 1'b0;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b00;
                led_data_mux_sel <= 2'b11;
                cpu_stop <= 1'b1;
                seg_sel <= 3'b010;
            end
            
            Debug_continue: begin      
                cpu_clk_continue <= 1'b0;        
                cpu_clk_enable <= 1'b0;
                datamove_en <= chk;
                check_address_reg_en <= chk;
                segment_data_mux_sel <= 2'b10;
                led_data_mux_sel <= 2'b01;
                cpu_stop <= 1'b1;
                seg_sel <= 3'b100;
            end

            Run_Single: begin
                cpu_clk_continue <= 1'b0;
                cpu_clk_enable <= 1'b1;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b01; 
                led_data_mux_sel <= 2'b00;      
                cpu_stop <= 1'b0;
                seg_sel <= 3'b001;
            end

            Run_Breakpoint: begin  
                cpu_clk_continue <= 1'b1;          
                cpu_clk_enable <= 1'b1;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b01;
                led_data_mux_sel <= 2'b00;
                cpu_stop <= 1'b0;
                seg_sel <= 3'b001;
            end

            Reset: begin
                cpu_clk_continue <= 1'b0;
                cpu_clk_enable <= 1'b0;
                datamove_en <= 1'b0;
                check_address_reg_en <= 1'b0;
                segment_data_mux_sel <= 2'b11;
                led_data_mux_sel <= 2'b11;
                cpu_stop <= 1'b1;
                seg_sel <= 3'b000;
            end
        endcase
    end
end

always @(*) begin
    breakpoint_address_reg_en = cont;
end




// Clocks ==================================================================================================================
// Basic counter: plus1 every system_clk(100MHz)

always @(posedge clk or negedge rstn) begin
    if (~rstn)
        counter <= 0;
    else
        counter <= counter + 32'h1;
end


// CPU clock control
localparam CPU_CLK_N = 11'd50;
always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        clk_3M_counter <= 0;
        cpu_stop_flag <= 0;
        clk_cpu <= 0;
    end
    else begin
        if (cpu_clk_enable || clk_3M_counter != 0) begin    
            if (clk_3M_counter > CPU_CLK_N + CPU_CLK_N) begin
                if (~cpu_clk_continue)
                    cpu_stop_flag <= 1;
                clk_3M_counter <= 'h0;
                clk_cpu <= 0;
            end
            else begin               
                if (clk_3M_counter < CPU_CLK_N)
                    clk_cpu <= 1;
                else 
                    clk_cpu <= 0;
                clk_3M_counter <= clk_3M_counter + 'h1;
            end
        end
        else begin
            cpu_stop_flag <= 0;
        end
       
    end
end


endmodule
