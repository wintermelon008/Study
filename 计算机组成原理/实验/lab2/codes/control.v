`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 11:05:12
// Design Name: 
// Module Name: control
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
    last edit: 2022.3.28
*/

module control(
    input [4:0] sys_but,
    input sys_clk,
    input sys_rst,
    input sort_finish,
    input sort_error,
    input [15:0] sort_cnt,
    output reg [7:0] mux,
    output reg input_en,
    output reg wen,
    output reg move_en,
    output reg [1:0] reg_en,
    output reg sort_start,
    output reg busy,
    output reg [15:0] led
    );

    reg [3:0] current_state, next_state;

    localparam ready = 4'd0;
    localparam data_edit_init = 4'd8;
    localparam data_edit = 4'd1;
    localparam save = 4'd2;
    localparam add_plus = 4'd3;
    localparam add_change = 4'd4;
    localparam sort_Sstart = 4'd5;
    localparam sort_wait = 4'd6;
    localparam sort_done = 4'd7;

    initial begin
        current_state <= 0;
        next_state <= 0;
    end


    /*  part 1
    sys_but table:
    sys_but[0] c save data
    sys_but[1] u set address
    sys_but[2] d run sort
    sys_but[3] l del data
    sys_but[4] r check next
    */
    always @(*) begin
        if (sys_rst == 0) begin
            // initial
            next_state = ready;
        end
        else begin
            case (current_state) 
                ready: begin
                    next_state = data_edit_init;
                end

                data_edit_init: begin
                    next_state = data_edit;
                end

                data_edit: begin
                    if (sys_but[0] == 1) begin
                        next_state = save;
                    end
                    else if (sys_but[1] == 1) begin
                        next_state = add_change;
                    end
                    else if (sys_but[2] == 1) begin
                        next_state = sort_Sstart;
                    end
                    else if (sys_but[4] == 1) begin
                        next_state = add_plus;
                    end
                    else begin
                        next_state = data_edit;
                    end
                end

                add_change: begin
                    next_state = data_edit_init;
                end

                add_plus: begin
                    next_state = data_edit_init;
                end

                save: begin
                    next_state = data_edit_init;
                end

                sort_Sstart: begin
                    if (sort_finish == 1) begin
                        next_state = sort_done;                    
                    end
                    else
                        next_state = sort_wait;
                end

                sort_wait: begin
                    if (sort_finish == 1)
                        next_state = sort_done;
                    else
                        next_state = sort_wait;
                end

                sort_done: begin
                    next_state = data_edit_init;
                end

                default : begin
                    next_state = ready;
                end
                    
            endcase
        end
    end

    //part2
    always @(posedge sys_clk or negedge sys_rst) begin
        if (sys_rst == 0)
            current_state <= ready;
        else
            current_state <= next_state;
    end

    //part3
    /*
    output reg [7:0] mux,
        mux[1:0] -> mux_1
        mux[2] -> mux2
        mux[3] -> mux3
        mux[4] -> mux4
        mux[6:5] -> mux5
        mux[7] -> mux6
    output reg input_en,
    output reg wen,
    output reg move_en.
    output reg [1:0] reg_en,
        reg_en[0] -> mar1
        reg_en[1] -> mar2
    output reg sort_start,
    output reg busy
    */
    always @(*) begin
        case (current_state) 
            data_edit: begin
                mux[1:0] = 2'b00;
                mux[2] = 1'b1;
                mux[3] = 1'b1;
                mux[4] = 1'b1;
                mux[6:5] = 2'b00;
                mux[7] = 1'b1;
                input_en = 1'b0;
                wen = 1'b0;
                move_en = 1'b1;
                reg_en = 2'b0;
                sort_start = 1'b0;
                busy = 1'b0;
            end

            data_edit_init: begin
                mux[1:0] = 2'b00;
                mux[2] = 1'b1;
                mux[3] = 1'b1;
                mux[4] = 1'b1;
                mux[6:5] = 2'b00;
                mux[7] = 1'b1;
                input_en = 1'b1;
                wen = 1'b0;
                move_en = 1'b1;
                reg_en = 2'b0;
                sort_start = 1'b0;
                busy = 1'b0;
            end

            save: begin
                mux[1:0] = 2'b00;
                mux[2] = 1'b1;
                mux[3] = 1'b1;
                mux[4] = 1'b1;
                mux[6:5] = 2'b00;
                mux[7] = 1'b1;
                input_en = 1'b0;
                wen = 1'b1;
                move_en = 1'b0;
                reg_en[0] = 1'b0;
                reg_en[1] = 1'b0;
                sort_start = 1'b0;
                busy = 1'b0;
            end

            add_plus: begin
                mux[1:0] = 2'b00;
                mux[2] = 1'b1;
                mux[3] = 1'b1;
                mux[4] = 1'b1;
                mux[6:5] = 2'b11;
                mux[7] = 1'b1;
                input_en = 1'b0;
                wen = 1'b0;
                move_en = 1'b0;
                reg_en[0] = 1'b1;
                reg_en[1] = 1'b0;
                sort_start = 1'b0;
                busy = 1'b0;

            end

            add_change: begin
                mux[1:0] = 2'b11;
                mux[2] = 1'b1;
                mux[3] = 1'b1;
                mux[4] = 1'b1;
                mux[6:5] = 2'b11;
                mux[7] = 1'b1;
                input_en = 1'b0;
                wen = 1'b0;
                move_en = 1'b0;
                reg_en[0] = 1'b1;
                reg_en[1] = 1'b0;
                sort_start = 1'b0;
                busy = 1'b0;
            end

            sort_Sstart: begin
                mux[1:0] = 2'b01;
                mux[2] = 1'b1;
                mux[3] = 1'b0;
                mux[4] = 1'b0;
                mux[6:5] = 2'b01;
                mux[7] = 1'b0;
                input_en = 1'b1;
                wen = 1'b0;
                move_en = 1'b0;
                reg_en[0] = 1'b1;
                reg_en[1] = 1'b1;
                sort_start = 1'b1;
                busy = 1'b1; 
            end

            sort_wait: begin
                mux[1:0] = 2'b01;
                mux[2] = 1'b1;
                mux[3] = 1'b0;
                mux[4] = 1'b0;
                mux[6:5] = 2'b01;
                mux[7] = 1'b0;
                input_en = 1'b1;
                wen = 1'b0;
                move_en = 1'b0;
                reg_en[0] = 1'b1;
                reg_en[1] = 1'b1;
                sort_start = 1'b0;
                busy = 1'b1; 
            end

            sort_done: begin
                mux[1:0] = 2'b01;
                mux[2] = 1'b0;
                mux[3] = 1'b0;
                mux[4] = 1'b0;
                mux[6:5] = 2'b01;
                mux[7] = 1'b0;
                input_en = 1'b1;
                wen = 1'b0;
                move_en = 1'b0;
                reg_en[0] = 1'b1;
                reg_en[1] = 1'b1;
                sort_start = 1'b0;
                busy = 1'b0; 
            end

            ready: begin
                mux[1:0] = 2'b10;
                mux[2] = 1'b0;
                mux[3] = 1'b0;
                mux[4] = 1'b1;
                mux[6:5] = 2'b01;
                mux[7] = 1'b1;
                input_en = 1'b1;
                wen = 1'b0;
                move_en = 1'b0;
                reg_en = 2'b0;
                sort_start = 1'b0;
                busy = 1'b0;
            end

            default: begin
                mux[1:0] = 2'b10;
                mux[2] = 1'b0;
                mux[3] = 1'b0;
                mux[4] = 1'b1;
                mux[6:5] = 2'b01;
                mux[7] = 1'b1;
                input_en = 1'b1;
                wen = 1'b0;
                move_en = 1'b0;
                reg_en = 2'b0;
                sort_start = 1'b0;
                busy = 1'b0;
            end

        endcase
    end

    always @(posedge sys_clk or negedge sys_rst) begin
        if (~sys_rst)
            led <= 0;
        else if (current_state == sort_done)
            led <= sort_cnt;
    end

endmodule
