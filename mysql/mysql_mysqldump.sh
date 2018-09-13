#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : 
# Revision     : 1.0
# Date         :
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 备份[整库|分表]/压缩备份/分类存储压缩文件/定时清理/备份检查/备份恢复
# -------------------------------------------------------------------------------

# 数据库备份存储目录
BACK_DIR="/data/backup"

# 限制最大备份进程数
# MAXIMUM_BACKUP_FILES=10

# 数据库地址
DB_HOSTNAME="localhost"
# DB_HOSTNAME="127.0.0.1"

# 数据库账|密
DB_USERNAME="root"
DB_PASSWORD="mysql@168"

# 数据库命令
MYSQL_PATH="/usr/local/mysql/bin/mysql"
MYSQLDUMP_PATH="/usr/local/mysql/bin/mysqldump"

# 需要备份的数据库列表
DATABASESLIST=(
yqdqas
)

function MysqlDumpDB
{
    for DANAME in ${DATABASESLIST[@]}
    do
        mkdir -p ${BACK_DIR}/$(date +%F);cd ${BACK_DIR}/$(date +%F)
        mkdir -p ./${DANAME}

        # 整库备份
        # ${MYSQL_PATH} -h${DB_HOSTNAME} -u${DB_USERNAME} -p${DB_PASSWORD} ${DBNAME} > ./${DANAME}/${DBNAME}.sql && tar zcvf ${DBNAME}_${DB_HOSTNAME}_$(date +"%Y%m%d").tgz ./${DANAME}/${DBNAME}.sql && rm -rf ./${DBNAME}

        # 分表备份
        TABLELIST=(`${MYSQL_PATH} -h${DB_HOSTNAME} -u${DB_USERNAME} -p${DB_PASSWORD} ${DBNAME} -e"show databases;"`)
        for TABLENAME in ${TABLELIST[@]}
        do
            ${MYSQL_PATH} -h${DB_HOSTNAME} -u${DB_USERNAME} -p${DB_PASSWORD} ${DBNAME} ${TABLENAME} > ./${DBNAME}/${TABLENAME}.sql
        done
        tar zcvf ${DBNAME}_${DB_HOSTNAME}_$(date +"%Y%m%d").tgz ./${DBNAME}/* && 
    done
}
