/etc/init.d/functions详解

# 0 主要概述
/etc/init.d/functions这个脚本是给/etc/init.d里边的文件使用的，提供了一些基础的功能，看看里边究竟有些什么。首先会设置umask，path，还有语言环境，然后会设置success,failure,warning,normal几种情况下的字体颜色。

# 1 重要方法
```shell
checkpid                                                #检查是否已存在pid，如果有一个存在，返回0（通过查看/proc目录）
daemon                                                  #启动某个服务。/etc/init.d目录部分脚本的start使用到这个
killproc                                                #杀死某个进程。/etc/init.d目录部分脚本的stop使用到这个
pidfileofproc                                           #寻找某个进程的pid
pidofproc                                               #类似上面的，只是还查找了pidof命令
status                                                  #返回一个服务的状态
echo_success,echo_failure,echo_passed,echo_warning      #分别输出各类信息
success,failure,passed,warning                          #分别记录日志并调用相应的方法
action                                                  #打印某个信息并执行给定的命令，它会根据命令执行的结果来调用 success,failure方法
strstr                                                  #判断$1是否含有$2
confirm                                                 #显示 "Start service $1 (Y)es/(N)o/(C)ontinue? [Y]"的提示信息，并返回选择结果
```

# 2 环境变量
```shell
# -*-Shell-script-*-

# functions This file contains functions to be used by most or all 
#  shell scripts in the /etc/init.d directory.              
# 注释 ：该脚本几乎被 /etc/init.d/ 下的所有脚本所调用，因为它包含了大量的基础函数。同时也被/etc/rc.d/rc.sysinit调用，例如 success、action、failure 等函数

TEXTDOMAIN=initscripts
# 设置 TEXTDOMAIN 变量
#某些系统使用LC_MESSAGES shell变量所指定的消息类型. 其他一些系统根据shell变量TEXTDOMAIN的值来创建消息类型的名称, 可能还会加上后缀'.mo'. 如果你使用TEXTDOMAIN变量, 你可能需要设置变量TEXTDOMAINDIR指向消息类型文件所在的位置. 还有某些系统以这种形式两个变量都使用: TEXTDOMAINDIR/LC_MESSAGES/Lc_Messages/TEXTDOMAIN.mo.

# 确保 root 用户的 umask 是正确的 022 （也就是 rwxr-xr-x）
umask 022

# 设置默认的 PATH 变量，默认为 /sbin:/usr/sbin:/bin:/usr/bin:/usr/X11R6/bin
PATH="/sbin:/usr/sbin:/bin:/usr/bin:/usr/X11R6/bin" 

# 导出为环境变量
export PATH

# 设置正确的屏幕宽度，#如果 COLUMNS 变量的值为空，则设置为 80 （列）
[ -z "${COLUMNS:-}" ] && COLUMNS=80 

# 如果 CONSOLETYPE 为空则设置 CONSOLETYPE 为 /sbin/consoletype 命令返回的值
[ -z "${CONSOLETYPE:-}" ] && CONSOLETYPE="`/sbin/consoletype`" 

# 如果存在 /etc/sysconfig/i18n 且 NOLOCALE 变量的值为空，则执行 /etc/sysconfig/i18n 文件，取得 LANG 变量的值
if [ -f /etc/sysconfig/i18n -a -z "${NOLOCALE:-}" ] ; then
      . /etc/sysconfig/i18n                  
      #如果当前 console 类型不是 pty（远程登录），而是 vt 或者 serial ，则根据 LANG 的值作出选择
      #如果 LANG 是 日文、中文简体、中文繁体、韩文等，则把 LC_MESSAGES 设置为 en_US同时导出为环境变量
      if [ "$CONSOLETYPE" != "pty" ]; then        
          case "${LANG:-}" in               
              ja_JP*|ko_KR*|zh_CN*|zh_TW*|bn_*|bd_*|pa_*|hi_*|ta_*|gu_*) 
                   export LC_MESSAGES=en_US
                   export LANG          
                   ;;
              *)
                   export LANG     
                   # 如果是其他类型的语言，则直接导出 LANG
               ;    ;
         esac
      else           
       # 如果当前 consle 是 pty,且如果 LC_MESSAGES 不为空，则直接导出 LC_MESSAGES                      
       [ -n "$LC_MESSAGES" ] && export LC_MESSAGES    
       export LANG
  fi
fi
```

