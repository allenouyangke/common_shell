#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : nfs_install.sh
# Revision     : 1.0
# Date         : 2018/08/15
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : nfs-server和nfs-client安装部署脚本。
# -------------------------------------------------------------------------------

source /ops/com/global_vars.sh && source /ops/com/global_funcs.sh

function NFSServerInstall
{
    yum install -y nfs-utils rpcbind
    F_STATUS_MINI "Yum安装nfs和rpcbind"
    service rpcbind start
    F_STATUS_MINI "启动rpcbing"
    service nfs start
    F_STATUS_MINI "启动nfs"
}

function NFSClientInstall
{
    yum install -y showmount
    F_STATUS_MINI "Yum安装showmount"
}