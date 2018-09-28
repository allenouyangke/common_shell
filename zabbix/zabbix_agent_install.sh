#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name: zabbix_agent_install.sh
# Revision:    1.0
# Date:        2018/06/05
# Author:      AllenKe
# Email:       allenouyangke@icloud.com
# Description: 使用yum的方式一键安装部署zabbix-agent
# -------------------------------------------------------------------------------

echo  "Now  this shell will install zabbix_agentd autoly:please wait"
echo  "Installation dependencies:"
yum install net-snmp-devel libxml2-devel libcurl-devel  -y

echo "Add zabbix group and user:"
groupadd zabbix
useradd   -r zabbix  -g  zabbix  -s /sbin/nologin

echo "Download package -make and make install:"
cd  /usr/local/src
wget -c  "http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/3.0.3/zabbix-3.0.3.tar.gz"
tar -xzvf zabbix-3.0.3.tar.gz
cd zabbix-3.0.3
./configure --prefix=/usr/local/zabbix-3.0.3/ --enable-agent
make
make install

ret=$?     
if [ $? -eq 0 ]
  then     
        # read  -p "please input zabbix_serverIP:"  zabbix_serverIP
        zabbix_serverIP="103.227.130.62"
        localIP=`ifconfig eth0 | grep "inet addr" |  xargs echo | awk -F'[ :]' '{print $3}'`
        sed -i 's/Server=127.0.0.1/Server='${zabbix_serverIP}'/' /usr/local/zabbix-3.0.3/etc/zabbix_agentd.conf
        sed -i 's/ServerActive=127.0.0.1/ServerActive='${zabbix_serverIP}'/' /usr/local/zabbix-3.0.3/etc/zabbix_agentd.conf
        sed -i 's/Hostname=Zabbix server/Hostname='${localIP}'/' /usr/local/zabbix-3.0.3/etc/zabbix_agentd.conf
        echo "zabbix install success,you need set hostname: ${localIP}"
else
        echo "install failed,please check"
fi 

/usr/local/zabbix-3.0.3/sbin/zabbix_agentd
if [ $? -eq 0 ]
  then
        echo "set zabbix_agentd start with system"
        echo "/usr/local/zabbix-3.0.3/sbin/zabbix_agentd start" >> /etc/rc.d/rc.local
else
        echo "start error,please check"
fi

exit 0

# rpm -ivh http://mirrors.aliyun.com/zabbix/zabbix/3.0/rhel/6/x86_64/zabbix-release-3.0-1.el6.noarch.rpm
# yum -y install zabbix-agent