# suppose that our former instructions are correct
# in the following test, if test fail we will show 0xffff
# otherwise we will show 0x0000

# test div
li x5, 0x5
li x6, 0x2
li x7, 0x2
div x5, x5, x6
bne x5, x7, fail

# test divu
li x5, 0x5
li x6, 0x2
li x7, 0x2
divu x5, x5, x6
bne x5, x7, fail

# test mul
li x5, 10
li x6, 11
li x7, 110
mul x5, x5, x6
bne x5, x7, fail

# test mulh
li x5, 0x7fffffff
li x6, 0x233333
li x7, 0x119999
mulh x5, x5, x6
bne x5, x7, fail

# test rem
li x5, 0x5
li x6, 0x2
li x7, 0x1
rem x5, x5, x6
bne x5, x7, fail

# test remu
li x5, 0x5
li x6, 0x2
li x7, 0x1
remu x5, x5, x6
bne x5, x7, fail

nop

fail:
li x5, 0xffff
sw x5, 0(x0)
