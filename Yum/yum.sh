#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : yum.sh
# Revision     : 1.0
# Date         : 2018/08/24
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : yum常用操作（适用于CentOS 5/6/7）
# -------------------------------------------------------------------------------

source /ops/com/global_vars.sh && source /ops/com/global_funcs.sh

SYSNAME=`cat /etc/redhat-release | awk -F"[ .]" '{print $1}'`
SYSVERSION=`cat /etc/redhat-release | awk -F"[ .]" '{print $3}'`

function Usage
{
    echo $"Usage: $0 [ali|163] [5|6|7]"
}

function CheckSYS
{
    SYSLIST=(
    CentOS
    CENTOS
    centos
    centOS
    Centos
    )
    count=0
    for SYS in ${SYSLIST[@]}
    do
        if [ ${SYSNAME} == ${SYS} ];then
            let count+=1
        fi
    done

    echo ${count}
    if [[ ${count} < 1 ]];then
        echo "This system is't CentOS"
        exit 65
    fi
}

function AddEpel
{
    # 安装yum源拓展
    yum -y install epel-release
}

function BackupRepo
{
    if [ ! -f "/etc/yum.repos.d/CentOS-Base.repo" ];then 
        echo "No repo file,Please check it!"
        exit 65
    fi
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
    if [ ! -f "/etc/yum.repos.d/CentOS-Base.repo.backup" ];then
        echo "No backup the repo,Please check it! "
        exit 66
    fi
    echo "Back up successful! "
    ls -al /etc/yum.repos.d/CentOS-Base.repo.backup
}


# 切换为国内源码
# 切换到mirrors.163.com
function Switch163Repo
{
    if [ ${1} == 5 ];then
        wget http://mirrors.163.com/.help/CentOS5-Base-163.repo -P /etc/yum.repos.d/
    elif [ ${1} == 6 ];then
        wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -P /etc/yum.repos.d/
    elif [ ${1} == 7 ];then
        wget http://mirrors.163.com/.help/CentOS7-Base-163.repo -P /etc/yum.repos.d/
    else
        echo "Not the version of ${1} repos! "
    fi
}

# 切换到mirrors.aliyun.com
function SwitchaliRepo
{
    if [ ${1} == 5 ];then
        wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo -P /etc/yum.repos.d/
    elif [ ${1} == 6 ];then
        wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo -P /etc/yum.repos.d/
    elif [ ${1} == 7 ];then
        wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo -P /etc/yum.repos.d/
    else
        echo "Not the version of ${1} repos! "
    fi
}

function Processor
{
    local SOURCENAME=${1}
    local VERSIONNUM=${2}
    if [ ${SOURCENAME} == 163 ];then
        Switch163Repo ${VERSIONNUM}
    elif [ ${SOURCENAME} == "ali" ];then
        SwitchaliRepo ${VERSIONNUM}
    else
        Usage
        exit 0
    fi

    # 生成缓存
    yum makecache
    # 更新yum源
    yum -y update
}

[ $# != 2 ] && Usage &&exit 65
CheckSYS
BackupRepo
Processor ${1} ${2}

