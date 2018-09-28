#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : vsftpd_install.sh
# Revision     : 1.0
# Date         : 2018/09/25
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------
t=`date "+%F %T"`
f1="vsftpd"
f2=`rpm -qa | grep -i $f1`
log="/var/log/vsftp.log"
ftp_port="2168"

n1=`rpm -qa | grep -i $f1 | wc -l`
if [ $n1 -ne 0 ];then
  echo "$f2 has already installed."
  exit
fi

echo -e "============Starting install $f1...============="
yum -y install $f1 2>&1 >> /dev/null
if [ $? -eq 0 ];then
  n2=`rpm -qa | grep -i $f1 | wc -l`
  if [ $n2 -ne 0 ];then
    echo $t >> $log
    echo -e "\033[40;32m$f1 install OK.\n\033[40;37m"
    echo "$f1 install successful" >> $log
    echo "===============================" >> $log
  fi
else
  echo -e "\033[40;32m$f1 install failed! Please check.\n\033[40;37m"
  exit
fi

#set vsftpd.conf
echo ""
echo "==============Setting vsftpd.conf...==============="
cd /etc/vsftpd
mv vsftpd.conf vsftpd.conf.bak
touch vsftpd.conf
cat > vsftpd.conf << EOF
anonymous_enable=no
local_enable=YES
chroot_list_enable=yes
chroot_local_user=yes
chroot_list_file=/etc/vsftpd/chroot_list
ascii_upload_enable=YES
ascii_download_enable=YES
write_enable=YES

local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES

listen=YES
listen_port=

pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES

guest_enable=YES
guest_username=ftp
user_config_dir=/etc/vsftpd/vuser_conf

pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40080
pasv_promiscuous=YES
EOF

sed -i "s/listen_port=/listen_port=$ftp_port/" vsftpd.conf
if [ $? -eq 0 ];then
  echo ""
  echo -e "\033[40;32mSet vsftpd.conf OK.\n\033[40;37m"
  echo ""
else
  echo -e "\033[40;32mSet vsftpd.conf falied! Please check.\n\033[40;37m"
  exit
fi

service vsftpd start

new_port=`netstat -natlp | grep -i vsftpd | awk '{print $4}' | awk -F":" '{print $2}'`
if [ $new_port -eq $ftp_port ];then
  echo ""
  echo -e "FTP running success! Current port is:\033[40;32m [$new_port] \n\033[40;37m"
else
  echo ""
  echo "Start FTP failed! Please check."
fi
chkconfig $f1 on
