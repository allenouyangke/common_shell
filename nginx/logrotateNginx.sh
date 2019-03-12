#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : logrotateNginx.sh
# Revision     : 1.0
# Date         : 2018/10/22
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------

$ vi /etc/logrotate.d/nginx

/usr/local/nginx/logs/www.willko.cn.log /usr/local/nginx/logs/nginx_error.log {
notifempty
daily
sharedscripts;
postrotate
/bin/kill -USR1 `/bin/cat /usr/local/nginx/nginx.pid`
endscript
}