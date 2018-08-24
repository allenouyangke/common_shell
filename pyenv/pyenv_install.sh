#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : pyenv_install.sh
# Revision     : 1.0
# Date         : 2018/07/31
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 基于CentOS6的pyenv安装和配置。
# -------------------------------------------------------------------------------

source /ops/com/global_funcs.sh && source /ops/com/global_vars.sh

function PyenvInsatllOnline
{
    F_PRINT_SUCCESS "开始在线安装pyenv"
    curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
    which pyenv > /dev/null 2>&1
    F_STATUS "安装pyenv成功" "安装pyenv失败"
}

function PyenvInstallGit
{
    yum install readline readline-devel readline-static -y
    yum install openssl openssl-devel openssl-static -y
    yum install sqlite-devel -y
    yum install bzip2-devel bzip2-libs -y
    F_PRINT_SUCCESS "开始git安装pyenv"
    # 手动安装
    git clone git://github.com/yyuu/pyenv.git ~/.pyenv

    # 配置环境变量
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    # source ~/.bashrc
    F_STATUS "配置环境变量成功" "配置环境变量失败"

    which pyenv > /dev/null 2>&1
    F_STATUS "安装pyenv成功" "安装pyenv失败"
}

function PyenvClean
{
    rm -rf ~/.pyenv/
    F_STATUS_MINI "清理Pyenv数据"
    sed -i "/PYENV/d;/pyenv/d" ~/.bashrc
    F_STATUS_MINI "清理Pyenv环境变量配置"

}