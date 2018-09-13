#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : random_ip.sh
# Revision     : 1.0
# Date         : 2018/08/29
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 通过并发的方式生成随机的测试IP。
# -------------------------------------------------------------------------------

# 允许的进程数
THREAD_NUM=10
FIFOFILE="/tmp/$$.fifo"
# 定义管道文件
mkfifo ${FIFOFILE}
exec 6<>$FIFOFILE
rm  ${FIFOFILE}

# 根据线程总数量设置令牌个数
for ((i=0;i<${THREAD_NUM};i++));do echo;done >&6

function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

for NUM in `seq 1 100`
do
{
    # 进程控制
    read -u6
    {
        rnd1=$(rand 1 255)
        rnd2=$(rand 0 255)
        rnd3=$(rand 0 255)
        rnd4=$(rand 0 255)
        # 测试并发控制是否生效
        # echo "`date +%H:%M:%S` ${rnd1}.${rnd2}.${rnd3}.${rnd4}" >> ip.list
        echo "${rnd1}.${rnd2}.${rnd3}.${rnd4}" >> ip.list
        echo >&6
    } &
}
done
wait

# 关闭fd6
exec 6>&-

exit 0