# 3 case语法
case语句 ：它能够把变量的内容与多个模板进行匹配,再根据成功匹配的模板去决定应该执行哪部分代码。
## 3.1 使用格式

```shell
case 匹配母板 in
    模板1 [ | 模板2 ] … )  语句组 ;;
    模板3 [ | 模板4 ] … )  语句组 ;;
esac
```

```
case语句的匹配是从上往下地匹配顺序。因此，case语句编写的原则是从上往下，模板从特殊到普通。
在C语言里，case语句中有default模板，而在shell程序设计中，可能将模板写成*，就可以完成相同的功能。
case语句的模板支持匹配:
    1.匹配以n开头的所有情况： n*
    2.匹配yes的所有字母大小不同的情况： [yY][eE][sS]
    3.但不支持{}匹配，因为模板可以使用 | 就可以达到目的。
```

## 3.2 基本示例
```shell
#!/bin/sh
echo "Please input \"yes\" or \"no\""
read var
case "$var" in
    [yY][eE][sS]) echo "Your input is YES" ;;
    [nN][oO]     ) echo "Your input is YES" ;;
    *) echo "Input Error!"      ;;
esac
exit 0
```

# 4 终端色彩
```shell
# 下面是设置 success、failure、passed、warning 4种情况下的字体颜色的配置
# 首先如果 BOOTUP 变量为空，如果存在 /etc/sysconfig/init 文件，执行 /etc/sysconfig/init 文件
if [ -z "${BOOTUP:-}" ]; then               
  if [ -f /etc/sysconfig/init ]; then        
      . /etc/sysconfig/init
  else                              
    # 否则我们就手工设置
    # 第一设置 BOOTUP 变量，默认就是 color，第二设置设置在屏幕的第几列输出后面的 "[ xxx ]" ，默认是第60列
    BOOTUP=color                      
    RES_COL=60                        
    MOVE_TO_COL="echo -en \\033[${RES_COL}G"    # MOVE_TO_COL 是用于打印 "OK" 或者 "FAILED" ,或者"PASSED" ,或者 "WARNING" 之前的部分，不含 "[" 
    SETCOLOR_SUCCESS="echo -en \\033[1;32m"     # SETCOLOR_SUCCESS 设置后面的字体都为绿色
    SETCOLOR_FAILURE="echo -en \\033[1;31m"       # SETCOLOR_FAILURE 设置后面将要输出的字体都为红色
    SETCOLOR_WARNING="echo -en \\033[1;33m"     # SETCOLOR_WARNING 设置后面将要输出的字体都为×××
    SETCOLOR_NORMAL="echo -en \\033[0;39m"      # SETCOLOR_NORMAL 设置后面输出的字体都为白色（默认）
    LOGLEVEL=1
  fi

  # 如果是通过串口登录的，则全部取消彩色输出
  if [ "$CONSOLETYPE" = "serial" ]; then       
      BOOTUP=serial
      MOVE_TO_COL=
      SETCOLOR_SUCCESS=
      SETCOLOR_FAILURE=
      SETCOLOR_WARNING=
      SETCOLOR_NORMAL=
  fi
fi

# 如果 BOOTUP 变量的值不为 verbose ，则把 INITLOG_ARGS 的值设置为 -q （安静模式）# 否则把 INITLOG_ARGS 的值清空 
if [ "${BOOTUP:-}" != "verbose" ]; then
   INITLOG_ARGS="-q"
else  
   INITLOG_ARGS= 
fi
```

