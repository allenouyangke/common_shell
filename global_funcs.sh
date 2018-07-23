#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name   : 	global_funcs.sh
# Revision      : 	1.0
# Date          : 	2018/07/23
# Author        : 	AllenKe
# Email         : 	allenouyangke@icloud.com
# Description   :	定义通用的shell函数，方便未来调用。
# Usage         :   source global_funcs.sh
# -------------------------------------------------------------------------------

# 遇到不存在的变量就会报错，并停止执行。
# set -u
set -o nounset

# 定义详细时间输出，格式：20180723111224
function F_DATE
{
    date +"%Y%m%d%H%M%S"
}

# 定义日期输出，格式：date +"%Y%m%d"
function F_TODATE
{
    date +"%Y%m%d"
}