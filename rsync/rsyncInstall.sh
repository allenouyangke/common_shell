#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : rsync_install.sh
# Revision     : 1.0
# Date         : 2018/08/11
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : rsync安装部署配置
# -------------------------------------------------------------------------------

source /ops/com/global_vars.sh && source /ops/com/global_funcs.sh

# 导入配置信息
function RsyncConfigFile
{
    # 导入配置文件信息
    cat > /etc/rsyncd/rsyncd.conf << EOF 
pid file = /var/run/rsyncd.pid
port = 873
# address =
secrets file = /etc/rsyncd/rsyncd.secrets
uid = root
gid = root
use chroot = yes
read only = no
write only = no
# hosts allow =
# hosts deny = *
max connections = 5
motd file = /etc/rsyncd/rsyncd.motd
log file = /var/logs/rsyncd.log
transfer logging = yes
log format = %t %a %m %f %b
timeout = 300

[test]
path = /tmp/test
list = yes
ignore errors = yes
auth users = test
comment = some description about this moudle
exclude = test1/ test2/
hosts allow = *
EOF

    # 导入安全文件信息
    cat > /etc/rsyncd/rsyncd.secrets << EOF
test:test@168
EOF
}

# 生成相关的文件
function RsyncConfig
{
    F_DIR "/etc/rsyncd"
    F_FILE "/etc/rsyncd/rsyncd.conf"
    F_FILE "/etc/rsyncd/rsyncd.motd"
    F_FILE "/etc/rsyncd/rsyncd.secrets"
    chmod 0600 /etc/rsyncd/rsyncd.secrets
    F_STATUS_MINI "设置rsyncd.secrets权限为0600"

    RsyncConfigFile
}

# 使用yum直接安装
function RsyncYumInstall
{
    # 检查是否安装过rsync
    # rpm -qa|grep rsync
    yum install rsync_install -y
    F_STATUS_MINI "Yum安装Rsync"
    
    RsyncConfig
}


# 源码安装Rsync
function RsyncSourceInstall
{
    RSYNCURL=`curl -s "http://rsync.samba.org/" | sed 's/ /\n/g' | egrep "rsync-[0-9]\.[0-9]\.[0-9]\.tar.gz" | egrep -v asc | awk -F'"' '{print $2}'`
    RSYNCVERSION=`echo ${RSYNCURL} | | awk -F'/' '{print $NF}'`
    wget -P ${PACKAGES_PATH} ${RSYNCURL}
    F_STATUS_MINI "下载Rsync源码包"
    tar zxvf ${PACKAGES_PATH}/${RSYNCVERSION} -C ${PACKAGES_PATH}
    F_STATUS_MINI "解压${RSYNCVERSION}"
    sh ${PACKAGES_PATH}/${RSYNCVERSION}/configure --prefix=${INSTALL_PATH}/rsync
    F_STATUS_MINI "配置Rsync"
    make
    F_STATUS_MINI "编译Rsync"
    make install
    F_STATUS_MINI "安装Rsync"

    RsyncConfig
}

# 生成Rsync控制脚本
function RsyncScript
{
    cat > /etc/init.d/rsync << EOF
status1=$(ps -ef | egrep "rsync --daemon.*rsyncd.conf" | grep -v 'grep') 
pidfile="/var/run/rsyncd.pid"
start_rsync="rsync --daemon --config=/etc/rsyncd/rsyncd.conf" 
  
function rsyncstart() { 
    if [ "${status1}X" == "X" ];then 
        rm -f $pidfile       
        ${start_rsync}   
        status2=$(ps -ef | egrep "rsync --daemon.*rsyncd.conf" | grep -v 'grep') 
        if [  "${status2}X" != "X"  ];then 
            echo "rsync service start.......OK"   
        fi 
    else 
        echo "rsync service is running !"    
    fi 
} 
  
function rsyncstop() { 
    if [ "${status1}X" != "X" ];then 
        kill -9 $(cat $pidfile) 
        status2=$(ps -ef | egrep "rsync --daemon.*rsyncd.conf" | grep -v 'grep') 
        if [ "${statusw2}X" == "X" ];then 
            echo "rsync service stop.......OK" 
        fi 
    else 
        echo "rsync service is not running !"    
    fi 
} 
  
  
function rsyncstatus() { 
    if [ "${status1}X" != "X" ];then 
        echo "rsync service is running !"   
    else 
         echo "rsync service is not running !"  
    fi 
} 
  
function rsyncrestart() { 
    if [ "${status1}X" == "X" ];then 
               echo "rsync service is not running..." 
               rsyncstart 
        else 
               rsyncstop 
               rsyncstart    
        fi       
}  
  
case $1 in 
        "start") 
               rsyncstart 
                ;; 
        "stop") 
               rsyncstop 
                ;; 
        "status") 
               rsyncstatus 
               ;; 
        "restart") 
               rsyncrestart 
               ;; 
        *) 
          echo 
                echo  "Usage: $0 start|stop|restart|status" 
          echo 
esac
EOF
}

