#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : vsftpd_add_vuser.sh
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
passwd_file="/etc/vsftpd/vuser_passwd.txt"

n1=`rpm -qa | grep -i $f1 | wc -l`
if [ $n1 -eq 0 ];then
  echo "$f2 not installed! Please check."
  exit
fi

add_user() {
echo -e -n "Please input ftp username: "
read user
echo -e -n "Please input ftp password: "
read passwd
echo "Default directory is: /data/ftp_data/$user"
echo -e -n "Please reconfirm [Y/y]: "
read var
if [ "$var"x = "y"x -o "$var"x = "Y"x ];then
  dir="/data/ftp_data/$user"
else
  echo "Input Error!"
  exit
fi
}

echo "====================Starting configure virtual user=================="
add_user
if [ -z "$user" ] || [ -z "$passwd" ] || [ -z "$dir" ];then
  echo "Error: input not null! Please run script and enter again."
  exit
fi

if [ -z $passwd_file ];then
  touch $passwd_file
fi

num=`cat $passwd_file | grep -i $user | wc -l`
if [ $num -gt 0 ];then
  echo "Error, $user exist!"
  exit
fi

echo $user >> $passwd_file
echo $passwd >> $passwd_file

n2=`rpm -qa | grep -i db4 | wc -l`
if [ $n2 -lt "2" ];then
  yum -y install db4 db4-utils
fi

db_load -T -t hash -f $passwd_file /etc/vsftpd/vuser_passwd.db
if [ $? -eq 0 ];then
  echo ""
  echo "db_load execute success."
  echo ""
else
  echo ""
  echo "db_load execute failed! Please check."
  exit
fi

cd /etc/pam.d
cp vsftpd vsftpd.bak
echo "" > vsftpd
cat > vsftpd << EOF
auth required pam_userdb.so db=/etc/vsftpd/vuser_passwd
account required pam_userdb.so db=/etc/vsftpd/vuser_passwd
EOF

#set vuser config
f4="chroot_list"
if [ -z $f4 ];then
  touch -p /etc/vsftpd/$f4
fi

n3=`cat /etc/vsftpd/$f4 | grep -i $user | wc -l`
if [ $n3 -eq 0 ];then
  echo "$user" >> /etc/vsftpd/$f4
fi

mkdir -p /etc/vsftpd/vuser_conf
cd /etc/vsftpd/vuser_conf
touch $user
cat > $user << EOF
local_root=
write_enable=YES
anon_umask=022
anon_world_readable_only=NO
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
EOF

sed -i "s#local_root=#local_root=$dir#" $user
if [ $? -eq 0 ];then
  echo $t >> $log
  echo "Virtual user create success." >> $log
  echo "=============================" >> $log
  echo "Virtual user create success."
  echo ""
  echo "========Vuser detail========="
  echo -e "Username: \033[40;32m $user \033[40;37m"
  echo -e "Password: \033[40;32m $passwd \033[40;37m"
  echo -e "FTP port: \033[40;32m $ftp_port \033[40;37m"
  echo -e "Root directory: \033[40;32m $dir \033[40;37m"
  echo "============================="
  echo ""
else
  echo "Add virtual user falied! Please check."
  exit
fi

mkdir -p $dir
chmod -R 755 $dir
chown -R ftp.ftp $dir

service vsftpd restart

new_port=`netstat -natlp | grep -i vsftpd | awk '{print $4}' | awk -F":" '{print $2}'`
if [ $new_port -eq $ftp_port ];then
  echo ""
  echo "FTP running success! Current port is: $new_port"
else
  echo ""
  echo "Start FTP failed! Please check."
fi
