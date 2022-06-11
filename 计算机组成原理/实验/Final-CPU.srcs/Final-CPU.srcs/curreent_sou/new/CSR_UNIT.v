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

    With the original CSRs below:
        mtevc (Machine Trp-Vecor Base-Address Register)     address 0x305
        mcause (Machine CauseRegister)                      address 0x342
        mepc (Machine Exception Program Counter)            address 0x341
        mtval (Machine Trap Value Resiste)                  address 0x343

    With new designed CSRs below:
        mipd (Machine Interrupt Program Done)               address 0x100
        bs (Button Status)                                  address 0x000   
        // none:0 up:1 down:2 left:3 right:4 reset(mid): 5
        map (Map Choose)                                    address 0x001
        // none:0, maze_map:1, finish:2

*/


/*  ========== CPU Interrupt table ==========

    1. User Interrupt (We make it as the ebreak instruction)
    2. Divide by 0
    3. Memory access error
    ......
*/
     

module CSR_UNIT(
    input csr_we,
    input csr_clk,
    input rstn,

    // CSRs
    input [31:0] mtevc_din,
    output [31:0] mtevc_dout,

    input [31:0] mcause_din,
    output [31:0] mcause_dout,

    input [31:0] mepc_din,
    output [31:0] mepc_dout,

    input [31:0] mtval_din,
    output [31:0] mtval_dout,

    input [31:0] mipd_din,
    output [31:0] mipd_dout,

    input [31:0] bs_din,
    output [31:0] bs_dout,

    input [31:0] map_din,
    output [31:0] map_dout,

    input [11:0] csr_debug_addr,
    output reg [31:0] csr_debug_dout
);


// mtevc (Machine Trp-Vecor Base-Address Register)     address 0x305
// This CSR will give the Interrupt solve program's base address.
wire mtevc_we;

assign mtevc_we = csr_we;
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

assign mcause_we = csr_we;
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

assign mepc_we = csr_we;
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

assign mtval_we = csr_we;
REG #(32) Mtval (
    .din(mtval_din),
    .dout(mtval_dout),

    .clk(csr_clk),
    .rstn(rstn),
    .wen(mtval_we)
);

// mipd (Machine Interrupt Program Done)               address 0x100
// This CSR will save the interrupt program done flag
wire mipd_we;

assign mipd_we = csr_we;
REG #(32) Mipd (
    .din(mipd_din),
    .dout(mipd_dout),

    .clk(csr_clk),
    .rstn(rstn),
    .wen(mipd_we)
);

// bs (Button Status)                                   address 0x000
// This CSR will save the interrupt program done flag
wire bs_we;

assign bs_we = csr_we;
REG #(32) Bs (
    .din(bs_din),
    .dout(bs_dout),

    .clk(csr_clk),
    .rstn(rstn),
    .wen(bs_we)
);

// map (Map Choose)                                    address 0x001
// This CSR will save the mux sel for screen output
// none:0, maze_map:1, finish:2

wire map_we;

assign map_we = csr_we;
REG #(32) Map (
    .din(map_din),
    .dout(map_dout),

    .clk(csr_clk),
    .rstn(rstn),
    .wen(map_we)
);

/*
    mtevc (Machine Trp-Vecor Base-Address Register)     address 0x305
    mcause (Machine CauseRegister)                      address 0x342
    mepc (Machine Exception Program Counter)            address 0x341
    mtval (Machine Trap Value Resiste)                  address 0x343

    mipd (Machine Interrupt Program Done)               address 0x100
*/


always @(*) begin
    case (csr_debug_addr) 
    
        32'h305: csr_debug_dout = mtevc_dout;
        32'h342: csr_debug_dout = mcause_dout;
        32'h341: csr_debug_dout = mepc_dout;
        32'h343: csr_debug_dout = mtval_dout;
        32'h100: csr_debug_dout = mipd_dout;
        32'h000: csr_debug_dout = bs_dout;
        32'h001: csr_debug_dout = map_dout;
        default: csr_debug_dout = 32'h0;

    endcase
end

endmodule
