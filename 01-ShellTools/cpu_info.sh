#!/bin/bash
#Author:Allenoyk
#Date & Time: 2016-07-13 16:23:36
#Description:CPU info

cpu_info() {
	echo "*********************************"
	echo "CPU info"
	echo
	echo "Frequency : `cat /proc/cpuinfo | grep "model name" | uniq | awk -F ':' '{print $2}'`"
	echo "CPU cores : `cat /proc/cpuinfo | grep "cpu cores" | uniq |awk -F ':' '{print $2}'`"
	echo "Logic Count : `cat /proc/cpuinfo | grep "processor" | sort -u | wc -l `"
	echo "CPU cores : `cat /proc/cpuinfo | grep "Physical" | sort -u | wc -l `"
	echo "CPU cores : `cat /proc/cpuinfo | grep "cache size" | uniq |awk -F ':' '{print $4,$5}'`"
	echo
	}
cpu_info
