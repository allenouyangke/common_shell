#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : check_ipinfo.sh
# Revision     : 1.0
# Date         : 2018/08/29
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 查询IP归属地。
# -------------------------------------------------------------------------------

# 多个IP查询
# 限制最大查询值为60
function BatchCheck
{
    THREADNUM=10
    FIFOFILE="/tmp/$$.fifo"
    mkfifo ${FIFOFILE}
    exec 6<>${FIFOFILE}
    rm ${FIFOFILE}

    for ((i=0;i<${THREADNUM};i++));do echo;done >&6

    while read IPADDRESS
    do
    {
        read -u6
        {
            curl -s https://ip.cn/index.php?ip=${IPADDRESS}
            echo >&6
        } &
    }
    done < ${1}
    wait
    exec 6>&-
}

# 单线程查询
function SingleCheck
{
    while read IPADDRESS
    do
    {
        read -u6
        {
            curl -s https://ip.cn/index.php?ip=${IPADDRESS}
        }
    }
    done < ${1}
}

# 单个IP查询
function SingleCheck
{
    curl -s https://ip.cn/index.php?ip=${1}
}