`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/05 10:00:54
// Design Name: 
// Module Name: CalculateUnit
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
    ================================   CalculateUnit module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.5

    This is the center arithmetic and logic unit.
    Designed for RISCV 32IMB
    With the sub-modules below:
        *ALU(I)
        *ALU(B)
        *MDU(M)
*/


module CalculateUnit(
    input clk,

    input [31:0] number1,
    input [31:0] number2,
    input [7:0] mode,

    output [31:0] fast_answer,
    output [31:0] slow_answer,      // After a clock cycle
    output reg [3:0] error
 );


/*                                              Below is the CCU working mode table 
    ========================================================================================================================
*/
    // Integer Arithmetic Logic Unit (Except MUL & DIV)
    // Code begin with 8'h0 ~ 8'h2

    // RISCV 32I
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

    // RISCV 32B
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

    // RISCV 32B ALU
    localparam BCLR = 8'h30;     // Clear single bit
    localparam BEXT = 8'h31;     // Get single bit
    localparam BINV = 8'h32;     // Not single bit
    localparam BSET = 8'h33;     // Set single bit
    localparam CLZ = 8'h34;      // Leading zeros count
    localparam CPOP = 8'h35;     // Set bits count     
    localparam CTZ = 8'h36;      // Suffix zeros count
    localparam ROL = 8'h37;      // High bits reverse
    localparam ROR = 8'h38;      // Low bits reverse

    // Integer Arithmetic Unit For MUL & DIV
    // Code begin with 8'h4

    // RISCV 32M ALU
    localparam MUL = 8'h40;      // Multiply
    localparam MULH = 8'h41;     // High bit multiply
    localparam MULHSU = 8'h42;   // High bit sign - unsign multiply
    localparam MULHU = 8'h43;    // High bit unsign multiply
    localparam DIV = 8'h44;      // Divide
    localparam DIVU = 8'h45;     // Unsigned Divide
    localparam REM = 8'h46;      // Remind number
    localparam REMU = 8'h47;     // Unsigned remide number

    
    // // Float-Point Arithmetic Logic Unit
    // // Code begin with 8'h5 ~ 8'h7

    // // RISCV 32F FPU
    // localparam FSGNJ = 8'h50;
    // localparam FSGNJN = 8'h51;
    // localparam FSGNJX = 8'h52;
    // localparam FMVDX = 8'h53;
    // localparam FEQ = 8'h54;
    // localparam FLE = 8'h55;
    // localparam FLT = 8'h56;
    // localparam FADD = 8'h57;
    // localparam FSUB = 8'h58;
    // localparam FMIN = 8'h59;
    // localparam FMAX = 8'h5A;

    // localparam FMADD = 8'h60;    // Multiply then add
    // localparam FMSUB = 8'h61;    // Multiply then sub
    // localparam FNMADD = 8'h62;   // Negitve multiply then add  
    // localparam FNMSUB = 8'h63;   // Negtive multiply then sub
    // localparam FMUL = 8'h64;
    // localparam FDIV = 8'h65;
    // localparam FSQRT = 8'h66;

    // localparam FCVTSW = 8'h70;
    // localparam FCVTSWU = 8'h71;
    // localparam FCVTWS = 8'h72;
    // localparam FCVTWUS = 8'h73;

    localparam TEST = 8'hFF;

/*                                              Below is the CCU error mode table 
    ========================================================================================================================
*/
    localparam NO_ERROR = 3'b0;

    localparam NO_INSTRUCTION = 3'h1;
    localparam DIV_BY_ZERO = 3'h2;


// Some wires and regs
    wire [31:0] alu_ans;
    wire alu_error;
    wire [31:0] balu_ans;
    wire balu_error;
    wire [1:0] mdu_error;
    reg [1:0] ccu_fastans_mux_sel;
    reg [1:0] ccu_slowans_mux_sel;

// Different ALU part
    ALU alu (
        .num1(number1), 
        .num2(number2),                          // The source data
        .mode_sel(mode),                         // ALU working mode sel
        .ans(alu_ans),                           // The fast_answer
        .error(alu_error)  
    );

    BALU balu(
        .num1(number1), 
        .num2(number2),                          // The source data
        .mode_sel(mode),                         // BALU working mode sel
        .ans(balu_ans),                          // The fast_answer
        .error(balu_error)  
    );

    MulDiv_Unit mdu(
        .clk(clk),
        .rstn(1'b1),

        .num1(number1),
        .num2(number2),
        .mode(mode),

        .ans(slow_answer),
        .error(mdu_error)
    );



    MUX4 #(32) ccu_fast_ans(
        .data1(alu_ans),
        .data2(balu_ans),
        .data3(32'h0),
        .data4(32'h0),
        .sel(ccu_fastans_mux_sel),
        .out(fast_answer)
    );


    always @(*) begin
        ccu_fastans_mux_sel = 2'b00;
        if (mode[7:4] == 4'h0 || mode[7:4] == 4'h1 || mode[7:4] == 4'h2)
            ccu_fastans_mux_sel = 2'b00;
        else if (mode[7:4] == 4'h3)
            ccu_fastans_mux_sel = 2'b01;
    end

    always @(*) begin
        error = NO_ERROR;
        if (alu_error == 1 && balu_error == 1 && mdu_error == 2'b11)
            error = NO_INSTRUCTION;
        else if (mdu_error == 2'b01)
            error = DIV_BY_ZERO;
    end

    
endmodule