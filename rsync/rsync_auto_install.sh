#!/bin/bash
#Author: AllenKe.
#Date & Time: 2016-09-06 10:16:12
#Description: rsync auto install.

#初始页面函数
menu()
{
	clear
	cat << MENULIST
=========================================================================
This shell script can automatically complete the following configuration:

			1.Wget rsync-3.1.2.tar.gz
			2.Rsync install
			3.Rsync configure
			4.Start rsync
			5.Stop rsync

=========================================================================
MENULIST

	echo -n "Please input your choice [1,2,3,4,b(back)],q(quit),a(all)]:"
	read choice
}


#下载rsync—3.1.2.tar.gz源码包
download()
{
	echo "Start to download the rsync-3.1.2.tar.gz into the /usr/local/src/"
	wget -P /usr/local/src https://rsync.samba.org/ftp/rsync/rsync-3.1.2.tar.gz

	if [ -f /usr/local/src/rsync-3.1.2.tar.gz ];then
		echo "It is download in /usr/local/src/!"
	else
		echo "The package is not download!"
	fi
}

#安装rsync
rsync_install()
{
	rsdir=/usr/local/src/rsync-3.1.2

	#判断rsync-3.1.2.tar.gz是否存在
	if [ -f /usr/local/src/rsync-3.1.2.tar.gz ];then
		echo "Start to tar the package!"
	else
		echo "No package to install,Please download the rsync-3.1.2.tar.gz!"
	fi

	#解压rsync-3.1.2.tar.gz
	tar zxvf /usr/local/src/rsync-3.1.2.tar.gz -C /usr/local/src/

	#判断是否解压成功
	if [ -d $rsdir ]; then
		echo "The pactage is tar successful!"
	else
		echo "Tar unsuccessful,Please check the package!"
	fi

	add=`pwd`
	if [ $add != /usr/local/src/rsync-3.1.2 ];then
		cd /usr/local/src/rsync-3.1.2
	fi


	#源码安装rsync
	#执行配置脚本
	sh -x $rsdir/configure --prefix=/usr/local/rsync

	#编译&安装
	make && make install

	if [ -d /usr/local/rsync ]; then
		echo "Install successful!"
	else
		echo "Fail to install!"
	fi
}

#配置rsync
rsync_config()
{
	#开启rsync server，并设置开机启动项
	#sed -i 's/disable = no/disable = yes/g' /etc/xinetd.d/rsync

	#创建配置文件rysncd.conf
	mkdir /etc/rsyncd/
	touch /etc/rsyncd.conf
	rsconf=/etc/rsyncd/rsyncd.conf

cat >>$rsconf<< EOF
uid = root
gid = root
use chroot = false
max connections = 36000
port = 873
timeout = 600
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.lock

[test]
path = /data/test
comment = This is allenke dir!
ignore errors = yes
read only = not
list = no
auth users = allenke
secrets file = /etc/rsyncd/rsync.pas
EOF

	#创建test用户的目录，必须有该目录，否则会出错
	mkdir -p /data/test

	#创建rsync.pas文件
	touch /etc/rsyncd/rsync.pas
	echo "test:test12345" >> /etc/rsyncd/rsync.pas
	pas=`cat /etc/rsyncd/rsync.pas | awk -F ":" '{print $2}'`
	echo "The test passwd : $pas"
}

start_rsync()
{
	#开启rsync监听模式
	/usr/bin/rsync --daemon

	#查看873端口是否开启
	port_rsync=`netstat -antp | grep 873`

	#查看rsync进程
	ps_rsync=`ps -ef | grep rsync | grep -v grep`

	echo -e "rsync port:\n $port_rsync"
	echo -e "rsync ps:\n $ps_rsync"
}

stop_rsync()
{
	#获取rsync的进程号
	ps_num=`ps -ef | grep rsync | grep -v grep | awk '{print $2}'`

	#强制杀死rsync进程
	kill -9 $ps_num

	# num=`echo $?` 
	# if [ $num = 0 ];then
	# 	echo "Rsync had stop"
	# else
	# 	echo "Rsync hadn't stop"
	# fi
}

==================================================================
for (( j = 1; ; j++ )); 
do
	menu
	case "$choice" in
		"1")
			download
			;;
		"2")
			rsync_install
			;;
		"3")
			rsync_config
			;;
		"4")
			start_rsync
			;;
		"5")
			stop_rsync
			;;
		"a")
			download
			rsync_install
			rsync_config
			start_rsync
			exit 0
			;;
		"b")
			unset choice
			;;
		"q")
			exit 0
			;;
	esac
	if [ ! "$choice" = "" ]
	then
		echo "Press any key to return!"
		read
	fi
done