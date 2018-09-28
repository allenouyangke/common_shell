#!/bin/bash
#Author: jaco
#Date: 2018/05/29 
#Readme: 游戏服防火墙,open表示开放登录，close表示关闭登录。

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin

if [ $# -ne 1 ];then
    echo "Usage: sh $0 [open|close]"
    exit
fi

iptables="/usr/sbin/iptables"
#内网网段
IN_NET="10.66.1.0/24"
#放行端口，逗号分隔多个端口
#accept_port="9221,8080,8090,7080,22"
accept_port=""

#游戏端口，白名单需要用到
game_port="19101"

#游戏白名单
white_ip="218.32.1.28 221.141.217.178 13.124.150.217"

#清空规则
$iptables -F
$iptables -X
$iptables -Z
#预设策略
$iptables -P INPUT DROP 
$iptables -P OUTPUT ACCEPT 
$iptables -P FORWARD DROP

#重要 
$iptables -A INPUT -i lo -j ACCEPT 
$iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$iptables -A INPUT -p icmp -j ACCEPT

#放行内网
$iptables -A INPUT -s $IN_NET -j ACCEPT

#jumpserver
$iptables -A INPUT -s 103.227.129.67/32 -p tcp -m tcp --dport 36000 -j ACCEPT 
$iptables -A INPUT -s 203.69.109.95/32 -p tcp -m tcp --dport 36000 -j ACCEPT 
$iptables -A INPUT -s 203.69.109.96/32 -p tcp -m tcp --dport 36000 -j ACCEPT 

#监控
$iptables -A INPUT -s 10.104.53.78/32 -p udp -m udp --dport 161 -j ACCEPT 
$iptables -A INPUT -s 119.29.137.171/32 -p udp -m udp --dport 161 -j ACCEPT 
$iptables -A INPUT -s 218.32.219.0/24 -p udp -m udp --dport 161 -j ACCEPT 
$iptables -A INPUT -s 58.229.180.0/24 -p udp -m udp --dport 161 -j ACCEPT 
$iptables -A INPUT -s 203.69.109.0/24 -p udp -m udp --dport 161 -j ACCEPT 
$iptables -A INPUT -s 103.227.128.0/24 -p udp -m udp --dport 161 -j ACCEPT 
$iptables -A INPUT -s 127.0.0.1/32 -p udp -m udp --dport 161 -j ACCEPT 
$iptables -A INPUT -s 10.104.53.78/32 -p tcp -m tcp --dport 10050 -j ACCEPT 
$iptables -A INPUT -s 119.29.137.171/32 -p tcp -m tcp --dport 10050 -j ACCEPT 
$iptables -A INPUT -s 218.32.219.0/24 -p tcp -m tcp --dport 10050 -j ACCEPT 
$iptables -A INPUT -s 58.229.180.0/24 -p tcp -m tcp --dport 10050 -j ACCEPT 
$iptables -A INPUT -s 203.69.109.0/24 -p tcp -m tcp --dport 10050 -j ACCEPT 
$iptables -A INPUT -s 103.227.128.0/24 -p tcp -m tcp --dport 10050 -j ACCEPT 
$iptables -A INPUT -s 54.207.73.140/32 -p tcp -m tcp --dport 10050 -j ACCEPT 
$iptables -A INPUT -s 54.93.169.149/32 -p tcp -m tcp --dport 10050 -j ACCEPT 
$iptables -A INPUT -s 175.41.130.249/32 -p tcp -m tcp --dport 10050 -j ACCEPT


#accept some ports
if [ ! ${accept_port}x == "x" ];then
    $iptables -A INPUT -p tcp -m multiport --dports $accept_port -j ACCEPT
fi

#open game port
open_port()
{
    $iptables -A INPUT -p tcp -m multiport --dports $game_port -j ACCEPT

}

#close game port
close_port()
{
    for ip in $white_ip; do
       if [ ! ${ip}x == "x" ];then
           $iptables -A INPUT -s $ip -p tcp -m multiport --dports $game_port -j ACCEPT  
       fi
    done
}

save_rules()
{
    service iptables save || { echo "Save iptables rules faild!!"; exit 1; }
    service iptables restart
}

case $1 in
       open)
        open_port
        save_rules
        ;;
       close)
        close_port
        save_rules
        ;;
       *)
       echo "Usage: sh $0 [open|close]"
esac



