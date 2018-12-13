#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : download-depends.sh
# Revision     : 1.0
# Date         : 2018-12-05 12:31:14
# Author       : Linkding
# Description  : 
# How to use   : 
# -------------------------------------------------------------------------------

logfile=/tmp/download-depends.log
ret=""
function getDepends()
{
   echo "fileName is" $1>>$logfile
   # use tr to del < >
   ret=`apt-cache depends $1|grep Depends |cut -d: -f2 |tr -d "<>"`
   echo $ret|tee  -a $logfile
}
# 需要获取其所依赖包的包
libs=$1                # 或者用$1，从命令行输入库名字

# download libs dependen. deep in 3
i=0
while [ $i -lt 3 ] ;
do
    let i++
    echo $i
    # download libs
    newlist=" "
    for j in $libs
    do
        added="$(getDepends $j)"
        newlist="$newlist $added"
        apt install $added --reinstall -d -y
    done

    libs=$newlist
done

