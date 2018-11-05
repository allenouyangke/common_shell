#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name   : 	global_funcs.sh
# Revision      : 	1.0
# Date          : 	2018/07/23
# Author        : 	AllenKe
# Email         : 	allenouyangke@icloud.com
# Description   :	定义通用的shell函数，方便未来调用。
# Usage         :   source global_funcs.sh
# -------------------------------------------------------------------------------

# 遇到不存在的变量就会报错，并停止执行。
# set -u
set -o nounset

# source ./global_vars.sh

# =============================== 配置输出函数 =====================================
# 获取IP地址的方式,
# /sbin/ifconfig -a|grep -w inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"
# /sbin/ifconfig|sed -n '/inet addr/s/^[^:]*:\([0-9.]\{7,15\}\) .*/\1/p' | grep -v 127.0.0.1
# 获取本机的内网IP
function F_PRI_IP
{
     /sbin/ifconfig -a|grep -w inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:" | grep -E "^10\.|192\.168\.|172\.1[6-9]\.|172\.2[0-9]\.|172\.3[01]\."
}

# 获取本机的公网IP
function F_PUB_IP
{
     /sbin/ifconfig -a|grep -w inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:" | grep -Ev "^10\.|192\.168\.|172\.1[6-9]\.|172\.2[0-9]\.|172\.3[01]\."
}

# 获取SN码，需要先检测dmidecode命令是否安装
function F_SN
{
    which dmidecode
    if [ $? != 0 ];then yum install dmidecode -y;fi
    dmidecode -t 1 | grep 'Serial Number' | awk -F':' '{print $NF}' | xargs
}

# 输出分割线（Separation line）
function F_SEP
{
    printf -v str "%${1:-100}s" ""
    echo "${str// /${2:-=}}"
}

# =============================== 时间输出函数 =====================================
# 定义当天详细时间输出，显示：2018-07-23 11:12:24
function F_SDATE
{
    date +"%Y-%m-%d %H:%M:%S"
}

# 定义当天详细时间输出，显示：20180723111224
function F_DATE
{
    date +"%Y%m%d%H%M%S"
}

# 定义当天日期输出，显示：20180723
function F_TODATE1
{
    date +"%Y%m%d"
}

# 定义当天日期输出，显示：2018-07-23
function F_TODATE2
{
    date +"%Y-%m-%d"
}

# 倒计时器，
function F_COUNTDOWN
{
    SECONDS_LEFT=${1}
    while [ "${SECONDS_LEFT}" -gt 0 ];do
      echo -ne "[ \033[32m 倒计时器 \033[0m ] \033[32m 请等待${SECONDS_LEFT}秒 \033[0m"
      sleep 1
      SECONDS_LEFT=$((${SECONDS_LEFT} - 1))
      echo -ne "\r     \r" #清除本行文字
    done
}

# =============================== 判断输出函数 =====================================
# 输出正确执行信息，显示：[ True ] 20180723111224 需要输出的信息
function F_PRINT_SUCCESS
{
    echo -e "[\033[1;32m True  \033[0m] $(F_SDATE) ${1}"
}

# 输出正确执行信息，显示：[ False ] 20180723111224 需要输出的信息
function F_PRINT_ERROR
{
    echo -e "[\033[1;31m False \033[0m] $(F_SDATE) ${1}"
}

# 输出警告信息，显示：[ Warn  ] 20180723111224 需要输出的信息
function F_PRINT_WARN
{
    echo -e "[\033[1;31m Warn  \033[0m] $(F_SDATE) ${1}"
}

# 输出并重定向正确的日志，显示：[ True ] 20180723111224 需要输出的信息
function F_LOG_SUCCESS
{
    F_PRINT_SUCCESS "${1}"
    F_PRINT_SUCCESS "${1}" >> ${2}
}

# 输出并重定向错误的日志，显示：[ False ] 20180723111224 需要输出的信息
function F_LOG_ERROR
{
    F_PRINT_ERROR "${1}"
    F_PRINT_ERROR "${1}" >> ${2}
}

# 输出重定向正确日志，无显示
function F_MUTE_SUCCESS
{
    F_PRINT_SUCCESS "${1}" >> ${2}
}

# 输出重定向错误日志，无显示
function F_MUTE_ERROR
{
    F_PRINT_ERROR "${1}" >> ${2}
}

# 判断命令/脚本是否执行成功，并重定向输出到日志文件
function F_LOG_OUTPUT
{
    if [ 0 == $? ]; then
        F_LOG_SUCCESS "${1}" "${2}"
    else
        F_LOG_ERROR "${1}" "${2}"
    fi
}

