#!/bin/bash

#读取生日的日期（只能匹配新历）
read -p "Pleas input your birthday (MMDD, ex> 0709): " bir

#获取目前的时间，输出格式为MMDD
now=`date +%m%d`

#判断当前的时间与输入的时间是否一致
if [ "$bir" == "$now" ]; then
        echo "Happy Birthday to you!!!"
#判断输入的日期是否大于当前日期
elif [ "$bir" -gt "$now" ]; then
        year=`date +%Y`
        # +%s参数：自UTC 时间 1970-01-01 00:00:00 以来所经过的秒数
        # 两个相减得到多的秒数，除以60，60，24最终得到离生日的天数
        total_d=$(($((`date --date="$year$bir" +%s`-`date +%s`))/60/60/24))
        echo "Your birthday will be $total_d later"
else
        year=$((`date +%Y`+1))
        total_d=$(($((`date --date="$year$bir" +%s`-`date +%s`))/60/60/24))
        echo "Your birthday will be $total_d later"
fi