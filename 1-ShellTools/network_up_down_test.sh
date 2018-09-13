#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : network_up_down_test.sh
# Revision     : 1.0
# Date         : 2018/09/13
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 使用speedtest.py测试本地上下行网速及网络延迟
# -------------------------------------------------------------------------------

wget https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py -P /tmp/

chmod a+rx /tmp/speedtest.py

mv /tmp/speedtest.py /usr/local/bin/speedtest-cli

chown root:root /usr/local/bin/speedtest-cli

speedtest-cli