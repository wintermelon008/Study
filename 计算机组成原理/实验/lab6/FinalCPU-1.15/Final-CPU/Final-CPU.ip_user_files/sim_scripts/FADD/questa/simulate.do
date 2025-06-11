onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib FADD_opt

do {wave.do}

view wave
view structure
view signals

do {FADD.udo}

run -all

quit -force