# 5 checkpid函数
```shell
# 下面定义一个函数 checkpid （），目的是检查 /proc 下是否存在指定的目录（例如 /proc/1/）
# 如果有任意一个存在，则返回0，如果给出的参数全部不存在对应的目录，则返回1
checkpid() {                          
local i           #局部变量定义
for i in $* ; do
  [ -d "/proc/$i" ] && return 0
done
return 1                             
}
```

# 6 daemon函数
```shell
# 下面定义最重要的一个函数，daemon 函数，它的作用是启动某项服务。/etc/init.d/ 下的脚本的 start 部分都会用到它
daemon() {
# Test syntax.
local gotbase= force=
local base= user= nice= bg= pid=
nicelevel=0
while [ "$1" != "${1##[-+]}" ]; do            # daemon 函数本身可以指定多个选项，例如 --check <value> ，--check=<value> ，
   case $1 in
     '')    echo $"$0: Usage: daemon [+/-nicelevel] {program}"         # 也可以指定 nice 值
            return 1;;
     --check)
     base=$2
     gotbase="yes"
     shift 2
     ;;
     --check=?*)
         base=${1#--check=}
     gotbase="yes"
     shift
     ;;
     --user)                                   # 也可以指定要以什么用户身份运行（--user <usr> , --user=<usr>)
     user=$2
     shift 2
     ;;
     --user=?*)
            user=${1#--user=}
     shift
     ;;
     --force)
         force="force"                     # --force 表示强制运行
     shift
     ;;
     [-+][0-9]*)
         nice="nice -n $1"              # 如果 daemon 的第一个参数是数字，则认为是 nice 值
            shift
     ;;
     *)     echo $"$0: Usage: daemon [+/-nicelevel] {program}"
            return 1;;
   esac
done
        # basename 就是从服务器的二进制程序的 full path 中取出最后的部分
        [ -z "$gotbase" ] && base=${1##*/}  

# 检查该服务是否已经在运行。不过 daemon 函数只查看 pid 文件而已
# 如果 /var/run 下存在该服务的 pid 文件，则从该 pid 文件每次读取一行，送给变量 line 。
#注意 pid 文件可能有多行，且不一定都是数字
# 对于 line 变量的每个 word 进行检查， 如果 p 全部是数字，且存在 /proc/$p/ 目录，则认为该数字是一个 pid ，把它加入到 pid 变量
# 如果 pid 变量最终为空，则 force 变量为空（不强制启动），则返回
if [ -f /var/run/${base}.pid ]; then
  local line p
  read line < /var/run/${base}.pid
  for p in $line ; do
   [ -z "${p//[0-9]/}" -a -d "/proc/$p" ] && pid="$pid $p"
  done
fi
[ -n "${pid:-}" -a -z "${force:-}" ] && return

#下面对该服务使用的资源作一些设置
# ulimit 是控制由该 shell 启动的进程能够使用的资源，-S 是 soft control 的意思，-c 是指最大的 core
# dump 文件大小，如果 DEAMON_COREFILE_LIMIT 为空，则默认为 0
ulimit -S -c ${DAEMON_COREFILE_LIMIT:-0} >/dev/null 2>&1

# if they set NICELEVEL in /etc/sysconfig/foo, honor it     
# 如果存在 /etc/sysconfi/foo 文件，且其中有 NICELEVEL 变量则用它代替  daemon 后面的那个 nice 值
# 注意，这里的 nice 赋值是用 nice -n <value> 的格式，因为 nice 本身可以启动命令，用这个格式较方便
[ -n "$NICELEVEL" ] && nice="nice -n $NICELEVEL"

# 如果 BOOTUP 的值为 verbose ，则打印一个服务名
        [ "${BOOTUP:-}" = "verbose" -a -z "$LSB" ] && echo -n " $base"

# 下面是开始启动它了
# 如果 user 变量为空，则默认使用 root 启动它,执行 nice -n <nice_value> initlog -q -c "$*" 
# 如果指定了用户，则执行 nice -n <nice_value> initlog -q -c "runuser -s /bin/bash - <user> -c "$*"
if [ -z "$user" ]; then 
    $nice initlog $INITLOG_ARGS -c "$*"
else                                      
    $nice initlog $INITLOG_ARGS -c "runuser -s /bin/bash - $user -c \"$*\""   
fi

# 如果上面的命令成功，则显示一个绿色的 [ OK ] ，否则显示 [ FAILURE ]
[ "$?" -eq 0 ] && success $"$base startup" || failure $"$base startup" 
}
```

