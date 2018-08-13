#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : git_install.sh
# Revision     : 1.0
# Date         : 2018/08/10
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 安装新版git命令/升级git到新版本
# -------------------------------------------------------------------------------

source /ops/com/global_funcs.sh && source /ops/com/global_vars.sh

function GitInstall
{
    which git
    if [ $? == 0 ];then yum remove git -y;fi
    F_PRINT_SUCCESS "清理旧版Git"
    
}