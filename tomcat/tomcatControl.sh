#!/bin/sh
LANG=zh_CN.UTF-8

. ~/script/yw_profile

serverHome="/home/$PROJ_NAME"
killLog="/home/$PROJ_NAME/logs/killTomcat.log"
all=(tomcat)      ######### add temp site here if necessary #######
sleepTime=20
timeStep=1
errorFlag=0
hostname=`hostname`
scriptLocate=$0
serviceType=$1
if [[ ${serviceType} == 'tomcat' ]];then
   serviceType='web'
fi
warnFile="/tmp/zabbix_${serviceType}_id.txt"
warnValues="${LOCALHOST}"

help()	{
	echo "Usage: $0  `echo ${all[@]} | sed 's# #|#g'`|all  start|stop|restart|check"
	exit 0
}

checkPara()	{
    local project=$1
    case $project in
        'tomcat')   return 100  ;;
    esac
    [ -d "$serverHome/tomcat_$project" ] && return 1 
    [ -d "$serverHome/tomcat-$project" ] && return 2
    [ -d "$serverHome/$project" ] && return 3
    [ -d $(find $serverHome -maxdepth 1 -type d -name "*$project") ] && return 4
	return 0
}

getPid()    {
    ps -ef | grep "$1" | grep -v grep | awk '{print $2 }'
}

changPath() {
    if [ ! -d ~/logs/$1 ];then
        mkdir -p ~/logs/$1
    fi
    cd ~/logs/$1
}

checkTomcat()	{
    pid=$(getPid "$1")
    local processNum=`ps -ef | grep "$1" | grep -v grep | wc -l`
    (( $processNum > 1 )) && return 2
	if [[ $pid != "" ]];then
		startTime=`ps -ef | grep "$1" | grep -v grep | awk '{print $5 }'`
		return 1
	fi
	return 0
}

startTomcat()	{
    if [ -d $1/work ]; then
        echo "Deleting the $1/work"
        rm -rf $1/work/*
        if (( $? != 0 ));then
            error "delete work cache error"
            errorFlag=1
            return 3 
        fi
    else
        error "locate $1 error"
        errorFlag=1
        return 3
    fi
    echo "Deleting the $1/logs/catalina.out"
    >$1/logs/catalina.out

    [ ! -d $1/logs ] && mkdir $1/logs
    [ ! -d $1/work ] && mkdir $1/work
    id java &> /dev/null && chown -R java:java $1
    id java &> /dev/null && chown -R java:java /home/logs/
    [ -e /home/logs/hadoop ] && chown -R hadoop:hadoop /home/logs/hadoop
    [ -e /home/logs/hbase ] && chown -R hadoop:hadoop /home/logs/hbase
	info "Executing startup.sh"
    if id java &> /dev/null && ! [[ $1 =~ cms ]];then
        su -c "$1/bin/catalina.sh start" - java
    else
	    $1/bin/startup.sh
    fi
}

stopTomcat()	{
	info "Executing shutdown.sh, will kill in $sleepTime sec"
    if id java &> /dev/null && ! [[ $1 =~ cms ]];then
        su -c "$1/bin/catalina.sh stop" - java
    else
	    $1/bin/shutdown.sh
    fi
	timeCount=0
	while (($timeCount < $sleepTime)); do
		((timeCount++))
		sleep 1
		if (( $timeCount == 10));then
			echo $timeCount Sec passed
		fi
        checkTomcat "$2"
        (( $? == 0 )) && return
	done
	
	warning "Kill the Tomcat process"
	date +"%Y-%m-%d %H:%M:%S"  >> $killLog
    if defined pid;then
        echo "kill $pid" >> $killLog    ######## pid is define in checkTomcat function #########
        ps -ef | grep $pid | grep -v grep >> $killLog
        kill -9 $pid
    fi
}

processor()	{

	local project=$1
	local action=$2

	checkPara $project
	case $? in
        1)
            tomcatDir="$serverHome/tomcat_$project" ;;
        2)
            tomcatDir="$serverHome/tomcat-$project" ;;
        3)
            tomcatDir="$serverHome/$project" ;;
	4)
			tomcatDir=`find $serverHome -maxdepth 1 -type d -name "*$project" ` ;;
        100)
            tomcatDir="/home/$PROJ_NAME/tomcat" ;;
		*)
			help ;;
	esac

	keyWord="Dcatalina.base=$tomcatDir "
	if [ ! -e "$tomcatDir/bin/catalina.sh" ]; then
        error "hostname: Tomcat $project not exists, please check!"
		return
	fi

    checkTomcat "$keyWord"
    if (( $? == 2 )); then
        error "More than 1 tomcat is found, please check!!"
        return
    fi
	case "$action" in
		"start")
            checkTomcat "$keyWord"
            (( $? > 0 )) && error "$hostname: Process exists. Aborted... start $project Error" && return 
            changPath $project
            info "Now starting $project"
			startTomcat $tomcatDir 
            success "$hostname: Start $project Done"
            exec $scriptLocate $project check
			;;
		"stop")
		    changPath $project
			info "Now stopping $project"
			stopTomcat $tomcatDir "$keyWord"
            success "$hostname: Stop $project Done"
			;;
		"restart")
		    changPath $project
			info "Stopping $project"
			stopTomcat $tomcatDir "$keyWord"
            checkTomcat "$keyWord"
            if (( $? > 0 ));then
                error "$hostname: Process exists. Aborted... restart $project Error"
                return
            else
			    info "Stop $project Done"
            fi
			sleep 3
            info "Now restarting $project"
			startTomcat $tomcatDir
            success "$hostname: Restart $project Done"
            exec $scriptLocate $project check
			;;
		"check")
			checkTomcat "$keyWord"
			if (( $? == 1 ));then
                success "$hostname: `echo $project ` process exists. Start time is $startTime, pid is $pid"
			else 
				echo 0
			fi
			;;
		*)
			help ;;
	esac
	
	(( $errorFlag == 1 )) && error "$hostname: ERROR OCCURRED!!!"

	return 0
}


[[ "$1" != "" ]] || help

if [[ $1 == "all" ]];then
	for proj in $tomcats;do
		processor $proj $2
	done
fi

if [[ $2 == "start" ]];then
       outerStart "processor $1 $2" ${warnValues} ${warnFile}
elif [[ $2 == "stop" ]];then
       outerStop "processor $1 $2"  ${warnValues} ${warnFile}
else
	processor $1 $2
fi