# 7 killproc函数
```shell
# 下面定义另外一个很重要的函数 killproc ，/etc/init.d/ 下面的脚本的 stop 部分都会用到它
# RC 是最终返回的值，初始化为 0
# killproc 函数的语法格式是 killproc <service> [<signal>] ，例如 killproc sm-client 9
killproc() {
RC=0
# Test syntax.
if [ "$#" -eq 0 ]; then
  echo $"Usage: killproc {program} [signal]"
  return 1
fi

# noset 是用于检查用户是否指定了 kill 要使用的信号
notset=0

# 如果 $2 不为空，则表示用户有设定信号，
# 把 $2 的值赋予 killlevel 变量
# 否则，notset 变量的值为1，同时 killlevel 为 '-9' （KILL 信号）
if [ -n "$2" ]; then                    
  killlevel=$2                        
else                                
  notset=1                           
  killlevel="-9"
fi
# 补充 ：注意，并不是说用户没有指定信号地停止某项服务时，就会立即用 kill -9 这样的方式强制杀死，而是先用 TERM 信号，然后再用 KILL

        # basename 就是得出服务的名称
        base=${1##*/} 

# 把 pid 变量的值清空。注意，不是指 pid 变量的值等于下面脚本的执行结果，要看清楚
# 下面和上面的 daemon 函数一样找出 pid
pid=
if [ -f /var/run/${base}.pid ]; then
    local line p
    read line < /var/run/${base}.pid
    for p in $line ; do
       [ -z "${p//[0-9]/}" -a -d "/proc/$p" ] && pid="$pid $p"
    done
fi

# 不过和 daemon 不同的是，一旦 pid 为空不会直接 return 而是尝试用 pid 命令再次查找
# -o 是用于忽略某个 pid ，-o $$ 是忽略当前 shell 的 pid、-o $PPID 是忽略 shell 的 pid 
# -o %PPID 是忽略 pidof 命令的父进程，要查询的进程是 $1 (fullpath) 或者 $base 
if [ -z "$pid" ]; then                  
  pid=`pidof -o $$ -o $PPID -o %PPID -x $1 || \  
   pidof -o $$ -o $PPID -o %PPID -x $base`    
fi

 # 如果 pid 的值最终不为空
 # 且 BOOTUP 的值为 verbose ，且 LSB 变量不为空，则打印一个服务名 
 # 如果 notset 变量不为1，表示用户没有指定信号
 # 调用 checkpid  $pid 检查是否在 /proc/ 下存在进程目录，如果有
  if [ -n "${pid:-}" ] ; then                         
    [ "$BOOTUP" = "verbose" -a -z "$LSB" ] && echo -n "$base "  
    if [ "$notset" -eq "1" ] ; then                               
         if checkpid $pid 2>&1; then                          
              # 先尝试用 TERM 信息，不行再用 KILL 信号，执行 kill -TERM $pid 
              kill -TERM $pid >/dev/null 2>&1 
              usleep 100000 
             # 如果 checkpid $pid 还是查到有 /proc/<pid>/ 目录存在，则表示还没有杀死，继续等待1秒
             # 如果1秒后用 checkpid 检查还是有，则再等待3秒；
             # 如果还是没有杀死，则用 KILL 信号
              if checkpid $pid && sleep 1 &&               
                 checkpid $pid && sleep 3 &&               
                 checkpid $pid ; then                           
                        kill -KILL $pid >/dev/null 2>&1     
                        usleep 100000                              
              fi
    fi

     # 再次检查 pid 目录
     # 并把结果返回给 RC ，这就算是 killproc 的最后状态了
     # 如果 RC 的值为0，则表示kill -9 没有杀死了进程，则调用 failure 函数，否则调用 success 
    checkpid $pid                                
    RC=$?                                      
    [ "$RC" -eq 0 ] && failure $"$base shutdown" || success $"$base shutdown"    
    RC=$((! $RC))

        # 上面都是在没有指定信号的情况的，下面是用户指定了信号的。例如 restart）或者 reload）部分，这个 else 是针对 if [ "$notset" -eq "1" ]  的
        # 如果检查到进程存在，则执行kill命令，但使用指定的信号 $killlevel，并把状态值返回给变量 RC
        # 如果 RC 为0则表示成功，调用 success；否则调用 failure 函数
    else    
       if checkpid $pid; then                       
            kill $killlevel $pid >/dev/null 2>&1         
            RC=$?                              
            [ "$RC" -eq 0 ] && success $"$base $killlevel" || failure $"$base $killlevel"    
       fi
  fi

# 这个 else 是针对 if [ -n "${pid:-}" ]  的，也就是说没有 pid 文件，pidof 命令也没有找到 pid ，则调用 failure 函数，表示停止服务失败
# 同时 RC 的值为1
else
     failure $"$base shutdown"                
     RC=1                              
fi

# 如果 notset 不为1 ，也就是用户没有指定信号的情况，自动删除 /var/run 下的 pid 文件
# 并把 RC 作为 exit status 返回
if [ "$notset" = "1" ]; then                    
            rm -f /var/run/$base.pid          
fi
return $RC                                
}
# 补充 ：自所以删除 pid 文件只针对 notset 为1 的情况，是因为 -HUP 信号（重读配置），并不杀死进程，所以不能删除它的 pid 文件
```

