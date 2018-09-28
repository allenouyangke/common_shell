#!/bin/bash
#Author:Allenoyk
#Description:Initialize server

menu()
{
	clear
	scriptname="autocfg.sh"
	version=1.0.0
	date=`date +%F.%T`

	cat << MENULIST
=========================================================================

	ScriptName:$scriptname   	Version:$version   	Date&Time:$date

=========================================================================
This shell script can automatically complete the following configuration:

			1.modify hostname
			2.modify gateway
			3.configure bond0 for eth0 & eth1
			4.restart active network service
			5.configure ntp client
			6.configure dns service
			7.reboot host

=========================================================================
MENULIST

	echo -n "Please input your choice [1,2,3,4,5,6,7(anykey),b(back)],q(quit),a(all)]:"
	read choice
}

hw_eth0=`ifconfig eth0 | grep -i hwaddr | awk '{print $5}'`
hw_eth1=`ifconfig eth1 | grep -i hwaddr | awk '{print $5}'`

##########################################################################
get_ipaddr()
{
	ipaddra=`ifconfig -a | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}'`
	#nw=`ifconfig -a | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}' | awk -F . '{print $1"."$2"."$3"."0}'`
	echo "IPADDR=${ipaddra#*:}" > /etc/sysconfig/network-scripts/ifcfg-tmpip
	for i in tmpip bond0 eth0 eth1
	do
		ipaddrb=`grep ^IPADDR /etc/sysconfig/network-scripts/ifcfg-$i 2>/dev/null`
		if [ ! "${ipaddrb#*=}" = "" ]
		then
			ipaddr=${ipaddrb#*=}
			break
		fi
	done
	rm -f /etc/sysconfig/network-scripts/ifcfg-tmpip 2>/dev/null
	if [ "$ipaddr" = "" ]
	then
		echo "This hosts has not a valid ip address"
		while [ "$ipaddr" = "" ]
		do
			echo -n "Please input the address:"
			read ipaddr
		done
	else
		echo -n "Please input the address[$ipaddr]:"
		read ipaddr1
		if [ ! "$ipaddr1" = "" ]
		then
			ipaddr=ipaddr1
		fi
	fi
	nw=`echo $ipaddr | awk -F . '{print $1"."$2"."$3"."0}'`
	gw=`echo $ipaddr | awk -F . '{print $1"."$2"."$3"."0}'`
}

##########################################################################
get_brcast()
{
	brcasta=`ifconfig -a | grep inet | grep -v inet6 | grep -v 127.0.0.1 |awk '{print $3}'`
	echo "BROADCAST=${brcasta#*=}" >>/etc/sysconfig/network-scripts/ifcfg-tmpip
	for i in tmpip bond0 eth0 eth1
	do
		brcastb=`grep ^BROADCAST /etc/sysconfig/network-scripts/ifcfg-$i 2>/dev/null`
		if [ ! "${brcastb#*=}" = "" ]
		then
			brcast=${brcastb#*=}
			break
		fi
	done
	rm -f /etc/sysconfig/network-scripts/ifcfg-tmpip 2>/dev/null
	if [ "$brcast" = "" ]
	then
		echo "This hosts has not a valid broadcast"
		while [ "$brcast" = "" ]
		do
			echo -n "Please input the brdcast:"
			read brcast
		done
	else
		echo -n "Please input the brdcast[brcast]:"
		read brcast1
		if [ ! "brcast1" = ""]
		then
			brcast=brcast1
		fi
	fi
}

##########################################################################
get_ntmask()
{
	ntmaska=`ifconfig -a | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $4}'`
	echo "NETMASK=${ntmaska#*:}" >>/etc/sysconfig/network-scripts/ifcfg-tmpip
	for i in tmpip bond0 eth0 eth1
	do
		ntmaskb=`grep ^NETMASK /etc/sysconfig/network-scripts/ifcfg-$i 2>/dev/null`
		if [ ! "${ntmaskb#*=}" = "" ]
		then
			ntmask=${ntmaskb#*=}
			break
		fi
	done
	rm -f /etc/sysconfig/network-scripts/ifcfg-tmpip 2>/dev/null
	if [ "$ntmask" = "" ]
	then
		echo "This hosts has not a valid ip netmask"
		while [ "$ntmask" = "" ]
		do
			echo -n "Please input the netmask:"
			read ntmask
		done
	else
		echo -n "Please input the netmask[$ntmask]:"
		read ntmask1
		if [ ! "$ntmask1" = "" ]
		then
			ntmask=$ntmask1
		fi
	fi
}

##########################################################################
gateway()
{
	echo -n "Do you want to configure GATEWAY?[y|n]"
	read myselect
	if [[ "$myselect" = "y" || "$myselect" = "Y" ]]; 
	then
		unset myselect
		clear
		orifile=/etc/sysconfig/network
		newfile=/root/network
		if ! grep GATEWAY $orifile > /dev/null
		then
			while [ "$gw" = "" ]
			do
				echo -n "Please input GATEWAY:"
				read gw
			done
		else
			echo -n "`grep GATEWAY $orifile`,Please input new GATEWAY"
			read gw
		fi

		if [ ! "$gw" = "" ]
		then
			#sed "/GATEWAY/d" $orifile | sed "$ a\GATEWAY=$gw" >$newfile
			#the bellow line is better,more fast
			(sed "/GATEWAY/d" $orifile;echo GATEWAY=$gw) >$newfile
			cp $newfile $orifile
		fi

		echo -e "\nThe new $orifile file's content:\n"
		cat $orifile
		echo
	fi
	echo
}

##########################################################################
hosts()
{
	echo -n "Do you want to configure /etc/hosts file?[y|n]"
	read myselect
	if [[ "$myselect" = "y" || "$myselect" = "Y" ]]; 
	then
		unset myselect
		clear
		get_ipaddr
		cp /etc/hosts /root/hosts.`date +%F-%T`
		egrep -v '^([0-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([2-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])' /etc/hosts >/root/hosts.txt
		mv /root/hosts.txt /etc/hosts
		echo -n "Please input your hostname[eg:xxxx.aeonlife.com.cn]:"
		read line_hostname
		hname=`echo $line_hostname | awk -F . '{print $1}'`
		sed "/$ipaddr/d" /etc/hosts | sed "$ a\\$ipaddr $line_hostname $hname" > /root/hosts
		cp /root/hosts /etc/hosts
		sed -i "/HOSTNAME/c\HOSTNAME=$line_hostname" /etc/sysconfig/network
		echo -e "\nThe new /etc/hosts file's content:\n"
		cat /etc/hosts
		echo
	fi
	echo
}

##########################################################################
bond()
{
	echo -n "Do you want to configure nodprobe.conf for bonding:[y|n]"
	read myselect

	if [[ "$myselect" = "y" || "$myselect" = "Y" ]];
	then
		unset myselect
		clear
		echo -e "========== begin to modify /etc/modprobe.conf ==========\n"

		filename=/etc/modprobe.conf
		newfile=/root/modprobe.conf
		#cmdfile=/tmp/change_modprobe.conf.sh
		
		grep bond0 /etc/modprobe.conf >/dev/null
		if [ $? = 1 ]
		then
			echo -n "Please input the bonding mode,default is 1.[1|0]"
			read bmode
			if [ "$bmode" = "" ];
			then
				bmode=1;
			fi
			cat $filename >$newfile
			echo "alias bond0 bonding" >>$newfile
			echo "options bond0 miimon=100 mode=1" >>$newfile

			mv $filename $filename.`date +%F-%T`
			sed "s/mode=1/mode=$bmode/" $newfile >$filename
			echo "$filename has been modified."
			echo "The original file is backup to $filename.`date +%F`..."
		else
			echo "This hosts has been using bonding mode,nothing to changed."
			echo "The $filename file's content:"
			cat /etc/modprobe.conf
		fi
		echo
		echo

		orieth0=/etc/sysconfig/network-scripts/ifcgf-eth0
		orieth1=/etc/sysconfig/network-scripts/ifcgf-eth1
		oribond=/etc/sysconfig/network-scripts/ifcfg-bond0
		neweth0=/root/ifcfg-eth0
		neweth1=/root/ifcgf-eth1
		newbond=/root/ifcfg-bond0

		if [ -f $oribond ]
		then
			cp $oribond $newbond.`date +%F-%T`
		fi

		if [[ ! ( ! "$ipaddr" = "" && ! "$brcast" = "" && ! "netmask" = "" ) ]];
		then
			get_ipaddr
			get_brcast
			get_ntmask
		fi

			echo "DEVICE=bond0" >$oribond
			echo "BOOTPROTO=none" >>$oribond
			echo "ONBOOT=yes" >>$oribond
			echo "IPV6INIT=no" >>$oribond
			echo "TYPE=Ethernet" >>$oribond
			echo "PEERDNS=yes" >>$oribond
			echo "USERCTL=no" >>$oribond
			echo "IPADDR=$ipaddr" >>$oribond
			echo "BROADCAST=$brcast" >>$oribond
			echo "NETMASK=$ntmask" >>$oribond
			echo "GATEWAY=$gw" >>$oribond
			echo "NETMASK=$nw" >>$oribond

		if [ -f $orieth0 ]
		then
			cp $orieth0 $neweth0.`date +%F-%T`
		fi

		if [ -f $orieth1 ]
		then
			cp $orieth1 $neweth1.`date +%F-%T`
		fi

			echo "DEVICE=eth0" >$orieth0
			echo "BOOTPROTO=none" >>$orieth0
			echo "MASTER=bond0" >>$orieth0
			echo "SLAVE=yes" >>$orieth0
			echo "ONBOOT=yes" >>$orieth0
			echo "HWADDR=$hw_eth0" >>$orieth0
			#sed -i '/HWADDR/c\HWADDR='$hw_eth0'' $orieth0 
			echo "IPV6INIT=no" >>$orieth0
			echo "TYPE=Ethernet" >>$orieth0
			echo "PEERDNS=yes" >>$orieth0
			echo "USERCTL=no" >>$orieth0

			echo "DEVICE=eth1" >$orieth1 
			echo "BOOTPROTO=none" >>$orieth1 
			echo "MASTER=bond0" >>$orieth1 
			echo "SLAVE=yes" >>$orieth1 
			echo "ONBOOT=yes" >>$orieth1 
			echo "HWADDR=$hw_eth1" >>$orieth1 
			#sed -i '/HWADDR/c\HWADDR='$hw_eth1'' $orieth1 
			echo "IPV6INIT=no" >>$orieth1 
			echo "TYPE=Ethernet" >>$orieth1 
			echo "PEERDNS=yes" >>$orieth1 
			echo "USERCTL=no" >>$orieth1

		echo -e "\ncat $oribond"
		cat $oribond
		echo -e "\ncat $orieth0"
		cat $orieth0
		echo -e "\ncat $orieth1"
		cat $orieth1
		echo
	fi
	echo
}

##########################################################################
ntp()
{
	echo -n "Do you want to configure ntp client?[y|n]"
	read myselect
	if [[ "$myselect" = "y" || "$myselect" = "Y" ]];
	then
		unset myselect
		clear
		orifile=/var/spool/cron/root
		newfile=/root/root

		if [ -f $orifile ]
		then
			sed "/ntpdate/d" $orifile > $newfile
		else
			touch $orifile
		fi

		if grep ntpdate $orifile > /dev/null
		then
			for i in `sed -n '/ntpdate/p' $orifile | awk '{print $7 }'`
			do
				((num++))
				echo -n "Please input the new ntp server ip-addr. server $num's ip [$i]:"
				#read ntpip[$sum]
				read ntpip
				if [ "$ntpip" = "" ]
				then
					ntpip=$i
				fi
				echo "$num * * * * /usr/sbin/ntpdate $ntpip" >> $newfile
			done
			unset num
		else
			echo "You can assign max two ntp server's ip!"
			echo
			for (( i = 0; i < 2; i++ )); do
				echo -n "Please input the new ntp server ip-addr:"
				read ntpip
				if [ ! "$ntpip" = "" ]
				then
					echo "$i * * * * /usr/sbin/ntpdate $ntpip" >> $newfile
				fi
			done
		fi
		cp $newfile $orifile
		echo
		echo "This new root's crontab is"
		crontab -l
		/usr/sbin/ntpdate $ntpip
		echo
		echo
	fi
	echo
}

##########################################################################
dns()
{
	echo -n "Do you want to configure dns service?[y|n]"
	read myselect
	if [[ "$myselect" = "y" || "$myselect" = "Y" ]]; then
		unset myselect
		clear
		echo -n "You can assign max two dns server's ip!\n"
		for (( i = 0; i < 2; i++ )); do
				echo -n "Please input the new dns server ip-addr:"
				read dnsip
				echo "nameserver" $dnsip >> /etc/resolv.conf
		done
	fi
	echo
}

##########################################################################
autostart()
{
	echo -n "Do you want to active network now?[y|n]"
	read myselect
	if [[ "$myselect" = "y" || "$myselect" = "Y" ]]; then
		unset myselect
		clear
		service network restart >/dev/null 2>&1
		service network restart
	fi
	echo
}

##########################################################################
for (( j = 1; ; j++ )); 
do
	menu
	case "$choice" in
		"1")
			hosts
			;;
		"2")
			gateway
			;;
		"3")
			bond
			;;
		"4")
			autostart
			;;
		"5")
			ntp
			;;
		"6")
			dns
			;;
		"7")
			reboot
			;;
		"8")
			;;
		"a")
			gateway
			hosts
			bond
			ntp
			dns
			autostart
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