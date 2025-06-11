.data
0	# 结果标记

# RISCV B扩展指令测试程序
.text
#bclr 单比特置零
li x5 0x0FF
li x6 0x003
li x11 0x0F7
nop
#bclr x5, x5, x6	  0100_1000_0110_0010_1001_0010_1011_0011  486292B3
bne x5, x11, Fail

#bclri
li x5 0x0FF
li x11 0x0F7
nop
#bclri x5, x5, 3	0100_1000_0011_0010_1001_0010_1001_0011  48329293
bne x5, x11, Fail

#bext
li x5 0x123
li x6 0x003
li x11 0x000
nop
#bext x5, x5, x6     	0100_1000_0110_0010_1101_0010_1011_0011  4862d2b3
bne x5, x11, Fail

#bexti
li x5 0x123
li x11 0x000
nop
#bexti x5, x5, 3	0100_1000_0011_0010_1101_0010_1001_0011  4832d293
bne x5, x11, Fail

#binv
li x5 0x123
li x6 0x003
li x11 0x12b
nop
#binv x5, x5, x6	0110_1000_0110_0010_1001_0010_1011_0011  686292b3
bne x5, x11, Fail

#binvi
li x5 0x123
li x11 0x12b
nop
#binvi x5, x5, 3	0110_1000_0011_0010_1001_0010_1001_0011  68329293
bne x5, x11, Fail

#bset
li x5 0x000
li x6 0x003
li x11 0x008
nop
#bset x5, x5, x6	0010_1000_0110_0010_1001_0010_1011_0011  286292b3
bne x5, x11, Fail

#bseti
li x5 0x000
li x11 0x008
nop
#bseti x5, x5,3		0010_1000_0011_0010_1001_0010_1001_0011  28329293
bne x5, x11, Fail

#clz
li x5 0x123
li x11 0x017
nop
#clz x5, x5		0110_0000_0000_0010_1001_0010_1001_0011	 60029293
bne x5, x11, Fail

#cpop
li x5 0x111
li x11 0x003
nop
#cpop x5, x5		0110_0000_0010_0010_1001_0010_1001_0011  60229293
bne x5, x11, Fail

#ctz
li x5 0xF18
li x11 0x003
nop
#ctz x5, x5		0110_0000_0001_0010_1001_0010_1001_0011  60129293
bne x5, x11, Fail








Fail:
li x10 0xFFF

Success:
li x10 0x111