# 8 pidfileofproc函数
```shell
# 下面的 pidfileofproc 函数和 checkpid 类似，但不执行 pidof 命令，只查询 pid 文件
pidfileofproc() {
local base=${1##*/}
if [ "$#" = 0 ] ; then
  echo $"Usage: pidfileofproc {program}"
  return 1
fi
# First try "/var/run/*.pid" files
if [ -f /var/run/$base.pid ] ; then
         local line p pid=
    read line < /var/run/$base.pid
    for p in $line ; do
         [ -z "${p//[0-9]/}" -a -d /proc/$p ] && pid="$pid $p"
    done
         if [ -n "$pid" ]; then
                 echo $pid
                 return 0
         fi
fi
}
```

# 9 pidofproc函数
```shell
# 下面的 pidofproc 函数和上面的 pidfileofproc 函数类似，但多了一步 pidof 命令
pidofproc() {
base=${1##*/}
# Test syntax.
if [ "$#" = 0 ]; then
  echo $"Usage: pidofproc {program}"
  return 1
fi
# First try "/var/run/*.pid" files
if [ -f /var/run/$base.pid ]; then
         local line p pid=
  read line < /var/run/$base.pid
  for p in $line ; do
         [ -z "${p//[0-9]/}" -a -d /proc/$p ] && pid="$pid $p"
  done
         if [ -n "$pid" ]; then
                 echo $pid
                 return 0
         fi
fi
pidof -o $$ -o $PPID -o %PPID -x $1 || \
  pidof -o $$ -o $PPID -o %PPID -x $base
}
```

