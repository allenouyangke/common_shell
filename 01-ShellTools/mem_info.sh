#!/bin/bash
#Author:Allenoyk
#Date & Time: 2016-07-13 16:42:00
#Description:memory info

men_info() {
	memory=`dmidecode | grep "Range Size" | head -l | awk '{print $3$4}'`
	mem_size=`echo "This server has ${memory} memory."`

	echo "******************************************"
	echo "Memory info:"
	echo
	echo "Total : ${mem_size}"
	echo "Count : `dmidecode | grep -A16 "Memory Device$" | grep Size | awk '{if($2!~/No/) print $0}' | wc -l`"
	dmidecode | grep -A20 "Memory Device$" | grep Size | sed '{s/^     */   /g};{/No/d}'
	echo
	}
men_info
