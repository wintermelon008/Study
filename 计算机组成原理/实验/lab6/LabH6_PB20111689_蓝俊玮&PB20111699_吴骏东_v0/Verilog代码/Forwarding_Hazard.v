`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/21 11:10:34
// Design Name: 
// Module Name: Forwarding_Hazard
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
    ================================  Forwarding_Hazard module   ================================
    Author:         Wintermelon
    Last Edit:      2022.4.22

    This is the module for cpu's data forwarding and hazard.
*/

module Forwarding_Hazard(
    input [31:0] id_is,
    input [31:0] ex_is,
    input [31:0] mem_is,
    input [31:0] wb_is,
    input [1:0] npc_mux_sel,

    // forwarding
    output reg [2:0] b_sr1_mux_sel_fh,
    output reg [2:0] b_sr2_mux_sel_fh,
    output reg [2:0] sr1_mux_sel_fh,
    output reg [2:0] sr2_mux_sel_fh,
    output reg [2:0] dm_sr2_mux_sel_fh,
    output reg [2:0] csr_mux_sel_fh,

    // hazard -- dealing with cpu's stop
    output reg pc_en,
    output reg if_id_en,
    output reg id_ex_clear
);

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
    
// Below is the mux_sel list
    localparam NO_FORWARD = 3'b000;
    localparam ALU_EX = 3'b100;
    localparam ALU_MEM = 3'b101;
    localparam DM_MEM = 3'b110;
    localparam NPC = 3'b111;
    localparam ALU_WB = 3'b111;

// Decide sr1_mux_sel_fh
always @(*) begin
    sr1_mux_sel_fh = NO_FORWARD;

    // 1 id and ex
    if (id_is[19:15] && id_is[19:15] == ex_is[11:7]) begin
        // id_sr1 = ex_dr != 0
        // 1.1 lui/auipc/alu/csr before alu/lw/sw/jalr/csr(R)
        if ((ex_is[6:0] == Loadupperimm || ex_is[6:0] == Adduppertopc || ex_is[6:0] == ArithmeticI || ex_is[6:0] == ArithmeticR ||
             ex_is[6:0] == ControlStatus ) &&
            (id_is[6:0] == MemoryLoad || id_is[6:0] == MemoryStore || id_is[6:0] == ArithmeticI || id_is[6:0] == ArithmeticR ||
             id_is[6:0] == JumpandlinkR || (id_is[6:0] == ControlStatus && id_is[14] == 0))) begin
                    sr1_mux_sel_fh = ALU_EX;
                end
    end

    // 2 id and mem
    else if (id_is[19:15] && id_is[19:15] == mem_is[11:7]) begin
        // id_sr1 = mem_dr != 0
        // 2.1 lui/auipc/alu/lw/jal/jalr/csr before alu/lw/sw/jalr/csr(R)
        if ((mem_is[6:0] == Loadupperimm || mem_is[6:0] == Adduppertopc || mem_is[6:0] == ArithmeticI || mem_is[6:0] == ArithmeticR ||
             mem_is[6:0] == MemoryLoad || mem_is[6:0] == JumpandlinkI || mem_is[6:0] == JumpandlinkR || mem_is[6:0] == ControlStatus) &&
            (id_is[6:0] == MemoryLoad || id_is[6:0] == MemoryStore || id_is[6:0] == ArithmeticI || id_is[6:0] == ArithmeticR ||
             id_is[6:0] == JumpandlinkR || (id_is[6:0] == ControlStatus && id_is[14] == 0))) begin
                    if (mem_is[6:0] == MemoryLoad)
                        sr1_mux_sel_fh = DM_MEM;
                    else if (mem_is[6:0] == JumpandlinkI || mem_is[6:0] == JumpandlinkR)
                        sr1_mux_sel_fh = NPC;
                    else
                        sr1_mux_sel_fh = ALU_MEM;
                end
    end
end

// Decide sr2_mux_sel_fh
always @(*) begin
    sr2_mux_sel_fh = NO_FORWARD;

    // 1 id and ex
    if (id_is[24:20] && id_is[24:20] == ex_is[11:7]) begin
        // id_sr2 = ex_dr != 0
        // 1.1 alu/auipc/lui before alur
        if ((ex_is[6:0] == Loadupperimm || ex_is[6:0] == Adduppertopc || ex_is[6:0] == ArithmeticI || ex_is[6:0] == ArithmeticR) &&
            (id_is[6:0] == ArithmeticR)) begin
                    sr2_mux_sel_fh = ALU_EX;
                end
    end

    // 2 id and mem
    else if (id_is[24:20] && id_is[24:20] == mem_is[11:7]) begin
        // id_sr2 = mem_dr != 0
        // 2.1 alu/auipc/lui/lw/jal/jalr before alur
        if ((mem_is[6:0] == Loadupperimm || mem_is[6:0] == Adduppertopc || mem_is[6:0] == ArithmeticI || mem_is[6:0] == ArithmeticR ||
             mem_is[6:0] == MemoryLoad || mem_is[6:0] == JumpandlinkI || mem_is[6:0] == JumpandlinkR) &&
            (id_is[6:0] == ArithmeticR)) begin
                    if (mem_is[6:0] == MemoryLoad)
                        sr2_mux_sel_fh = DM_MEM;
                    else if (mem_is[6:0] == JumpandlinkI || mem_is[6:0] == JumpandlinkR)
                        sr2_mux_sel_fh = NPC;
                    else
                        sr2_mux_sel_fh = ALU_MEM;
                end
    end
end

// Decide csr_mux_sel_fh
always @(*) begin
    csr_mux_sel_fh = NO_FORWARD;

    // 1 id and ex
    if (ex_is[6:0] == ControlStatus && id_is[6:0] == ControlStatus && id_is[31:20] == ex_is[31:20]) begin
        csr_mux_sel_fh = ALU_EX;
    end

    // 2 id and mem
    else if (mem_is[6:0] == ControlStatus && id_is[6:0] == ControlStatus && id_is[31:20] == mem_is[31:20]) begin
        csr_mux_sel_fh = ALU_MEM;
    end

    // 3 id and wb
    else if (wb_is[6:0] == ControlStatus && id_is[6:0] == ControlStatus && id_is[31:20] == wb_is[31:20]) begin
        csr_mux_sel_fh = ALU_WB;
    end
end

// Decide dm_sr2_mux_sel_fh
always @(*) begin
    dm_sr2_mux_sel_fh = NO_FORWARD;

    // 1 id and ex
    if (id_is[24:20] && id_is[24:20] == ex_is[11:7]) begin
        // id_sr2 = ex_dr != 0
        // 1.1 alu/auipc/lui before sw
        if ((ex_is[6:0] == Loadupperimm || ex_is[6:0] == Adduppertopc || ex_is[6:0] == ArithmeticI || ex_is[6:0] == ArithmeticR) &&
            (id_is[6:0] == MemoryStore)) begin
                    dm_sr2_mux_sel_fh = ALU_EX;
                end
    end

    // 2 id and mem
    else if (id_is[24:20] && id_is[24:20] == mem_is[11:7]) begin
        // id_sr2 = mem_dr != 0
        // 2.1 alu/auipc/lui/lw/jal/jalr before sw 
        if ((mem_is[6:0] == Loadupperimm || mem_is[6:0] == Adduppertopc || mem_is[6:0] == ArithmeticI || mem_is[6:0] == ArithmeticR ||
             mem_is[6:0] == MemoryLoad || mem_is[6:0] == JumpandlinkI || mem_is[6:0] == JumpandlinkR) &&
            (id_is[6:0] == MemoryStore)) begin
                    if (mem_is[6:0] == MemoryLoad)
                        dm_sr2_mux_sel_fh = DM_MEM;
                    else if (mem_is[6:0] == JumpandlinkI || mem_is[6:0] == JumpandlinkR)
                        dm_sr2_mux_sel_fh = NPC;
                    else
                        dm_sr2_mux_sel_fh = ALU_MEM;
                end
    end
end
// Decide b_mux_sel_fh
always @(*) begin
    b_sr1_mux_sel_fh = NO_FORWARD;

    // 1 id and ex
    if (id_is[19:15] && id_is[19:15] == ex_is[11:7]) begin
        // id_sr1 = ex_dr != 0
        // 1.1 lui/auipc/alu before beq
        if ((ex_is[6:0] == Loadupperimm || ex_is[6:0] == Adduppertopc || ex_is[6:0] == ArithmeticI || ex_is[6:0] == ArithmeticR) &&
            (id_is[6:0] == Conditionjump)) begin
                    b_sr1_mux_sel_fh = ALU_EX;
                end
    end

    // 2 id and mem
    else if (id_is[19:15] && id_is[19:15] == mem_is[11:7]) begin
        // id_sr = mem_dr != 0
        // 2.1 lui/auipc/alu/jal/jalr before beq
        if ((mem_is[6:0] == Loadupperimm || mem_is[6:0] == Adduppertopc || mem_is[6:0] == ArithmeticI || mem_is[6:0] == ArithmeticR ||
             mem_is[6:0] == JumpandlinkI || mem_is[6:0] == JumpandlinkR) &&
            (id_is[6:0] == Conditionjump)) begin
                    if (mem_is[6:0] == JumpandlinkI || mem_is[6:0] == JumpandlinkR)
                        b_sr1_mux_sel_fh = NPC;
                    else
                        b_sr1_mux_sel_fh = ALU_MEM;
                end
    end
end
always @(*) begin
    b_sr2_mux_sel_fh = NO_FORWARD;

    // 1 id and ex
    if (id_is[24:20] && id_is[24:20] == ex_is[11:7]) begin
        // id_sr2 = ex_dr != 0
        // 1.1 alu/auipc/lui before beq
        if ((ex_is[6:0] == Loadupperimm || ex_is[6:0] == Adduppertopc || ex_is[6:0] == ArithmeticI || ex_is[6:0] == ArithmeticR) &&
            (id_is[6:0] == Conditionjump)) begin
                    b_sr2_mux_sel_fh = ALU_EX;
                end
    end

    // 2 id and mem
    else if (id_is[24:20] && id_is[24:20] == mem_is[11:7]) begin
        // id_sr2 = mem_dr != 0
        // 2.1 alu/auipc/lui/jal/jalr before beq
        if ((mem_is[6:0] == Loadupperimm || mem_is[6:0] == Adduppertopc || mem_is[6:0] == ArithmeticI || mem_is[6:0] == ArithmeticR ||
             mem_is[6:0] == JumpandlinkI || mem_is[6:0] == JumpandlinkR) &&
            (id_is[6:0] == Conditionjump)) begin
                    if (mem_is[6:0] == JumpandlinkI || mem_is[6:0] == JumpandlinkR)
                        b_sr2_mux_sel_fh = NPC;
                    else
                        b_sr2_mux_sel_fh = ALU_MEM;
                end
    end
end

// Insert stop and clear registers

always @(*) begin
    pc_en = 1'b1;       // pc change enable
    if_id_en = 1'b1;    // if_id_instruction change enable
    id_ex_clear = 1'b0; // id_ex_control and instruction clear enable

    // B and J
    if ((npc_mux_sel == 2'b01 && ex_is[6:0] == Conditionjump) || (npc_mux_sel == 2'b11 && ex_is[6:0] == Conditionjump) ||
        // (npc_mux_sel == 2'b11)  --- 5.18 19:42
         ex_is[6:0] == JumpandlinkI || ex_is[6:0] == JumpandlinkR || mem_is[6:0] == JumpandlinkR) begin
        // not pc+4
        id_ex_clear = 1'b1;
    end

    else if (ex_is[6:0] == MemoryLoad && id_is[6:0] == MemoryLoad) begin
        pc_en = 1'b0;
        if_id_en = 1'b0;
        id_ex_clear = 1'b1;
    end

    // id and ex
    else if ((id_is[19:15] && id_is[19:15] == ex_is[11:7]) || (id_is[24:20] && id_is[24:20] == ex_is[11:7])) begin
        // id_sr = ex_dr != 0
        if ((ex_is[6:0] == MemoryLoad || (ex_is[6:0] == ArithmeticR && ex_is[31:25] == 7'b0000001)) ||
        //if ((ex_is[6:0] == MemoryLoad) ||
            ((ex_is[6:0] == ArithmeticI || ex_is[6:0] == ArithmeticR || ex_is[6:0] == Loadupperimm || ex_is[6:0] == Adduppertopc) &&
             (id_is[6:0] == Conditionjump))) begin
                pc_en = 1'b0;
                if_id_en = 1'b0;
                id_ex_clear = 1'b1;
        end
    end

    // id and mem
    else if ((id_is[19:15] && id_is[19:15] == mem_is[11:7]) || (id_is[24:20] && id_is[24:20] == mem_is[11:7])) begin
        // id_sr = mem_dr != 0
        if ((mem_is[6:0] == JumpandlinkI || mem_is[6:0] == MemoryLoad) &&
            (ex_is[6:0] == ArithmeticI || ex_is[6:0] == ArithmeticR || ex_is[6:0] == Loadupperimm || ex_is[6:0] == Adduppertopc ||
             id_is[6:0] == Conditionjump || id_is[6:0] == JumpandlinkR)) begin
                pc_en = 1'b0;
                if_id_en = 1'b0;
                id_ex_clear = 1'b1;
        end
    end
end

endmodule
