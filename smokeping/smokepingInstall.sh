#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : smokepingInstall.sh
# Revision     : 1.0
# Date         : 2018/10/11
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 
# -------------------------------------------------------------------------------

SMOKEPINGDIR="/opt/smokeping"

function Status
{
    if [ $? != 0 ];then
        echo "This step failed to execute,Please check!"
        exit 1
    fi
}

function SmokepingDevelInstall
{
    # 绘图工具
    yum -y install rrdtool perl-rrdtool
    # smokeping相关扩展
    yum -y install perl-core openssl-devel fping curl gcc-c++
}

function SmokepingInstall
{
    local SAVEPATH="/usr/local/src/"
    local PACKAGEURL=" https://oss.oetiker.ch/smokeping/pub/"
    local PACKAGENAME="smokeping-2.6.11.tar.gz"
    local PACKAGEDIR=`echo ${PACKAGENAME} | cut -d . -f 1-3`
    wget ${PACKAGEURL}${PACKAGENAME} -P ${SAVEPATH}/
    # if [ !　-e　${SAVEPATH}/${PACKAGENAME} ];then
    #     echo "Download failed,Please check!"
    #     exit 1
    # fi
    cd ${SAVEPATH} && tar zxvf ${PACKAGENAME} && cd ${PACKAGEDIR}
    ./configure --prefix=${SMOKEPINGDIR} && Status
    make install && Status
}

function SmokepingConfig
{
    if [ ! -d ${SMOKEPINGDIR}/htdocs ];then
        echo "Dir htdocs is not exist,Please check!"
        exit 1
    fi
    cd ${SMOKEPINGDIR}/htdocs && mkdir cache data var
    mv smokeping.fcgi.dist smkeping.fcgi
    chmod 600 ${SMOKEPINGDIR}/etc/smokeping_secrets.dist
    # 配置文件
    cd ${SMOKEPINGDIR}/etc && cp config.dist config
    sed -i "s#datadir  = /opt/smokeping/data#datadir  = /opt/smokeping/htdocs/data#g" config
    sed -i "s#imgcache = /opt/smokeping/cache#imgcache = /opt/smokeping/htdocs/cache#g" config
    sed -i "s#piddir  = /opt/smokeping/var#piddir  = /opt/smokeping/htdocs/var#g" config
}

function Main
{
    SmokepingDevelInstall
    SmokepingInstall
    SmokepingConfig
}

Main
