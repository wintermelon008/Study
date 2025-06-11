`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/27 15:11:55
// Design Name: 
// Module Name: MUL_testbentch
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


module MUL_testbentch();

wire [31:0] check_data, check_pc;
reg [15:0] check_address;
reg clk;

// /*                                              Below is the ALU & FPU working mode table 
//     ========================================================================================================================
// */
//     // Integer Arithmetic Logic Unit (Except MUL & DIV)
//     // Code begin with 8'h0 ~ 8'h2

//     // RISCV 32I
//     localparam SUB = 8'h00;
//     localparam ADD = 8'h01;
//     localparam AND = 8'h02;
//     localparam OR = 8'h03;
//     localparam XOR = 8'h04;
//     localparam RMV = 8'h05;      // Right shift (logic)
//     localparam LMV = 8'h06;      // Left shift  (logic)
//     localparam ARMV = 8'h07;     // Right shift (arithmetic)
//     localparam SLT = 8'h08;      // Sign less then set bit
//     localparam SLTU = 8'h09;     // Unsign less then set bit

//     // RISCV 32B
//     localparam ANDN = 8'h10;     // Not then and
//     localparam MAX = 8'h11;      
//     localparam MAXU = 8'h12;
//     localparam MIN = 8'h13;
//     localparam MINU = 8'h14;
//     localparam ORN = 8'h15;      // Not then or
//     localparam SH1ADD = 8'h16;
//     localparam SH2ADD = 8'h17;
//     localparam SH3ADD = 8'h18;
//     localparam XNOR = 8'h19;

//     // Integer Bit Calculate Unit
//     // Code begin with 8'h3

//     // RISCV 32B ALU
//     localparam BCLR = 8'h30;     // Clear single bit
//     localparam BEXT = 8'h31;     // Get single bit
//     localparam BINV = 8'h32;     // Not single bit
//     localparam BSET = 8'h33;     // Set single bit
//     localparam CLZ = 8'h34;      // Leading zeros count
//     localparam CPOP = 8'h35;     // Set bits count     
//     localparam CTZ = 8'h36;      // Suffix zeros count
//     localparam ROL = 8'h37;      // High bits reverse
//     localparam ROR = 8'h38;      // Low bits reverse

//     // Integer Arithmetic Unit For MUL & DIV
//     // Code begin with 8'h4

//     // RISCV 32M ALU
//     localparam MUL = 8'h40;      // Multiply
//     localparam MULH = 8'h41;     // High bit multiply
//     localparam MULHSU = 8'h42;   // High bit sign - unsign multiply
//     localparam MULHU = 8'h43;    // High bit unsign multiply
//     localparam DIV = 8'h44;      // Divide
//     localparam DIVU = 8'h45;     // Unsigned Divide
//     localparam REM = 8'h46;      // Remind number
//     localparam REMU = 8'h47;     // Unsigned remide number


initial begin
    clk <= 1'b0;
end

always #5 clk <= ~clk;


Pipeline_CPU cpu(
    // cpu control form PDU
    .sys_clk(clk), 
    .rstn(rstn),

    // IO_BUS
    .io_addr(),	// I/O address
    .io_dout(),	// I/O data output
    .io_we(),		    // I/O write enable
    .io_rd(),		    // I/O read enable
    .io_din(),	// I/O data input

    // Debug_BUS
    .chk_pc(check_pc), 	// Current pc
    .chk_addr(check_address),	// Debug address
    .chk_data(check_data)  // Debug data

);

// CalculateUnit ccu(
//     .clk(clk),

//     .number1(num1),
//     .number2(num2),
//     .mode(mode),

//     .fast_answer(fast_ans),
//     .slow_answer(slow_ans),      // After a clock cycle
//     .error(error)
//  );

// MulDiv_Unit mdu(
//     .clk(clk),
//     .rstn(1'b1),

//     .num1(num1),
//     .num2(num2),
//     .mode(mode),

//     .ans(ans),
//     .error(error)
// );

// BALU balu(
//     .num1(num1), .num2(num2),                    // The source data
//     .mode_sel(mode),                         // BALU working mode sel
//     .ans(ans),                              // The answer
//     .error(error)  
// );

// FAST_MUL mul(
//     .number1(num1),
//     .number2(num2),  
//     .clk(clk),
//     .ans(mul_ans)
// );

// FAST_DIV div(
//     .number1(num1),
//     .number2(num2),  
//     .clk(clk),
//     .ans(div_ans),
//     .ans_ready(div_ans_ready)
//     );
endmodule
