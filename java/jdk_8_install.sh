#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : jdk_8_install.sh
# Revision     : 1.0
# Date         : 2018/08/09
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 一键安装JDK8
# -------------------------------------------------------------------------------

source /ops/com/global_vars.sh && source /ops/com/global_funcs.sh

function JDK8SPath
{
    echo 'JAVA_HOME=/usr/local/jdk1.8.0_161' >> /etc/profile
    echo 'JRE_HOME=/usr/local/jdk1.8.0_161/jre' >> /etc/profile
    echo 'PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin' >> /etc/profile
    echo 'CLASSPATH=:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib' >> /etc/profile
    echo 'export JAVA_HOME JRE_HOME PATH CLASSPATH' >> /etc/profile

    F_STATUS_MINI "导入JAVA_HOME、JRE_HOME、PATH、CLASSPATH环境变量"
    source /etc/profile
    F_STATUS_MINI "重新加载/etc/profile"
}

function JDK8Install
{
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u141-b15/336fa29ff2bb4ef291e347e091f7f4a7/jdk-8u141-linux-x64.tar.gz" -P /usr/local/src/
    F_STATUS_MINI "下载JSK8源码包"
    cd /usr/local/src/;tar zxvf jdk-8u141-linux-x64.tar.gz -C /usr/local/
    F_STATUS_MINI "解压JSK8源码包"
    JDK8SPath
}

function JSK8Test
{
    java -version
    F_STATUS "JAVA测试成功" "JAVA测试失败，请检查相关配置和变量"
}

function Usage
{
    F_RED "Usage : Please select the operation (install|test)"
}

case $1 in
    install) JDK8Install ;;
    test) JDK8Test;;
    *) Usage ;;
esac
