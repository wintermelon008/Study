`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/06 18:58:17
// Design Name: 
// Module Name: Pipline_CTRL
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
    ================================   Pipline_CTRL module   ================================ 
    Author:         Wintermelon
    Last Edit:      2022.5.9

    This is the PCU
    Function: 1. Solve the interrupt (with CSRs inside)
              2. Solve the data hazard (with the forwarding control, pipeline stop etc.)
*/

/*  ================================= CSR table =================================

    With the original CSRs below:
        mtevc (Machine Trp-Vecor Base-Address Register)     address 0x305
        mcause (Machine CauseRegister)                      address 0x342
        mepc (Machine Exception Program Counter)            address 0x341
        mtval (Machine Trap Value Resiste)                  address 0x343

    With new designed CSRs below:
        mipd (Machine Interrupt Program Done)               address 0x100

*/

module Pipline_CTRL(
    input clk,    // 100Mhz
    input rstn,

    // Instruction and PC
    input [31:0] if_is, id_is, ex_is, mem_is, wb_is,
    input [31:0] if_pc, id_pc, ex_pc, mem_pc, wb_pc,

    input [2:0] ex_npc_mux_sel,

    // CPU interrupt infomation
    input [3:0] error,
    input ebreak,              

    // CSR
    input [31:0] csr_din,
    output reg [31:0] csr_dout,
    input [31:0] csr_radd,
    input [31:0] csr_wadd,
    input csr_wen,

    // CPU PC control
    output reg [31:0] pc_dout,
    output reg pc_wen,
    output reg npc_mux_sel,     // When 1, the npc will be 2'b11(interrupt)

    // outside signals
    input butc,
    input butu,
    input butl,
    input butd,
    input butr,

    output cpu_clk,
    output clk_50,
    output reg if_id_wen, id_ex_wen, ex_mem_wen, mem_wb_wen,
    output reg if_id_clear, id_ex_clear, ex_mem_clear, mem_wb_clear,
    
    output [2:0] b_sr1_mux_sel_fh,
    output [2:0] b_sr2_mux_sel_fh,
    output [2:0] sr1_mux_sel_fh,
    output [2:0] sr2_mux_sel_fh,
    output [2:0] dm_sr2_mux_sel_fh,
    output [2:0] csr_mux_sel_fh,


    // Debug
    input [11:0] csr_debug_addr,
    output [31:0] csr_debug_data
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


/*  ================================= CPU Interrupt Reason table =================================
    This is the interrupt reason id for mcause

    1. Program Interrupt (We make it as ebreak)
    2. User Interrupt (We make it as user breakpoint)
    3. Divide by 0
    4. Memory access error
    5. Instruction decode error
    ......
*/

    // These two kinds will not make CPU into interrupt status
    localparam Program_Breakpoint = 32'h1;

    
    // These will.
    localparam Divide_By_Zero = 32'h3;
    localparam Memory_Access_Error = 32'h4;
    localparam Is_Decode_Error = 32'h5;
    localparam User_Button = 32'h6;


/*  ================================= PCU State machine table =================================

    1. Wait (CPU continue working)
    2. Set CSRs (mtevc, mcause, mepc, mtval) (CPU stop, set the muxs)
    3. Wait for interrupt solveing program finish
    4. Reload PC (CPU stop, set the muxs)
    5. Wait(1.) (CPU continue working)
    ......
*/

    localparam Reset = 4'h0;
    localparam Wait = 4'h1;

    localparam Load_Part1 = 4'h2;
    localparam Load_Part2 = 4'h3;
    localparam Load = 4'h4;
    localparam Wait_done = 4'h5;
    localparam Reload_Part1 = 4'h6;
    localparam Reload_Part2 = 4'h7;
    localparam Reload = 4'h8;



/*
    ================================= CPU clock State machine table =================================
*/
    localparam CLOCK_STOP = 2'b00;
    localparam CLOCK_RUN = 2'b01;


wire if_id_en_fh, id_ex_clear_fh, pc_wen_fh;
reg if_id_clear_pcu, id_ex_clear_pcu, pc_wen_pcu;

wire csr_we;        // The final write enable signal

wire interrupt;     // The flag when from user to interrupt
wire ret;           // The flag when from interrupt to user
wire button_sig;    // The flag when a button has been pressed

reg [3:0] current_state, next_state;
reg [1:0] clk_cs, clk_ns;
reg [31:0] mtevc, mtval, mepc, mcause, mipd, bs;
wire [31:0] mtevc_dout, mtval_dout, mepc_dout, mcause_dout, mipd_dout, bs_dout;


reg [31:0] cpu_clk_conter;
reg slow_clk;
reg cpu_clk_en;
reg pcu_csr_wen;        // Control by state machine
reg pcu_run;            // Starts the interrupt program

// Below is the wires connection
assign cpu_clk = slow_clk & cpu_clk_en;


assign interrupt = (error == NO_ERROR) ? 1'b0 : 1'b1;
assign ret = (csr_din == 32'h1 && csr_wadd == 32'h0100) ? 1'b1 : 1'b0;
assign button_sig = butc || butd || butr || butu || butl;   // Any button will change this 

assign clk_50 = slow_clk;


initial begin
    clk_cs = CLOCK_RUN;
    cpu_clk_conter <= 'b0;
    current_state <= Wait;
end


always @(*) begin
    if_id_wen = if_id_en_fh;
    id_ex_wen = 1'b1;
    ex_mem_wen = 1'b1;
    mem_wb_wen = 1'b1;

    if_id_clear = if_id_clear_pcu;
    id_ex_clear = id_ex_clear_fh || id_ex_clear_pcu;
    ex_mem_clear = 1'b0;
    mem_wb_clear = 1'b0;

    pc_wen = pc_wen_fh || pc_wen_pcu;
end

// CSR read
always @(*) begin
    csr_dout = 32'h0;
    case (csr_radd)
        32'h0305: csr_dout = mtevc_dout;
        32'h0342: csr_dout = mcause_dout;
        32'h0341: csr_dout = mepc_dout;
        32'h0343: csr_dout = mtval_dout;
        32'h0100: csr_dout = mipd_dout;
        32'h0000: csr_dout = bs_dout;
    endcase
end

// CSR write
always @(*) begin
    mtevc = mtevc_dout;
    mcause = mcause_dout;
    mepc = mepc_dout;
    mtval = mtval_dout;      
    mipd = mipd_dout;
    bs = bs_dout;

    if (button_sig) begin
        // User press the button
        mtevc = 32'hF010;
        mcause = User_Button;   
        mepc = (id_ex_clear && if_id_wen) ? if_pc : id_pc;   
        // none:0 up:1 down:2 left:3 right:4 reset(mid): 5
        if (butu)
            bs = 32'h1;
        else if (butd)
            bs = 32'h2;
        else if (butl) 
            bs = 32'h3;
        else if (butr)
            bs = 32'h4;
        else if (butc)
            bs = 32'h5;
        mipd = 1'b0;
    end

    else if (ebreak) begin
        // Progrom starts at 0xF000
        mtevc = 32'hF000;
        mcause = Program_Breakpoint;
        mepc = id_pc;
        mtval = 32'h0;      // no working infomation
        mipd = 1'b0;

    end 
    else if (csr_wen) begin
        // Program CSR instruction write
        case (csr_wadd) 
            32'h0305: mtevc = csr_din;
            32'h0342: mcause = csr_din;
            32'h0341: mepc = csr_din;
            32'h0343: mtval = csr_din;
            32'h0100: mipd = csr_din;
            32'h0000: bs = csr_din;
        endcase
    end
    // else begin
    //     case(error)
    //         ERROR_DIV_BY_ZERO: begin
    //             // Prorgam starts at 0xF008
    //             mtevc = 32'hF008;
    //             mcause = Divide_By_Zero;
    //             mepc = id_pc;
    //             mtval = id_pc;      
    //         end
    //     endcase
    // end
end

// Below is the PCU state machine

always @(*) begin
    if (~rstn) begin
        next_state = Reset;
    end
    else begin
        next_state = Reset;
        
        case (current_state) 
            Wait: begin
                next_state = Wait;

                if (button_sig || error != NO_ERROR) begin
                    next_state = Load_Part1;
                end

            end

            Load_Part1: next_state = Load_Part2;

            Load_Part2: next_state = Load;

            Load: next_state = Wait_done;

            Wait_done: begin
                if (mipd_dout == 32'h1)
                    next_state = Reload_Part1;
                else
                    next_state = Wait_done;
            end

            Reload_Part1: next_state = Reload_Part2;

            Reload_Part2: next_state = Reload;

            Reload: next_state = Wait;

            Reset: next_state = Wait;

        endcase
    end
end

always @(posedge clk or negedge rstn) begin
    if (~rstn)
        current_state <= Reset;
    else
        current_state <= next_state;
end

always @(*) begin
    pcu_csr_wen = 1'b1;
    pc_wen_pcu = 1'b0;
    pcu_run = 1'b1;
    pc_dout = 32'h0;
    npc_mux_sel = 1'b0;
    if_id_clear_pcu = 1'b0;
    id_ex_clear_pcu = 1'b0;

    case (next_state)
        Wait: begin

        end
        
        Load_Part1: begin
            pc_wen_pcu = 1'b1;
            npc_mux_sel = 1'b1;
            pc_dout = mtevc_dout;

            if_id_clear_pcu = 1'b1;
            id_ex_clear_pcu = 1'b1;
        end

        Load_Part2: begin
            pc_wen_pcu = 1'b1;
            npc_mux_sel = 1'b1;
            pc_dout = mtevc_dout;

            if_id_clear_pcu = 1'b1;
            id_ex_clear_pcu = 1'b1;
        end

        Load: begin
            pc_wen_pcu = 1'b1;
            npc_mux_sel = 1'b1;
            pc_dout = mtevc_dout;
            pcu_run = 1'b1;

            if_id_clear_pcu = 1'b1;
            id_ex_clear_pcu = 1'b1;
        end

        Wait_done: begin

        end

        Reload_Part1: begin
            pc_wen_pcu = 1'b1;
            npc_mux_sel = 1'b1;
            pc_dout = mepc_dout;

            if_id_clear_pcu = 1'b1;
            id_ex_clear_pcu = 1'b1;
        end

        Reload_Part2: begin
            pc_wen_pcu = 1'b1;
            npc_mux_sel = 1'b1;
            pc_dout = mepc_dout;

            if_id_clear_pcu = 1'b1;
            id_ex_clear_pcu = 1'b1;
        end

        Reload: begin
            pc_wen_pcu = 1'b1;
            npc_mux_sel = 1'b1;
            pc_dout = mepc_dout;
            pcu_run = 1'b1;

            if_id_clear_pcu = 1'b1;
            id_ex_clear_pcu = 1'b1;
        end
    endcase
end


// Below is the CPU clock control

always @(*) begin
    if (~rstn) begin
        clk_ns = CLOCK_STOP;
    end
    else begin
        case (clk_cs) 
            CLOCK_RUN: begin 
                if (ebreak || next_state == Reload_Part1 || button_sig) begin
                    // Breakpoint
                    clk_ns = CLOCK_STOP;
                end
                else
                    clk_ns = CLOCK_RUN;
            end

            CLOCK_STOP: begin
                if (pcu_run) begin
                    // Breakpoints: user press [enter], then pdu_run will be 1
                    // Other interrupt: the program will set Mipd to 1
                    clk_ns = CLOCK_RUN;
                end
                else
                    clk_ns = CLOCK_STOP;
            end
    
            default: clk_ns = CLOCK_STOP;
        endcase
    end
end

always @(posedge clk or negedge rstn) begin
    if (~rstn)
        clk_cs <= CLOCK_STOP;
    else
        clk_cs <= clk_ns;
end

always @(*) begin
    case (clk_ns) 
        CLOCK_RUN: begin
            cpu_clk_en = 1'b1;
        end

        CLOCK_STOP: begin
            cpu_clk_en = 1'b0;
        end

        default: begin
            cpu_clk_en = 1'b0;
        end
    endcase
end

// CPU clock control
localparam CPU_CLK_N = 11'd1;
//localparam CPU_CLK_N = 11'd25000000;

always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        cpu_clk_conter <= 0;
        slow_clk <= 0;
    end
    else begin
        if (cpu_clk_conter == CPU_CLK_N + CPU_CLK_N) begin
            cpu_clk_conter <= 32'b1;
            slow_clk <= 1'b1;
        end
        else begin               
            if (cpu_clk_conter < CPU_CLK_N)
                slow_clk <= 1'b1;
            else 
                slow_clk <= 1'b0;
            cpu_clk_conter <= cpu_clk_conter + 'h1;
        end
 
       
    end
end



// CSRs
CSR_UNIT csr(
    .csr_we(1'b1),
    .csr_clk(clk),
    .rstn(rstn),

    // CSRs
    .mtevc_din(mtevc),
    .mtevc_dout(mtevc_dout),

    .mcause_din(mcause),
    .mcause_dout(mcause_dout),

    .mepc_din(mepc),
    .mepc_dout(mepc_dout),

    .mtval_din(mtval),
    .mtval_dout(mtval_dout),

    .mipd_din(mipd),
    .mipd_dout(mipd_dout),

    .bs_din(bs),
    .bs_dout(bs_dout),

    .csr_debug_addr(csr_debug_addr),
    .csr_debug_dout(csr_debug_data)
);




// FH
Forwarding_Hazard fh(
    .id_is(id_is),
    .ex_is(ex_is),
    .mem_is(mem_is),
    .wb_is(wb_is),
    .npc_mux_sel(ex_npc_mux_sel),

    // forwarding
    .b_sr1_mux_sel_fh(b_sr1_mux_sel_fh),
    .b_sr2_mux_sel_fh(b_sr2_mux_sel_fh),
    .sr1_mux_sel_fh(sr1_mux_sel_fh),
    .sr2_mux_sel_fh(sr2_mux_sel_fh),
    .dm_sr2_mux_sel_fh(dm_sr2_mux_sel_fh),
    .csr_mux_sel_fh(csr_mux_sel_fh),

    // hazard -- dealing with cpu's stop
    .pc_en(pc_wen_fh),
    .if_id_en(if_id_en_fh),
    .id_ex_clear(id_ex_clear_fh)
);

endmodule
