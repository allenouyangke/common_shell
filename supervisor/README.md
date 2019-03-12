supervisor安装部署

# 0 基本概述
- 基于python编写，安装方便
- 进程管理工具，可以很方便的对用户定义的进程进行启动，关闭，重启，并且对意外关闭的进程进行重启 ，只需要简单的配置一下即可，且有web端，状态、日志查看清晰明了。
- 组成部分 
    - supervisord[服务端，所以要通过这个来启动它]
    - supervisorctl[客户端，可以来执行stop等命令]

# 1 安装部署
```shell
python -m pip install supervisor
```

# 2 基本配置
- 获取配置文件
```shell
echo_supervisord_conf > /etc/supervisord.conf
```
- 主要配置文件  
[主配置文件](./ConfigFile/supervisord.conf)

- 管理监控项配置文件  
[基础配置模块](./ConfigFile/conf.d/model.conf)  
[nginx配置文件](./ConfigFile/conf.d/nginx.conf)  
[mysql配置文件](./ConfigFile/conf.d/mysql.conf)



# 3 常用命令
## 3.1 supervisord
```shell
supervisord # 将一组应用程序作为守护进程运行。

# 用法：/root/.pyenv/versions/2.7.3/bin/supervisord [options]

# 选项：
-c /        # 配置FILENAME - 配置文件路径（如果没有给出，则搜索）
-n /        # nodaemon - 在前台运行（与配置文件中的'nodaemon = true'相同）
-h /        # help - 打印此用法消息并退出
-v /        # version - 打印supervisord版本号并退出
-u /        # 用户USER - 以此用户（或数字uid）的身份运行supervisord
-m /        # umask UMASK - 将此umask用于守护程序子进程（默认为022）
-d /        # directory DIRECTORY - 守护进程时chdir的目录
-l /        # logfile FILENAME - 使用FILENAME作为日志文件路径
-y /        # logfile_maxbytes BYTES - 使用BYTES限制日志文件的最大大小
-z /        # logfile_backups NUM - 达到最大字节数时要保留的备份数
-e /        # loglevel LEVEL - 使用LEVEL作为日志级别（调试，信息，警告，错误，关键）
-j /        # pidfile FILENAME - 将守护进程的pid文件写入FILENAME
-i /        # 标识符STR - 用于此supervisord实例的标识符
-q /        # childlogdir DIRECTORY - 子进程日志的日志目录
-k /        # nocleanup - 阻止进程执行清理（删除旧的自动子日志文件）在启动时。
-a /        # minfds NUM - 启动成功的最小文件描述符数
-t /        # strip_ansi - 从进程输出中剥离ansi转义代码
--minprocs NUM # 可用于启动成功的最小进程数
--profile_options OPTIONS # 在分析器和输出下运行supervisord
                             结果基于OPTIONS，这是一个逗号
                             “累积”，“来电”和/或“来电者”列表，
                             例如“累积的，呼叫者”）
```

## 3.2 supervisorctl
```shell
status                   # 查看程序状态
stop program_name        # 关闭 program_name 程序
start program_name       # 启动 program_name 程序
restart program_name     # 重启 program_name 程序
reread                   # 读取有更新（增加）的配置文件，不会启动新添加的程序，也不会重启任何程序
reload                   # 载入最新的配置文件，停止原有的进程并按照新的配置启动
update                   # 重启配置文件修改过的程序，配置没有改动的进程不会收到影响而重启
```

# 4 参考资料
- [官方文档](http://supervisord.org/)
- [supervisor 管理进程简明教程](https://www.jianshu.com/p/bf2b3f4dec73)
- [Supervisor的使用](https://blog.csdn.net/huwh_/article/details/80497790)