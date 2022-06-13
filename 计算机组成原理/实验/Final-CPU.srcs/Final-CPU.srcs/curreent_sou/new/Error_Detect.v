`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/11 14:22:05
// Design Name: 
// Module Name: Error_Detect
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
    ================================  Error_Detect module   ================================
    Author:         Wintermelon
    Last Edit:      2022.5.11

    This module will detect the error inside the CPU, and make the final error id for PCU

*/

module Error_Detect(
    input [3:0] ccu_error,
    input cu_error,
    input imu_error,
    input dmu_error,

    output reg [3:0] cpu_error
);

/*  ================================= CPU ERROR table =================================
    1. Divide by 0
    2. Memory Access Error
    3. Instruction Opcode Error
*/
    localparam NO_ERROR = 4'h0;
    localparam ERROR_DIV_BY_ZERO = 4'h1;
    localparam ERROR_MEM_ACCESS_ERR = 4'h2;
    localparam ERROR_IS_OPCODE_ERR = 4'h3;

/*                                              Below is the CCU error mode table 
    ========================================================================================================================
*/
    localparam NO_INSTRUCTION = 3'h1;
    localparam DIV_BY_ZERO = 3'h2;

    always @(*) begin
        cpu_error = NO_ERROR;

        // if (ccu_error == DIV_BY_ZERO)
        //     cpu_error = ERROR_DIV_BY_ZERO;
        // if (imu_error || dmu_error)
        //     cpu_error = ERROR_MEM_ACCESS_ERR;
        // else if (cu_error)
        //     cpu_error = ERROR_IS_OPCODE_ERR;
        
    end

endmodule
