# suppose that our former instructions are correct
# in the following test, if test fail we will show 0xffff
# otherwise we will show 0x0000

# test andn
li x5, 0x1
li x6, 0x2
li x7, 0x1
# andn x5, x5, x6	-> 0100-0000-0110-0010-1111-0010-1011-0011 4062f2b3
nop
bne x5, x7, fail


# test orn
li x5, 0x1
li x6, 0x0
li x7, 0xffffffff
# orn x5, x5, x6	-> 0100-0000-0110-0010-1110-0010-1011-0011 4062e2b3
nop
bne x5, x7, fail


# test max
li x5, 0x1
li x6, 0x2
li x7, 0x2
# max x5, x5, x6	-> 0000-1010-0110-0010-1110-0010-1011-0011 0a62e2b3
nop
bne x5, x7, fail


# test maxu
li x5, 0x1
li x6, 0x2
li x7, 0x2
# maxu x5, x5, x6	-> 0000-1010-0110-0010-1111-0010-1011-0011 0a62f2b3
nop
bne x5, x7, fail


# test min
li x5, 0x2
li x6, 0x1
li x7, 0x1
# min x5, x5, x6	-> 0000-1010-0110-0010-1100-0010-1011-0011 0a62c2b3
nop
bne x5, x7, fail


# test minu
li x5, 0x2
li x6, 0x1
li x7, 0x1
# minu x5, x5, x6	-> 0000-1010-0110-0010-1101-0010-1011-0011 0a62d2b3
nop
bne x5, x7, fail


# test sh1add
li x5, 0x1
li x6, 0x1
li x7, 0x3
# sh1add x5, x5, x6	-> 0010 0000 0110 0010 1010 0010 1011 0011 2062a2b3
nop
bne x5, x7, fail


# test sh2add
li x5, 0x1
li x6, 0x1
li x7, 0x5
# sh2add x5, x5, x6	-> 0010 0000 0110 0010 1100 0010 1011 0011 2062c2b3
nop
bne x5, x7, fail


# test sh3add
li x5, 0x1
li x6, 0x1
li x7, 0x9
# sh3add x5, x5, x6	-> 0010 0000 0110 0010 1110 0010 1011 0011 2062e2b3
nop
bne x5, x7, fail


# test xnor
li x5, 0x3
li x6, 0xc
li x7, 0xfffffff0
# xnor x5, x5, x6	-> 0100 0000 0110 0010 1100 0010 1011 0011 4062c2b3
nop
bne x5, x7, fail

# test ld
li x5, 0x2
sw x5, 0(x0)
nop 
# ld x5, 0(x0)		-> 0000 0000 0000 0000 0011 0010 1000 0011 00003283
li x7, 0x2
bne x5, x7, fail


# test sd
li x5, 0x6
nop
# sd x5, 0(x0)		-> 0000 0000 0101 0000 0011 0000 0010 0011 00503023
lw x5, 0(x0)
li x7, 0x6
bne x5, x7, fail


nop
fail:
li x5, 0xffff
sw x5, 0(x0)
