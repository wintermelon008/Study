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
    ================================  Decode module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.12

    This is the decode unit for our cpu
    decides all the control signals
*/


module Control#(
    parameter SIGNUM = 35
)
(
    input [31:0] instruction,
    output [SIGNUM-1:0] control_signals,    // The number of ctrl sigs is unsure yet
    output reg error
);

reg [2:0] sr2_mux_sel, sr1_mux_sel;
reg [2:0] rf_wb_mux_sel;
reg rf_sr1_mux_sel, rf_sr2_mux_sel;
reg rfi_we, rff_we, dm_we, dm_rd, csr_we;
reg [3:0] jump_ctrl;
reg [7:0] ccu_mode;
reg [2:0] dmu_mode;
reg ccu_ans_mux_sel;
reg ebreak;

// Below is the instruction opcode list ================================================================================================

    localparam ArithmeticR = 7'b0110011;        // RISCV 32IBM - Register
    localparam ArithmeticI = 7'b0010011;        // RISCV 32IBM - Immediate
    localparam ControlStatus = 7'b1110011;      // RISCV 32I - CSR
    localparam Conditionjump = 7'b1100011;      // RISCV 32I - Branch-type
    localparam MemoryLoad = 7'b0000011;         // RISCV 32I - Immediate(MEM)
    localparam MemoryStore = 7'b0100011;        // RISCV 32I - Store-type
    localparam JumpandlinkR = 7'b1100111;       // RISCV 32I - Jump-type(R)
    localparam JumpandlinkI = 7'b1101111;       // RISCV 32I - Jump-type(I)
    localparam Adduppertopc = 7'b0010111;       // RISCV 32I - Upper-type
    localparam Loadupperimm = 7'b0110111;       // RISCV 32I - Upper-type

    localparam FloatArithmetic = 7'b1010011;    // RISCV 32F - Arithmetic
    localparam FloatMemoryLoad = 7'b0000111;    // RISCV 32F - Immediate(MEM)
    localparam FloatMemoryStore = 7'b0100111;   // RISCV 32F - Store-type
    localparam FloatMulAdd = 7'b1000011;        // RISCV 32F - R4-type
    localparam FloatMulSub = 7'b1000111;        // RISCV 32F - R4-type
    localparam FloatMulNegAdd = 7'b1001111;     // RISCV 32F - R4-type
    localparam FloatMulNegSub = 7'b1001011;     // RISCV 32F - R4-type

/*                                              Below is the CCU working mode table 
    ========================================================================================================================
*/
    // Integer Arithmetic Logic Unit (Except MUL & DIV)
    // Code begin with 8'h0 ~ 8'h2

    // RISCV 32I ALU
    localparam SUB = 8'h00;
    localparam ADD = 8'h01;
    localparam AND = 8'h02;
    localparam OR = 8'h03;
    localparam XOR = 8'h04;
    localparam RMV = 8'h05;      // Right shift (logic)
    localparam LMV = 8'h06;      // Left shift  (logic)
    localparam ARMV = 8'h07;     // Right shift (arithmetic)
    localparam SLTS = 8'h08;      // Sign less then set bit
    localparam SLTUS = 8'h09;     // Unsign less then set bit

    // RISCV 32B ALU
    localparam ANDN = 8'h10;     // Not then and
    localparam MAX = 8'h11;      
    localparam MAXU = 8'h12;
    localparam MIN = 8'h13;
    localparam MINU = 8'h14;
    localparam ORN = 8'h15;      // Not then or
    localparam SH1ADD = 8'h16;
    localparam SH2ADD = 8'h17;
    localparam SH3ADD = 8'h18;
    localparam XNOR = 8'h19;

    // Integer Bit Calculate Unit
    // Code begin with 8'h3

    // RISCV 32B BALU
    localparam BCLR = 8'h30;     // Clear single bit
    localparam BEXT = 8'h31;     // Get single bit
    localparam BINV = 8'h32;     // Not single bit
    localparam BSET = 8'h33;     // Set single bit
    localparam CLZ = 8'h34;      // Leading zeros count
    localparam CPOP = 8'h35;     // Set bits count     
    localparam CTZ = 8'h36;      // Suffix zeros count
    localparam ROL = 8'h37;      // High bits reverse
    localparam ROR = 8'h38;      // Low bits reverse
    localparam ROLI = 8'h39;      
    localparam RORI = 8'h3A;      

    // Integer Arithmetic Unit For MUL & DIV
    // Code begin with 8'h4

    // RISCV 32M MDU
    localparam MUL = 8'h40;      // Multiply
    localparam MULH = 8'h41;     // High bit multiply
    localparam MULHSU = 8'h42;   // High bit sign - unsign multiply
    localparam MULHU = 8'h43;    // High bit unsign multiply
    localparam DIV = 8'h44;      // Divide
    localparam DIVU = 8'h45;     // Unsigned Divide
    localparam REM = 8'h46;      // Remind number
    localparam REMU = 8'h47;     // Unsigned remide number


