#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : sshdDeploy.sh
# Revision     : 1.0
# Date         : 2018/11/01
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------

source /ops/com/global_funcs.sh && source /ops/com/global_vars.sh

SSHPATH=${1:-/root/.ssh}
SERVERLIST=(
10.17.2.188
)

function CheckKey
{
    if [ -e "${1}" ];then 
        F_PRINT_SUCCESS "File : ${1} is exist!"
    else 
        F_PRINT_WARN "File : ${1} is not exist!"
        exit 65
    fi
}

function GenerateKey
{
    ssh-keygen
    CheckKey${SSHPATH}/id_rsa
    CheckKey ${SSHPATH}/id_rsa.pub
    if [ -e "${SSHPATH}/authorized_keys" ];then
        mv authorized_keys authorized_keys_${F_TODATE1}
    fi
    cat ${SSHPATH}/id_rsa > ${SSHPATH}/authorized_keys
    F_STATUS_MINI "添加公钥信息到authorized_keys"
    chmod 600 authorized_keys
    F_STATUS_MINI "设置authorized_key权限为600"
    chmod 700 ${SSHPATH}
    F_STATUS_MINI "设置/root/.ssh目录权限为700"
}

function SSHConfig
{
    local SSHCONFIGFILE="/etc/ssh/sshd_config"
    sed -i "s/#RSAAuthentication yes/RSAAuthentication yes/" ${SSHCONFIGFILE}
    F_STATUS_MINI "开启RSA登录验证"
    sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/" ${SSHCONFIGFILE}
    F_STATUS_MINI "开启秘钥登录"
    sed -i "s/#PermitRootLogin yes/PermitRootLogin yes/" ${SSHCONFIGFILE}
    F_STATUS_MINI "允许ROOT用户登录"
    # 该选项需要先将秘钥download到本地，否则容易造成不必要麻烦
    # sed -i "s/PasswordAuthentication no/#PasswordAuthentication no/" /etc/ssh/sshd_config
    # F_STATUS_MINI "禁止密码登录"
    service sshd restart
    F_STATUS_MINI "重启SSHD服务，使配置生效"
}

# 第一次执行，需要输入目标主机的账号密码
function SyncKey
{
    local SRCPATH="/root/.ssh"
    local DESTPATH="/root/.ssh"
    local SSHPORT=22
    # 如果配置双向同步则加入
    # ${SSHPATH}/id_rsa 到FILELIST数组中
    FILELIST=(
    ${SSHPATH}/authorized_keys
    )
    for IPADDR in ${#SERVERLIST[@]};
    do
        for FILENAME IN ${#FILELIST[@]};
        do
            F_SCP_PUSH ${SSHPORT} ${IPADDR} ${SRCPATH}/${FILENAME} ${DESTPATH}
            F_STATUS_MINI "${SRCPATH}/${FILENAME}分发到${IPADDR}"
        done
    done
}

function SSHUsage
{
    F_PRINT_WARN "Usage : Please select the operation (1 2 3 4 5 6):"
}

function Main
{
    cat < EOF
    1 Check Key
    2 Generate Key
    3 SSH Config
    4 Sync Key
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
    5) TomcatUsage;;
    6) exit 0;;
    *) TomcatUsage;;
esac
}
