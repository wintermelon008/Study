`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/09 13:51:52
// Design Name: 
// Module Name: CSR_UNIT
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

/* ================================  CSR_UNIT module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.9
    This is CSR unit module
    With the CSRs below:
        mtevc (Machine Trp-Vecor Base-Address Register)     address 0x305
        mcause (Machine CauseRegister)                      address 0x342
        mepc (Machine Exception Program Counter)            address 0x341
        mtval (Machine Trap Value Resiste)                  address 0x343

    This module will decode the @csr_address and save/load the register.
*/


/*  ========== CPU Interrupt table ==========

    1. User Interrupt (We make it as breakpoint)
    2. Divide by 0
    3. Memory access error
    ......
*/
     

module CSR_UNIT(
    input [31:0] csr_address,
    input [31:0] csr_din,
    input csr_we,
    input csr_clk,
    input rstn,

    output reg [31:0] csr_dout,

    input [31:0] csr_debug_addr,
    output reg [31:0] csr_debug_dout
);


// mtevc (Machine Trp-Vecor Base-Address Register)     address 0x305
// This CSR will give the Interrupt solve program's base address.
wire mtevc_we;
wire [31:0] mtevc_din, mtevc_dout;

assign mtevc_we = (csr_address == 32'h305 && csr_we == 1'b1) ? 1'b1 : 1'b0; 
REG #(32) Mtevc (
    .din(mtevc_din),
    .dout(mtevc_dout),

    .clk(csr_clk),
    .rstn(rstn),
    .wen(mtevc_we)
);

// mcause (Machine CauseRegister)                      address 0x342
// This CSR will save the reason for interrupt.
wire mcause_we;
wire [31:0] mcause_din, mcause_dout;

assign mcause_we = (csr_address == 32'h342 && csr_we == 1'b1) ? 1'b1 : 1'b0; 
REG #(32) Mcause (
    .din(mcause_din),
    .dout(mcause_dout),

    .clk(csr_clk),
    .rstn(rstn),
    .wen(mcause_we)
);


// mepc (Machine Exception Program Counter)            address 0x341
// This CSR will save the return PC after sloveing the interrupt.
wire mepc_we;
wire [31:0] mepc_din, mepc_dout;

assign mepc_we = (csr_address == 32'h342 && csr_we == 1'b1) ? 1'b1 : 1'b0; 
REG #(32) Mepc (
    .din(mepc_din),
    .dout(mepc_dout),

    .clk(csr_clk),
    .rstn(rstn),
    .wen(mepc_we)
);

// mtval (Machine Trap Value Resiste)                  address 0x343
// This CSR will save the interrupt infomation.
wire mtval_we;
wire [31:0] mtval_din, mtval_dout;

assign mtval_we = (csr_address == 32'h342 && csr_we == 1'b1) ? 1'b1 : 1'b0; 
REG #(32) Mtval (
    .din(mtval_din),
    .dout(mtval_dout),

    .clk(csr_clk),
    .rstn(rstn),
    .wen(mtval_we)
);


/*
    mtevc (Machine Trp-Vecor Base-Address Register)     address 0x305
    mcause (Machine CauseRegister)                      address 0x342
    mepc (Machine Exception Program Counter)            address 0x341
    mtval (Machine Trap Value Resiste)                  address 0x343
*/

always @(*) begin
    case (csr_address) 
        32'h305: csr_dout = mtevc_dout;
        32'h342: csr_dout = mcause_dout;
        32'h341: csr_dout = mepc_dout;
        32'h343: csr_dout = mtval_dout;
        
        default: csr_dout = 32'h0;
    endcase
end


always @(*) begin
    case (csr_debug_addr) 
        32'h305: csr_debug_dout = mtevc_dout;
        32'h342: csr_debug_dout = mcause_dout;
        32'h341: csr_debug_dout = mepc_dout;
        32'h343: csr_debug_dout = mtval_dout;
        
        default: csr_debug_dout = 32'h0;
    endcase
end

endmodule
