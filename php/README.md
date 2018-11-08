# 一 准备篇

## 1 配置网络 & 关闭 SELINUX & 配置防火墙

[配置网络 & 关闭 SELINUX & 配置防火墙](https://www.jianshu.com/p/6ee0c701437b)

# 二 安装篇

## 1 添加 php Webtatic yum 源

- CentOS 6
```shell
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
```

- CentOS 7
```shell
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
```

## 2 yum 安装
- php5.6
```shell
yum -y install php56w-fpm
```

- php7.0
```shell
yum -y install php70w-fpm
```

- php7.1
```shell
yum -y install php71w-fpm
```

## 3 启动 php-fpm

- CentOS 6
```shell
service php-fpm start
chkconfig php-fpm on 
```

- CentOS 7
```shell
systemctl start php-fpm.service
systemctl enable php-fpm.service
```

## 4 状态管理命令
- CentOS 6
```shell
/etc/rc.d/init.d/php-fpm
```

```shell
service php-fpm start
service php-fpm stop
service php-fpm restart
service php-fpm reload
service php-fpm force-reload
service php-fpm condrestart
service php-fpm try-restart
service php-fpm status
service php-fpm configtest
chkconfig php-fpm on                       #启用开机自启
chkconfig php-fpm off                      #禁用开机自启
```

- CentOS 7
```shell
/usr/lib/systemd/system/php-fpm.service
```

```shell
systemctl start php-fpm.service              #启动
systemctl stop php-fpm.service               #停止
systemctl restart php-fpm.service            #重启
systemctl reload php-fpm.service             #重载
systemctl status php-fpm.service             #检查服务
systemctl enable php-fpm.service             #启用开机自启
systemctl disable php-fpm.service            #禁用开机自启
```

## 5 相关软件目录及文件位置
```shell
/usr/sbin/php-fpm
/etc/php-fpm.conf
/etc/php.ini
/var/run/php-fpm/php-fpm.pid
```

# 三 配置 nginx 支持 php
## 1 安装 nginx

[Centos 下，yum 安装 nginx](https://www.jianshu.com/p/2ddffe61d8fa)

## 2 处理 php-fpm 配置
```shell
vi /etc/php-fpm.d/www.conf
```

```shell
user = www
group = www
```

## 3 处理 nginx 配置
```shell
vi /etc/nginx/nginx.conf
```

```shell
user www;                         #修改nginx运行用户为www
```

## 4 处理 nginx 默认虚拟主机配置
```shell
vi /etc/nginx/conf.d/default.conf  #取消FastCGI server部分location的注释，注意fastcgi_param行的参数，改为$document_root$fastcgi_script_name
```

```shell
location ~ \.php$ {
  root /usr/share/nginx/html;
  fastcgi_pass 127.0.0.1:9000;
  fastcgi_index index.php;
  fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
  include fastcgi_params;
}
```

## 5 重启 nginx 和 php-fpm
- CentOS 6
```shell
service nginx restart && service php-fpm restart
```

- CentOS 7
```shell
systemctl restart nginx.service && systemctl restart php-fpm.service
```

## 6 测试脚本
```shell
vi /usr/share/nginx/html/phpinfo.php
```

```php
<?php
phpinfo();
?>
```

## 7 在浏览器打开测试地址，看到 phpinfo 页面，即安装成功。
```shell
http://192.168.0.150/phpinfo.php
```

# 四，扩展篇
## 1 使用 yum 安装扩展
- php7.1
```shell
yum -y install php71w-common        #php-api, php-bz2, php-calendar, php-ctype, php-curl, php-date, php-exif, php-fileinfo, php-filter, php-ftp, php-gettext, php-gmp, php-hash, php-iconv, php-json, php-libxml, php-openssl, php-pcre, php-pecl-Fileinfo, php-pecl-phar, php-pecl-zip, php-reflection, php-session, php-shmop, php-simplexml, php-sockets, php-spl, php-tokenizer, php-zend-abi, php-zip, php-zlib
yum -y install php71w-cli           #php-cgi, php-pcntl, php-readline
yum -y install php71w-opcache       #php71w-pecl-zendopcache
yum -y install php71w-bcmath    
yum -y install php71w-dba   
yum -y install php71w-devel 
yum -y install php71w-embedded      #php-embedded-devel
yum -y install php71w-enchant       
yum -y install php71w-gd    
yum -y install php71w-imap  
yum -y install php71w-interbase #php_database, php-firebird
yum -y install php71w-intl  
yum -y install php71w-ldap  
yum -y install php71w-mbstring  
yum -y install php71w-mcrypt    
yum -y install php71w-mysql     #php-mysqli, php_database
yum -y install php71w-mysqlnd       #php-mysqli, php_database
yum -y install php71w-odbc          #php-pdo_odbc, php_database
yum -y install php71w-pdo           #php71w-pdo_sqlite, php71w-sqlite3
yum -y install php71w-pdo_dblib #php71w-mssql
yum -y install php71w-pear  
yum -y install php71w-pecl-apcu 
yum -y install php71w-pecl-imagick  
yum -y install php71w-pecl-memcached    
yum -y install php71w-pecl-mongodb  
yum -y install php71w-pecl-redis    
yum -y install php71w-pecl-xdebug   
yum -y install php71w-pgsql      #php-pdo_pgsql, php_database
yum -y install php71w-phpdbg    
yum -y install php71w-process        #php-posix, php-sysvmsg, php-sysvsem, php-sysvshm
yum -y install php71w-pspell    
yum -y install php71w-recode    
yum -y install php71w-snmp  
yum -y install php71w-soap  
yum -y install php71w-tidy  
yum -y install php71w-xml            #php-dom, php-domxml, php-wddx, php-xsl
yum -y install php71w-xmlrpc
```

# 五 优化篇

暂无

# 六 参考文章

[Webtatic Yum 储存库使用指南](https://link.jianshu.com?t=https://webtatic.com/projects/yum-repository/)  
[CentOS yum安装php](https://www.jianshu.com/p/460891081d55)