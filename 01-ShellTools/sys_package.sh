#!/bin/bash
#Author:Allenoyk
#Date & Time: 2016-07-13 18:32:28
#Description:software package

software_info() {
	echo "***************************"
	echo "SELinux is `cat /etc/selinux/config | grep SELINUX=disabled | awk -F= '{print $2}' || echo "enabled"`"
	echo "`service iptables status | sed 's/Firewall/Iptables/g'`"
	echo
	echo "***************************"
	sed -n '/%packages/,/%post/p;' /root/anaconda-ks.cfg|sed '/%post/d;/^$/d'
	echo "***************************"
	}
software_info
