# linux指令使用合集



### 文件操作



#### 字串模式匹配

用于在命令中进行字符串替换，提高使用效率

|   模式   |            匹配的字串            |
| :------: | :------------------------------: |
|   `*`    |             任意字串             |
|  `foo*`  |       匹配 foo 开头的字串        |
|  `*x*`   |         匹配含 x 的字串          |
|   `?`    |             一个字符             |
|  `a?b`   | `acb`、`a0b` 等，但不包含 `a00b` |
| `*.[ch]` |      以 .c 或 .h 结尾的文件      |

例如：

```shell
#删除所有以 tar.gz 结尾的压缩文件
$ rm *.tar.gz	

#将当前及子目录下所有以 .c 或 .h 结尾的代码移动到 /path
$ mv -r *.[ch] /path	

#删除当前目录所有文件
$ rm -rf *
```





#### **查看文件内容** concatenate

```shell
$ cat [option] <filename>

$ cat file.txt	#输出 file.txt 的全部内容
```





#### 编辑文件内容

**通用编辑器 `Nano `** 

```shell
$ nano <filename>

$ nano file.txt	#编辑 file.txt 文件，若没有则直接创建
```

nano 使用简略指南

直接输入即可， `^` 代表 Ctrl 键。编辑完成后按下 `Crtl+X` 即可



 **文本编辑器 `vim`** 

```shell
$ vi <filename>

$ vi file.txt		#浏览并编辑 file.txt 的内容
```

vim 使用简略指南

​		默认进入普通模式，按下 `i` 键后进入编辑模式，按下 `ESC` 返回普通模式，按下 `:wq` 保存并退出，按下 `:q!`  不保存直接退出





#### 文件复制 copy

```shell
$ cp [option] <source> <dest>
#将 source 文件复制到 dest 文件

$ cp [option] <source> ... <directory>
#将一系列 source 文件复制到 directory 目录下
```

常用选项

|            选项             |                作用                |
| :-------------------------: | :--------------------------------: |
| `-r` , `-R` , `--recursive` | 递归复制，常用于复制文件夹（目录） |
|       `-f`, `--force`       |        覆盖目标地址同名文件        |
|      `-u`, `--update`       |  仅当源文件比目标文件新才进行复制  |
|       `-l`, `--link`        |             创建硬链接             |
|   `-s`, `--symbolic-link`   |             创建软链接             |

例如：

```shell
#将 file1.txt 复制一份到同目录，命名为 file2.txt
$ cp file1.txt file2.txt

#将 file1.txt、file2.txt 文件复制到同目录下的 file 目录中
$ cp file1.txt file2.txt ./file/

#将 dir1 文件夹及其所有子文件复制到同目录下的 test 文件夹中
$ cp -r dir1 ./test/
```





#### 文件移动 move

类似于 ` 剪切` 操作

```shell
$ mv [option] <source> <dest>
#将 source 文件移动到 dest 文件

$ mv [option] <source> ... <directory>
#将一系列 source 文件移动到 directory 目录下 
```

常用选项

|           选项            |               含义               |
| :-----------------------: | :------------------------------: |
| `-r`, `-R`, `--recursive` |     递归移动，常用于移动目录     |
|      `-f`, `--force`      |       覆盖目标地址同名文件       |
|     `-u`, `--update`      | 仅当源文件比目标文件新才进行移动 |





#### 文件删除 remove

```shell
$ rm [option] <filename> ...
#删除一系列文件
```

常用选项

|            选项             |                作用                |
| :-------------------------: | :--------------------------------: |
| `-r` , `-R` , `--recursive` | 递归删除，常用于删除文件夹（目录） |
|       `-f`, `--force`       | 无视不存在或者没有权限的文件和参数 |
|        `-d`, `--dir`        |             删除空目录             |

例如：

```shell
#删除 file1.txt 文件：
$ rm file1.txt

#删除 test 目录及其下的所有文件：
$ rm -r test/

#删除 test1/、test2/、file1.txt 这些文件、目录。其中，这些文件或者目录可能不存在、写保护或者没有权限读写：
$ rm -rf test1/ test2/ file1.txt		#强制删除
```





#### 创建目录（文件夹）make directory

```shell
$ mkdir [option] <direname> ...

$ mkdir test dir
#创建名为 test 和 dir 的两个目录
```

常用选项

| 选项 |                             作用                             |
| :--: | :----------------------------------------------------------: |
| `-p` | 如果中间目录不存在，则创建；如果要创建的目录已经存在，则不报错 |





#### 创建文件 touch

```shell
$ touch <filename> ...

$ touch file1 file2
#创建两个文件 file1 file2
```





#### 查找文件 find

```shell
$ find [option] <path> [expression]
#在 path 路径中根据 expression 搜索文件
```

常用选项与表达式

|   选项   |  表达式   |                   作用                   |
| :------: | :-------: | :--------------------------------------: |
| `-name ` |  `*.ext`  | 文件名后缀为 ext。其中 `*` 是任意匹配符  |
| `-type`  |    `d`    |              文件类型为目录              |
|          |    `f`    |            文件类型为普通文件            |
| `-size`  | `+<size>` |          大于 `size` 大小的文件          |
|          | `-<size>` |          小于 `size` 大小的文件          |
|  `-or`   |           | 或运算符，代表它前后两个条件满足一个即可 |

例如：

```shell
#在当前目录搜索名为 report.pdf 的文件：
$ find . -name 'report.pdf'

#全盘搜索大于 1G 的文件：
$ find / -size +1G

#在用户目录搜索所有名为 node_modules 的文件夹：
$ find ~/ -name 'node_modules' -type d
```





#### 压缩文件 tape archive

```shell
$ tar [option] <filename> ...
#将一系列目标文件压缩成一个文件
```

常用选项

|                  选项                  |                     含义                     |
| :------------------------------------: | :------------------------------------------: |
|                  `-A`                  | 将一个存档文件中的内容追加到另一个存档文件中 |
|            `-r`, `--append`            |        将一些文件追加到一个存档文件中        |
|            `-c`, `--create`            |            从一些文件创建存档文件            |
|             `-t`, `--list`             |            列出一个存档文件的内容            |
|      `-x`, `--extract`， ` --get`      |            从存档文件中提取出文件            |
|        `-f`, `--file=<archive>`        |              使用指定的存档文件              |
|     `-C`, `--directory=<dirname>`      |                指定输出的目录                |
| `-z`, `--gzip`, `--gunzip`, `--ungzip` |          使用 gzip 算法处理存档文件          |
|            `-j`, `--bzip2`             |         使用 bzip2 算法处理存档文件          |
|              `-J`, `--xz`              |           使用 xz 算法处理存档文件           |

例如：

```shell
#将 file1、file2、file3 打包为 target.tar：
$ tar -c -f target.tar file1 file2 file3

#将 target.tar 中的文件提取到 test 目录中：
$ tar -x -f target.tar -C test/

#将 file1、file2、file3 打包，并使用 gzip 算法压缩，得到压缩文件 target.tar.gz ：
$ tar -cz -f target.tar.gz file1 file2 file3

#将压缩文件 target.tar.gz 解压到 test 目录中：
$ tar -xz -f target.tar.gz -C test/

#将 archive1.tar、archive2.tar、archive3.tar 三个存档文件中的文件追加到 archive.tar 中
$ tar -Af archive.tar archive1.tar archive2.tar archive3.tar

#列出 target.tar 存档文件中的内容
$ tar -t -f target.tar

# 打印出文件的详细信息
$ tar -tv -f target.tar
```