# 判断命令/脚本是否执行成功，格式：F_STATUS "True的提示" "False的提示"
function F_STATUS
{
    if [ $? == 0 ];then
        F_PRINT_SUCCESS ${1}
    else
        F_PRINT_ERROR ${2}
    fi
}
# 判断命令/脚本是否执行成功，格式：F_STATUS "中性提示信息"
function F_STATUS_MINI
{
    if [ $? == 0 ];then
        F_PRINT_SUCCESS ${1}
    else
        F_PRINT_ERROR ${1}
    fi
}
# # 判断命令/脚本是否执行成功，如发生错误，则会退出执行，格式：F_STATUS "中性提示信息"
function F_STATUS_EXIT
{
    if [ $? == 0 ];then
        F_PRINT_SUCCESS ${1}
    else
        F_PRINT_ERROR ${1}
        exit 1
    fi
}

# 判断文件是否存在，
function F_FILE
{
    if [ -e "${1}" ];then F_PRINT_WARN "File : ${1} is exist!"; else F_PRINT_WARN "File : ${1} is not exist!";touch ${1};F_STATUS_MINI "创建文件${1}";fi
}

# 判断目录是否存在，如果不存在则创建
function F_DIR
{
    if [ -d "${1}" ];then F_PRINT_WARN "Dir : ${1} is exist!"; else F_PRINT_WARN "Dir : ${1} is not exist!";mkdir -p ${1};F_STATUS_MINI "创建目录${1}";fi
}

# =============================== 颜色输出函数 =====================================
# 输出红色字体
function F_RED
{
    echo -e "\033[31m ${1} \033[0m"
}

# 输出黑色字体
function F_BLACK
{
    echo -e "\033[30m ${1} \033[0m"
}

# 输出绿色字体
function F_GREEN
{
    echo -e "\033[32m ${1} \033[0m"
}

# 输出黄色字体
function F_YELLOW
{
    echo -e "\033[33m ${1} \033[0m"
}

# 输出蓝色字体
function F_BLUE
{
    echo -e "\033[34m ${1} \033[0m"
}

# 输出紫色字体
function F_PURPLE
{
    echo -e "\033[35m ${1} \033[0m"
}

# 输出黑底白字
function F_BBLACK
{
    echo -e "\033[40;37m ${1} \033[0m"
}

# 输出红底黑字
function F_BRED
{
    echo -e "\033[41;30m ${1} \033[0m"
}

# 输出绿底蓝字
function F_BGREEN
{
    echo -e "\033[42;34m ${1} \033[0m"
}

# 输出黄底蓝字
function F_BYELLOW
{
    echo -e "\033[43;34m ${1} \033[0m"
}

# 输出蓝底黑字
function F_BBLUE
{
    echo -e "\033[44;30m ${1} \033[0m"
}

# 输出紫底黑字
function F_BPURPLE
{
    echo -e "\033[45;30m ${1} \033[0m"
}

# 输出白底蓝字
function F_BWHITE
{
    echo -e "\033[47;34m ${1} \033[0m"
}

# =============================== 公共服务函数 =====================================

# 从远端拉数据到本地
function F_SCP_PULL
{
    local SSH_PORT=${1}
    local REMOTE_IP=${2}
    local SRC_PATH=${3}
    local DEST_PATH=${4}
    scp -r -P${SSH_PORT} root@${REMOTE_IP}:${SRC_PATH} ${DEST_PATH}
}

# 从本地推文件到远端
function F_SCP_PUSH
{
    local SSH_PORT=${1}
    local REMOTE_IP=${2}
    local SRC_PATH=${3}
    local DEST_PATH=${4}
    scp -r -P${SSH_PORT} ${SRC_PATH} root@${REMOTE_IP}:${DEST_PATH} 
}

# 关闭selinux
function F_CLOSE_SELINUX
{
    sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
    F_STATUS_MINI "selinux已关闭，重启系统后生效!"
    read -p "是否马上重启系统（Yy/Nn）：" option
    if [ ${option} == "Y" ] || [ ${option} == "y" ];then 
        F_COUNTDOWN 6
        shutdown -r now
    else 
        F_PRINT_SUCCESS "稍后请重启系统，以生效selinux配置"
        exit 0
    fi
}

# =============================== 远程操作函数 =====================================
# ssh远程连接
function F_SSH
{
    # 需要先建立服务器间的信任关系
    # F_SSH ip_address command
    ssh -o stricthostkeychecking=no -o GSSAPIAuthentication=no -p ${SSHPORT} ${1} "${2}"
}

# =============================== 数据库操作函数 =====================================
# 连接本地MySQL数据库
function F_MYSQL_LOCAL
{
    ${MYSQLCOMMAND} -u${MYSQLUSER} -p${MYSQLPASS} -P${MYSQLPORT} -h${MYSQLHOST:-"127.0.0.1"} -e"${1}"
}

# 连接远端MySQL数据库
function F_MYSQL_REMOTE
{
    ${MYSQLCOMMAND} -u${MYSQLUSER} -p${MYSQLPASS} -P${MYSQLPORT} -h"${1}" -e"${2}"
}