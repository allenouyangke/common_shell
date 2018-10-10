#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : ntpdateControl.sh
# Revision     : 1.0
# Date         : 2018/10/10
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 设置常用海外的地区的时间同步
# http://www.ntp.org.cn/pool.php
# -------------------------------------------------------------------------------

function ZoneList
{
    cat <<EOF
    cn        Asia/Shanghai       中国上海          
    vn        Asia/Saigon         越南胡志明市      
    kr        Asia/Seoul          韩国汉城          
    jp        Asia/Tokyo          日本东京          
    de        Europe/Dublin       德国都柏林        
    sg        Asia/Singapore      新马地区   
    us        America/St_Thomas   美国圣托马斯
EOF
    read -p "Please enter the zoneid(eg: cn):" ZONEID
    case ${ZONEID} in
    cn|CN) ZONE="Asia/Shanghai" ;;
    vn|VN) ZONE="Asia/Saigon" ;;
    kr|KR) ZONE="Asia/Seoul" ;;
    jp|JP) ZONE="Asia/Tokyo" ;;
    de|DE) ZONE="Europe/Dublin" ;;
    sg|SG) ZONE="Asia/Singapore" ;;
    us|US) ZONE="America/St_Thomas" ;;
    *) Usage: Please choose from cn|vn|kr|jp|de|sg|us. ;;
    esac
}

function SetTimeZone
{
    rm -rf /etc/localtime
    \cp /usr/share/zoneinfo/${1} /etc/localtime
}

function SetTimeCrond
{
    local CRONDPATH="/var/spool/cron/root"
    if [ ! -f ${CRONDPATH} ];then touch ${CRONDPATH};fi
    local CRONTNUM=`grep ntpdate /var/spool/cron/root | wc -l`
    if [ ${CRONTNUM} -eq 0 ];then
        echo "0 1 * * * /usr/sbin/ntpdate cn.ntp.org.cn" >> ${CRONDPATH}
        /usr/sbin/ntpdate cn.ntp.org.cn
        service crond restart
    fi
}

function Main
{
    ZoneList
    SetTimeZone ${ZONE}
    SetTimeCrond
    echo "Ntpdate successful!"
    date -R
}

Main