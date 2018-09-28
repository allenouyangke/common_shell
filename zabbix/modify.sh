#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name: 	modify.sh
# Revision: 	1.0
# Date: 		2018/06/12
# Author: 		AllenKe
# Email: 		allenouyangke@icloud.com
# Description:	用于修改zabbix_agentd的配置文件。
# -------------------------------------------------------------------------------

CONFIGFILE="/etc/zabbix/zabbix_agentd.conf"

sed -i \"s/103.227.130.62/111.230.111.131/g\" ${CONFIGFILE}

/etc/init.d/zabbix-agent restart