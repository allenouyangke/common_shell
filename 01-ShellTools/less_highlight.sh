#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : less_highlight.sh
# Revision     : 1.0
# Date         : 2018/09/11
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : 设置less支持语法高亮。
# -------------------------------------------------------------------------------

# source /ops/com/global_vars.sh && source /ops/com/global_funcs.sh

PATH_FILE="/root/.bash_profile"

yum install source-highlight -y

cat >> ${PATH_FILE} << EOF
LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
LESS=' -R '
export LESSOPEN LESS
EOF

#. ${PATH_FILE}