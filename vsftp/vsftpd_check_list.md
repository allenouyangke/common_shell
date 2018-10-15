## check——list
* /etc/vsftpd/vsftpd.conf ftp服务端配置文件
* /etc/hosts.allow 允许的网段ip
* /etc/hosts.deny 禁止的网段ip
* /etc/vsftpd/user_list 开放的用户
* /etc/vsftpd/ftpusers ftp用户

### 421错误
环境情况：
* iptables防火墙关闭
* selinux关闭

报错信息：
>[root@**]# ftp 192.168.100.1
Connected to 192.168.100.1 (192.168.100.1).
421 Service not available.
ftp> 

telnet结果相同，同样报错421，无法连接ftp服务。

解决办法：在/etc/hosts.allow 和 /etc/hosts.deny 中开放对应的网段白名单。


