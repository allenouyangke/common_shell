[TOC]

# 1 部署环境

- NFS服务器
- NFS客户端

# 2 服务器端安装部署
- 检查nfs-utils,rpcbind是否安装
`rpm -qa | egrep "rpcbind|nfs"`

- 安装nfs
`yum -y install nfs-utils rpcbind`

- 创建共享目录
`mkdir /sharestore`

- NFS共享文件路径配置
```shell
vim /etc/exports
/sharestore     *(rw,sync,no_root_squash)
```

- 启动NFS服务（先启动rpcbind，再启动nfs；若都已安装，则重启。）
```shell
service rpcbind restart
servcie nfs restart
```

- 设置开机自启动
```shell
chkconfig rpcbind on
chkconfig nfs on
```

# 3 客户端挂载配置
- 创建一个挂载点
`mkdir /mnt/store`

- 查看NFS服务器上的共享
`showmount -e IPADDRESS`

- 挂载
`mount -t nfs IPADDRESS:/sharestore /mnt/store`

- 查看已挂载共享
`mount`