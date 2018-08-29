#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : rsync_single_web.sh
# Revision     : 1.0
# Date         : 2018/08/29
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : rsync实现单一文件分发功能。
# -------------------------------------------------------------------------------

WEBLISTS=(
web1
web2
web3
web4
)
 
for HOSTNAME  in  ${WEBLISTS[@]}
do
    rsync  -avz  ${1}  $host:${1}
done
ret=$?
if [ ${ret} -eq 0 ]
    then
    echo   "${1} 分发完毕。"
else
    echo   "${1} 分发失败，请检查！"
    exit 1
fi

exit 0