// Below is the Branch control list ================================================================================================

    localparam NPC = 4'h0;
    localparam OFFPC = 4'h1;
    localparam NEQ = 4'h2;
    localparam EQ = 4'h3;
    localparam SLT = 4'h4;  // sign less than
    localparam ULT = 4'h5;  // unsign less than
    localparam SGT = 4'h6;  // sign greater than
    localparam UGT = 4'h7;  // unsign greater than
    localparam JALR = 4'h8; 
    
/*===================================== Control Unit signals table =====================================
    control_signals - 35 bit
    
    MUX Ctrl signal:
        control_signals[2:0] - alu-sr1mux (3)
        control_signals[5:3] - alu-sr2mux (3)
        control_signals[8:6] - rfmux (3)
        control_signals[9] - rf-sr1mux (1)
        control_signals[10] - rf-sr2mux (1)
        control_signals[11] - ccu-ansmux (1)

    CCU mode signal:
        control_signals[21:14] - alumode (8)

    Regfile writing enable:
        control_signals[22] - rfi_we (1)

    Memory working mode:
        control-signals[26:24] - dmu_mode (3)

    Data memory unit reading and writing enable:
        control_signals[27] - dm_we (1)
        control_signals[28] - dmu_rd (1)

    CSR write enable
        control_signals[29] = csr_wen (1)

    B & J control signal:
        control_signals[33:30] - jump_ctrl (4)

    Interrupt signal:
        control_signals[34] - ebreak (1)

*/ //===================================================================================================

// Below is the DMU_mode list
    localparam BY_WORD = 3'h0;
    localparam BY_HALF = 3'h1;
    localparam BY_HALF_U = 3'h2;
    localparam BY_BYTE = 3'h3;
    localparam BY_BYTE_U = 4'h4;


// Below is the mux sel info
    localparam SR1_REG = 3'b000;
    localparam SR1_PC = 3'b001;
    localparam SR1_CSR = 3'b010;
    localparam SR1_ZERO = 3'b011;

    localparam SR2_REG = 3'b000;
    localparam SR2_IMM = 3'b001;
    localparam SR2_CSR = 3'b010;
    localparam SR2_ZERO = 3'b011;

    localparam RF_CCU = 3'b000;
    localparam RF_PCP4 = 3'b001;
    localparam RF_DMU = 3'b010;
    localparam RF_CSR = 3'b011;
    localparam RF_ZERO = 3'b110;

// Below is the control signals connection
    assign control_signals[2:0] = sr1_mux_sel;
    assign control_signals[5:3] = sr2_mux_sel;
    assign control_signals[8:6] = rf_wb_mux_sel;
    assign control_signals[9] = rf_sr1_mux_sel;
    assign control_signals[10] = rf_sr2_mux_sel;
    assign control_signals[11] = ccu_ans_mux_sel;

    assign control_signals[21:14] = ccu_mode;

    assign control_signals[22] = rfi_we;
    assign control_signals[26:24] = dmu_mode;

    assign control_signals[27] = dm_we;
    assign control_signals[28] = dm_rd;
    assign control_signals[29] = csr_we;

    assign control_signals[33:30] = jump_ctrl;
    assign control_signals[34] = ebreak;


// READ ME!
// the control signals havent edited yet


