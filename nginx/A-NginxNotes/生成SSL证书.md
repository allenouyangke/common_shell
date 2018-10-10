[TOC]

# 0 关于自签名证书
SL证书是加密网站信息并创建更安全连接的一种方式。此外，证书可以向站点访问者显示虚拟专用服务器的标识信息。证书颁发机构可以颁发SSL证书来验证服务器的详细信息，而自签名证书没有第三方佐证。

# 1 初始化
- 安装EPEL存储库
```
su -c 'rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm' 
```

- 安装Nginx
```
yum install nginx -y
```

# 2 创建证书的目录
- SSL证书分为2个主要部分
    - 证书
    - 公钥

- 创建SSL证书存储目录
```
sudo mkdir -p /etc/nginx/ssl
```

# 3 创建服务器秘钥和证书签名请求
- 创建私有服务器密钥（要求输入密码）
```
sudo openssl genrsa -des3 -out server.key 1024
```

- 创建证书签名请求
```
sudo openssl req -new -key server.key -out server.csr
```
注意：最重要的一行是“Common Name”。在这里输入您的官方网域名称，如果您还没有，请输入您网站的IP位址。将挑战密码和可选的公司名称留空

# 4 删除密码
- 若有密码，每次重启nginx时都需要手动输入密码
```
sudo cp server.key server.key.org
sudo openssl rsa -in server.key.org -out server.key
```

# 5 签署您的SSL证书
- 通过将365更改为您希望的天数来指定证书应保持有效的时间
```
sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
```

# 6 设置证书
- 修改配置文件内容，启用SSL证书
```
vi /etc/nginx/conf.d/ssl.conf

# HTTPS server

server {
    listen       443;
    server_name example.com;

    ssl on;
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key; 
}
```

- 重启Nginx
```
/etc/init.d/nginx restart
```

# 7 访问测试
- 浏览器上访问https+域名|IP，访问成功并且显示安全的https链接即可。

# 8 参考文档
[如何在nginx上为CentOS 6创建SSL证书](https://blog.csdn.net/hanshileiai/article/details/54579948#t2)