#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : apacheInstall.sh
# Revision     : 1.0
# Date         : 2018/10/23
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------

source /ops/com/global_vars.sh && source /ops/com/global_funcs.sh

function ApacheYumInstall
{
    yum install httpd -y >/dev/null 2>&1
    F_STATUS_MINI "Yum安装"
}

function ApacheVersions
{
    APACHEVERSIONS=`curl -s http://archive.apache.org/dist/httpd/ | grep 'tar.gz<' | awk -F" |\"" '{print $13}'`
    F_PRINT_SUCCESS "获取Apache Online Versions:"
    for line in ${APACHEVERSIONS[@]}; do F_GREEN ${line}; done
}

function ApacheSourceInstall
{
    wget http://archive.apache.org/dist/httpd/httpd-2.2.25.tar.gz
    tar -xvf httpd-2.2.25.tar.gz
    cd httpd-2.2.25
}