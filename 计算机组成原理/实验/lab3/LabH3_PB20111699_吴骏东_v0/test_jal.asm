# This is the test fot jal and jalr
# [jal], [jalr]
.text
addi t0, x0, 1
jal s1, Here1
Here2:
jalr s3, 4(s1)
Here1:
jal s2, Here2
# Endless loop!