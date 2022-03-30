`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/27 15:33:40
// Design Name: 
// Module Name: Sort
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
    This is the sort module.
    Use selection sort.
    last edit: 2022.3.27 
*/

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

    integer i, k;
    
    // The used reg
    reg [15:0] current_number;
    reg [15:0] max_number;
    reg [7:0] max_address;
    reg [7:0] highest_address;
    reg [7:0] origin_highest_address;

    // The alu module relates
    reg [3:0] alu_sel;
    wire [31:0] ans;
    wire [2:0] sub_flag;
    wire alu_error;

    // The defination of timer
    reg [15:0] timer;
    reg timer_en;

    // The defination of State Machine
    reg [4:0] current_state;
    reg [4:0] next_state;


    localparam Reset = 5'h00;
    // Init all the signals and regs
    localparam Wait = 5'h01;     
    // Wait for the start signal

    localparam Start = 5'h02;
    // Enable the busy signal and start the timer

    localparam Read_ready = 5'h03;
    localparam Read_1 = 5'h04;
    localparam Read_2 = 5'h05;
    localparam Read_3 = 5'h06;   //Unuse.
    // Read state lasts 2 T.
    // Read_1 will output the target address
    // Read_2 will input the number in target address, and update the max_address and max_number

    localparam Exchange_ready = 5'h07;
    localparam Exchange_P1_1 = 5'h08;
    localparam Exchange_P1_2 = 5'h09;
    localparam Exchange_P1_3 = 5'h0a;
    localparam Exchange_P1_4 = 5'h0b;
    localparam Exchange_P2_1 = 5'h0c;
    localparam Exchange_P2_2 = 5'h0d;
    localparam Exchange_P2_3 = 5'h0e;
    localparam Exchange_P2_4 = 5'h0f;
    /*
        Exchange state lasts 4 T
        Exchange_P1_2~2 will store the largest number into last_addrsss
        Exchange_P2_2~4 will save the original number (at last_address) into max_address
    */
    
    localparam Sortdone_ready = 5'h10;

    localparam Sortdone = 5'h11;
    // Sortdone state will output the timer and disable the busy signal


    // Part 1: make out nextstate
    always @(*) begin
        if (~sys_rst)
            next_state = Reset;
        else begin
            case (current_state)
                Wait: begin
                    if (start)
                        next_state = Start;
                    else
                        next_state = Wait;
                end

                Reset: begin
                    next_state = Wait;
                end

                Start: begin
                    next_state = Read_ready;
                end

                Read_ready: begin
                    next_state = Read_1;
                end

                Read_1: begin
                    next_state = Read_2;
                end

                Read_2: begin
                    next_state = Read_3;
                end

                Read_3: begin
                    if (i < highest_address + 1)
                        next_state = Read_ready;
                    else
                        next_state = Exchange_ready;
                end

                Exchange_ready: begin
                    next_state = Exchange_P1_1;
                end

                Exchange_P1_2: begin
                    next_state = Exchange_P1_3;
                end

                Exchange_P1_1: begin
                    next_state = Exchange_P1_2;
                end

                Exchange_P1_3: begin
                    next_state = Exchange_P1_4;
                end

                Exchange_P1_4: begin
                    next_state = Exchange_P2_1;
                end

                Exchange_P2_1: begin
                    next_state = Exchange_P2_2;
                end

                Exchange_P2_2: begin
                    next_state = Exchange_P2_3;
                end

                Exchange_P2_3: begin
                    next_state = Exchange_P2_4;
                end

                Exchange_P2_4: begin
                    if (k < origin_highest_address)
                        next_state = Read_ready;
                    else
                        next_state = Sortdone_ready;
                end

                Sortdone_ready: begin
                    next_state = Sortdone;
                end

                Sortdone: begin
                    next_state = Reset;
                end

                default: begin
                    next_state = Reset;
                end

            endcase
        end
    end



    //Part 2: change the current_state
    always @(posedge sys_clk or negedge sys_rst) begin
        if (sys_rst == 0) begin
            current_state <= Reset;
        end
        else 
            current_state <= next_state;
    end

    reg [2:0] flag;

    // Part 3: outputs

    always @(posedge sys_clk or negedge sys_rst) begin
        if (~sys_rst) begin
            max_address <= 0;
            max_number <= 0;
            write_en <= 0;
            timer_en <= 0;
            done <= 0;
            highest_address <= 0;
            origin_highest_address <= 0;
            i <= 0;
            k <= 0;
            current_number <= 0;
            time_cnt <= 0;
        end
        else begin
            case(next_state)
                Reset: begin
                    max_address <= 0;
                    max_number <= 0;
                    write_en <= 0;
                    timer_en <= 0;
                    done <= 0;
                    highest_address <= 0;
                    origin_highest_address <= 0;
                    i <= 0;
                    k <= 0;
                    current_number <= 0;
                    time_cnt <= 0;
                    flag <= 0;
                end

                Wait: begin
                    max_address <= 0;
                    max_number <= 0;
                    write_en <= 0;
                    timer_en <= 0;
                    done <= 0;
                    highest_address <= 0;
                    origin_highest_address <= 0;
                    i <= 0;
                    k <= 0;
                    current_number <= 0;
                    time_cnt <= 0;
                    
                    flag <= 0;
                end

                Start: begin
                    timer_en <= 1;
                    i <= 0;
                    k <= 0;
                end

                Read_ready: begin
                    write_en <= 0;
                    origin_highest_address <= max_addr_i;
                end

                Read_1: begin
                    highest_address <= origin_highest_address - k;
                    add_o <= i;
                end

                Read_2: begin
                    //do nothing
                end

                Read_3: begin
                    current_number <= data_i;
                    if (current_number > max_number) begin
                        max_number <= current_number;
                        max_address <= i - 1;
                    end
                    i <= i + 1;
                end

                Exchange_ready: begin
                    if (current_number > max_number) begin
                        max_number <= current_number;
                        max_address <= i - 1;
                    end
                end

                Exchange_P1_1: begin
                    write_en <= 0;
                    data_o <= max_number;
                    add_o <= highest_address;
                end

                Exchange_P1_2:begin
                    //do nothing
                end

                Exchange_P1_3: begin
                    if (flag < 2) begin
                        write_en <= 1;
                        //flag <= flag + 1;
                    end
                end

                Exchange_P1_4: begin
                    //do nothing
                end

                Exchange_P2_1: begin
                    write_en <= 0;
                    data_o <= current_number;
                    add_o <= max_address;
                end

                Exchange_P2_2: begin
                    // do nothing
                end

                Exchange_P2_3: begin
                    if (flag < 2) begin
                        write_en <= 1;
                        //flag <= flag + 1;
                    end
                    
                end

                Exchange_P2_4: begin
                    i <= 0;
                    k <= k + 1;
                    max_address <= 0;
                    max_number <= 0;
                    current_number <= 0;
                end

                Sortdone_ready: begin
                    write_en <= 0;
                    done <= 1;
                    time_cnt <= timer;
                end

                Sortdone: begin
                    timer_en <= 0;
                    //do nothing
                end

            endcase
        end
    end
    


    // The timer
    always @(posedge sys_clk or negedge sys_rst) begin
        if (~sys_rst)
            timer <= 16'b0;
        else if (timer_en)
            timer <= timer + 1'b1;
    end


   // The alu
    ALU #(16) maxer (max_number, current_number, alu_sel, ans, sub_flag, alu_error);

endmodule
