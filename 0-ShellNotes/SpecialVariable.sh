#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : SpecialVariable.sh
# Revision     : 1.0
# Date         : 2018/09/13
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : shell的特殊变量
# -------------------------------------------------------------------------------

$0	
# 当前脚本的文件名
$n	
# 传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是$1，第二个参数是$2。
$#	
# 传递给脚本或函数的参数个数。
$*	
# 传递给脚本或函数的所有参数。
$@	
# 传递给脚本或函数的所有参数。被双引号(" ")包含时，与 $* 稍有不同
$?	
# 上个命令的退出状态，或函数的返回值。
$$	
# 当前Shell进程ID。对于 Shell 脚本，就是这些脚本所在的进程ID。

# Example :
echo "File Name: $0"
echo "First Parameter : $1"
echo "First Parameter : $2"
echo "Quoted Values: $@"
echo "Quoted Values: $*"
echo "Total Number of Parameters : $#"



# Different from $* and $@
# Precautions One : 都表示传递给函数或脚本的所有参数，不被双引号(" ")包含时，都以"$1" "$2" … "$n" 的形式输出所有参数
# Precautions Two : 被双引号(" ")包含时，"$*" 会将所有的参数作为一个整体，以"$1 $2 … $n"的形式输出所有参数；"$@" 会将各个参数分开，以"$1" "$2" … "$n" 的形式输出所有参数


# Exit status $?
# Precautions One : 获取上一个命令/函数的退出状态。所谓退出状态，就是上一个命令执行后的返回结果
# Precautions Two : 退出状态是一个数字，一般情况下，大部分命令执行成功会返回 0，失败返回 1
