#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : BracketsUsage.sh
# Revision     : 1.0
# Date         : 2018/09/13
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : shell中常用括号含义
# -------------------------------------------------------------------------------

# 单小括号 () ------ shell命令及输出(左右不留空格)
# 命令组 : 开启一个独立的shell执行命令，括号内以分号连接，最后一个命令不需要；各个命令和括号吴空格
# 命令替换 : 得到命令输出，eg：cmd=${command} 等同于 cmd=$`command`
# 初始化数组 : array=(a b c d)

# 双小括号 (()) ------ 算数运算
# 省去$符号的算术运算 : 
# C语言规则运算 : $((exp))
# 跨进制运算 : 二进制、八进制、十六进制运算时，输出结果自动转化为十进制

# 单中括号 [] ------ 算术比较(左右留空)
# 字符串比较 : == !=
# 整数比较 : [详细看判断操作表]
# 数组索引 : array[0]

# 双中括号 [[]] ------ 字符串比较
# 字符串比较 : 可以把右边作为一个模式，而不仅仅是一个字符串 eg： [[ hello == hell? ]] 结果为True。[[]] 中匹配字符串或通配符，需要要引号
# 逻辑运算符 : 防止脚本逻辑错误， && || < >能正存在于[[]]
# 退出码 : bash把双中括号的表达式看作一个单独的元素，并返回一个退出状态码

# Example :
if ($i<5)    
if [ $i -lt 5 ]    
if [ $a -ne 1 -a $a != 2 ]    
if [ $a -ne 1] && [ $a != 2 ]    
if [[ $a != 1 && $a != 2 ]]    
     
for i in $(seq 0 4);do echo $i;done    
for i in `seq 0 4`;do echo $i;done    
for ((i=0;i<5;i++));do echo $i;done    
for i in {0..4};do echo $i;done  

# 大/花括号 {}
# 创建匿名函数 : 不会新开进程，括号内变量余下仍可使用。括号内的命令间用分号隔开，最后一个也必须有分号。{}的第一个命令和左括号之间必须要有一个空格。

# 特殊替换
${var:-string};${var:+string}
# var==NULL，则var=string;var!=NULL,则var即为${var:-string};
# ${var:=string}常用于判断var是否赋值，若无则给var一个默认值值

${var:=string}
# var!=NULL，则var被替换为string；var==NULL，则不执行替换，即空值

${var:?string}
# var!=NULL，则var即为${var:?string};var==NULL，则把string输出到标准错误中，并从脚本退出。用于检查是否设置了变量的值


# 模式匹配
# #是去掉左边(在键盘上#在$之左边)；%是去掉右边(在键盘上%在$之右边)；
# #和%中的单一符号是最小匹配，两个相同符号是最大匹配。

${var%pattern}
# 第一种模式：${variable%pattern}。shell在variable中查找，看它是否一给的模式pattern结尾，如果是，把variable去掉右边最短的匹配模式

${var%%pattern}
# 第二种模式： ${variable%%pattern}，这种模式时，shell在variable中查找，看它是否一给的模式pattern结尾，如果是，把variable中去掉右边最长的匹配模式

${var#pattern}
# 第三种模式：${variable#pattern} 这种模式时，shell在variable中查找，看它是否一给的模式pattern开始，如果是，把variable中去掉左边最短的匹配模式

${var##pattern}
# 第四种模式： ${variable##pattern} 这种模式时，shell在variable中查找，看它是否一给的模式pattern结尾，如果是，把variable中去掉左边最长的匹配模式

# Precautions :
# 四种模式中都不会改变variable的值
# 只有在pattern中使用了*匹配符号时，%和%%，#和##才有区别
# 结构中的pattern支持通配符，*表示零个或多个任意字符，?表示仅与一个任意字符匹配，[...]表示匹配中括号里面的字符，[!...]表示不匹配中括号里面的字符

# Example :
var=testcase    
echo $var    
# testcase    
echo ${var%s*e}   
# testca    
echo $var    
# testcase   
echo ${var%%s*e}   
# te  
echo ${var#?e}    
# stcase  
echo ${var##?e}    
# stcase  
echo ${var##*e}    
  
echo ${var##*s}    
# e    
echo ${var##test}    
# case


# 字符串提取和替换

${var:num}
# 第一种模式：${var:num}，shell在var中提取第num个字符到末尾的所有字符。若num为正数，从左边0处开始；若num为负数，从右边开始提取字串，但必须使用在冒号后面加空格或一个数字或整个num加上括号，如${var: -2}、${var:1-3}或${var:(-2)}

${var:num1:num2}
# 第二种模式：${var:num1:num2}，num1是位置，num2是长度。表示从$var字符串的第$num1个位置开始提取长度为$num2的子串。不能为负数

${var/pattern/pattern}
# 第三种模式：${var/pattern/pattern}表示将var字符串的第一个匹配的pattern替换为另一个pattern

${var//pattern/pattern}
# 第四种模式：${var//pattern/pattern}表示将var字符串中的所有能匹配的pattern替换为另一个pattern

# Example :
var=/home/centos  
echo $var  
# /home/centos  
echo ${var:5}  
# /centos  
echo ${var: -6}  
# centos  
echo ${var:(-6)}  
# centos  
echo ${var:1:4}  
# home  
echo ${var/o/h}  
# /hhme/centos  
echo ${var//o/h}  
# /hhme/cenths  

# Precautions : 对{}和()而言, 括号中的重定向符只影响该条命令， 而括号外的重定向符影响到括号中的所有命令。


# 符号$后的括号

${a}
# 变量a的值, 在不引起歧义的情况下可以省略大括号

$(cmd)
# 命令替换，和`cmd`效果相同，结果为shell命令cmd的输

$((expression));`exprexpression`
# 效果相同, 计算数学表达式exp的数值, 其中exp只要符合C语言的运算规则即可, 甚至三目运算符和逻辑表达式都可以计算


# 多条命令执行

(cmd1;cmd2;cmd3)
# 新开一个子shell顺序执行命令cmd1,cmd2,cmd3, 各命令之间用分号隔开, 最后一个命令后可以没有分号

{ cmd1;cmd2;cmd3;}
# 当前shell顺序执行命令cmd1,cmd2,cmd3, 各命令之间用分号隔开, 最后一个命令后必须有分号, 第一条命令和左括号之间必须用空格隔开