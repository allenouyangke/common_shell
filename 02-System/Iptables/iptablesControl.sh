#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : iptablesControl.sh
# Revision     : 1.0
# Date         : 2018/11/12
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 
# -------------------------------------------------------------------------------

ADDSCRIPT="iptablesAdd.sh"
DELSCRIPT="iptablesDel.sh"

function CheckScript
{
    if [ -e "${1}" ];then
        BACKTIME=`date +%Y%m%d%H%M%S`
        cp ${1} ${1}-${BACKTIME}.backup
        > ${1}
    fi
}

function NextStep
{
    if [ "${1}" == "n" -o "${1}" == "N" ];then 
        break 
    fi
}

# ===============================================================================
# 1
function IptablesResatrt
{
    echo -e "`service iptables restart &`"
}


# ===============================================================================
# 2
# 2-1
function AddIP
{
    echo -n "Please enter IP address:"
    read IPADDR
    iptables -A INPUT -s ${ip} -p tcp --dport 22 -j ACCEPT
    echo "iptables -A INPUT -s ${ip} -p tcp --dport 22 -j ACCEPT" >>./${ADDSCRIPT}
    service iptables save
}

# 2-2
function AddPort
{
    echo -n "Please enter Port:"
    read PORT
    if [ ${PORT} -lt 0 ] || [ ${PORT} -gt 65535 ];then
        echo "This is Port is Unlawful."
        continue
    fi
    iptables -A INPUT -p tcp --dport ${PORT}  -j ACCEPT
    echo "iptables -A INPUT -p tcp --dport ${PORT}  -j ACCEPT" >>./${ADDSCRIPT}
    service iptables save
}

# 2-3
function AddSerACL
{
    echo -n "Please enter IP address:"
    read IPADDR
    echo -n "Please enter Port:"
    read PORT
    if [ ${PORT} -lt 0 ] || [ ${PORT} -gt 65535 ];then
        echo "This is Port is Unlawful."
        continue
    fi
    iptables -A INPUT -p tcp -s ${IPADDR} --dport ${PORT} -j ACCEPT
    echo "iptables -A INPUT -p tcp -s ${IPADDR} --dport ${PORT} -j ACCEPT" >>./${ADDSCRIPT}
    service iptables save
}

# 2-4 3-4
function AddDelNew
{
    echo -n "Please enter iptables rules:"
    read IPTABLESRULES
    `${IPTABLESRULES}`
    if [ "${1}" == Add ];then
        echo "${IPTABLESRULES}" >>./${ADDSCRIPT}
    elif [ "${1}" == Del ];then
        echo "${IPTABLESRULES}" >>./${DELSCRIPT}
    fi
    service iptables save
}

# 2-0
function IptablesAdd
{
    CheckScript ${ADDSCRIPT}
    while true
    do
        clear
        cat <<EOF
----------------------------------Aadd ACL-------------------------------------

            (1) 针对源IP放行添加
            (2) 针对服务器端口放行添加
            (3) 针对有端口和服务的ACL添加（这里要参数IP和端口 例如 0/0 80）
            (4) 自定义添加
            (5) 退回上一级

-------------------------------------------------------------------------------
EOF
        echo -n "Enter you chose[0-4]:"
        read ACLNUM
        
        case ${ACLNUM} in
            1) AddIP ;;
            2) AddPort ;;
            3) AddSerACL ;;
            4) AddDelNew Add ;;
            5) break ;;
            *)  echo "This is not between 0-7" && read && continue;;
        esac

        echo -n "是否继续添加/删除: [y/n]:" 
        read OPTION
        NextStep ${OPTION}
    done
}

# ===============================================================================
# 3
# 3-1
function DelIP
{
    echo -n "Please enter IP address:"
    read IPADDR
    iptables -D INPUT -s ${IPADDR} -p tcp --dport 22 -j ACCEPT
    echo "iptables -D INPUT -s ${IPADDR} -p tcp --dport 22 -j ACCEPT" >>./${DELSCRIPT}
    service iptables save
}

