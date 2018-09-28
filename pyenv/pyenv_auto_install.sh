#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : pyenv_auto_install.sh
# Revision     : 1.0
# Date         : 2018/09/26
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------
# ====================================全局变量====================================
PYENV_DIR="/root/.pyenv"
PYENV_URL="https://github.com/yyuu/pyenv.git"
PYENVVIRTUALENV_URL="https://github.com/yyuu/pyenv-virtualenv.git"
PYENVVIRTUALENV_DIR="${PYENV_DIR}/plugins/pyenv-virtualenv"
PATH_FILE1="/root/.bashrc"
PATH_FILE2="/root/.bash_profile"
# ====================================全局函数====================================
PyenvInstall()
{
    yum install install -y build-essential zlib1g-dev libssl-dev libsqlite3-dev libbz2-dev libreadline-dev gcc gcc-c++
    if [ ! d "${PYENV_DIR}" ];then
        mkdir ${PYENV_DIR}
    fi
    git clone ${PYENV_URL} ${PYENV_DIR}
}
PyenvConfig()
{
    cat >> ${PATH_FILE1} <<EOF
export PATH=~/.pyenv/bin:$PATH
export PYENV_ROOT=~/.pyenv
eval "$(pyenv init -)"
EOF
    source ${PATH_FILE1}
}
PyenvUsage()
{
    cat <<EOF
pyenv常用方法说明
    python version              :           查看当前系统的python版本
    python versions             :           查看当前pyenv安装的python版本
    pyenv install 3.5.3         :           安装指定版本的python
    pyenv unstall 3.5.1         :           卸载指定版本的python
    pyenv rehash                :           立即刷新配置
    pyenv shell 2.7.13          :           指定shell的pytho版本
EOF
}
PyenvVirtualenvInstall()
{
    git clone ${PYENVVIRTUALENV_URL} ${PYENVVIRTUALENV_DIR}
}
PyenvVirtualenvConfig()
{
    echo 'eval "$(pyenv virtualenv-init -)"' >> ${PATH_FILE2}
}
PyenvVirtualenvUsage()
{
    cat <<EOF
pyenv-virtualenv常用方法说明
    pyenv virtualenv version projectname    :       创建虚拟环境并指定版本和虚拟化环境名称
    pyenv uninstall projectname             :       清除已经创建的虚拟环境
    pyenv activate projectname              :       激活指定虚拟环境
    pyenv deactivate                        :       退出当前的虚拟环境
EOF
}
# ====================================控制输出====================================
case $1 in
    install) PyenvInstall ;;
    config) PyenvConfig ;;
    virtualenv) PyenvVirtualenvInstall && PyenvVirtualenvConfig ;;
    help) "Usage: install|config|virtualenv" ;;
    *) PyenvUsage && PyenvVirtualenvUsage ;;
esac