> PB20111699 吴骏东
>
> 2022.4.30
>
> 实验内容说明



### Shell PART

#### 程序编译

```shell
# make
g++ -o shell shell.cpp history.cpp
```



#### 必做部分

**shell 支持多条管道的指令**。例如

 ```shell
[Shell] # ls | grep s | grep l
shell
shell.cpp
shell.h
[Shell] # 
 ```

**shell 支持重定向**。例如

```shell
[Shell] # ls
123		 history.cpp  Makefile	shell.cpp  strace
command_log.txt  history.h    shell	shell.h
[Shell] # ls | grep s > 1.txt
[Shell] # grep l < 1.txt > 2.txt 
[Shell] # cat 2.txt
shell
shell.cpp
shell.h
[Shell] # 
```

说明：shell 需要用户在 重定向符 与 目标文件 之间保留空格，否则无法识别。



**shell 可以正确处理 Ctrl-C 信号**。例如

```shell
[Shell] # ^C
[Shell] # ^C
[Shell] # ^C
[Shell] # ^C
[Shell] # ls^C
[Shell] # sleep 10
^C

[Shell] # ls
123		 history.cpp  Makefile	shell.cpp  strace
command_log.txt  history.h    shell	shell.h
[Shell] # 
```

**shell 支持 history 等命令**。例如

```shell
[Shell] # history 10
  Command [53]: echo 1
  Command [54]: ls
  Command [55]: ls | grep s > 1.txt
  Command [56]: ls
  Command [57]: grep l < 1.txt > 2.txt
  Command [58]: cat 2.txt
  Command [59]: wait 10
  Command [60]: sleep 10
  Command [61]: ls
  Command [62]: history 20
[Shell] # ! 61
ls
123    2.txt		history.cpp  Makefile  shell.cpp  strace
1.txt  command_log.txt	history.h    shell     shell.h
[Shell] # !!
ls
123    2.txt		history.cpp  Makefile  shell.cpp  strace
1.txt  command_log.txt	history.h    shell     shell.h
[Shell] # ! 53
echo 1
1
[Shell] # history 5
  Command [64]: ls
  Command [65]: ls
  Command [66]: ! 53
  Command [67]: echo 1
  Command [68]: history 5
[Shell] # 
```



#### **选做部分**

**shell 可以查看历史命令**。本实验中设置了一个默认存储文件（见 `history.h`），该文件将实时存储用户已经输入的指令。文件路径为：

```
/home/username/command_log.txt
```



**shell 可以处理 Ctrl-D。**例如

```shell
[Shell] # echo 1
1
[Shell] # echo 2
2
[Shell] # Goodbye!		// 按下 Ctrl-D
melon@ubuntu:~/Desktop/lab2$ 
```



**shell 可以读取环境变量值**。例如

```shell
[Shell] # echo $USER
melon
[Shell] # echo $ABC
Not found.
[Shell] # export ABC=12345
[Shell] # echo $ABC
12345
```





### Strace PART

#### 程序编译

```shell
# g++ strace.cpp -o strace
```