# 10 status函数
```shell
# 注释 ：下面的 status 函数是判断服务的状态，总共有4种
status() {              
local base=${1##*/}
local pid
# Test syntax.
if [ "$#" = 0 ] ; then
  echo $"Usage: status {program}"
  return 1
fi

# 同样是查找 pid 先。直接使用 pidof 命令
# 如果 pid 变量的值不为空，则表示找到进程，则打印 "xxx (pid nnn) is running " , 并返回 0
pid=`pidof -o $$ -o $PPID -o %PPID -x $1 || \                
      pidof -o $$ -o $PPID -o %PPID -x ${base}`
if [ -n "$pid" ]; then                     
         echo $"${base} (pid $pid) is running..."
         return 0                     
fi

# 如果 pidof 命令没有找到，则尝试从 pid 文件找
# 如果 pidof 命令找不到，但从 pid 文件找到了pid，则打印 "xxx dead but pid file exists"，并返回 1
if [ -f /var/run/${base}.pid ] ; then
         read pid < /var/run/${base}.pid
         if [ -n "$pid" ]; then            
                 echo $"${base} dead but pid file exists"    
                 return 1              
         fi
fi

# 如果 pidof 命令和 pid 文件都没有找到 pid ，如果在 /var/lock/subsys 下存在对应的文件，打印 “xxxx dead but subsys locked”，并返回 2
if [ -f /var/lock/subsys/${base} ]; then          
  echo $"${base} dead but subsys locked"         
  return 2                             
fi
# 如果 pidof 命令、pidf 文件都没有找到pid ，且没有别锁，则打印 “xxx is stopped”，  #并返回3
echo $"${base} is stopped"                   
return 3                             
}
```

# 11 结果显示
```shell
# 注释 ：下面的 echo_xxx 函数就是真正在屏幕上打印 [ ok ] 、[ PASSED ]、[ FAILURE ]、[ WARNING ] 的部分了
# 下面是 echo_success 部分
# 返回 0，其他一律返回 1
echo_success() {                          
  [ "$BOOTUP" = "color" ] && $MOVE_TO_COL   
  echo -n "[  "                         
  [ "$BOOTUP" = "color" ] && $SETCOLOR_SUCCESS      
  echo -n $"OK"                          
  [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL     
  echo -n "  ]"                         
  echo -ne "\r"                     
  return 0                              
echo_failure() {
  [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
  echo -n "["
  [ "$BOOTUP" = "color" ] && $SETCOLOR_FAILURE
  echo -n $"FAILED"
  [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
  echo -n "]"
  echo -ne "\r"
  return 1
}
echo_passed() {
  [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
  echo -n "["
  [ "$BOOTUP" = "color" ] && $SETCOLOR_WARNING
  echo -n $"PASSED"
  [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
  echo -n "]"
  echo -ne "\r"
  return 1
}
echo_warning() {
  [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
  echo -n "["
  [ "$BOOTUP" = "color" ] && $SETCOLOR_WARNING
  echo -n $"WARNING"
  [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
  echo -n "]"
  echo -ne "\r"
  return 1
}
```

