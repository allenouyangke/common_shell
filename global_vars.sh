#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name   : 	global_vars.sh
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

export OPS_DIR="/ops"                                              # 定义运维管理目录
export OPS_TMP="${OPS_DIR}/tmp"                                    # 定义临时文件目录
export LOG_DIR="${OPS_DIR}/log"                                    # 定义日志存放目录
export TPL_DIR="${OPS_DIR}/tpl"                                    # 定义模板存放目录
export BIN_DIR="${OPS_DIR}/bin"                                    # 定义模板存放目录
export COM_DIR="${OPS_DIR}/com"                                    # 定义通用文件存放目录
export LOG_ERR="${LOG_DIR}/err.log"                                # 定义错误日志文件
export LOG_COR="${LOG_DIR}/cor.log"                                # 定义正确日志文件
export TMP_IPLIST="${OPS_TMP}/ip_list"                             # 定义服务器IP存放目录
export PACKAGES_PATH="/usr/local/src"                              # 定义软件包下载存放路径
export INSTALL_PATH="/usr/local"                                   # 定义软件安装路径


export SSHPORT=22                                                  # 定义SSH默认端口
