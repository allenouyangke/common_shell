#!/usr/bin/env python
#-*- coding: utf-8 -*-
# -------------------------------------------------------------------------------
# Script_name: 	zabbix_batch.py
# Revision: 	1.0
# Date: 		2018/06/14
# Author: 		AllenKe
# Email: 		allenouyangke@icloud.com
# Description:	用于Zabbix的批量操作。
# Source:       https://www.jianshu.com/p/e087cace8ddf
# -------------------------------------------------------------------------------

import os
import sys
import argparse

# 导入zabbix_api_tools的zabbix_api
from zabbix_api_tools import zabbix_api

reload(sys)
sys.setdefaultencoding('utf-8')

host_file = 'serlist.txt'
base_templates = "'Template OS Linux,Linux disk to monitor'"
cmd = 'python zabbix_api_tools.py'

# 实例化zabbix_api
zabbix=zabbix_api()

def create_hosts():
    groups = raw_input("请输入组名：")
    # add_templates = raw_input("请输入模块名：")
    templates = base_templates # + add_templates
    cmd1 = cmd + ' -A ' + groups
    os.system(cmd1)

    # with open(host_file) as fb:
    #     host_info = dict(line.strip().split(',') for line in fb)
    
    # for hostname in host_info:
    #     cmd2 = cmd + ' -C ' + host_info[hostname] + ' ' + \
    #         groups + ' ' + templates + ' ' + hostname + visibleName
    #     os.system(cmd2)

    with open(host_file) as fb:
        host_info = list(line.strip().split(',') for line in fb)

    num = len(host_info[:])

    for host in range(num):
        hostip = host_info[host][0]
        hostname = host_info[host][1]
        visibleName = host_info[host][2]
        cmd2 = cmd + ' -C ' + hostip + ' ' + groups + ' ' + templates + ' ' + hostname + ' ' + visibleName
        os.system(cmd2)
    
    # 如果本机是salt，target文件可以只写主机名，然后用salt获取ip，代码修改如下：
    # with open(host_file) as fb:
    #     host_info = list(line.strip() for line in fb)
    
    # for hostname in host_info:
    #     ip_cmd='salt ' + hostname + ' grains.item fqdn_ip4|xargs'
    #     ip = os.popen(ip_cmd).read().split()[4]
    #     cmd2 = cmd + ' -C ' + ip + ' ' + groups + ' ' + templates + ' ' + hostname
    #     os.system(cmd2)

def get_hosts():
    with open(host_file) as fb:
        # [zabbix.host_get(line.strip()) for line in fb]
        [zabbix.host_get(line.strip().split(',')[0]) for line in fb]

def delete_hosts():
    with open(host_file) as fb:
        [zabbix.host_delete(line.strip().split(',')[0]) for line in fb]

def enable_hosts():
    with open(host_file) as fb:
        [zabbix.host_enable(line.strip().split(',')[0]) for line in fb]

def disable_hosts():
    with open(host_file) as fb:
        [zabbix.host_disable(line.strip().split(',')[0]) for line in fb]


if __name__ == "__main__":
    if len(sys.argv) == 1 or sys.argv[1] == '-h':
        print "\033[041m 请选择如下操作：\033[0m"
        print """
        \033[042m python zabbix_batch.py -A \033[0m  # 批量添加主机
        \033[042m python zabbix_batch.py -C \033[0m  # 批量查询主机   
        \033[042m python zabbix_batch.py -D \033[0m  # 批量删除主机
        \033[042m python zabbix_batch.py -e \033[0m  # 批量开启主机
        \033[042m python zabbix_batch.py -d \033[0m  # 批量禁止主机
        """
        print "\033[041m serlist.txt格式说明：\033[0m"
        print """
        \033[042m hostip,hostname,visibleName \033[0m

        eg:
        111.111.111.111,111.111.111.111,S3_XM_Game_111.111.111.111
        222.222.222.222,222.222.222.222,S3_XM_Game_222.222.222.222
        """

    else:
        if sys.argv[1] == '-A':
            create_hosts()
        elif sys.argv[1] == '-C':
            get_hosts()
        elif sys.argv[1] == '-D':
            delete_hosts()
        elif sys.argv[1] == '-e':
            enable_hosts()
        elif sys.argv[1] == '-d':
            disable_hosts()
