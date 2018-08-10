#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : allcenter.sh
# Revision     : 1.0
# Date         : 2018/08/10
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 用于控制部署相关软件和服务。
# -------------------------------------------------------------------------------

source $PWD/global_funcs.sh && source $PWD/global_vars.sh

function SerList
{
    F_PRINT_SUCCESS "---------- 服务安装列表 ----------"
    SERLIST=`find . -name *_install.sh -type f | awk -F'/' '{print $NF}'`
    for SERNAME in ${SERLIST[@]}; do echo ${SERNAME}; done
}

function Menu
{
while :
do
    clear
    cat << EOF
---------- 操作菜单 ----------

        1 初始化OPS目录
        2 显示可部署服务
        3 进入部署模式
        0 退出操作菜单

------------------------------

EOF
read -p "请输入你的选择：" OPTION
case ${OPTION} in
    1) cd /opstest/common_shell/;sh ops_init.sh ;;
    2) SerList ;;
    3) exit 0 ;;
    *) echo "请选择正确的选项" ;;
esac
read -p "输入任意键清空"
done
}




