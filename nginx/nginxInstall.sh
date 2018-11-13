#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : nginx_install.sh
# Revision     : 1.0
# Date         : 2018/08/09
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : nginx简单部署，一键式部署脚本。
# -------------------------------------------------------------------------------

source /ops/com/global_vars.sh && source /ops/com/global_funcs.sh

DOWNLOADPATH="/usr/local/src/"
INSTALLPATH="/usr/local/nginx"

function NginxYumInstall
{
    yum install nginx -y
}

function NginxVersions
{
    NGINXVERSIONS=`curl -s "http://nginx.org/en/download.html" | sed 's/ /\n/g' | grep -E "tar\.gz" | grep -v "asc" | awk -F'>' '{print $2}' | tr -d '</a'`
    F_PRINT_SUCCESS "获取Nginx Online Versions:"
    for line in ${NGINXVERSIONS[@]}; do F_GREEN ${line}; done
}

function NginxSourceInstall
{
    NginxVersions
    read -p "请选择需要安装的Nginx版本 : " NGINXVER
    wget -c http://nginx.org/download/${NGINXVER}.tar.gz -P ${DOWNLOADPATH}
    F_STATUS "下载${NGINXVER}成功" "下载${NGINXVER}失败"
    cd ${DOWNLOADPATH};tar zxvf ${NGINXVER}.tar.gz
    F_STATUS "解压${NGINXVER}成功" "解压${NGINXVER}失败"
    yum -y install pcre-devel openssl openssl-devel
    F_STATUS_MINI "安装依赖包"
    cd ${NGINXVER};sed -i -e 's/1.6.2//g' -e 's/nginx\//WS/g' -e 's/"NGINX"/"WS"/g' src/core/nginx.h
    F_STATUS "屏蔽${NGINXVER}版本号成功" "屏蔽${NGINXVER}版本号失败"
    useradd www
    F_STATUS_MINI "添加用户www"
    ./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
    F_STATUS_MINI "配置、添加相关nginx模块"
    make
    F_STATUS_MINI "编译"
    make install
    F_STATUS_MINI "安装"
}

function NginxTest
{
    F_PRINT_SUCCESS "测试配置文件"
    /usr/local/nginx/sbin/nginx -t
    if [ $? == 0 ];then
        F_PRINT_SUCCESS "测试配置文件成功，正在启动Nginx"
        /usr/local/nginx/sbin/nginx && sleep 6
        if [ $? == 0 ];then
            F_PRINT_SUCCESS "Nginx启动成功"
            sleep 1
            F_PRINT_SUCCESS "相关进程及端口："
            sleep 1
            ps -ef | grep nginx
            echo 
            ss -tnl | grep 80
        else
            F_PRINT_ERROR "Nginx启动失败"
            exit 0
        fi
    else
        F_PRINT_ERROR "测试配置文件失败，请检查"
        exit 1
    fi
}

function Usage
{
    F_PRINT_WARN "Usage : Please select the operation (versions|install|test)"
}

case $1 in
    versions) NginxVersions ;;
    install) NginxSourceInstall ;;
    test) NginxTest;;
    *) Usage ;;
esac