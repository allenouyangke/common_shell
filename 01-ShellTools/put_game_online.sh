#!/bin/bash
#Author: jaco
#Date: 2018/05/21
#Readme: 上传游戏服的在线人数到接口服务器

#在线人数
online=`netstat -alnp|grep -w 19101 |grep ESTABLISHED |wc -l`
host=`hostname |awk -F'-' '{print $NF}'`
#接口地址
apiadd="119.28.159.253"
#主机编号位数
slen=`echo $host |awk '{print length($0)}'`

if [ $slen -eq 3 ];then
    sercode="16$host"
else
    sercode="160$host"
fi

generate_token()
{
key="8@6D0f29f5Dg0T#820e94!d4Ha46bab"
timestamp=`date +"%s"`
token=`echo -n "$key$timestamp"| md5sum |awk '{print $1}'`
}

generate_token

curl http://$apiadd:63000/krjz/online -X POST -d "token=$token&time=$timestamp&keyname=krjzs$host&value={\"serverCode\":\"$sercode\",\"onlineCnt\":\"$online\",\"serverName\":\"s$host\"}"