- 关闭SELINUX

```shell
vi /etc/selinux/config    #编辑SELINUX配置文件

#SELINUX=enforcing        #修改:注释掉
#SELINUXTYPE=targeted     #修改:注释掉
SELINUX=disabled          #增加

setenforce 0              #使配置立即生效
```