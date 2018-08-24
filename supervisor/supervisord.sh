#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : supervisord.sh
# Revision     : 1.0
# Date         : 2018/08/23
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : supervisord启动/停止/重启脚本
# -------------------------------------------------------------------------------

. /etc/init.d/functions

RETVAL=0
prog="supervisord"
SUPERVISORD=/root/.pyenv/shims/supervisord
PID_FILE=/ops/tmp/supervisor/supervisor.pid
CONFIG_FILE=/etc/supervisord.conf

start()
{
    echo -n $"Starting $prog: "
    $SUPERVISORD -c $CONFIG_FILE --pidfile $PID_FILE && success || failure
    RETVAL=$?
    echo
    return $RETVAL
}

stop()
{
    echo -n $"Stopping $prog: "
    killproc -p $PID_FILE -d 10 $SUPERVISORD
    RETVAL=$?
    echo
}

reload()
{
    echo -n $"Reloading $prog: "
    if [ -n "`pidfileofproc $SUPERVISORD`" ] ; then
        killproc $SUPERVISORD -HUP
    else
        # Fails if the pid file does not exist BEFORE the reload
        failure $"Reloading $prog"
    fi
    sleep 1
    if [ ! -e $PID_FILE ] ; then
        # Fails if the pid file does not exist AFTER the reload
        failure $"Reloading $prog"
    fi
    RETVAL=$?
    echo
}

case "$1" in
    start)
            start
            ;;
    stop)
            stop
            ;;
    restart)
            stop
            start
            ;;
    reload)
            reload
            ;;
    status)
            status -p $PID_FILE $SUPERVISORD
            RETVAL=$?
            ;;
    *)
            echo $"Usage: $0 {start|stop|restart|reload|status}"
            RETVAL=1
esac
exit $RETVAL