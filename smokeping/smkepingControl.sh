#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : smkepingControl.sh
# Revision     : 1.0
# Date         : 2018/10/30
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------

PIDFILE=/opt/smokeping-2.6.9/var/smokeping.pid 
SMOKEPING='sudo -u apache /opt/smokeping-2.6.9/bin/smokeping' 

ERROR=0
RUNNING=0
ARGV="$@"
if [ "x$ARGV" = "x" ] ; then
    ARGS=help
fi 

for ARG in $@ $ARGS
do 

    if [ -f $PIDFILE ] ; then
        PID=`cat $PIDFILE`
        if kill -0 $PID 2>/dev/null ; then
            # smokeping is running 
            RUNNING=1
        else
            # smokeping not running but PID file exists => delete PID file
            rm -f $PIDFILE
            RUNNING=0
        fi
    else
        # smokeping (no pid file) not running
        RUNNING=0
    fi 

    case $ARG in
    start) 

        if [ $RUNNING -eq 0 ] ; then 
        if $SMOKEPING > /dev/null; then
            echo "$0 $ARG: smokeping started"
          else
            echo "$0 $ARG: smokeping could not be started"
            ERROR=1
        fi
        else 
        echo "$0 $ARG: smokeping is running with PID $PID"
        ERROR=2
        fi
    ;;
    stop)
        if [ $RUNNING -eq 1 ] ; then
            if kill $PID ; then
                echo "$0 $ARG: smokeping ($PID) stopped"
                rm $PIDFILE 
            else
                echo "$0 $ARG: smokeping could not be stopped"
                ERROR=3
            fi
        else 
            echo "$0 $ARG: smokeping not running"
            ERROR=4
        fi
    ;;
    restart)
        if [ $RUNNING -eq 1 ] ; then
            if $SMOKEPING --restart > /dev/null; then
              echo "$0 $ARG: smokeping restarted"
            else
                 echo "$0 $ARG: smokeping could not be started"
            ERROR=5
        fi
        else 
             $0 start 
        fi
    ;;
    strace_debug)
        rm -f /tmp/strace_smokeping
        if [ $RUNNING -eq 1 ] ; then
            if strace -o/tmp/strace_smokeping $SMOKEPING --restart >/dev/null; then
            echo "$0 $ARG: smokeping restarted with strace debug in /tmp/strace_smokeping"
            else
                 echo "$0 $ARG: smokeping strace debug could not be started"
            ERROR=6
           fi
        else 
            if strace -o/tmp/strace_smokeping $SMOKEPING >/dev/null; then
            echo "$0 $ARG: smokeping started with strace debug in /tmp/strace_smokeping"
            else
                 echo "$0 $ARG: smokeping strace debug could not be started"
            ERROR=7
           fi
        fi
    ;;
    status)
        if [ $RUNNING -eq 1 ] ; then
            echo "$0 $ARG: smokeping is running with PID ($PID)"
        else 
            echo "$0 $ARG: smokeping is not running"
        fi
        ;;
    *)
        echo "usage: $0 (start|stop|restart|status|strace_debug|help)"
        cat <<EOF 

  start      - start smokeping 
  stop       - stop smokeping 
  restart    - restart smokeping if running or start if not running
  status     - show status if smokeping is running or not
  help       - this screen 

EOF 

        ;; 

    esac
done
exit $ERROR