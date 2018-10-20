# 0 安装部署
## yum安装
```shell
yum install monit -y
```

## 源码安装

- [Monot下载地址](https://mmonit.com/monit/dist/binary/)

```shell
wget https://mmonit.com/monit/dist/monit-5.25.2.tar.gz
tar -zxvf monit-5.25.2.tar.gz
cd monit-5.25.2
./configure --prefix=/home/pjalm/monit
make && make install
```

## 使用编译好的包

# 1 基础配置
默认配置文件路径`/root/.monitrc`
```
set daemon  30                # 设置监控进程频率为30秒
set logfile /home/pjaq/monit/logs/monit.log      #定义日志存放

set mailserver smtp.163.com  port 25 USERNAME "x.x.x.x@163.com" PASSWORD "xxxx",   #设置发送邮件的服务器及邮箱，若不需要发邮件注释掉即可
# 制定报警邮件的格式
 set mail-format {
      from: x.x.x.x@163.com
   subject: monit alert --  $EVENT $SERVICE
   message: $EVENT Service $SERVICE
                 Date:        $DATE
                 Action:      $ACTION
                 Host:        $HOST
                 Description: $DESCRIPTION
 
            Your faithful employee,
    }
set alert chenyinghong@aobi.com  #设置报警收件人
 
set httpd port 2812 and    # 设置monit进程监听端口，这项必须打开，即使不用，否则启动会报错
    use address localhost  # only accept connection from localhost 设置这个http服务器的侦听地址
    allow localhost        # allow localhost to connect to the server and 允许本地访问
    allow admin:monit      # require user 'admin' with password 'monit' 设置使用用户名admin和密码monit
 
include /etc/monit.d/*    # 存放关于进程监控定义的目录
```

## 2 常用操作
- 检查语法
```shell
monit -t
```

- 启动服务
```shell
# 默认配置文件路径/root/.monitrc
monit -c ConfFilePath
```

- 常用命令
```
#monit -h
start all           # Start all services 启动monit监控了的所有服务
start name          # Only start the named service 启动指定的服务
stop all            # Stop all services 停止monit监控了的所有服务
stop name           # Only stop the named service  停止指定的服务
restart all         # Stop and start all services 重启monit监控了的所有服务
restart name        # Only restart the named service 重启指定的服务
monitor all         # Enable monitoring of all services
monitor name        # Only enable monitoring of the named service
unmonitor all       # Disable monitoring of all services
unmonitor name      # Only disable monitoring of the named service
reload              # Reinitialize monit  重载monit
status [name]       # Print full status information for service(s) 查看指定服务的详细状态
summary [name]      # Print short status information for service(s) 查看指定服务的简要报告
quit                # Kill monit daemon process 退出monit程序
validate            # Check all services and start if not running 检查所有服务，如果不是运行状态则启动
procmatch <pattern> # Test process matching pattern
```

## 3 应用场景
- 通过pid文件管理各种服务进程的启停操作
- 通过监控各方面的指标自动拉起、重启、关闭相关的服务器进程
- 监控相关进程并设定监控值，向相关人员进行报警


## 4 注意事项
- 配置文件中的命令需要使用绝对路径
- 启停进程无任何输出，因为monit是异步执行的
