#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name : access_log_cut.sh
# Revision : 1.0
# Date : 2018/09/30
# Author : AllenKe
# Email : allenouyangke@icloud.com
# Description :
# -------------------------------------------------------------------------------

LOG_FILE="/var/log/nginx/access.log"

LAST_HOUT=1

# Start time.
START_TIME=`data -d "${LAST_HOUT} hour ago" +"%H:%M:%S"`
# End time.
END_TIME=`date +"%H:%M:%S"`

# Get the host ip address
HOST_IP=`ip addr | grep eth0 | awk 'BEGIN{FS="([[:space:]]|/)+"}NR==2{print $3}'`
# Output log file.
FILETER_IP="/"
