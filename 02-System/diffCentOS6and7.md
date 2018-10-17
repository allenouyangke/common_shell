CentOS6与CentOS7区别归纳汇总

# 表格一览

命令|CentOS6|CentOS7|备注说明
---|---|---|---
ifconfig | True | False | 通过yum instal -y net-tools支持
route | True | False | 通过yum instal -y net-tools支持
ntpd ntpdate | True | False | 通过yum install ntp ntpdate支持
/etc/issue | 有版本号 | 无信息 | 通过/etc/redhat-release
setup | True | Flase nmtui命令取代了setup | 通过yum install NetworkManager-tui支持
python | 2.6 | 2.7 |
kernel | 2.6 | 3.10 |
file system | ext4 | xfs |
Language | locale -a | localctl status |
Service Management | chkconfig<br>/etc/init.d/SERVICE | systemctl |
Service Management and Control | sysvinit | system <br> systemctl是主要工具，融合了service和chkconfig |
Zone and Time | /etc/sysconfig/clock | timedatectl set-timezone Asia/Shanghai<br>timedatectl status | 
Network | eth0 | 可预见性的命名规则 |
dig<br>nslookup | True | False | 通过yum install bind-utils -y支持
Hostname | /etc/sysconfig/network | /etc/hostname |
/etc/rc.local | True | False | 默认这个文件没有执行权限x
init 0 | True | True | 关机重启
内核参数配置文件 | /etc/sysctl.cnf | /usr/lib/sysctl.d/00-system.conf<br>/etc/sysctl.d/\<name\>.conf
防火墙 | /etc/sysconfig/iptables | firewalld | 
启动级别 | /etc/inittab | False |
切换等级 | 切回单用户模式 init 0 | init 0<br>systemctl emergency<br>systemctl isolate runlevel1.target |

# 参考资料
[CentOS7和CentOS6区别](https://blog.csdn.net/xu_Melon/article/details/79043898)