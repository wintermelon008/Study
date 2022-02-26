## git使用学习心得

#### 1. 写在前面的废话

这是我第一次学习git、学习linux、系统化管理个人仓库的经历，算是对新的一年自己的一次挑战与创新。希望今后的自己能够一直保持着这份对新知识新技能的渴望吧。



#### **2. git 概念介绍**

Git 有三种状态，你的文件可能处于其中之一：已提交(committed)、已修改(modified)和已暂存(staged)。 已提交表示数据已经安全的保存在本地数据库中。 已修改表示修改了文件，但还没保存到数据库中。 已暂存表示对一个已修改文件的当前版本做了标记，使之包含在下次提交的快照中。

**Git 仓库目录(Repository)** 是 Git 用来保存项目的元数据和对象数据库的地方。 这是 Git 中最重要的部分，从其它计算机克隆仓库时，拷贝的就是这里的数据。

**工作目录(Working Directory)** 是对项目的某个版本独立提取出来的内容。 这些从 Git 仓库的压缩数据库中提取出来的文件，放在磁盘上供你使用或修改。

**暂存区域(Staging Area)** 是一个文件，保存了下次将提交的文件列表信息，一般在 Git 仓库目录中。 有时候也被称作‘索引’，不过一般说法还是叫暂存区域。

基本的 Git 工作流程如下：

1. 在工作目录中修改文件。
2. 暂存文件，将文件的快照放入暂存区域。
3. 提交更新，找到暂存区域的文件，将快照永久性存储到 Git 仓库目录。

如果 Git 目录中保存着的特定版本文件，就属于已提交状态。 如果作了修改并已放入暂存区域，就属于已暂存状态。 如果自上次取出后，作了修改但还没有放到暂存区域，就是已修改状态。





#### 3. 常用 git 指令合集



**建立并初始化本地仓库**

```shell
makdir	<firename>	 			#建立新文件夹
cd /...		        			#切换到仓库路径
pwd					 			#显示当前路径名

git init						#初始化为 git 仓库
```



**从远程复制 git 仓库**

```shell
git clone <url> <name>
```

该命令会在当前目录下创建一个名为 `name`(默认与远程仓库保持一致) 的目录，并在这个目录下初始化一个 `.git` 文件夹，从远程仓库拉取下所有数据放入 `.git` 文件夹，然后从中读取最新版本的文件的拷贝。

//todo git 的传输协议



**提交更新到 git 仓库**

```shell
git status
```

该命令用于检查当前仓库的文件状态。如果输出如下：

> On branch master
>
> nothing to commit, working directory clean

代表当前工作目录没有内容，也即所有的文件均没有被修改。

//todo 分支目录

如果修改了仓库中的 `test.txt`文件，则使用该命令后会提示：

> On branch master
>
> Untracked files:  
>
> ​      (use "git add <file>..." to include in what will be committed)     
>
> ​		<font color=Red>test.txt</font>
>
> nothing added to commit but untracked files present (use "git add" to track)



```shell
git add <filename>
```

该命令用于跟踪新的文件，将`firename`变为暂存状态。

`git add` 命令使用文件或目录的路径作为参数；如果参数是目录的路径，该命令将递归地跟踪该目录下的所有文件。

执行上述语句后，`git status` 输出如下:

> On branch master 
>
> Changes to be committed:  
>
> ​    (use "git reset HEAD <file>..." to unstage)     
>
> ​		<font color=green> new file: test.txt</font>



```shell
git diff <filename>
```

该命令可以显示仓库中尚未暂存的改动内容。注意，如果添加了`filename`，则只检查同名文件(夹)的内容；在不加参数时，指令不会输出上次提交以来的所有改动。如果要实现该功能，则需要使用`git diff --cashed`或`git diff --staged`。



```shell
git commit
```

该指令用于将暂存区的内容提交到本地仓库中。请注意：在此之前，**请一定要确认还有什么修改过的或新建的文件还没有 `git add` 过**，否则提交的时候不会记录这些还没暂存起来的变化。 这些修改过的文件只保留在本地磁盘。 所以，每次准备提交前，先用 `git status` 看下，是不是都已暂存起来了，如果没有暂存起来则要先使用命令：`git add .`将所有文件暂存起来， 然后再运行提交命令 `git commit`。

直接执行`git commit`时，Git 会启动默认的软件进行编辑(一般为`vim`)。可以通过使用`git commit -m "<comment>"`将提交信息与命令放在同一行。

Git 也提供了一个跳过使用暂存区域的方式， 只要在提交的时候，给 `git commit` 加上 `-a` 选项，Git 就会自动把所有已经跟踪过的文件暂存起来一并提交，从而跳过 `git add` 步骤。



```shell
git push
```

该指令用于将本地仓库的内容传输至远程仓库。在第一次传输时，需要指定传输的地址，操作如下：

```shell
git push <remote-name> <branch-name>
```

随后，就可以使用`git push`指令进行传输。



**查看提交历史记录**

```shell
git log
```

`git log` 会按提交时间列出所有的更新，最近的更新排在最上面。此外，一个常用的选项是 `-p`，用来显示每次提交的内容差异。 你也可以加上 `-2` 来仅显示最近两次提交。如果你想看到每次提交的简略的统计信息，可以使用 `--stat` 选项。





#### 参考文献

1. git 教程 [Git基础概念 - Git教程™ (yiibai.com)](https://www.yiibai.com/git/git_basic_concepts.html)







