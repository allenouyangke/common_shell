#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : Operator.sh
# Revision     : 1.0
# Date         : 2018/09/13
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : shell运算符汇总(http://c.biancheng.net/cpp/view/2736.html)
# -------------------------------------------------------------------------------

# 算术运算符
+
-
*
/
%
=
==
!=

# 数学运算方法
let
# let-example :
no1=10;
let no1++
echo $no1
let no1--
echo $no1

no1=10
let no1+=5
echo $no1
let no1-=6
echo $no1


[]
# []-Example :
no1=2
no2=3
result=$[ no1 + no2 ]
echo $result

result=$[ $no1 + 5 ]
echo $result


expr
# expr-Example :
no1=3
no2=4
result=`expr $no1 + $no2`
echo $result
 
result=`expr 5 + 10`
echo $result
 
result=$(expr $no1 + 5)
echo $result
 
 
bc
# bc-Example : 
echo '4 * 0.56' | bc

no1=54
result=`echo "$no1 * 1.5" | bc`

echo 'scale=2;3/8' | bc

no=100
echo "obase=2;$no" | bc
 
no=1111
echo "obase=10;ibase=2;$no" | bc


# 关系运算符
-eq	
# 检测两个数是否相等，相等返回 true
-ne	
# 检测两个数是否相等，不相等返回 true。
-gt	
# 检测左边的数是否大于右边的，如果是，则返回 true
-lt
# 检测左边的数是否小于右边的，如果是，则返回 true
-ge	
# 检测左边的数是否大等于右边的，如果是，则返回 true
-le	
# 检测左边的数是否小于等于右边的，如果是，则返回 true


# 布尔运算符
!	
# 非运算，表达式为 true 则返回 false，否则返回 true
-o	
# 或运算，有一个表达式为 true 则返回 true
-a	
# 与运算，两个表达式都为 true 才返回 true


# 字符串运算符
=	
# 检测两个字符串是否相等，相等返回 true
!=	
# 检测两个字符串是否相等，不相等返回 true
-z	
# 检测字符串长度是否为0，为0返回 true
-n	
# 检测字符串长度是否为0，不为0返回 true
str	
# 检测字符串是否为空，不为空返回 true


# 文件测试运算符
-b file	
# 检测文件是否是块设备文件，如果是，则返回 true
-c file	
# 检测文件是否是字符设备文件，如果是，则返回 true
-d file	
# 检测文件是否是目录，如果是，则返回 true
-f file	
# 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true
-g file	
# 检测文件是否设置了 SGID 位，如果是，则返回 true
-k file	
# 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true
-p file	
# 检测文件是否是具名管道，如果是，则返回 true
-u file	
# 检测文件是否设置了 SUID 位，如果是，则返回 true
-r file	
# 检测文件是否可读，如果是，则返回 true
-w file	
# 检测文件是否可写，如果是，则返回 true
-x file	
# 检测文件是否可执行，如果是，则返回 true
-s file	
# 检测文件是否为空（文件大小是否大于0），不为空返回 true
-e file	
# 检测文件（包括目录）是否存在，如果是，则返回 true