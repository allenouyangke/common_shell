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
    which pyenv
    F_STATUS "安装pyenv成功" "安装pyenv失败"
}

function PyenvInstallGit
{
    F_PRINT_SUCCESS "开始git安装pyenv"
    # 手动安装
    git clone git://github.com/yyuu/pyenv.git ~/.pyenv

    # 配置环境变量
    cat >> ~/.bashrc << EOF
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
EOF
    source ~/.bashrc
    F_STATUS "配置环境变量成功" "配置环境变量失败"

    which pyenv
    F_STATUS "安装pyenv成功" "安装pyenv失败"
}