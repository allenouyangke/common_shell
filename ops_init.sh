#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name	: 	personal_ops.sh
# Revision		: 	1.0
# Date			: 	2018/07/24
# Author		: 	AllenKe
# Email		    : 	allenouyangke@icloud.com
# Description	:	用于初始化自定义的运维环境ops。
# Usage		    :	sh personal_ops.sh <init|vars|funcs|iptables|kernal>
# -------------------------------------------------------------------------------

set -o nounset

# 加载公共变量和函数
source ${PWD}/global_vars.sh
source ${PWD}/global_funcs.sh

if [ -d "/ops" ];then
    F_RED "Please backup /ops dir."
    exit 65
fi

# 将目录结构写入到OPS_DIR_LIST数组里
OPS_DIR_LIST=(
OPS_DIR
OPS_TMP
LOG_DIR
TPL_DIR
BIN_DIR
COM_DIR
LOG_ERR
LOG_COR
TMP_IPLIST
)

for DIR in ${OPS_DIR_LIST[@]}
do
    eval mkdir \$${DIR}
    DIR_PATH=`eval echo \$${DIR}`
    if [ $? == 0 ];then
        F_PRINT_SUCCESS "目录${DIR_PATH}创建成功"
    else
        F_PRINT_ERROR "目录${DIR_PATH}创建失败"
    fi
done