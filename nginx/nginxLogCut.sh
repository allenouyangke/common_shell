#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : nginxLogCut.sh
# Revision     : 1.0
# Date         : 2018/10/22
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------

LOGDIR="/data/logs/nginx"
PIDFILE="cat ${LOGDIR}/nginx.pid"
DATE=`date -d "1 hours ago" +%Y%d%H`
DATE_OLD=`date -d "7 days ago" +%Y%m%d`

for i in `ls ${LOGDIR}/access.log`
do
    mv ${i} ${i}.${DATE}
done

for i in `ls ${LOGDIR}/*error.log`
do
    mv $i $i.$DATE
done

kill -s USER1 ${PIDFILE}

rm -v ${LOGDIR}"/access.log."${DATE_OLD}*
rm -v ${LOGDIR}"/error.log."${DATE_OLD}*

exit 0