#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : ProcessControl.sh
# Revision     : 1.0
# Date         : 2018/09/13
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : shell流程控制语句信息汇总
# -------------------------------------------------------------------------------

# if statement
# if ... fi command;

if [ expression ]
then
   Statement(s) to be executed if expression is true
fi


# if ... else ... fi command;

if [ expression ]
then
   Statement(s) to be executed if expression is true
else
   Statement(s) to be executed if expression is not true
fi


# if ... elif ... else ... fi command;

if [ expression 1 ]
then
   Statement(s) to be executed if expression 1 is true
elif [ expression 2 ]
then
   Statement(s) to be executed if expression 2 is true
elif [ expression 3 ]
then
   Statement(s) to be executed if expression 3 is true
else
   Statement(s) to be executed if no expression is true
fi


# case statement
# case ... esac

case value in
mode1)
    command1
    command2
    command3
    ;;
mode2）
    command1
    command2
    command3
    ;;
*)
    command1
    command2
    command3
    ;;
esac


# for statement
# shell for
for variable in list
do
    command1
    command2
    ...
    commandN
done

# C shell for
for (( ; ; ))  
do  
    command1
    command2
    ...
    commandN
done  

# while statement
# 用于不断执行一系列命令
while command
do
   Statement(s) to be executed if command is true
done


# until statement
# 循环执行一系列命令直至条件为 true 时停止
until command
do
   Statement(s) to be executed until command is true
done

# Precautions : 一般 while 循环优于 until 循环，但在某些时候—也只是极少数情况下，until 循环更加有用


# break
# 允许跳出所有循环（终止执行后面的所有循环）

# continue
# 不会跳出所有循环，仅仅跳出当前循环