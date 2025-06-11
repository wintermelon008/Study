# This is the test for beq and blt
.data
3
.text
addi t0, x0, 0
lw t1, 0(t0)

blt x0, t1, Postive
beq x0, t1, Zero
Negtive:
addi s0, x0, 1
beq x0, x0, done
Zero:
addi s1, x0, 1
beq x0, x0, done
Postive:
addi s2, x0, 1
beq x0, x0, done
done:
