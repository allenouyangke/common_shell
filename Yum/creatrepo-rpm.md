### 背景
在离线环境下，如何需要创建某个源，比如python3，比如其他应用的源，可以将收集到的rpm包整合到一个文件夹，打包，传入到目标服务器。以下举例部署一个python3的源。

### 使用createrepo命令生成一个源索引
```
createrepo -d /home/py3

$ cat >>/etc/yum.repos.d/py3.repo<<-EOF
[py3]
name=py3
baseurl=file:///home/py3
gpgcheck=0
enabled=1
```
#### yum重建索引
```
yum clean all
yum makecache
```

测试，安装几个python的包试下
```
yum install python36u -y
```
成功，即可