always @(instruction) begin
// Initial settings
    ccu_mode = ADD;
    ccu_ans_mux_sel = 1'b0;
    dmu_mode = BY_WORD;
    ebreak = 1'b0;
    csr_we = 1'b0;
    error = 1'b0;

    sr1_mux_sel = SR1_ZERO;
    sr2_mux_sel = SR2_ZERO;
    rf_wb_mux_sel = RF_ZERO;
    
    rfi_we = 1'b0;
    dm_we = 1'b0;
    dm_rd = 1'b0;
    jump_ctrl = NPC;

    case (instruction[6:0])     // Check the opcode
        
        ArithmeticR: begin      // The arithmetic instructions (Reg)
            
            case (instruction[31:25])  // Check the func7
                7'b0000000: begin
                    case (instruction[14:12])   //Check the func3
                        3'b000: begin   // add
                            ccu_mode = ADD;
                        end

                        3'b001: begin   // sll
                            ccu_mode = LMV;
                        end

                        3'b010: begin   // slt
                            ccu_mode = SLTS;
                        end

                        3'b011: begin   // sltu
                            ccu_mode = SLTUS; 
                        end

                        3'b100: begin   // xor
                            ccu_mode = XOR;
                        end

                        3'b101: begin   // srl
                            ccu_mode = RMV;
                        end

                        3'b110: begin   // or
                            ccu_mode = OR;
                        end

                        3'b111: begin   // and
                            ccu_mode = AND;
                        end

                    endcase
                end

                7'b0100000: begin
                    case (instruction[14:12])   // Check the func3
                        3'b000: begin   // sub
                            ccu_mode = SUB;
                        end

                        3'b100: begin
                            ccu_mode = XNOR;
                        end

                        3'b101: begin   // sra
                            ccu_mode = ARMV;
                        end

                        3'b110: begin
                            ccu_mode = ORN;
                        end

                        3'b111: begin
                            ccu_mode = ANDN;
                        end

                    endcase
                end

                7'b0100100: begin
                    case(instruction[14:12])
                        3'b001: begin
                            ccu_mode = BCLR;
                        end

                        3'b101: begin
                            ccu_mode = BEXT;
                        end                                  
                    endcase
                end

                7'b0110100: begin
                    case(instruction[14:12])
                        3'b001: begin
                            ccu_mode = BINV;
                        end                     
                    endcase
                end

                7'b0010100: begin
                    case(instruction[14:12])
                        3'b001: begin
                            ccu_mode = BSET;
                        end 
                    endcase
                end

                7'b0010000: begin
                    // Shift and ADD (B)
                    case (instruction[14:12])
                        3'b010: begin
                            ccu_mode = SH1ADD;
                        end

                        3'b100: begin
                            ccu_mode = SH2ADD;
                        end

                        3'b110: begin
                            ccu_mode = SH3ADD;
                        end
                    endcase
                end

                7'b0000101: begin
                    // MAX MIN
                    case (instruction[14:12])
                        3'b100: begin
                            ccu_mode = MIN;
                        end

                        3'b101: begin
                            ccu_mode = MINU;
                        end

                        3'b110: begin
                            ccu_mode = MAX;
                        end

                        3'b111: begin
                            ccu_mode = MAXU;
                        end

                        default: begin
                            ccu_mode = ADD;
                        end
                    endcase
                end

                7'b0110000: begin
                    // Cut and reverse(B)
                    case (instruction[14:12])
                        3'b001: begin
                            ccu_mode = ROL;
                        end

                        3'b101: begin
                            ccu_mode = ROR;
                        end
                    endcase
                end

                7'b0000001: begin
                    // Mul and Div Instructions
                    ccu_ans_mux_sel = 1'b1;
                    case (instruction[14:12]) 
                        3'b000: begin
                            ccu_mode = MUL;
                        end

                        3'b001: begin
                            ccu_mode = MULH;
                        end

                        3'b010: begin
                            ccu_mode = MULHSU;
                        end

                        3'b011: begin
                            ccu_mode = MULHU;
                        end

                        3'b100: begin
                            ccu_mode = DIV;
                        end

                        3'b101: begin
                            ccu_mode = DIVU;
                        end

                        3'b110: begin
                            ccu_mode = REM;
                        end

                        3'b111: begin
                            ccu_mode = REMU;
                        end
                    endcase
                end

                default: begin  
                    ccu_mode = ADD;
                end
            endcase

            sr1_mux_sel = SR1_REG;
            sr2_mux_sel = SR2_REG;
            rf_wb_mux_sel = RF_CCU;
            rfi_we = 1'b1;
            dm_we = 1'b0;
            dm_rd = 1'b0;
            jump_ctrl = NPC;

        end

        ArithmeticI: begin
            case (instruction[31:25])
                7'b0110000: begin
                    // Cut and reverse(B)
                    // Count(B)
                    case (instruction[14:12])
                        // 3'b001: begin
                        //     ccu_mode = ROLI;
                        // end
                        3'b001: begin
                            case (instruction[24:20])
                                5'b00000: begin
                                    ccu_mode = CLZ;
                                end

                                5'b00010: begin
                                    ccu_mode = CPOP;
                                end

                                5'b00001: begin
                                    ccu_mode = CTZ;
                                end
                            endcase
                        end

                        3'b101: begin
                            ccu_mode = RORI;
                        end
                    endcase
                end

                7'b0100100: begin
                    case(instruction[14:12])
                        3'b001: begin
                            ccu_mode = BCLR;
                        end

                        3'b101: begin
                            ccu_mode = BEXT;
                        end                                  
                    endcase
                end

                7'b0110100: begin
                    case(instruction[14:12])
                        3'b001: begin
                            ccu_mode = BINV;
                        end                     
                    endcase
                end

                7'b0010100: begin
                    case(instruction[14:12])
                        3'b001: begin
                            ccu_mode = BSET;
                        end 
                    endcase
                end

                7'b0000000: begin
                    case (instruction[14:12]) // Check func3

                        3'b000: begin   // addi
                            ccu_mode = ADD;
                        end

                        3'b001: begin   // slli
                            ccu_mode = LMV;
                        end

                        3'b010: begin
                            ccu_mode = SLTS;
                        end

                        3'b011: begin
                            ccu_mode = SLTUS;
                        end

                        3'b100: begin   // xori
                            ccu_mode = XOR;
                        end 

                        3'b101: begin   // srli
                            ccu_mode = RMV;
                        end

                        3'b110: begin   // ori
                            ccu_mode = OR;
                        end

                        3'b111: begin   // andi
                            ccu_mode = AND;
                        end

                        default: begin  // the same as addi
                            ccu_mode = ADD;
                        end

                    endcase
                end

                7'b0100000: begin
                    case(instruction[14:12])
                        3'b101: begin
                            // srai
                            ccu_mode = ARMV;
                        end
                    endcase
                end
            endcase
            
            

            sr1_mux_sel = SR1_REG;
            sr2_mux_sel = SR2_IMM;
            rf_wb_mux_sel = RF_CCU;
            rfi_we = 1'b1;
            dm_we = 1'b0;
            dm_rd = 1'b0;
            jump_ctrl = NPC;

        end

        Conditionjump: begin

            ccu_mode = SUB;

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

                3'b101: begin   // bge
                    jump_ctrl = SGT;
                end

                3'b110: begin   // bltu
                    jump_ctrl = ULT;
                end

                3'b111: begin   // bgeu
                    jump_ctrl = UGT;
                end


                default: begin  // the same as beq
                    jump_ctrl = EQ;
                end
            endcase

            rfi_we = 1'b0;
            dm_rd = 1'b0;
            dm_we = 1'b0;

        end

        MemoryLoad: begin   
            // load
            case (instruction[14:12]) 
                3'b000: begin
                // lb, sb
                    dmu_mode = BY_BYTE;
                end

                3'b001: begin
                // lh, sh
                    dmu_mode = BY_HALF;
                end

                3'b010: begin
                // lw, sw
                    dmu_mode = BY_WORD;
                end

                3'b100: begin
                // lbu
                    dmu_mode = BY_BYTE_U;
                end

                3'b101: begin
                // lhu
                    dmu_mode = BY_HALF_U;
                end

                default: begin
                    dmu_mode = BY_WORD;
                end
                
            endcase
            sr1_mux_sel = SR1_REG;
            sr2_mux_sel = SR2_IMM;
            rf_wb_mux_sel = RF_DMU;
            rfi_we = 1'b1;
            dm_we = 1'b0;
            dm_rd = 1'b1;
            jump_ctrl = NPC;
            ccu_mode = ADD;
        end

        MemoryStore: begin  // sw
            sr1_mux_sel = SR1_REG;
            sr2_mux_sel = SR2_IMM;
            rf_wb_mux_sel = RF_ZERO;
            rfi_we = 1'b0;
            dm_we = 1'b1;
            dm_rd = 1'b0;
            jump_ctrl = NPC;
            ccu_mode = ADD;
        end

        JumpandlinkI: begin  // jal
            rf_wb_mux_sel = RF_PCP4;
            rfi_we = 1'b1;
            dm_we = 1'b0;
            dm_rd = 1'b0;
            jump_ctrl = OFFPC;
            ccu_mode = ADD;
        end

        JumpandlinkR: begin  // jalr
            sr1_mux_sel = SR1_REG;
            sr2_mux_sel = SR2_IMM;
            rf_wb_mux_sel = RF_PCP4;
            rfi_we = 1'b1;
            dm_we = 1'b0;
            dm_rd = 1'b0;
            jump_ctrl = JALR;
            ccu_mode = ADD;
        end

        Adduppertopc: begin  // auipc
            sr1_mux_sel = SR1_PC;
            sr2_mux_sel = SR2_IMM;
            rf_wb_mux_sel = RF_CCU;
            rfi_we = 1'b1;
            dm_we = 1'b0;
            dm_rd = 1'b0;
            jump_ctrl = NPC;
            ccu_mode = ADD;
        end

        Loadupperimm: begin  // lui     
            sr1_mux_sel = SR1_ZERO;
            sr2_mux_sel = SR2_IMM;
            rf_wb_mux_sel = RF_CCU;
            rfi_we = 1'b1;
            dm_we = 1'b0;
            dm_rd = 1'b0;
            jump_ctrl = NPC;
            ccu_mode = ADD;
        end

        ControlStatus: begin
            csr_we = 1'b1;
            rf_wb_mux_sel = RF_CSR;
            ccu_mode = ADD;
            rfi_we = 1'b1;
            dm_we = 1'b0;
            dm_rd = 1'b0;
            jump_ctrl = NPC;   

            if (instruction[31:20] == 12'b1 && instruction[19:7] == 13'b0) begin
                // Ebreak
                ebreak = 1'b1;
            end
            else begin
                case(instruction[14:12])
                    3'b001: begin
                        // csrrw
                        sr1_mux_sel = SR1_REG;
                        sr2_mux_sel = SR2_ZERO;
                    end

                    3'b010: begin
                        // csrrs
                        sr1_mux_sel = SR1_REG;
                        sr2_mux_sel = SR2_CSR;
                        ccu_mode = OR;
                        csr_we = 1'b0;
                    end

                    3'b011: begin
                        // csrrc
                        sr1_mux_sel = SR1_REG;
                        sr2_mux_sel = SR2_CSR;
                        ccu_mode = AND;
                    end

                    3'b101: begin
                        // csrrwi
                        sr1_mux_sel = SR1_ZERO;
                        sr2_mux_sel = SR2_IMM;
                    end

                    3'b110: begin
                        // csrrsi
                        sr1_mux_sel = SR1_CSR;
                        sr2_mux_sel = SR2_IMM;
                        ccu_mode = OR;
                    end

                    3'b111: begin
                        // csrrci
                        sr1_mux_sel = SR1_CSR;
                        sr2_mux_sel = SR2_IMM;
                        ccu_mode = AND;
                    end

                endcase
            end    
                
        end

        7'b0000000: begin   // just empty
            sr1_mux_sel = SR1_ZERO;
            sr2_mux_sel = SR2_ZERO;
            rf_wb_mux_sel = RF_ZERO;     // always zero
            rfi_we = 1'b0;
            dm_we = 1'b0;
            dm_rd = 1'b0;
            jump_ctrl = NPC;
            ccu_mode = ADD;
        end

        default: begin  // all the signals are zero
            error = 1'b1;
        end

    endcase
end



endmodule
