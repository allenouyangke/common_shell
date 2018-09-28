#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name:  check_Multimysql.sh
# Revision:     1.0
# Date:         2018/06/11
# Author:       AllenKe
# Email:        allenouyangke@icloud.com
# Description:  MySQL检测脚本。
# -------------------------------------------------------------------------------

# 用户名
MYSQL_USER='zabbix'

# 密码
MYSQL_PWD='zabbix'

# 主机地址/IP
MYSQL_HOST='localhost'
# MYSQL_HOST='127.0.0.1'

# 端口
MYSQL_PORT=$2

# 确定使用哪个socket文件
((num=${MYSQL_PORT}-3305))
MYSQL_SOCKET="/tmp/mysql${num}.sock"

# 数据连接
MYSQL_CONN_ADMIN="/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT} -S${MYSQL_SOCKET}"
MYSQL_CONN="/usr/local/mysql/bin/mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT} -S${MYSQL_SOCKET}"

# if [[ ${MYSQL_PORT} -eq 3306  ]];then
#     MYSQL_CONN_ADMIN="/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT} -S /tmp/mysql1.sock'"
#     MYSQL_CONN="/usr/local/mysql/bin/mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT} -S /tmp/mysql1.sock'"
# else
#     ((num=${MYSQL_PORT}-3305))
#     MYSQL_CONN_ADMIN="/usr/local/mysql/bin/mysqladmin -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT} -S /tmp/mysql${num}.sock'"
#     MYSQL_CONN="/usr/local/mysql/bin/mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT} -S /tmp/mysql${num}.sock'"
# fi

# help函数
help(){
    echo "Usage:$0 [ping|Uptime|Com_update|Slow_queries|Com_select|Com_rollback|Questions|Com_insert|Com_delete|Com_commit|Bytes_sent|Bytes_received|Com_begin] port"
}

# 参数个数是否正确
if [ $# -lt "2" ];then
    echo "参数缺失！"
    help
    exit 2
fi

# 获取数据
case $1 in
    # 判断MySQL是否存活
    ping)
        result=`${MYSQL_CONN_ADMIN} ping | grep -c alive`
        echo ${result}
        ;;
    # MySQL正常运行时间
    Uptime)
        result=`${MYSQL_CONN_ADMIN} status | cut -f2 -d"T"`
        echo ${result}
        ;;
    # 
    Com_update)
        result=`${MYSQL_CONN_ADMIN} extended-status | grep -w "Com_update" | cut -d"|" -f3`
        echo ${result}
        ;;
    # 按字面意思是慢查询的意思，不知道musql认为多久才足够算为长查询，这个先放着。
    # 已经超过long_query_time秒的查询数量
    Slow_queries)
        result=`${MYSQL_CONN_ADMIN} status | cut -f5 -d":" | cut -f1 -d"O"`
        echo ${result}
        ;;
    # 平均每秒select语句执行次数
    Com_select)
        result=`${MYSQL_CONN_ADMIN} extended-status | grep -w "Com_select" | cut -d"|" -f3`
        echo ${result}
        ;;
    
    Com_rollback)
        result=`${MYSQL_CONN_ADMIN} extended-status | grep -w "Com_rollback" | cut -d"|" -f3`
        echo ${result}
        ;;
    # 服务器启动以来客户的问题(查询)数目  （应该是只要跟mysql作交互：不管你查询表，还是查询服务器状态都问记一次）。
    Questions)
        result=`${MYSQL_CONN_ADMIN} status | cut -f4 -d":" | cut -f1 -d"S"`
        echo ${result}
        ;;
    # 平均每秒insert语句执行次数
    Com_insert)
        result=`${MYSQL_CONN_ADMIN} extended-status | grep -w "Com_insert" | cut -d"|" -f3`
        echo ${result}
        ;;
    # 平均每秒delete语句执行次数
    Com_delete)
        result=`${MYSQL_CONN_ADMIN} extended-status | grep -w "Com_delete" | cut -d"|" -f3`
        echo ${result}
        ;;
    # 
    Com_commit)
        result=`${MYSQL_CONN_ADMIN} extended-status | grep -w "Com_commit" | cut -d"|" -f3`
        echo ${result}
        ;;
    Com_sent)
        result=`${MYSQL_CONN_ADMIN} extended-status | grep -w "Com_sent" | cut -d"|" -f3`
        echo ${result}
        ;;
    Com_received)
        result=`${MYSQL_CONN_ADMIN} extended-status | grep -w "Com_received" | cut -d"|" -f3`
        echo ${result}
        ;;
    Com_begin)
        result=`${MYSQL_CONN_ADMIN} extended-status | grep -w "Com_begin" | cut -d"|" -f3`
        echo ${result}
        ;;
    # 连接数统计
    Threads_connected)
        result=`${MYSQL_CONN_ADMIN} extended-status | | grep "Threads_connected" | cut -d"|" -f3`
        echo ${result}
        ;;
    # 超时数统计
    # 响应时间统计
    # 需要启动相关的功能，会影响数据库的性能。
    *)
    help
    ;;
esac