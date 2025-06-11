# suppose that our former instructions are correct
# in the following test, if test fail we will show 0xffff
# otherwise we will show 0x0000


# test lb
li x5, 0x2
sw x5, 0(x0)
lb x5, 0(x0)
li x7, 0x2
bne x5, x7, fail

# test lbu
li x5, 0x3
sw x5, 0(x0)
lbu x5, 0(x0)
li x7, 0x3
bne x5, x7, fail

# test lh
li x5, 0x4
sw x5, 0(x0)
lh x5, 0(x0)
li x7, 0x4
bne x5, x7, fail

# test lhu
li x5, 0x5
sw x5, 0(x0)
lhu x5, 0(x0)
li x7, 0x5
bne x5, x7, fail

# test sb
li x5, 0x6
sb x5, 0(x0)
lw x5, 0(x0)
li x7, 0x6
bne x5, x7, fail

# test sh
li x5, 0x7
sh x5, 0(x0)
lw x5, 0(x0)
li x7, 0x7
bne x5, x7, fail

nop

fail:
li x5, 0xffff
sw x5, 0(x0)
