#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : ServerInfo.sh
# Revision     : 1.0
# Date         : 2018/09/14
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 服务器基本信息统计
# -------------------------------------------------------------------------------

TBNAME="serverinfo"

function SQLITESQL
{
    local SQLITE="/usr/bin/sqlite3"
    local SQLITEDB="/tmp/serverinfo"
    ${SQLITE} ${SQLITEDB} ${1}
}

which dmidecode > /dev/null 2>&1
[ $? != 0 ] && echo "demidecode is not found" && exit 1

echo "${TBNAME}"
SQLITESQL "CREATE TABLEB ${TBNAME}(item primary key not null, msg char(50));"

if [[ -f /usr/bin/lsb_release ]]; then 
    OS=$(/usr/bin/lsb_release -a |grep Description |awk -F : '{print $2}' |sed 's/^[ \t]*//g')
else 
    OS=$(cat /etc/issue |sed -n '1p') 
fi 
SQLITESQL "INSERT INTO ${TBNAME} (item,msg) values ('system',"${OS}");"

SQLITESQL "select * from ${TBNAME};"