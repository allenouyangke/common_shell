#!/usr/bin/bash

 # 关闭非常必要的服务
 function CLOSE_SERVER(){
   /etc/init.d/postfix stop;
   /etc/init.d/iptables stop;
   /etc/init.d/ip6tables stop;

   chkconfig postfix off;
   chkconfig iptables off;
   chkconfig ip6tables off;
   chkconfig ntpd on;
   chkconfig --list;
 }

# 关闭selinux
function CLOSE_SELINUX() {
   cp -rpv /etc/selinux/config /etc/selinux/config_$(date +%F).bak

   SELINUX_STATUS=`egrep ^SELINUX=/etc/selinux/config | awk -F "=" '{print $2}'`;
   echo "Selinux status: ${SELINUX_STATUS}";

   if [[ "${SELINUX_STATUS}" != "disabled" ]]; then
     sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config;
     SELINUX_STATUS=`egrep ^SELINUX= /etc/selinux/config | awk -F "=" '{print $2}'`;
     if [[ "${SELINUX_STATUS}" == "disabled" ]]; then
       echo "Selinux is disabled,please reboot the system after other process.";
     else
       echo "Disable Selinux faild,please do it manually.";
     fi
   fi
 }

 # 修改主机名
function HOSTNAME() {
  cp -rpv /etc/sysconfig/network /etc/sysconfig/network_$(date +%F).bak;

  # IDC域名，可以添加在hostname的后面
  IDC_DOMAIN="bjyz.dajie-inc.com";

  echo "Please enter new host name in form XXX-XXX (use Ctrl+u to delete input) : ";
  read -p "New host name:" NEW_HOST_NAME;
  sed -i "s/^HOSTNAME=.*/HOSTNAME=${NEW_HOST_NAME}.${IDC_DOMAIN}/" /etc/sysconfig/network
  HOST_NAME=`echo "${NEW_HOST_NAME}.${IDC_DOMAIN}"`;
  hostname ${HOSTNAME};
}

# 添加相关用户
function NEW_USER() {
  echo -e "Do you need to add new users (Y/y/N/n) : "
  read num

  if [[ "${num}" == "N|n" ]]; then
    echo "The step is being skipped!"
  else
    NEW_USERS="webmaster zabbix";
    for ADD_USER in ${NEW_USERS}
    do
        OLD_USER=`egrep ^$ADD_USER /etc/passwd`;
        if [[ "${OLD_USER}" = '' ]]; then
          echo "Add user: ${ADD_USER}";
          useradd ${ADD_USER};
        else
          echo "${ADD_USER} is exist,no need to add it!"
        fi
    done;
  fi
}

# 初始化ops目录
function OPS_INIT() {
  NEW_DIR="/ops/server /ops/logs /ops/script /ops/project /ops/install /ops/backup"

  if [[ -d /ops ]]; then
    for MAKE_DIR in ${NEW_DIR}
    do
      if [[ ! -d ${MAKE_DIR} ]]; then
        echo "Making dir: ${MAKE_DIR}";
        mkdir -p ${MAKE_DIR};
      else
        echo "${MAKE_DIR} is already here,no need to make it.";
      fi
    done;
  else
    echo "There is no /ops,let's make it and go on";
    mkdir /ops;
    for MAKE_DIR in ${NEW_DIR}
    do
      if [[ ! -d ${MAKE_DIR} ]]; then
        echo "Making dir: ${MAKE_DIR}";
        mkdir -p ${MAKE_DIR}
      else
        echo "${MAKE_DIR} is already here,no need to make it.";
      fi
    done
  fi

  OLD_USER=`egrep ^webmaster /etc/passwd | awk -F: '{print $1}'`;
  if [[ "${OLD_USER}" = 'webmaster' ]]; then
    chown -R webmaster.webmaster /ops
  fi
}


# 修改yum源
function YUM_REPO() {
  YUM_PATH="/etc/yum.repos.d/CentOS-Base.repo"
  mv ${YUM_PATH} ${YUM_PATH}.$(date +%F).bak

  OS_VER=`cat  /etc/redhat-release | awk  '{print $3}' | awk -F. '{print $1}'`
  if [[ "${OS_VER}" = 7 ]]; then
    wget http://mirrors.163.com/.help/CentOS7-Base-163.repo -P /etc/yum.repos.d/
  elif [[ "${OS_VER}" = 6 ]]; then
    wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -P /etc/yum.repos.d/
  elif [[ "${OS_VER}" == 5 ]]; then
    wget http://mirrors.163.com/.help/CentOS5-Base-163.repo -P /etc/yum.repos.d/
  else
    echo "There is no appropriate yum repos to update!"
  fi

  # 生成缓存
  yum makecache

  # 更新/升级yum源
  yum -y update
}

# zabbix-agent客户端配置
function ZABBIX_AGENT() {
  yum install zabbix-agent -y
  ZABIX_SERVER=103.227.130.62

}


################################################################################
function menu()
{
	clear
	scriptname="CentOS6"
	version=1.0.0
	date=`date +%F.%T`

	cat << MENULIST
=========================================================================
	ScriptName:$scriptname   	Version:$version   	Date&Time:$date
=========================================================================
This shell script can automatically complete the following configuration:
			1.Close unused services
			2.Close SELinux
			3.Modify hostname
			4.Add new users
      5.Init ops dir
      6.Switch yum repos
=========================================================================
MENULIST

	echo -n "Please input your choice [1,2,3,4,5,6,b(back)],q(quit),a(all)]:"
	read choice
}


################################################################################
for (( j = 1; ; j++ ));
do
	menu
	case "$choice" in
		"1")
			CLOSE_SERVER
			;;
		"2")
			CLOSE_SELINUX
			;;
		"3")
			HOSTNAME
			;;
		"4")
			ADD_USER
			;;
    "5")
      OPS_INIT
      ;;
    "6")
      YUM_REPO
      ;;
		"a")
			CLOSE_SERVER
      CLOSE_SELINUX
      HOSTNAME
      ADD_USER
      OPS_INIT
      YUM_REPO
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
