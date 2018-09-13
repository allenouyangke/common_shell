#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : CommentUsage.sh
# Revision     : 1.0
# Date         : 2018/09/13
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : shell常用注释方法
# -------------------------------------------------------------------------------

# Method One : HERE DOCUMENT特性，实现多行注释(最稳妥的方式)
<<'COMMENT'
...

COMMENT

# Menthod Two : 使用:命令的特殊性，局限性较多，且影响性能(临时使用)
# (: + 空格 + 单引号)
: '
COMMENT1
COMMENT2
'

# Defect One : 不会注释 shell 脚本中本身带有单引号的语句部分，除非将程序中的单引号全部换成又引号。
# Defect Two : 虽然 : 会忽视后面的参数，但其实参数部分还是可能会被执行些操作，比如替换操作，文件截取操作等。所以这样会影响到代码的执行效率。

# Menthod Three : : + << 'COMMENT' 的方式

echo "Say Something"
: <<'COMMENT'
    your comment 1
    comment 2
    blah
COMMENT
echo "Do something else"

# Precautions : 加上单引号部分，有时候虽然不加不会有什么问题，但还是要加，以防出现莫名其妙的意外发生，比如发生字符扩展，命令替换等。

# Menthod Four : 最保险的方法还是每行前加上 #