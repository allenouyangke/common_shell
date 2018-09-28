#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name: authorized_v2.sh
# Revision:    2.0
# Date:        2018/06/12
# Author:      AllenKe
# Email:       allenouyangke@icloud.com
# Description: 针对多实例的MySQL进行授权。
# -------------------------------------------------------------------------------

# 用户名
MYSQL_USER='root'

# 密码
MYSQL_PWD='test@168'

# 主机地址/IP
MYSQL_HOST='localhost'
# MYSQL_HOST='127.0.0.1'

# 端口
# MYSQL_PORT=$2
MYSQL_PORT=3306

# 判断使用的socket文件
((num=${MYSQL_PORT}-3305))
MYSQL_SOCKET="/tmp/mysql${num}.sock"

# 数据连接
MYSQL_CONN="/usr/local/mysql/bin/mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT} -S${MYSQL_SOCKET}"


${MYSQL_CONN} -e"GRANT ALL PRIVILEGES ON *.* TO zabbix@'127.0.0.1' IDENTIFIED BY 'zabbix';"
${MYSQL_CONN} -e"GRANT ALL PRIVILEGES ON *.* TO zabbix@'localhost' IDENTIFIED BY 'zabbix';"