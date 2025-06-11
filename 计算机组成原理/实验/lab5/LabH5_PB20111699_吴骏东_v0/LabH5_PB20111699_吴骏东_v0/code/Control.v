`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/06 14:21:41
// Design Name: 
// Module Name: Control
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
    ================================  Control module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.20

    This is the control unit for our cpu
    decides all the control signals
*/


module Control#(
    parameter SIGNUM = 25
)
(
    input [31:0] instruction,
    output wire [SIGNUM-1:0] control_signal    // The number of ctrl sigs is unsure yet
);


// Below is the instruction opcode list ================================================================================================

    localparam ArithmeticR = 7'b0110011;
    localparam ArithmeticI = 7'b0010011;
    localparam Conditionjump = 7'b1100011;
    localparam MemoryLoad = 7'b0000011;
    localparam MemoryStore = 7'b0100011;
    localparam JumpandlinkR = 7'b1100111;
    localparam JumpandlinkI = 7'b1101111;
    localparam Adduppertopc = 7'b0010111;
    localparam Loadupperimm = 7'b0110111;
    

// Below is the control signals' list ==================================================================================================
/*
    MUX Ctrl signal:

    signals[2:0] - rs1mux
    signals[5:3] - rs2mux
    signals[7:6] - rfmux

    ALU mode signal:
    signals[13:10] - alusel

    Regfile writing enable:
    signals[15] - rf_we

    Data memory and I/O writing enable:
    signals[16] - dm_we

    I/O reading enable
    signals[18] - io_re

    Jump control signal:
    signals[22:19] - jump_ctrl
*/

reg [2:0] rs2_mux_sel_ctrl, rs1_mux_sel_ctrl;
reg [1:0] rf_mux_sel;
reg rf_we, dm_we, io_re;
reg [3:0] jump_ctrl;
reg [3:0] alu_sel;

/*
    rs1_mux_sel_ctrl = 
    rs2_mux_sel_ctrl = 
    rf_mux_sel =
    rf_we =
    dm_we =
    jump_ctrl =
    
*/

assign control_signal[2:0] = rs1_mux_sel_ctrl;
assign control_signal[5:3] = rs2_mux_sel_ctrl;
assign control_signal[7:6] = rf_mux_sel;

assign control_signal[13:10] = alu_sel;
assign control_signal[15] = rf_we;
assign control_signal[16] = dm_we;
assign control_signal[18] = io_re;

assign control_signal[22:19] = jump_ctrl;


/* Branchsel Meaning Table
    NPC (pc + 4)            ---- 0
    OFFPC (pc + offset)     ---- 1
    NEQ (not equal)         ---- 2
    EQ (equal)              ---- 3
    SLT (sign less than)    ---- 4
    ULT (unsign less than)  ---- 5
    JALR (jalr)             ---- 6
*/

// ALU consts
localparam SUB = 4'd00;
localparam ADD = 4'd01;
localparam AND = 4'd02;
localparam OR = 4'd03;
localparam XOR = 4'd04;
localparam RMV = 4'd05;      
localparam LMV = 4'd06;     
localparam ARMV = 4'd07;    
localparam TEST = 4'd15;

// Branch consts
localparam NPC = 4'h0;
localparam OFFPC = 4'h1;
localparam NEQ = 4'h2;
localparam EQ = 4'h3;
localparam SLT = 4'h4;
localparam ULT = 4'h5;
localparam JALR = 4'h6;


// READ ME!
// the control signals havent edited yet


always @(instruction) begin
       
        case (instruction[6:0])     // Check the opcode
            
            ArithmeticR: begin      // The arithmetic instructions (Reg)
                
                case (instruction[31:25])  // Check the func7
                    7'b0000000: begin
                        case (instruction[14:12])   //Check the func3
                            3'b000: begin   // add
                                alu_sel = ADD;
                            end

                            3'b001: begin   // sll
                                alu_sel = LMV;
                            end

                            3'b100: begin   // xor
                                alu_sel = XOR;
                            end

                            3'b101: begin   // srl
                                alu_sel = RMV;
                            end

                            3'b110: begin   // or
                                alu_sel = OR;
                            end

                            3'b111: begin   // and
                                alu_sel = AND;
                            end

                            default: begin  // the same as add
                                alu_sel = ADD;
                            end
                        endcase
                    end

                    7'b0100000: begin
                        case (instruction[14:12])   // Check the func3
                            3'b000: begin   // sub
                                alu_sel = SUB;
                            end

                            3'b101: begin   // sra
                                alu_sel = ARMV;
                            end

                            default: begin  // the same as add
                                alu_sel = ADD;
                            end
                        endcase
                    end

                    default: begin  
                        alu_sel = ADD;
                    end
                endcase

                rs1_mux_sel_ctrl = 3'b000;
                rs2_mux_sel_ctrl = 3'b000;
                rf_mux_sel = 2'b00;
                rf_we = 1'b1;
                dm_we = 1'b0;
                io_re = 1'b0;
                jump_ctrl = NPC;

            end

            ArithmeticI: begin
                case (instruction[14:12]) // Check func3

                    3'b000: begin   // addi
                        alu_sel = ADD;
                    end

                    3'b001: begin   // slli
                        alu_sel = LMV;
                    end

                    3'b100: begin   // xori
                        alu_sel = XOR;
                    end 

                    3'b101: begin   // srli and srai
                        if (instruction[31:26] == 6'b000000) begin  //srli
                            alu_sel = RMV;
                        end

                        else begin  // srai
                            alu_sel = ARMV;
                        end
                    end

                    3'b110: begin   // ori
                        alu_sel = OR;
                    end

                    3'b111: begin   // andi
                        alu_sel = AND;
                    end

                    default: begin  // the same as addi
                        alu_sel = ADD;
                    end

                endcase

                rs1_mux_sel_ctrl = 3'b000;
                rs2_mux_sel_ctrl = 3'b001;
                rf_mux_sel = 2'b00;
                rf_we = 1'b1;
                dm_we = 1'b0;
                io_re = 1'b0;
                jump_ctrl = NPC;

            end

            Conditionjump: begin

                alu_sel = SUB;

                case (instruction[14:12]) 

                    3'b000: begin   // beq
                        jump_ctrl = EQ;
                    end

                    3'b001: begin   // bne
                        jump_ctrl = NEQ;
                    end

                    3'b100: begin   // blt
                        jump_ctrl = SLT;
                    end

                    3'b110: begin   // bltu
                        jump_ctrl = ULT;
                    end

                    default: begin  // the same as beq
                        jump_ctrl = EQ;
                    end
                endcase

                rs1_mux_sel_ctrl = 3'b000;
                rs2_mux_sel_ctrl = 3'b000;
                rf_mux_sel = 2'b00;
                rf_we = 1'b0;
                io_re = 1'b0;
                dm_we = 1'b0;

            end

            MemoryLoad: begin   // lw
                rs1_mux_sel_ctrl = 3'b000;
                rs2_mux_sel_ctrl = 2'b001;
                rf_mux_sel = 2'b10;
                rf_we = 1'b1;
                dm_we = 1'b0;
                io_re = 1'b1;
                jump_ctrl = NPC;
                alu_sel = ADD;
            end

            MemoryStore: begin  // sw
                rs1_mux_sel_ctrl = 3'b000;
                rs2_mux_sel_ctrl = 3'b001;
                rf_mux_sel = 2'b00;
                rf_we = 1'b0;
                dm_we = 1'b1;
                io_re = 1'b0;
                jump_ctrl = NPC;
                alu_sel = ADD;
            end

            JumpandlinkI: begin  // jal
                rs1_mux_sel_ctrl = 3'b000;
                rs2_mux_sel_ctrl = 3'b000;
                rf_mux_sel = 2'b01;
                rf_we = 1'b1;
                dm_we = 1'b0;
                io_re = 1'b0;
                jump_ctrl = OFFPC;
                alu_sel = ADD;
            end

            JumpandlinkR: begin  // jalr
                rs1_mux_sel_ctrl = 3'b000;
                rs2_mux_sel_ctrl = 3'b001;
                rf_mux_sel = 2'b01;
                rf_we = 1'b1;
                dm_we = 1'b0;
                io_re = 1'b0;
                jump_ctrl = JALR;
                alu_sel = ADD;
            end

            Adduppertopc: begin  // auipc
                rs1_mux_sel_ctrl = 3'b001;
                rs2_mux_sel_ctrl = 3'b001;
                rf_mux_sel = 2'b00;
                rf_we = 1'b1;
                dm_we = 1'b0;
                io_re = 1'b0;
                jump_ctrl = NPC;
                alu_sel = ADD;
            end

            Loadupperimm: begin  // lui     
                rs1_mux_sel_ctrl = 3'b010;
                rs2_mux_sel_ctrl = 3'b001;
                rf_mux_sel = 2'b00;
                rf_we = 1'b1;
                dm_we = 1'b0;
                io_re = 1'b0;
                jump_ctrl = NPC;
                alu_sel = ADD;
            end

            7'b0000000: begin   //not an is
                rs1_mux_sel_ctrl = 3'b000;
                rs2_mux_sel_ctrl = 3'b000;
                rf_mux_sel = 2'b00;     // always zero
                rf_we = 1'b0;
                dm_we = 1'b0;
                io_re = 1'b0;
                jump_ctrl = NPC;
                alu_sel = ADD;
            end

            default: begin  // all the signals are zero
                rs1_mux_sel_ctrl = 2'b00;
                rs2_mux_sel_ctrl = 2'b00;
                rf_mux_sel = 2'b00;
                rf_we = 1'b0;
                dm_we = 1'b0;
                io_re = 1'b0;
                jump_ctrl = NPC;
                alu_sel = ADD;
            end

        endcase
    end



endmodule
