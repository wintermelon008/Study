vlib work
vlib riviera

vlib riviera/dist_mem_gen_v8_0_13
vlib riviera/xil_defaultlib

vmap dist_mem_gen_v8_0_13 riviera/dist_mem_gen_v8_0_13
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work dist_mem_gen_v8_0_13  -v2k5 \
"../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../Final-CPU.srcs/sources_1/ip/user_stack/sim/user_stack.v" \


vlog -work xil_defaultlib \
"glbl.v"

