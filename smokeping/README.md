# 0 简介信息
 &emsp;&emsp; SmokePing是一款完全免费的可以用来监控IDC网络质量的工具，并且它有一个基于RRDTool绘图的前端展示界面，用户可以直观的通过浏览器查看各类监控信息。虽然这东西年代久远，但是还是可以做为一个参考的工具使用。根据相关的教程，还是推荐使用zabbix较好。

&emsp;&emsp; 由于新公司的业务涉及到海外的市场，有较多的海外服务器，为了提升对关地区的业务服务器的网络状态进行把控，先部署了一套smokeping做为短期的网络状态监控工具，来判断相关的网络情况。

&emsp;&emsp; 由于目前没有本地的服务器资源和相关虚拟机资源，只能暂时在个人的香港服务器上进行部署，获取的数据是香港到各个的地区的网络状态。

<!--more-->

# 1 系统环境

- CentOS Linux release 7.4.1708 (Core)
- nginx version: nginx/1.12.2
- spawn-fcgi-1.6.3
- smokeping-2.6.11

**总结：**CentOS7.x + Nginx + Fast_cgi + SmokePing



# 2 安装部署

## 2.1 安装依赖包

安装EPEL源

```shell
yum -y install epel-release
```

安装绘图工具

```shell
yum -y install rrdtool perl-rrdtool
```

安装smokeping的相关扩展

```shell
yum -y install perl-core openssl-devel fping curl gcc-c++
```

**注：**目前可先安装这些部分依赖包，后面编译过程中如果出错，smokeping本身提供了相关的依赖包安装脚本。



## 2.2 安装smokeping

下载源码

```shell
wget https://oss.oetiker.ch/smokeping/pub/smokeping-2.6.11.tar.gz -P /usr/local/src/
```

解压源码

```shell
cd /usr/local/src/
tar zxvf smokeping-2.6.11.tar.gz
```

尝试配置，会出现错误

```shell
cd smokeping-2.6.11
./configure --prefix=/opt/smokeping

# 报错信息（部分）

# 在目录下执行依赖包安装
./setup/build-perl-modules.sh /opt/smokeping/thirdparty

# 再次进行配置
./configure --prefix=/opt/smokeping

# 编译安装
make install
```



## 2.3 配置SmokePing

创建三个必要的目录

```shell
cd /opt/smokeping/htdocs
mkdir cache data var
```

重命名fcgi

```shell
mv smokeping.fcgi.dist smokeping.fcgi
```

修改权限，防止出错

```shell
chmod 600 /opt/smokeping/etc/smokeping_secrets.dist
```

编辑配置文件

```shell
cd /opt/smokeping/etc
cp config.dist config
vi config

# 需要将imgcache,datadir,piddir的路径改为 /opt/smokeping/htdocs/*

imgcache = /opt/smokeping/htdocs/cache
datadir  = /opt/smokeping/htdocs/data
piddir  = /opt/smokeping/htdocs/var
```



## 2.4 启动运行

使用debug模式尝试运行

```shell
cd /opt/smokeping/bin
./smokeping --config=/opt/smokeping/etc/config --debug
# 测试通过后则可以正常启动
```

启动运行smokeping，并开启日志记录

```shell
./smokeping --config=/opt/smokeping/etc/config --logfile=smoke.log
```



# 3 nginx反向代理

## 3.1 安装部署

安装Nginx和Fast_fcgi

```shell
yum -y install nginx
# 由于nginx本身不支持直接访问fcgi，所以需要装一个spawn-fcgi
yum -y install spawn-fcgi
```

调整WEB目录所有者

```shell
chown -R nginx:nginx /opt/smokeping/htdocs
```

**使用spawn-fcgi以nginx用户来启动Smokeping的FCGI程序**

```shell
spawn-fcgi -a 127.0.0.1 -p 9007 -P /var/run/smokeping-fastcgi.pid -u nginx -f /opt/smokeping/htdocs/smokeping.fcgi
```



## 3.2 配置访问主机

创建主机配置文件

```shell
vi /etc/nginx/conf.d/somkeping.conf
# 主机内容如下
server {
        listen       8080;
        server_name  localhost;
        location / {
            root   /opt/smokeping/htdocs/;
            index  index.html index.htm smokeping.fcgi;
        }
        location ~ .*\.fcgi$ {
            root  /opt/smokeping/htdocs/;
            fastcgi_pass   127.0.0.1:9007;
            include /etc/nginx/fastcgi_params;
        }
}
```

配置nginx主配置文件 

```shell
# 清空主配置文件
:.,$d

# 输入新的内容
user  nginx;
worker_processes  4;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
```

启动nginx

```shell
systemctl start nginx
```

关闭防火墙

```shell
systemctl stop firewalld.service
systemctl disable firewalld.service
```

通过WEB浏览器输入`http://ip:8080`



# 4 中文支持

**Smokeping的页面和图表都不支持中文，但可以稍作修改让它支持。**

安装中文字体

```shell
yum -y install wqy-zenhei-fonts.noarch
```

配置文件插入相关编码

```shell
# 修改smokeping主配置文件
vi /opt/smokeping/etc/config

# 在*** Presentation ***下面插入
charset = utf-8

# 修改分组的配置文件
vi /opt/smokeping/lib/Smokeping/Graphs.pm

# 在 '--end', $stasks[0][2],下面插入
'--font TITLE:20:"WenQuanYi Zen Hei Mono"',

# 最后在主配置文件里修改相关部分为中文
```

重启smokeping和fcgi即可

```shell
ps -ef | grep smokeping
kill -9 进程PID

cd /opt/smokeping/bin
./smokeping --config=/opt/smokeping/etc/config --logfile=smoke.log
spawn-fcgi -a 127.0.0.1 -p 9007 -P /var/run/smokeping-fastcgi.pid -u nginx -f /opt/smokeping/htdocs/smokeping.fcgi
```



# 5 参考资料

[IP地址分部查询](http://ip.yqie.com/search.aspx?searchword=%E5%B9%BF%E5%B7%9E)

[CentOS7详细安装配置Smokeing](https://lala.im/2821.html)

[smokeping安装配置使用](https://www.cnblogs.com/icecrystal/p/5851631.html)

[smokeping安装部署最佳实践](https://www.cnblogs.com/xuliangwei/p/6344220.html)

[CentOS6安装smokeping](https://www.cnblogs.com/binleelinux/p/5872067.html)

