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
source ${PWD}/global_vars.sh && source ${PWD}/global_funcs.sh

function OpsInit
{
    if [ -d "/ops" ];then
        F_PRINT_WARN "/ops目录已经存在，请选择删除/备份(rm/bk)。"
        read OPTION
        case ${OPTION} in
            rm) 
                rm -rf /ops
                F_PRINT_SUCCESS "删除成功"
                ;;
            bk)
                mv /ops /tmp/ops_`date +"%Y%m%d%H%M%S"`
                F_PRINT_SUCCESS "备份成功，备份路径：/tmp/ops_`date +"%Y%m%d%H%M%S"`"
                ;;
            *)
                F_PRINT_ERROR "请重新执行初始化脚本，并输入正确的操作"
                exit 65
                ;;
        esac
    fi

    # 创建/ops目录，并构建相关的目录/文件
    OPS_DIR_LIST=(
    $OPS_DIR
    $OPS_TMP
    $LOG_DIR
    $TPL_DIR
    $BIN_DIR
    $COM_DIR
    $LOG_ERR
    $LOG_COR
    $TMP_IPLIST
    )

    for DIR in ${OPS_DIR_LIST[@]}
    do
        mkdir -p ${DIR}
        # if [ $? == 0 ];then
        #     F_PRINT_SUCCESS "目录${DIR}创建成功"
        # else
        #     F_PRINT_ERROR "目录${DIR}创建失败"
        # fi
        F_STATUS "目录${DIR}创建成功" "目录${DIR}创建失败"
    done
}

function GlobalUpdate
{
    # 将公共加载文件同步到/ops/
    \cp ${PWD}/global_vars.sh ${COM_DIR}
    F_STATUS "文件global_vars.sh同步成功" "文件global_vars.sh同步失败"
    \cp ${PWD}/global_funcs.sh ${COM_DIR}
    F_STATUS "文件global_funcs.sh同步成功" "文件global_funcs.sh同步失败"
}

function CommonList
{
    ls $PWD | grep "^[^0-9]" | grep -Ev "\.sh$|\.md$"
}

function OPSCenterUsage
{
    F_PRINT_WARN "Usage: $0 init|update|list"
}

function Main
{
    [ $# != 1 ] && OPSCenterUsage && exit 1
    case ${1} in
        init) OpsInit ;;
        update) GlobalUpdate ;;
        list) CommonList;;
        *) OPSCenterUsage ;;
    esac
}

Main ${1}