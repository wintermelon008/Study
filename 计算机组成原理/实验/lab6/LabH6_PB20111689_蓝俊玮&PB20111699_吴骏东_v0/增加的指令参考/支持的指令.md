

### RISCV 32 M 扩展

#### mul 乘（R)

<center>00000 + 01 + rs2 + rs1 + 000 + rd + 0110011

```
x[rd] = x[rs1] * x[rs2]
```



#### mulh 高位乘（R）

<center>00000 + 01 + rs2 + rs1 + 001 + rd + 0110011

```
x[rd] = (x[rs1] * x[rs2]) >>_s 32
```



#### mulhsu 高位有符号-无符号乘（R）

<center>00000 + 01 + rs2 + rs1 + 010 + rd + 0110011

```
x[rd] = (x[rs1]_s *_u x[rs2]) >>_s 32
```



#### mulhu 高位无符号乘（R）

<center>00000 + 01 + rs2 + rs1 + 011 + rd + 0110011

```
x[rd] = (x[rs1]_u * x[rs2]_u) >>_u 32
```



#### div 除法(R)

<center>00000 + 01 + rs2 + rs1 + 100 + rd + 0110011

x[rd] = x[rs1] / x[rs2]



#### divu 无符号除法(R)

<center>00000 + 01 + rs2 + rs1 + 101 + rd + 0110011

x[rd] = x[rs1] $/_u$ x[rs2]



#### rem 求余数(R)

<center>00000 + 01 + rs2 + rs1 + 110 + rd + 0110011

x[rd] = x[rs1] % x[rs2]



#### remu 无符号求余数(R)

<center>00000 + 01 + rs2 + rs1 + 111 + rd + 0110011

x[rd] = x[rs1] $\%_u$ x[rs2]






###  RISCV 32 B 扩展



#### add.uw 无符号加字 （R）

<img src="is_pic\adduw.png" alt="image-20220503222950499" style="zoom: 50%;" />

```
let base = X(rs2);
let index = EXTZ(X(rs1)[31..0]);
X(rd) = base + index;
```



#### andn 按位反后与（R）

<img src="is_pic\addn.png" alt="image-20220503223217542" style="zoom:50%;" />

```
X(rd) = X(rs1) & ~X(rs2);
```



#### bclr 单比特置零 （R）

<img src="is_pic\blcr.png" alt="image-20220503223336747" style="zoom:50%;" />

```
let index = X(rs2) & (XLEN - 1);		// XLEN = 32
X(rd) = X(rs1) & ~(1 << index)
```



#### bclri 单比特置零 （I）

<img src="is_pic\bclri.png" alt="image-20220503230024930" style="zoom:50%;" />

```
let index = shamt & (XLEN - 1);			// XLEN = 32
X(rd) = X(rs1) & ~(1 << index)
```



#### bext 单比特提取（R）

<img src="is_pic\bext.png" alt="image-20220503230210546" style="zoom:50%;" />

```
let index = X(rs2) & (XLEN - 1);		// XLEN = 32
X(rd) = (X(rs1) >> index) & 1;
```



#### bexti 单比特提取（I）

<img src="is_pic\bexti.png" alt="image-20220503230317018" style="zoom:50%;" />

```
let index = shamt & (XLEN - 1);			// XLEN = 32
X(rd) = (X(rs1) >> index) & 1;
```



#### binv 单比特取反 （R）

<img src="is_pic\binv.png" alt="image-20220503232146712" style="zoom:50%;" />

```
let index = X(rs2) & (XLEN - 1);		// XLEN = 32
X(rd) = X(rs1) ^ (1 << index)
```



#### binvi 单比特取反（I）

<img src="is_pic\ibinvi.png" alt="image-20220503232230996" style="zoom:50%;" />

```
let index = shamt & (XLEN - 1);			// XLEN = 32
X(rd) = X(rs1) ^ (1 << index)
```



#### bset 单比特置数（R）

<img src="is_pic\bset.png" alt="image-20220503232500179" style="zoom:50%;" />

```
let index = X(rs2) & (XLEN - 1);		// XLEN = 32
X(rd) = X(rs1) | (1 << index)
```



#### bseti 单比特置数（I）

<img src="is_pic\bseti.png" alt="image-20220503232612054" style="zoom:50%;" />

```
let index = shamt & (XLEN - 1);			// XLEN = 32
X(rd) = X(rs1) | (1 << index)
```



#### clz 前导零计数（R）

<img src="is_pic\clz.png" alt="image-20220503232932775" style="zoom:50%;" />

