#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  :
# Revision     : 1.0
# Date         :
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------

source /ops/com/global_vars.sh && source /ops/com/global_funcs.sh

MYSQLCOMMAND=
MYSQLUSER
MYSQLPASS
MYSQLPORT


# 操作界面
function PassList
{

}

# 数据库操作

F_MYSQL_LOCAL


function F_MYSQL_LOCAL
{
    ${MYSQLCOMMAND} -u${MYSQLUSER} -p${MYSQLPASS} -P${MYSQLPORT} -h${MYSQLHOST:-"127.0.0.1"} -e"${1}"
}