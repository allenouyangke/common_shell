#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : web_check.sh
# Revision     : 1.0
# Date         : 2018/08/13
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 用于简单监测网站是否存活。
# -------------------------------------------------------------------------------

URLLIST=(
http://miaofang.qhwjgh.com/baicao/guitou/
)
EMIALLIST="445304116@qq.com,326757865@qq.com"

for URLNAME in ${URLLIST[@]}
do
    RCODE=`curl -o /dev/null -s -w "%{http_code}" "${URLNAME}"`
    if [ ${RCODE} != 200 ];then
        echo "站点"${URLNAME}"无法访问，请联系相关人员进行恢复。" | mail -s "[Disaster]站点${URL}挂了！" ${EMIALLIST}
        exit 0
    fi
    echo "站点访问正常！"
done