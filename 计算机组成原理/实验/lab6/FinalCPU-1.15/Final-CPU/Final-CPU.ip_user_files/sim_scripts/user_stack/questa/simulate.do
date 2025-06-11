onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib user_stack_opt

do {wave.do}

view wave
view structure
view signals

do {user_stack.udo}

run -all

quit -force
