# This is the test program for instrution:
# [add]  [addi]
.data 

.text
# First is the test for addi
addi t1, t1, 1		# t1 = t1 + 1 = x1
addi t1, t1, 15		# t1 = t1 + 15 = x10
addi t1, t1, -1		# t1 = t1 - 1 = xf
addi t1, t1, -16	# t1 = t1 - 16 = xffffffff

addi t2, t1, 2		# t2 = t1 + 2 = x1
addi t2, t2, -1		# t2 = t2 - 1 = 0
addi t1, t1, 1		# t1 = t1 + 1 = 0

# Now regt1 and t2 are zero.
#Then is the test for add
addi t1, t1, 5		# t1 = 5
add t2, t1, t1		# t2 = t1 + t1 = xa
add t1, t1, t2		# t1 = t1 + t2 = xf
addi t1, t1, -15	# t1 = 0
add t1, t1, t2		# t1 = t2 = xa

# Now regt1 and regt2 are xa