# 12 状态信息
```shell
# Inform the graphical boot of our current state
update_boot_stage() {
  if [ "$GRAPHICAL" = "yes" -a -x /usr/bin/rhgb-client ]; then
    /usr/bin/rhgb-client --update="$1"
  fi
  return 0
}

# success 函数除了打印 [ xxx ] 之外，还会使用 initlog 记录信息
# -n 是 --name 的意思，-s 是 --string ，-e 是 --event ，1 表示完全成功
success() {                                  
  if [ -z "${IN_INITLOG:-}" ]; then
     initlog $INITLOG_ARGS -n $0 -s "$1" -e 1          
  else
     # silly hack to avoid EPIPE killing rc.sysinit
     trap "" SIGPIPE
     echo "$INITLOG_ARGS -n $0 -s \"$1\" -e 1" >&21
     trap - SIGPIPE
  fi
  [ "$BOOTUP" != "verbose" -a -z "$LSB" ] && echo_success
  return 0
}

#失败日志
# failure 的话 --event 是 2 是失败
failure() {
  rc=$?
  if [ -z "${IN_INITLOG:-}" ]; then
     initlog $INITLOG_ARGS -n $0 -s "$1" -e 2         
  else
     trap "" SIGPIPE
     echo "$INITLOG_ARGS -n $0 -s \"$1\" -e 2" >&21
     trap - SIGPIPE
  fi
  [ "$BOOTUP" != "verbose" -a -z "$LSB" ] && echo_failure
  [ -x /usr/bin/rhgb-client ] && /usr/bin/rhgb-client --details=yes
  return $rc
}

# pass日志
# passed 的话 --event 还是1
passed() {
  rc=$?
  if [ -z "${IN_INITLOG:-}" ]; then
     initlog $INITLOG_ARGS -n $0 -s "$1" -e 1          
  else
     trap "" SIGPIPE
     echo "$INITLOG_ARGS -n $0 -s \"$1\" -e 1" >&21
     trap - SIGPIPE
  fi
  [ "$BOOTUP" != "verbose" -a -z "$LSB" ] && echo_passed
  return $rc
}
# warning日志
# warning 的话 --event 也是 1
warning() {
  rc=$?
  if [ -z "${IN_INITLOG:-}" ]; then
     initlog $INITLOG_ARGS -n $0 -s "$1" -e 1         
  else
     trap "" SIGPIPE
     echo "$INITLOG_ARGS -n $0 -s \"$1\" -e 1" >&21
     trap - SIGPIPE
  fi
  [ "$BOOTUP" != "verbose" -a -z "$LSB" ] && echo_warning
  return $rc
}
```

# 13 action函数
```shell
# action 函数是另外一个最重要的函数，它的作用是打印某个提示信息并执行给定命令
tion() {
  STRING=$1
  echo -n "$STRING "
  if [ "${RHGB_STARTED}" != "" -a -w /etc/rhgb/temp/rhgb-console ]; then
      echo -n "$STRING " > /etc/rhgb/temp/rhgb-console
  fi
  shift
  initlog $INITLOG_ARGS -c "$*" && success $"$STRING" || failure $"$STRING"
  rc=$?
  echo
  if [ "${RHGB_STARTED}" != "" -a -w /etc/rhgb/temp/rhgb-console ]; then
      if [ "$rc" = "0" ]; then
       echo_success > /etc/rhgb/temp/rhgb-console
      else
        echo_failed > /etc/rhgb/temp/rhgb-console
[ -x /usr/bin/rhgb-client ] && /usr/bin/rhgb-client --details=yes
      fi
      echo
  fi
  return $rc
}

 # returns OK if $1 contains $2
 # strstr 函数是判断 $1 字符串是否含有 $2 字符串，是则返回0，否则返回1
() {
   [ "${1#*$2*}" = "$1" ] && return 1
   return 0
}
```

# 14 confirm函数
```shell
# confirm 函数是用于交互式的启动服务
# 会打印一个提示信息               
# 如果 answer 变量是 y 或者 Y 则返回 0（但未真正启动）
# 如果 answer 是 c 或者 C ，则删除 /var/run/confirm 文件                           
# 如果 answer 是 n 或者 N，则直接返回1
confirm() {
  [ -x /usr/bin/rhgb-client ] && /usr/bin/rhgb-client --details=yes
  while : ; do 
    echo -n $"Start service $1 (Y)es/(N)o/(C)ontinue? [Y] "             
    read answer
    if strstr $"yY" "$answer" || [ "$answer" = "" ] ; then             
        return 0                                        
    elif strstr $"cC" "$answer" ; then                           
        rm -f /var/run/confirm                               
        [ -x /usr/bin/rhgb-client ] && /usr/bin/rhgb-client --details=no
        return 2                                        
   elif strstr $"nN" "$answer" ; then                            
  return 1                                              
     fi
  done
```