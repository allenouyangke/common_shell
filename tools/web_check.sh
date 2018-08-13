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
RCODE=` curl -o /dev/null -s -w "%{http_code}" "${URL}"`

for URL in ${URLLIST[@]}
do
    if [ ${URL} != 200 ];then
        echo "站点${URL}无法访问，请联系相关人员进行恢复。" | mail -s "[Disaster]站点${URL}挂了！" 326757865@qq.com,445304116@qq.com
    fi
done