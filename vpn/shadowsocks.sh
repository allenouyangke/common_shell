#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================================
#   System Required:  CentOS 6,7, Debian, Ubuntu
#   Description: One click Install Shadowsocks-Python server
#===============================================================================================

clear
echo "#############################################################"

# Make sure only root can run our script
function rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error:This script must be run as root!" 1>&2
       exit 1
    fi
}

# Disable selinux
function disable_selinux(){
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi
}

# Pre-installation settings
function pre_install(){
    # Set shadowsocks config password
    echo "Please input password for shadowsocks:"
    read -p "(Default password: 123456):" shadowsockspwd
    [ -z "$shadowsockspwd" ] && shadowsockspwd="123456"
    echo ""
    echo "---------------------------"
    echo "password = $shadowsockspwd"
    echo "---------------------------"
    echo ""
    # Set shadowsocks config port
    while true
    do
    echo -e "Please input port for shadowsocks-python [1-65535]:"
    read -p "(Default port: 9388):" shadowsocksport
    [ -z "$shadowsocksport" ] && shadowsocksport="9388"
    expr $shadowsocksport + 0 &>/dev/null
    if [ $? -eq 0 ]; then
        if [ $shadowsocksport -ge 1 ] && [ $shadowsocksport -le 65535 ]; then
            echo ""
            echo "---------------------------"
            echo "port = $shadowsocksport"
            echo "---------------------------"
            echo ""
            break
        else
            echo "Input error! Please input correct numbers."
        fi
    else
        echo "Input error! Please input correct numbers."
    fi
    done
    get_char(){
        SAVEDSTTY=`stty -g`
        stty -echo
        stty cbreak
        dd if=/dev/tty bs=1 count=1 2> /dev/null
        stty -raw
        stty echo
        stty $SAVEDSTTY
    }
    echo ""
    echo "Press any key to start...or Press Ctrl+C to cancel"
    char=`get_char`
    #Install necessary dependencies
    yum install -y epel-release wget
	yum --disablerepo=epel -y update ca-certificates  
	yum install -y python-setuptools m2crypto supervisor
	echo "----------pip-----------------"
    #easy_install pip
	wget https://pypi.python.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz#md5=35f01da33009719497f01a4ba69d63c9 --no-check-certificate
	tar zxvf pip-9.0.1.tar.gz
	cd pip-9.0.1
	python setup.py install
	echo "------shadowsocks-------------"
    pip install shadowsocks

  
    #Current folder
    cur_dir=`pwd`
    cd $cur_dir
}



# Config shadowsocks
function config_shadowsocks(){
    cat > /etc/shadowsocks.json << EOF
{
    "server":"0.0.0.0",
    "server_port":${shadowsocksport},
    "local_port":1080,
    "password":"${shadowsockspwd}",
    "timeout":600,
    "method":"aes-256-cfb"
}
EOF
}
function supervisord_conf(){
    cat >>/etc/supervisord.conf <<-EOF
	[program:shadowsocks]
	command=ssserver -c /etc/shadowsocks.json
	autostart=true
	autorestart=true
	user=root
	log_stderr=true
	logfile=/var/log/shadowsocks.log
EOF
}

function rc_local(){
    cat >> /etc/rc.local <<-EOF
	service supervisord start
EOF
}


# iptables set
function iptables_set(){
    echo "iptables start setting..."
    /sbin/service iptables status 1>/dev/null 2>&1
    if [ $? -eq 0 ]; then
        /etc/init.d/iptables status | grep '${shadowsocksport}' | grep 'ACCEPT' >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            /sbin/iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${shadowsocksport} -j ACCEPT
            /etc/init.d/iptables save
            /etc/init.d/iptables restart
        else
            echo "port ${shadowsocksport} has been set up."
        fi
    else
        echo "iptables looks like shutdown, please manually set it if necessary."
    fi
}

# Install Shadowsocks
function install_ss(){
    service supervisord start
    clear
    echo -e "Your Server Port: \033[41;37m ${shadowsocksport} \033[0m"
    echo -e "Your Password: \033[41;37m ${shadowsockspwd} \033[0m"
    echo -e "Your Local Port: \033[41;37m 1080 \033[0m"
    echo -e "Your Encryption Method: \033[41;37m aes-256-cfb \033[0m"
    echo ""
    exit 0
}
function install_shadowsocks(){
    rootness
    disable_selinux
    pre_install
	config_shadowsocks
    supervisord_conf
	rc_local
    iptables_set	
    install_ss
}

# Initialization step
action=$1
[  -z $1 ] && action=install
case "$action" in
install)
    install_shadowsocks
    ;;
*)
    echo "Arguments error! [${action} ]"
    echo "Usage: `basename $0` {install|uninstall}"
    ;;
esac

