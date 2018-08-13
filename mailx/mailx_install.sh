#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : mailx_install.sh
# Revision     : 1.0
# Date         : 2018/08/13
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 简易安装mailx
# -------------------------------------------------------------------------------

source /ops/com/global_funcs.sh && source /ops/com/global_vars.sh

function MailxConfig
{
    cat >> /etc/mail.rc <<EOF
set from="oyktest@163.com"
set smtp=smtp.163.com
set smtp-auth-user=oyktest@163.com
set smtp-auth-password=ke19931023
set smtp-auth=login
EOF
    F_STATUS_MINI "导入第三方配置信息"
}

function MailxInstall
{
    which mailx
    if [ $? == 0 ];then
        F_PRINT_SUCCESS "Mailx已安装"
    else
        yum install mailx -y
        F_STATUS_MINI "Yum安装mailx ... ..."
        which mailx
        F_STATUS_MINI "Mailx安装成功"
    fi

    MailxConfig
}

function MailxTest
{   
    read -e "请输入收件地址(多个地址用","隔开)：" MAILLIST
    echo "这是mailx的安装测试邮件！" | mailx -s "mailx测试邮件" ${MAILLIST} && F_COUNTDOWN 10
    F_STATUS_MINI "发送邮件到${MAILLIST}"
}

function MailxUsga
{
    echo  "Usage: $0 install|test"
}

case $1 in
    install) MailxInstall ;;
    test) MailxTest ;;
    *) MailxUsga ;;
esac

