
# Level 1.10【生化】分子量计算：给定一个只含 C，H，O，N 的化学分子式，
# 输出它的分子量

molecular = input('Please input the molecular formula \n[input]:')
length = len(molecular)
i = 0
atoms = [0, 0, 0, 0]

while (i < length):
    if molecular[i] == 'C':
        j = 1
        temp = 0
        while i + j < length and molecular[i + j] >= '0' and molecular[i + j] <= '9':
            temp = temp * 10 + int(molecular[i + j])
            j = j + 1
        atoms[0] += temp
        i += j
    
    elif molecular[i] == 'H':
        j = 1
        temp = 0
        while i + j < length and molecular[i + j] >= '0' and molecular[i + j] <= '9':
            temp = temp * 10 + int(molecular[i + j])
            j = j + 1
        atoms[1] += temp
        i += j

    elif molecular[i] == 'O':
        j = 1
        temp = 0
        while i + j < length and molecular[i + j] >= '0' and molecular[i + j] <= '9':
            temp = temp * 10 + int(molecular[i + j])
            j = j + 1
        atoms[2] += temp
        i += j

    elif molecular[i] == 'N':
        j = 1
        temp = 0
        while i + j < length and molecular[i + j] >= '0' and molecular[i + j] <= '9':
            temp = temp * 10 + int(molecular[i + j])
            j = j + 1
        atoms[3] += temp
        i += j

mass = 12 * atoms[0] + atoms[1] + 16 * atoms[2] + 14 * atoms[3]
print(mass)
print(atoms)

