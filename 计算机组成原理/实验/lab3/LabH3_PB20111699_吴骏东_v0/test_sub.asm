.text
# This program will test instruction:
# [sub], [auipc]

# Frist is the test of sub
addi t1, t1, 255	# t1 = xff
addi t2, t2, 128	# t2 = x80
sub t2, t1, t2		# t2 = t1 - t2 = x7f
sub t2, t1, t2		# t2 = t1 - t2 = x80

# Then is the test for auipc
auipc t1, 1	# t1 = pc + x1000
auipc t1, 2	# t1 = pc + x2000
auipc t1, -1	# t1 = pc - x1000