# suppose that our former instructions are correct
# in the following test, if test fail we will show 0xffff
# otherwise we will show 0x00ff

# test and
li x5, 0xf
li x6, 0x1
li x7, 0x1
and x5, x5, x6
bne x5, x7, fail

# test andi
li x5, 0xf
li x7, 0x1
andi x5, x5, 0x1
bne x5, x7, fail

# test or
li x5, 0x1
li x6, 0x2
li x7, 0x3
or x5, x5, x6
bne x5, x7, fail

# test ori
li x5, 0x1
li x7, 0x3
ori x5, x5, 0x2
bne x5, x7, fail

# test sll
li x5, 0x1
li x6, 0x2
li x7, 0x4
sll x5, x5, x6
bne x5, x7, fail

# test slli
li x5, 0x1
li x7, 0x4
slli x5, x5, 0x2
bne x5, x7, fail

# test slt
li x5, 0x3
li x6, 0x2
li x7, 0x2
slt x5, x5, x6
bne x5, x7, fail

# test slti
li x5, 0x3
li x7, 0x2
slti x5, x5, 0x2
bne x5, x7, fail

# test sltu
li x5, 0x3
li x6, 0x2
li x7, 0x2
sltu x5, x5, x6
bne x5, x7, fail

# test sltiu
li x5, 0x3
li x7, 0x2
sltiu x5, x5, 0x2
bne x5, x7, fail

# test sra
li x5, 0xf
li x6, 0x1
li x7, 0x7
sra x5, x5, x6
bne x5, x7, fail

# test srai
li x5, 0xf
li x7, 0x7
srai x5, x5, 0x1
bne x5, x7, fail

# test srl
li x5, 0xf
li x6, 0x1
li x7, 0x7
srl x5, x5, x6
bne x5, x7, fail

# test srli
li x5, 0xf
li x7, 0x7
srli x5, x5, 0x1
bne x5, x7, fail

# test xor
li x5, 0x5
li x6, 0x2
li x7, 0x7
xor x5, x5, x6
bne x5, x7, fail

# test xori
li x5, 0x5
li x7, 0x7
xori x5, x5, 0x2
bne x5, x7, fail

nop

fail:
li x5, 0xfff
sw x5, 0(x0)
