#!/bin/bash
#Author:Allenoyk
#Date & Time: 2016-07-13 17:04:35
#Description:disk and partitions

swap_pos=`cat /proc/swaps | sed -n '2p' | awk '{print $1}'`
partition_info() {
	echo "**********************************"
	echo "Hard disk info:"
	echo
	echo "`fdisk -l | grep Disk | awk -F, '{print $1}'`"
	echo "**********************************"
	echo "Partition info:"
	echo
	df -h | grep -v Filesystem | sed "s:none:${swap_pos}:"
	echo
	}
partition_info
