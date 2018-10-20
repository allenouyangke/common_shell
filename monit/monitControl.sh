#!/bin/sh
### BEGIN INIT INFO
# Provides:          monit
# Required-Start:    $remote_fs
# Required-Stop:     $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: service and resource monitoring daemon
### END INIT INFO
# start and stop monit daemon monitor process.

PATH=/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/local/monit/bin/monit
CONFIG=/root/.monitrc
NAME=monit
DESC="daemon monitor"

# Check if DAEMON binary exist
test -f $DAEMON || exit 0

monit_not_configured () {
    printf "%b\n" "monit won't be started/stopped\n\tunless it it's configured"
    if [ "$1" != "stop" ]
        then
        printf "%b\n" "\tplease configure monit and then edit /etc/default/monit"
        printf "%b\n" "\tand set the \"startup\" variable to 1 in order to allow "
        printf "%b\n" "\tmonit to start"
    fi
    exit 0
}

monit_check_config () {
    # Check for emtpy config, probably default configfile.
    if [ "`grep -s -v \"^#\" $CONFIG`" = "" ]; then
        echo "empty config, please edit $CONFIG."
        exit 0
    fi
}

monit_check_perms () {
    # Check the permission on configfile. 
    # The permission must not have more than -rwx------ (0700) permissions.
   
    # Skip checking, fix perms instead.
    /bin/chmod go-rwx $CONFIG

}


monit_check_syntax () {
  $DAEMON -c $CONFIG -t 2>/dev/null >/dev/null
  if [ $? -eq 1 ] ; then
      echo "Syntax error:"
                $DAEMON -c $CONFIG -t
                exit 0
  fi
}


monit_checks () {
    # Check if startup variable is set to 1, if not we exit.
    #if [ "$startup" != "1" ]; then
    #    monit_not_configured $1
    #fi
    # Check for emtpy configfile
    monit_check_config
    # Check permissions of configfile
    monit_check_perms
         # Check syntax of config file
    monit_check_syntax
}

case "$1" in
  start)
        echo -n "Starting $DESC: "
                monit_checks 
        echo "$NAME"
        $DAEMON -c $CONFIG > /dev/null 2>&1
        ;;
  stop)
        echo -n "Stopping $DESC: "
                #monit_checks
        echo "$NAME"
        $DAEMON -c $CONFIG quit > /dev/null 2>&1
        echo "."
        ;;
  reload)
        echo -n "reloading $DESC: "
                monit_checks
        echo "$NAME"
        $DAEMON -c $CONFIG reload> /dev/null 2>&1
        ;;
  restart)
        /bin/sh $0 stop
        sleep 3
        /bin/sh $0 start
        ;;
  syntax)
   monit_check_syntax
   ;;
  *)
        N=/home/monit/${NAME}.sh
        echo "Usage: $N {start|stop|restart|reload|syntax}" >&2
        exit 1
        ;;
esac

exit 0