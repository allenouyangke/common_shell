#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : return_usage.sh
# Revision     : 1.0
# Date         : 2018/09/12
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : return的用法
# -------------------------------------------------------------------------------

function ReturnTest()
{
    echo "arg1 = $1"
    if [ $1 = "1" ];then
        return 1
    else
        return 0
    fi
}

echo;echo "ReturnTest 1"
ReturnTest 1
echo $?         # Print return result.

echo;echo "ReturnTest 0"
ReturnTest 0
echo $?         # Print return result.

echo;echo "ReturnTest 2"
ReturnTest 2
echo $?         # Print return result.

echo;echo "ReturnTest 0 = "`ReturnTest 0`
if ReturnTest 0;then
    echo "ReturnTest 0"
fi

echo;echo "if false"            # If 0 is error.
if false;then
    echo "ReturnTest 0"
fi

echo
ReturnTest 0
res=`echo $?`           # Get return result.
if [ ${res} "0" ];then
    echo "ReturnTest 0"
fi

echo;echo "End! "

exit 0