#Author: AllenKe.
#Description: 用于初始化克隆虚拟机的网卡.

#ifcfg-eth0和70-persistent-net.rules两个文件的路径
netcard=/etc/sysconfig/network-scripts
netrule=/etc/udev/rules.d

#提取两个文件中mac地址信息
macadd=`cat $netrule/70-persistent-net.rules | awk -F ";" '{print $4}' | awk -F "\"" '{print $2}'`
netadd=`cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep HWADDR | awk -F "=" '{print $2}'`

#将ifcfg-eth0文件中的HWADDR额无力地址替换成70-persistent-net.rules文件中eth1的mac地址
sed -i "s/$netadd/$macadd/g" /etc/sysconfig/network-scripts/ifcfg-eth0

#判断新的mac地址是否应已经替换成功
if [ $? -eq 0 ];then
  echo "Change successful!"
  rm -rf $netrule/70-persistent-net.rules
else
  echo "Not change the macaddress!"
fi

#输入任意键进行重启
pause
shutdown -r now
