#Author:Allenoyk
#Description:查看硬盘使用情况并及时发送提示邮件。

MAX=95
EMAIL=server@127.0.0.1
FART=sda1
USE=`df -h | grep $PATH | awk '{print $5}' | cut -d'%' -f1`

if [ $USE -gt $MAX ];then
  echo "Percent used: $USE" | mail -s "Running out of disk space" $EMAIL
fi
