onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib div_unsigned_opt

do {wave.do}

view wave
view structure
view signals

do {div_unsigned.udo}

run -all

quit -force
