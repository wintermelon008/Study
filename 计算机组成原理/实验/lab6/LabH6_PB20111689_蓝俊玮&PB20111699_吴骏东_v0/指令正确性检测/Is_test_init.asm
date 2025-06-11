# This is the instruction test program
.data
base: .word 0xFF00

.text
#addi
addi t0, x0, 6

#add
add t0, t0, t0

#lw and auipc
lw t0, base

#sw
sw t0, 0(x0)

#beq, bnq, blt, bltu
addi t1, x0, 5
label1:
blt t1, x0, label2
addi t1, x0, -6
bne t1, t1, label2
beq t1, t1, label1
label2:
bltu t1, x0, label1

#jal, jalr

jal s0, label3
addi x0, x0, 0
label3:
jalr s1, 12(s0)
addi x0, x0, 0

#lui
lui t2 0xFEDCB

addi s5, x0, 20
addi s6, x0, 5
nop
nop
nop
nop
mul s4, s5, s6
nop
nop
nop


