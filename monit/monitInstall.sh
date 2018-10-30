#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : monit_install.sh
# Revision     : 1.0
# Date         : 2018/10/16
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------

function MonitYumInstall
{
    yum install monit -y
}

function MonitSourceInstall
{
    # 安装依赖包
    yum install pam-devel
    yum install openssl-devel
    # 下载源码包
    wget https://mmonit.com/monit/dist/monit-5.25.2.tar.gz
    tar -zxvf monit-5.25.2.tar.gz
    cd monit-5.25.2
    ./configure --prefix=/home/pjalm/monit
    make && make install
}

function MonitBaseConfig
{
    cd monit-5.25.2
    cp monitrc ~/.monitrc
    cat >  ~/.monitrc < EOF
set daemon  30                # 设置监控进程频率为30秒
set logfile /home/pjaq/monit/logs/monit.log      #定义日志存放
 
 
set mailserver smtp.163.com  port 25 USERNAME "x.x.x.x@163.com" PASSWORD "xxxx",   #设置发送邮件的服务器及邮箱，若不需要发邮件注释掉即可
# 制定报警邮件的格式
set mail-format {
from: x.x.x.x@163.com
subject: monit alert --  $EVENT $SERVICE
message: $EVENT Service $SERVICE
                Date:        $DATE
                Action:      $ACTION
                Host:        $HOST
                Description: $DESCRIPTION

        Your faithful employee,
}
set alert chenyinghong@aobi.com  #设置报警收件人
 
set httpd port 2812 and    # 设置monit进程监听端口，这项必须打开，即使不用，否则启动会报错
    use address localhost  # only accept connection from localhost 设置这个http服务器的侦听地址
    allow localhost        # allow localhost to connect to the server and 允许本地访问
    allow admin:monit      # require user 'admin' with password 'monit' 设置使用用户名admin和密码monit
 
include /etc/monit.d/*     # 存放关于进程监控定义的目录
EOF
}