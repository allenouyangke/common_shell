#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : memcached.sh
# Revision     : 1.0
# Date         : 2018/08/27
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : memcached启动/停止/重启脚本
# -------------------------------------------------------------------------------

memcached_path="/home/memcached/bin/memcached"
memcached_pid="/var/run/memcached.pid"
memcached_memory="100"

# Source function library.
. /etc/rc.d/init.d/functions

[ -x $memcached_path ] || exit 0

RETVAL=0
prog="memcached"

# Start daemons.
start() {
    if [ -e $memcached_pid -a ! -z $memcached_pid ];then
        echo $prog" already running...."
        exit 1
    fi

    echo -n $"Starting $prog "
    # Single instance for all caches
    $memcached_path -m $memcached_memory -l 0.0.0.0 -p 11211 -u root -d -P $memcached_pid
    RETVAL=$?
    [ $RETVAL -eq 0 ] && {
        touch /var/lock/subsys/$prog
        success $"$prog"
    }
    echo
    return $RETVAL
}

# Stop daemons.
stop() {
    echo -n $"Stopping $prog "
    killproc -d 10 $memcached_path
    echo
    [ $RETVAL = 0 ] && rm -f $memcached_pid /var/lock/subsys/$prog

    RETVAL=$?
    return $RETVAL
}


case "$1" in
        start)
            start
            ;;
        stop)
            stop
            ;;
        status)
            status $prog
            RETVAL=$?
            ;;
        restart)
            stop
            start
            ;;
        *)
            echo $"Usage: $0 {start|stop|status|restart}"
            exit 1
esac
exit $RETVAL