# 3-2
function DelPort
{
    echo -n "Please enter Port:"
    read PORT
    if [ ${PORT} -lt 0 ] || [ ${PORT} -gt 65535 ];then
        echo "This is Port is Unlawful."
        continue
    fi
    iptables -D INPUT -p tcp --dport ${PORT}  -j ACCEPT
    echo "iptables -D INPUT -p tcp --dport ${PORT}  -j ACCEPT" >>./${ADDSCRIPT}
    service iptables save
}

# 3-3
function DelSerACL
{
    echo -n "Please enter IP address:"
    read IPADDR
    echo -n "Please enter Port:"
    read PORT
    if [ ${PORT} -lt 0 ] || [ ${PORT} -gt 65535 ];then
        echo "This is Port is Unlawful."
        continue
    fi
    iptables -D INPUT -p tcp -s ${IPADDR} --dport ${PORT} -j ACCEPT
    echo "iptables -D INPUT -p tcp -s ${IPADDR} --dport ${PORT} -j ACCEPT" >>./${ADDSCRIPT}
    service iptables save
}

# 3-0
function IptablesDel
{
    CheckScript ${DELSCRIPT}
    while true
    do
        clear
        cat <<EOF
----------------------------------Delete ACL----------------------------------
            (1) 针对源ip删除
            (2) 针对端口删除
            (3) 针对有端口和服务的ACL删除
            (4) 自定义删除 
            (5) 退回上一级 
-------------------------------------------------------------------------------
EOF
        echo -n "Enter your chose[0-5]:"
        read ACLNUM

        case ${ACLNUM} in
            1) DelIP ;;
            2) DelPort ;;
            3) DelSerACL ;;
            4) AddDelNew Del ;;
            5) break ;;
            *) echo "This is not between 0-7" && read && continue ;;
        esac
        
        echo -n "是否继续添加/删除: [y/n]:" 
        read OPTION
        NextStep ${OPTION}
    done
}

# ===============================================================================
# 4
function IptablesStop
{
    echo -e "`service iptables stop &` "
}

# ===============================================================================
# 5
function IptablesSave
{
    echo -e "`service iptables save &`"
}

# ===============================================================================
# 6
function IptablesStatus
{
    echo -e "`service iptables status &`"
}

# ===============================================================================
# 7
function IptablesACLList
{
    while true
    do
        clear
        cat <<EOF
----------------------------------List ACL-------------------------------------

            (1) 查看当前正在使用的规则集
            (2) 查看每个策略或每条规则、每条链的简单流量统计
            (3) 查看NAT表
            (4) 自定义查看
            (5) 退回上一级

-------------------------------------------------------------------------------
EOF
        echo -n "Enter your chose[0-5]:"
        read ACLNUM

        case ${ACLNUM} in
            1) iptables -L ;;
            2) iptables -L -n -v ;;
            3) iptables -L -t nat ;;
            4) AddDelNew status ;;
            5) break ;;
        esac

        echo -n "是否想继续添加: [y/n]:" 
        read OPTION
        NextStep ${OPTION}
    done
}


# ===============================================================================
function Main
{
    while true
    do
        clear
        cat <<EOF
----------------------------------Menu-----------------------------------------

                    (1) service iptables restart
                    (2) iptables add
                    (3) iptables delete
                    (4) iptables stop
                    (5) iptables save(不推荐使用这种模式)
                    (6) iptables status
                    (7) iptables ACL list
                    (0) exit
                    会在当前的目录下生成一个fw.sh文件
                    
-------------------------------------------------------------------------------
EOF
        echo -n "Enter you chose[0-7]:"
        read NUM

        case ${NUM} in
            1) IptablesResatrt ;;
            2) IptablesAdd ;;
            3) IptablesDel ;;
            4) IptablesStop ;;
            5) IptablesSave ;;
            6) IptablesStatus ;;
            7) IptablesACLList ;;
            0) exit ;;
            *) echo "This is not between 0-7" && read && continue ;;
        esac

        echo -n "是否继续添加/删除: [y/n]:" 
        read OPTION
        NextStep ${OPTION}
    done
}

Main