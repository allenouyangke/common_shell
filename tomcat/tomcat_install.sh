#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : tomcat_install.sh
# Revision     : 1.0
# Date         : 2018/08/10
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 一键部署tomcat
# -------------------------------------------------------------------------------

source $PWD/../global_funcs.sh && source $PWD/../global_vars.sh

TOMCATNAME="tomcat7"

function TomcatInstall
{
    TOMCATVERSION="apache-tomcat-7.0.82.tar.gz"
    
    wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-7/v7.0.82/bin/${TOMCATVERSION} -P /usr/local/src/
    F_STATUS_MINI "下载Tomcat7安装包"
    tar zxvf /usr/local/src/${TOMCATVERSION} -C /usr/local/
    F_STATUS_MINI "解压Tomcat7"
    cd /usr/local/;mv ${TOMCATVERSION} ${TOMCATNAME}
    F_STATUS_MINI "Tomcat7部署完成"
}

function TomcatTest
{

}

function TomcatScript
{
    
}