```
val HighestSetBit : forall ('N : Int), 'N >= 0. bits('N) -> int
function HighestSetBit x = {
  foreach (i from (xlen - 1) to 0 by 1 in dec)
  if [x[i]] == 0b1 then return(i) 
  else ();
  return -1;
}
let rs = X(rs);
X[rd] = (xlen - 1) - HighestSetBit(rs);
```



#### cpop 置位计数（R）

<img src="D:\2022春\计算机组成原理\实验\final\is_pic\cpop.png" alt="image-20220503233137249" style="zoom:50%;" />

```
let bitcount = 0;
let rs = X(rs);
foreach (i from 0 to (xlen - 1) in inc)
  if rs[i] == 0b1 then bitcount = bitcount + 1 
  else ();
X[rd] = bitcount
```



#### ctz 后缀零计数（R）

<img src="is_pic\ctz.png" alt="image-20220503233542608" style="zoom:50%;" />

```
val LowestSetBit32 : forall ('N : Int), 'N >= 0. bits('N) -> int
function LowestSetBit32 x = {
  foreach (i from 0 to 31 by 1 in dec)
  if [x[i]] == 0b1 then return(i) 
  else ();
  return 32;
}
let rs = X(rs);
X[rd] = LowestSetBit32(rs);
```



#### max 有符号取较大值（R）

<img src="is_pic\max.png" alt="image-20220503233651424" style="zoom:50%;" />

```
let rs1_val = X(rs1)
let rs2_val = X(rs2);
let result = if rs1_val <_s rs2_val
				then rs2_val
 			 else rs1_val;
X(rd) = result;
```



#### maxu 无符号取较大值（R）

<img src="D:\2022春\计算机组成原理\实验\final\is_pic\maxu.png" alt="image-20220503233837342" style="zoom:50%;" />

```
let rs1_val = X(rs1)
let rs2_val = X(rs2);
let result = if rs1_val <_u rs2_val
				then rs2_val
 			 else rs1_val;
X(rd) = result;
```



#### min 有符号取较小值（R）

<img src="is_pic\min.png" alt="image-20220503233937286" style="zoom:50%;" />

```
let rs1_val = X(rs1)
let rs2_val = X(rs2);
let result = if rs1_val <_s rs2_val
				then rs1_val
 			 else rs2_val;
X(rd) = result;
```



#### minu 无符号取较小值（R）

<img src="is_pic\minu.png" alt="image-20220503234033189" style="zoom:50%;" />

```
let rs1_val = X(rs1)
let rs2_val = X(rs2);
let result = if rs1_val <_u rs2_val
				then rs1_val
 			 else rs2_val;
X(rd) = result;
```



#### orn 按位反后或（R）

<img src="is_pic\orn.png" alt="image-20220503234335479" style="zoom:50%;" />

```
X(rd) = X(rs1) | ~X(rs2);
```





#### rol 高位截断交换（R）

<img src="is_pic\rol.png" alt="image-20220503234637214" style="zoom:50%;" />

```
let shamt = X(rs2)[4..0];
let result = (X(rs1) << shamt) | (X(rs1) >> (xlen - shamt));
X(rd) = result;
```



#### ror 低位截断交换（R）

<img src="is_pic\ror.png" alt="image-20220503234947579" style="zoom:50%;" />

```
let shamt = X(rs2)[4..0];
let result = (X(rs1) >> shamt) | (X(rs1) << (xlen - shamt));
X(rd) = result;
```



#### roli 高位截断交换（I）

没有图... 将 rol opcode 变为 0010011 即可。

```
let shamt = shamt[4..0];
let result = (X(rs1) << shamt) | (X(rs1) >> (xlen - shamt));
X(rd) = result;
```



#### rori 低位截断交换（I）

<img src="is_pic\roli.png" alt="image-20220503235107772" style="zoom:50%;" />

```
let shamt = shamt[4..0];
let result = (X(rs1) >> shamt) | (X(rs1) << (xlen - shamt));
X(rd) = result;
```



#### sh1add 左移一位加（R）

<img src="is_pic\sh1add.png" alt="image-20220503235424498" style="zoom:50%;" />

```
X(rd) = X(rs2) + (X(rs1) << 1);
```



#### sh2add 左移两位加（R）

<img src="is_pic\sh2add.png" alt="image-20220503235536896" style="zoom:50%;" />

```
X(rd) = X(rs2) + (X(rs1) << 2);
```



#### sh3add 左移三位加（R）

<img src="is_pic\sh3add.png" alt="image-20220503235557154" style="zoom:50%;" />

```
X(rd) = X(rs2) + (X(rs1) << 3);
```



#### xnor 同或（R）

<img src="is_pic\xnor.png" alt="image-20220503235812413" style="zoom:50%;" />

```
X(rd) = ~(X(rs1) ^ X(rs2));
```

