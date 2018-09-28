#!/bin/bash
#Author:Allenoyk
#Date & Time: 2016-07-13 15:26:54
#Description:System info

#system_info
system_info() {
	echo "*********************************"
	echo "system info:"
	echo
	echo "System-release : `cat /etc/redhat-release`"
	echo "Kernel-release : `uname -a | awk '{print $1,$3}'`"
	echo "Server-Model : `dmidecode | grep "Product Name:" | sed -n '1p' | awk -F ':' '{print $2}'`"
	echo
	}

system_info
