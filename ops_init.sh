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

OPS_DIR="/ops"
COM_DIR="${OPS_DIR}/common"
if [ d != "${COM_DIR}" ];then
    mkdir -p ${COM_DIR}
fi

cd ${COM_DIR};git clone https://github.com/allenouyangke/common_shell.git

# 加载公共变量和函数
source ${COM_DIR}/global_vars.sh
source ${COM_DIR}/global_funcs.sh

# 将目录结构写入到OPS_DIR_LIST数组里
OPS_DIR_LIST=(
OPS_DIR
OPS_TMP
LOG_DIR
TPL_DIR
BIN_DIR
LOG_ERR
LOG_COR
TMP_IPLIST
)

for DIR in ${OPS_DIR_LIST[@]}
do
    eval mkdir \$${DIR}
done
