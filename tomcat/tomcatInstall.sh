#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : tomcat_install.sh
# Revision     : 1.0
# Date         : 2018/08/10
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 一键部署tomcat
# -------------------------------------------------------------------------------

source /ops/com/global_vars.sh && source /ops/com/global_funcs.sh

TOMCATDIR="/usr/local"
TOMCATNAME="tomcat7"
# CentOS6
IPADDRESS=`/sbin/ifconfig -a|grep -w inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`

function CheckJDK
{
    java -version > /dev/null 2>&1
    if [ $? != 0 ];then
        F_PRINT_ERROR "java: command not found,Please check!"
        exit 65
    fi
}

function TomcatInstall
{
    TOMCATVERSION="apache-tomcat-7.0.91.tar.gz"
    wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-7/v7.0.91/bin/${TOMCATVERSION} -P ${TOMCATDIR}/src/
    F_STATUS_MINI "下载Tomcat7安装包"
    tar zxvf ${TOMCATDIR}/src/${TOMCATVERSION} -C ${TOMCATDIR}/
    F_STATUS_MINI "解压Tomcat7"
    cd ${TOMCATDIR}/;mv ${TOMCATVERSION} ${TOMCATNAME}
    F_STATUS_MINI "Tomcat7部署完成"
}

function TomcatTest
{
    curl -o /dev/null -s -w "%{http_code}" "http://127.0.0.1:8080"
    F_STATUS_MINI "127.0.0.1访问测试"
    curl -o /dev/null -s -w "%{http_code}" "http://localhost:8080"
    F_STATUS_MINI "localhost访问测试"
    curl -o /dev/null -s -w "%{http_code}" "http://${IPADDRESS}:8080"
    F_STATUS_MINI "${IPADDRESS}访问测试"
}

# 统计
function TomcatClean
{
    TOMCATLIST=`find ${TOMCATDIR}/ -name *tomcat* -type d`
    for TOMCATNAME in ${TOMCATLIST[@]}
    do
        echo "${TOMCATNAME}"
    done
    F_GREEN "请输入需要清理的tomcat目录:"
    read TOMCATRM
    F_RED "请再次确定是否清理 ${TOMCATRM} [Yy|Nn]:"
    read OPTION
    if [ ${OPTION} == "Y" ] || [ ${OPTION} == "y" ];then
        rm -rf ${TOMCATRM}
    else
        exit 65
    fi
}

function TomcatUsage
{
    F_PRINT_WARN "Usage : Please select the operation (1 2 3 4 5 6):"
}

function Main
{
    cat < EOF
    1 Check JDK
    2 Tomcat Install
    3 Tomcat Test
    4 Tomcat Clean
    5 Help
    6 Quit
EOF

F_GREEN "Please enter your option:"
read OPTION

case ${OPTION} in
    1) CheckJDK;;
    2) TomcatInstall;;
    3) TomcatTest;;
    4) TomcatClean;;
    5) TomcatUsage
    6) exit 0;;
    *) TomcatUsage;;
esac
}

Main