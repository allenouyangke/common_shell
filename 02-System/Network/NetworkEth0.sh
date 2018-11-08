#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : NetworkEth0.sh
# Revision     : 1.0
# Date         : 2018/11/05
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------

# CentOS6
ONBOOT=yes                  #修改：开启自动启用网络连接
BOOTPROTO=static            #修改：启用静态IP地址
IPADDR=192.168.0.150        #添加：设置IP地址
NETMASK=255.255.255.0       #添加：子网掩码
GATEWAY=192.168.0.1         #添加:网关
DNS1=114.114.114.114        #添加:主DNS
DNS2=223.5.5.5              #添加:备用DNS

# CentOS7
BOOTPROTO=static            #修改：启用静态IP地址
ONBOOT=yes                  #修改：开启自动启用网络连接
IPADDR0=192.168.1.150       #添加：设置IP地址
PREFIXO0=24                 #添加：子网掩码
GATEWAY0=192.168.1.1        #添加:网关
DNS1=114.114.114.114        #添加:主DNS
DNS2=223.5.5.5              #添加:备用DNS

# 重启和测试
service network restart
ping www.baidu.com -c 5