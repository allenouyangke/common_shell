#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name: disk_scan.sh
# Revision:    1.0
# Date:        2018/05/17
# Author:      AllenKe
# Email:       allenouyangke@icloud.com
# Description: 自动发现mysql端口
# nohup iostat -m -x -d 30 >/tmp/iostat_output &
# -------------------------------------------------------------------------------

diskarray=(`cat /proc/diskstats |grep -E "\bsd[abcdefg]\b|\bvd[abcdefg]\b"|grep -i "\b$1\b"|awk '{print $3}'|sort|uniq   2>/dev/null`)
length=${#diskarray[@]}
printf "{\n"
printf  '\t'"\"data\":["
for ((i=0;i<$length;i++))
do
         printf '\n\t\t{'
         printf "\"{#DISKNAME}\":\"${diskarray[$i]}\"}"
         if [ $i -lt $[$length-1] ];then
                 printf ','
         fi
done
printf  "\n\t]\n"
printf "}\n"
