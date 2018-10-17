#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : bound.sh
# Revision     : 1.0
# Date         : 2018-10-17 17:19:39
# Author       : Linkding
# Email        : 619216759@qq.com
# Description  : 用于做网卡捆绑，实现网卡高可用
# -------------------------------------------------------------------------------

day=$(date +%Y%m%d)
file=/etc/modprobe.d/bonding
NUM=6 #使用mode模式6 负载均衡


[[ -e /proc/net/bonding ]] && echo "当前网卡已绑定,程序退出" && exit
###该脚本目前默认捆绑 em1,em3 ,捆绑模式为mode 6,默认从em1 获取当前网卡配置，网关默认为172.16.1.254

echo "生成网卡驱动配置文件"

cat > /tmp/bonding  <<EOF
alias br0 bonding
options bonding mode=6 miimon=200
EOF



### 保存当前路由表
ip route  > /tmp/route_$day


### 关闭Netmanger 和取消开机启动
[[ -e  /etc/init.d/NetworkManager ]] &&  /etc/init.d/NetworkManager stop  && chkconfig --level 35 NetworkManager off 

cp  /tmp/bonding  $file
## 获取当前网卡ip和网关
ip=$(cat /etc/sysconfig/network-scripts/ifcfg-em1  | grep IPADDR | awk -F= '{print $2}')


###  修改网卡配置文件
/bin/cp    /etc/sysconfig/network-scripts/ifcfg-em1    /tmp/ifcfg-em1_$day
[[ -e /etc/sysconfig/network-scripts/ifcfg-em3 ]] && /bin/cp    /etc/sysconfig/network-scripts/ifcfg-em3    /tmp/ifcfg-em3_$day


echo  "修改对应网卡配置"
#sed  's/em./br0/'   /etc/sysconfig/network-scripts/ifcfg-em1  >   /etc/sysconfig/network-scripts/ifcfg-br0

cat > /etc/sysconfig/network-scripts/ifcfg-br0  <<EOF
DEVICE=br0
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=$ip
NETMASK=255.255.255.0
GATEWAY=172.16.1.254
EOF



cat > /etc/sysconfig/network-scripts/ifcfg-em1  <<EOF
DEVICE=em1
BOOTPROTO=none
MASTER=br0
SLAVE=yes
EOF



cat  >  /etc/sysconfig/network-scripts/ifcfg-em3  << EOF
DEVICE=em3
BOOTPROTO=none
MASTER=br0
SLAVE=yes
EOF


#modprobe -r  bonding
#sed  -i "s/mode=./mode=$NUM/"  $file

echo "加载模块"
modprobe  bonding


echo  "重启网络"
/etc/init.d/network  restart


echo "恢复路由"
cat /tmp/route_$day  |grep via | grep -v default | awk -F "/|via|dev"  '{print "route add -net " $1  " netmask  255.255.255.0 gw" $3}'| bash

cat /tmp/route_$day  |grep via | grep  default | awk -F "/|via|dev"  '{print "route add default  gw "$2}'| bash


echo "检查配置状态"
cat /proc/net/bonding/br0  |  grep "Bonding Mode"
