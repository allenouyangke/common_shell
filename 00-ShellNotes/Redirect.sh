#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : Redirect.sh
# Revision     : 1.0
# Date         : 2018/09/13
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 重定向
# -------------------------------------------------------------------------------

# 一般情况下，每个 Unix/Linux 命令运行时都会打开三个文件
# 标准输入文件(stdin)：stdin 的文件描述符为0，Unix 程序默认从 stdin 读取数据。
# 标准输出文件(stdout)：stdout 的文件描述符为1，Unix 程序默认向 stdout 输出数据。
# 标准错误文件(stderr)：stderr 的文件描述符为2，Unix 程序会向 stderr 流中写入错误信息。

# stderr redirect to file
$command 2> file

# stderr append redirect to file
$command 2>> file

# Stdout and stderr are merged and redirected to file
$command > file 2>&1
$command >> file 2>&1

# Both stdin and stdout redirect
$command < file1 > file2

# Redirect output to file
$command > file

# Redirect input to file
$command < file

# Redirect output to file in append mode
$command >> file

# 将文件描述符为 n 的文件重定向到 file
n > file

# 将文件描述符为 n 的文件以追加的方式重定向到 file
n >> file

# 将输出文件 m 和 n 合并
n >& m

# 将输入文件 m 和 n 合并
n <& m

# 将开始标记 tag 和结束标记 tag 之间的内容作为输入
\<< tag


# Here Document(嵌入文档)
command << delimiter
    document
delimiter

# Precautions One : 结尾的 delimiter 一定要顶格写，前面不能有任何字符，后面也不能有任何字符，包括空格和 tab 缩进
# Precautions Two : 开始的 delimiter 前后的空格会被忽略掉


/dev/null
# Precautions One : 一个特殊的文件，写入到它的内容都会被丢弃；如果尝试从该文件读取内容，那么什么也读不到
# Precautions Two : 非常有用，将命令的输出重定向到它，会起到”禁止输出“的效果

# 屏蔽 stdout 和 stderr
$command > /dev/null 2>&1 file