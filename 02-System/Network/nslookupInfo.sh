#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : nslookupInfo.sh
# Revision     : 1.0
# Date         : 2018/12/11
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------

DOMAINLIST=(

)

>./nslookup.Info

for DOMAIN in ${DOMAINLIST[@]}
do 
    echo;echo ========== Analysis ${DOMAIN} ==========
    nslookup ${DOMAIN}
    echo ========== The End  ${DOMAIN} ==========
done