#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name: authorized.sh
# Revision:    1.0
# Date:        2018/06/11
# Author:      AllenKe
# Email:       allenouyangke@icloud.com
# Description: 添加zabbix用户和密码，并授权登录。
#              针对单个MySQL。
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

# 数据连接
MYSQL_CONN="/usr/local/mysql/bin/mysql -u${MYSQL_USER} -p${MYSQL_PWD} -h${MYSQL_HOST} -P${MYSQL_PORT}"


${MYSQL_CONN} -e"GRANT ALL PRIVILEGES ON *.* TO zabbix@'127.0.0.1' IDENTIFIED BY 'zabbix';"
${MYSQL_CONN} -e"GRANT ALL PRIVILEGES ON *.* TO zabbix@'localhost' IDENTIFIED BY 'zabbix';"

# echo "GRANT ALL PRIVILEGES ON *.* TO zabbix@'localhost' IDENTIFIED BY 'zabbix';" | ${MYSQL_CONN}
# echo "GRANT ALL PRIVILEGES ON *.* TO zabbix@'127.0.0.1' IDENTIFIED BY 'zabbix';" | ${MYSQL_CONN}

exit 0