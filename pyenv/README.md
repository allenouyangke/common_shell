[TOC]



# 1 建议安装路径 

```shell
$HOME/.pyenv 

# 本身默认安装到~/.pyenv

```

# 2 自动安装 

```shell
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash 

```

# 3 手动安装 

```shell
cd ~ 
git clone git://github.com/yyuu/pyenv.git .pyenv 

```

# 4 配置环境变量 

```shell
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc 
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc 
echo 'eval "$(pyenv init -)"' >> ~/.bashrc 
source ~/.bashrc

```

# 5 使用方法

## 5.1 pyenv常用方法说明
  

- python version : 查看当前系统的python版本

- pyenv versions : 查看当前pyenv安装的python版本    

- pyenv install -l :查看可供安装的各个版本      

- pyenv install 3.5.3 : 安装指定版本的python

- pyenv unstall 3.5.1 : 卸载指定版本的python

- pyenv rehash : 立即刷新配置

- pyenv shell 2.7.13 : 指定shell的pytho版本





## 5.2 pyenv-virtualenv常用方法说明

- pyenv virtualenv version projectname : 创建虚拟环境并指定版本和虚拟化环境名称
- pyenv uninstall projectname : 清除已经创建的虚拟环境
- pyenv activate projectname : 激活指定虚拟环境
- pyenv deactivate : 退出当前的虚拟环境



# 6 一键安装脚本



```shell

#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name:     pyenv_install.sh
# Revision:     1.0
# Date:         2018/07/17
# Author:         AllenKe
# Email:         allenouyangke@icloud.com
# Description:    一键安装、配置pyenv。
#                        基于于CentOS 6
# -------------------------------------------------------------------------------
# ====================================全局变量=====================================
PYENV_DIR="/root/.pyenv"
PYENV_URL="https://github.com/yyuu/pyenv.git"
PYENVVIRTUALENV_URL="https://github.com/yyuu/pyenv-virtualenv.git"
PYENVVIRTUALENV_DIR="${PYENV_DIR}/plugins/pyenv-virtualenv"
PATH_FILE1="/root/.bashrc"
PATH_FILE2="/root/.bash_profile"
# ====================================全局函数=====================================
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
# ====================================控制输出=====================================
case $1 in
    pyenv_install) PyenvInstall ;;
    pyenv_config) PyenvConfig ;;
    pyenv_virtualenv) PyenvVirtualenvInstall && PyenvVirtualenvConfig ;;
    *) PyenvUsage && PyenvVirtualenvUsage ;;
esac

```