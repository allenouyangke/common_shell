#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name   : svnInstall.sh
# Revision      : 1.0
# Date          : 2018/11/09
# Author        : AllenKe
# Email         : allenouyangke@icloud.com
# Description   : svn自动部署脚本(http://blog.51cto.com/liqingbiao/1831236)
# -------------------------------------------------------------------------------

source /ops/com/global_vars.sh && source /ops/com/global_funcs.sh

source $PWD/../java/jsk_8_install.sh

JDK8Install

SVNDATADIR="/data/svn"

# 源码安装存在太多依赖关系，这里为了快速部署建议使用yum作为默认部署形式
function SvnYumInstall
{
    yum install subversion -y
    F_STATUS_MINI "Yum安装subversion"
}

function SvnConfig
{
    F_DIR ${SVNDATADIR}
    svnadmin create ${SVNDATADIR}
    F_STATUS_MINI "创建第一个svn仓库"
}

function SvnTest
{

}

function SvnUsage
{

}

function SvnMain
{

}

if [ $# != 1 ];then
    F_PRINT_WARN SvnUsage
    exit 65
fi
SvnMain ${1}