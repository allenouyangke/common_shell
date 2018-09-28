#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name: 
# Revision:    1.0
# Date:        
# Author:      AllenKe
# Email:       allenouyangke@icloud.com
# Description: 
# -------------------------------------------------------------------------------

RES=`netstat -tulnp |grep mysql|awk -F "[ :]+" '{print $4}'`
PORT=($RES)
printf '{\n'
printf '\t"data":[\n'
for key in ${!PORT[@]}
do
    if [[ "${#PORT[@]}" -gt 1 && "${key}" -ne "$((${#PORT[@]-1}))" ]];then
        printf '\t\t {'
        printf "\"{#MYSQLPORT}\":\"${PORT[${key}]}\"},\n"
    else [[ "${key}" -eq "((${#PORT[@]}-1))" ]]
        printf '\t\t {' 
        printf "\"{#MYSQLPORT}\":\"${PORT[${key}]}\"}\n"
    fi
done
printf '\t ]\n'
printf '}\n'

