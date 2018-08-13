#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : rsync.sh
# Revision     : 1.0
# Date         : 2018/08/11
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : Rsync控制脚本。
# -------------------------------------------------------------------------------
  
status1=$(ps -ef | egrep "rsync --daemon.*rsyncd.conf" | grep -v 'grep') 
pidfile="/var/run/rsyncd.pid"
start_rsync="rsync --daemon --config=/etc/rsyncd/rsyncd.conf" 
  
function rsyncstart() { 
    if [ "${status1}X" == "X" ];then 
        rm -f $pidfile       
        ${start_rsync}   
        status2=$(ps -ef | egrep "rsync --daemon.*rsyncd.conf" | grep -v 'grep') 
        if [  "${status2}X" != "X"  ];then 
            echo "rsync service start.......OK"   
        fi 
    else 
        echo "rsync service is running !"    
    fi 
} 
  
function rsyncstop() { 
    if [ "${status1}X" != "X" ];then 
        kill -9 $(cat $pidfile) 
        status2=$(ps -ef | egrep "rsync --daemon.*rsyncd.conf" | grep -v 'grep') 
        if [ "${statusw2}X" == "X" ];then 
            echo "rsync service stop.......OK" 
        fi 
    else 
        echo "rsync service is not running !"    
    fi 
} 
  
  
function rsyncstatus() { 
    if [ "${status1}X" != "X" ];then 
        echo "rsync service is running !"   
    else 
         echo "rsync service is not running !"  
    fi 
} 
  
function rsyncrestart() { 
    if [ "${status1}X" == "X" ];then 
               echo "rsync service is not running..." 
               rsyncstart 
        else 
               rsyncstop 
               rsyncstart    
        fi       
}  
  
case $1 in 
        "start") 
               rsyncstart 
                ;; 
        "stop") 
               rsyncstop 
                ;; 
        "status") 
               rsyncstatus 
               ;; 
        "restart") 
               rsyncrestart 
               ;; 
        *) 
          echo 
                echo  "Usage: $0 start|stop|restart|status" 
          echo 
esac