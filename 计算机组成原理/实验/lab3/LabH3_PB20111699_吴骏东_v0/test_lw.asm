# This is the test for lw and sw
#[lw]  [sw]
.data
1
2
3
-1
0
.text
addi t1, x0, 0
lw t2, 0(t1)
addi t2, t2, 1
sw t2, 0(t1)

addi t1, t1, 4
lw t2, 0(t1)
addi t2, t2, 1
sw t2, 0(t1)

addi t1, t1, 4
lw t2, 0(t1)
addi t2, t2, 1
sw t2, 0(t1)

addi t1, t1, 4
lw t2, 0(t1)
addi t2, t2, 1
sw t2, 0(t1)

addi t1, t1, 4
lw t2, 0(t1)
addi t2, t2, 1
sw t2, 0(t1)