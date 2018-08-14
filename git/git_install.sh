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
GITVERSION="v2.2.1.tar.gz"

function GitInstall
{
    which git
    if [ $? == 0 ];then yum remove git -y;fi
    F_STATUS_MINI "清理旧版Git"
    yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel asciidoc gcc perl-ExtUtils-MakeMaker -y
    F_STATUS_MINI "安装Git依赖包"
    wget https://github.com/git/git/archive/${GITVERSION} -P ${PACKAGES_PATH}
    F_STATUS_MINI "下载${GITVERSION}源码包"
    tar zcvf ${PACKAGES_PATH}/${GITVERSION} -C ${PACKAGES_PATH}/
    cd ${PACKAGES_PATH}/ && cd `find ./ -name git -type d`
    make configure
    F_STATUS_MINI "编译配置文件"
    ./configure --prefix=/usr/local/git --with-iconv=/usr/local/libiconv
    F_STATUS_MINI "配置Git安装参数"
    make install 
    F_STATUS_MINI "安装Git"
    echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
    F_STATUS_MINI "配置环境变量"
    source /etc/bashrc && F_COUNTDOWN 6
    F_STATUS_MINI "变量生效"
}

function GitDocInstall
{
    cd ${PACKAGES_PATH}/ && cd `find ./ -name git -type d`
    make all doc
    F_STATUS_MINI "编译all doc"
    make install install-doc install-html
    F_STATUS_MINI "安装all doc"
}

function GitTest
{
    git --version
}

function GitUsage
{
    F_PRINT_WARN "Usage: $0 install|install_doc|test"
}

case $1 in
    install) GitInstall ;;
    install_doc) GitDocInstall ;;
    test) GitTest ;;
    *) GitUsage ;;
esac