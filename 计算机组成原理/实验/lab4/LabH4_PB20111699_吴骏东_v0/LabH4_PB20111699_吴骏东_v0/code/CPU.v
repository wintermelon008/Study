`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/06 15:01:07
// Design Name: 
// Module Name: CPU
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
    This is the single T CPU top module

    last edit: 2022.4.6
*/


module CPU(
    input clk, 
    input rstn,

    //IO_BUS
    output reg [7:0] io_addr,	        // The address for I/O devices
    output reg [31:0] io_dout,	        // The data waiting to output
    output  io_we,		            // I/O writing_enable
    output  io_rd,		            // I/O read_enable
    input [31:0]  io_din,	        // The data from I/O devices

    //Debug_BUS
    output reg [31:0] pc, 	            // Current_pc
    input [15:0] chk_addr,	        // Check current datapath state (code)
    output reg [31:0] chk_data      // Current datapath state data

);

wire nclk;
assign nclk = ~clk;

// debug datas
reg [31:0] alu_ans_reg, rf_din_r, dataA_reg, dataB_reg, dm_dout_reg;


// Below is the  declaration of wires and regs used in sub-module =======================================================================

// PC
wire [31:0] pc_in, pc_out;
wire pc_en;     // This is always 1

// IM 
wire [7:0] im_chk_address;
wire [31:0] im_useless2, im_chk_data;
wire [31:0] instruction;

// DM
wire [7:0] dm_check_address;
wire [31:0] dm_check_data;
wire dm_we;
wire [31:0] dm_dout;

// Control
localparam SIGNUM = 25;     // The number of signals
wire [SIGNUM-1:0] signals;

// MUXs
wire imm_mux_sel, io_dm_mux_sel;
wire [1:0] sr1_mux_sel,  sr2_mux_sel, rf_mux_sel, npc_mux_sel;
wire [31:0] sr1_mux_out, sr2_mux_out, imm_mux_out, io_dm_mux_out;
reg [31:0] zeros;

// Regfile
wire [4:0] rs1, rs2, rd;
wire [31:0] dataA, dataB, rf_din;
wire rf_we;
wire [4:0] rf_check_address;
wire [31:0] rf_check_data;

// ALUs
wire [31:0] alu_ans;
wire [2:0] alu_flag;
wire alu_error;
wire [31:0] plus_pc, offset_pc;

wire [2:0] alu_useless1, alu_useless3;
wire alu_useless2, alu_useless4;

reg [31:0] four;
reg [3:0] add_mode;

// Sign Extend
wire [31: 0] sexd12, sexd20, sexd_left;


// Below is the wires connection

assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign rd = instruction[11:7];

assign sr1_mux_sel = signals[2:1];
assign sr2_mux_sel = signals[4:3];
assign imm_mux_sel = signals[5];
assign rf_mux_sel = signals[7:6];

assign rf_we = signals[15];
assign dm_we = signals[16];
assign pc_en = signals[17];
assign io_rd = signals[18];
assign io_we = dm_we;

// The I/O and DM read&write 
assign io_dm_mux_sel = (alu_ans[15:8] == 8'hff)? 1'b1 : 1'b0;   
// Suppose output devices address starts from xFF00
// When 1, the data is to and from I/O
// When 0, the data is to and from DM

// The debug datas
assign rf_check_address = chk_addr[4:0];
assign dm_check_address = chk_addr[7:0];

// Below is the control signals' list ==================================================================================================
/*
    MUX Ctrl signal:

    signals[2:1] - rs1mux
    signals[4:3] - rs2mux
    signals[5] - immmux
    signals[7:6] - rfmux

    ALU mode signal:
    signals[13:10] - alusel

    Regfile writing enable:
    signals[15] - rf_we

    Data memory and I/O writing enable:
    signals[16] - dm_we

    PC writing enable:
    signals[17] - pc_en

    I/O reading enable
    signals[18] - io_re

    Jump control signal:
    signals[22:19] - jump_ctrl
*/
/*
    ### Why DM needs the read_en signal?
    No Need!
*/




// Below is the sub-module declaration ===================================================================================================

// PC


Dff #(32) reg_pc (
    .d(pc_in),
    .q(pc_out),
    .clk(clk),
    .en(pc_en)
);


// IM 
Instruction_MEM im (
    .sys_clk(add_mode[0]),
    .add_1(im_chk_address),
    .data_1(im_useless2),
    .we_1(zeros[0]),
    .radd_2(pc_out[9:2]),
    .out_1(im_chk_data),
    .out_2(instruction)
);

// 0000_0000_0000_0000_0010_1111_1111_1100

// DM
Data_MEM dm (
    .sys_clk(nclk),
    .add_1(alu_ans[9:2]),
    .data_1(dataB),
    .we_1(dm_we),
    .radd_2(dm_check_address),
    .out_1(dm_dout),
    .out_2(dm_check_data)
);


// Control
Control #(SIGNUM) ctrl(
    .instruction(instruction),
    .control_signal(signals)
);


// Regfile
RegFile #(5, 32) rf (
    .sys_clk(nclk),
    .ra0(rs1),
    .ra1(rs2),
    .ra2(rf_check_address),
    .rd0(dataA),
    .rd1(dataB),
    .rd2(rf_check_data),
    .we(rf_we),
    .wa(rd),
    .wd(rf_din)
);

// ALUs
initial begin
    four <= 'd4;
    add_mode <= 'd1;   
end

ALU #(32) alu (
    .num1(sr1_mux_out),
    .num2(sr2_mux_out),       
    .sel(signals[13:10]),         
    .ans(alu_ans),
    .sub_flag(alu_flag),
    .error(alu_error)
);

ALU #(32) plus4(
    .num1(pc_out),        
    .num2(four),        
    .sel(add_mode),         
    .ans(plus_pc),
    .sub_flag(alu_useless1),
    .error(alu_useless2)
);

ALU #(32) pcoffset(
    .num1(pc_out),        
    .num2(imm_mux_out),        
    .sel(add_mode),         
    .ans(offset_pc),         
    .sub_flag(alu_useless3),
    .error(alu_useless4)
);


// MUXs

initial begin
    zeros <= 0;
end

MUX4 #(32) npcmux(
    .data1(plus_pc),       
    .data2(offset_pc),
    .data3({{alu_ans[31:1]}, {1'b0}}),
    .data4(zeros),       
    .sel(npc_mux_sel),
    .out(pc_in)
);

MUX4 #(32) sr1mux(
    .data1(pc_out),
    .data2(zeros),
    .data3(zeros),
    .data4(dataA),
    .sel(sr1_mux_sel),
    .out(sr1_mux_out)
);

MUX4 #(32) sr2mux(
    .data1(dataB),          
    .data2(sexd12),
    .data3(sexd_left),
    .data4(zeros),
    .sel(sr2_mux_sel),
    .out(sr2_mux_out)
);

MUX4 #(32) rfmux(
    .data1(alu_ans),       
    .data2(io_dm_mux_out),
    .data3(plus_pc),
    .data4(zeros),
    .sel(rf_mux_sel),
    .out(rf_din)
);

MUX2 #(32) immmux(
    .data1(sexd20),
    .data2(sexd12),
    .sel(imm_mux_sel),
    .out(imm_mux_out)
);

MUX2 #(32) io_dm_mux(
    .data1(io_din),
    .data2(dm_dout),
    .sel(io_dm_mux_sel),
    .out(io_dm_mux_out)
);


// Sign Extend
Signextend #(32) sexd (
    .instruction(instruction),
    .n12bitout(sexd12),
    .n20bitout(sexd20),
    .left12out(sexd_left)
);


// Branch
BranchCtrl bctrl(
    .branch_sel(signals[22:19]),
    .sub_flag(alu_flag),
    .npcmux(npc_mux_sel)
);

// Below is the I/O input and output ================================================================================================
always @(*) begin
    if (~rstn)
        io_dout = 0;
    else
        io_dout = dataB;
end

always @(*) begin
    if (~rstn)
        io_addr = 0;
    else
        io_addr = alu_ans[7:0];
end





// Below is the output for debug messeges ===========================================================================================


always @(*) begin
    pc = pc_out;
end


/*
    Checkaddr decode table
    Decide the checkdata output
*/

always @(*) begin
    case(chk_addr[15:12])
        4'h0: begin     // datapath status
            if (chk_addr[11:4] == 8'h0) begin   // available input
                case(chk_addr[3:0])
                    4'h0: chk_data = pc_in;
                    4'h1: chk_data = pc;
                    4'h2: chk_data = instruction;
                    4'h3: chk_data = {{15'b0}, {signals[22:17]}, {signals[13:10]}, {signals[7:1]}};
                    4'h4: chk_data = dataA_reg;
                    4'h5: chk_data = dataB_reg;
                    4'h6: chk_data = sexd12;
                    4'h7: chk_data = alu_ans_reg;
                    4'h8: chk_data = dm_dout_reg;

                    default: chk_data = 32'h0;
                endcase
            end
            else
                chk_data = 32'h0;
        end

        4'h1: begin     // read RF
            chk_data = rf_check_data;
        end

        4'h2: begin
            chk_data = dm_check_data;
        end

        default: begin
            chk_data = 32'h0;
        end
    endcase
end
/*
    Below is the meaning of check data ==============================================================================================
    data[15:0] rf_din
    data[31:16] pc
    pc[4:0] sr2
    pc[9:5] sr1
    pc[15] rf_en
    pc[14] dm_en 
    pc[13:12] rf_mux
    pc[11:10] npc_mux
*/

always @(posedge nclk or negedge rstn) begin
    if (~rstn) begin
        alu_ans_reg <= 0;
        dataA_reg <= 0;
        dataB_reg <= 0;
        dm_dout_reg <= 0;
    end
    else begin
        alu_ans_reg <= alu_ans;
        dataA_reg <= dataA;
        dataB_reg <= dataB;
        dm_dout_reg <= io_dm_mux_out;
    end
end

always @(posedge nclk or negedge rstn) begin
    if (~rstn)
        rf_din_r <= 0;
    else begin
        rf_din_r <= rf_din;
    end
end
/*
assign chk_data[15:0] = rf_din_r[15:0];
//assign chk_data[15:0] = sexd12[15:0];
//assign chk_data[15:0] = dataA[15:0];
assign chk_data[31:16] = pc_out[15:0];

assign pc[4:0] = dataB[5:0];
assign pc[9:5] = dataA[5:0];
assign pc[15] = rf_we;
assign pc[14] = dm_we;
assign pc[13:12] = rf_mux_sel;
assign pc[11:10] = npc_mux_sel;

*/
endmodule