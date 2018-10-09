[TOC]

# 1 基础概述
- redis是用C语言开发的一个开源的高性能键值对（key-value）数据库。它通过提供多种键值数据类型来适应不同场景下的存储需求。

- 目前为止redis支持的键值数据类型如下
    - 字符串
    - 列表（lists）
    - 集合（sets）
    - 有序集合（sorts sets）
    - 哈希表（hashs）

- 默认端口：6379

- key设置说明
    - key不要太长，尽量不要超过1024字节，这不仅消耗内存，而且会降低查找的效率；
    - key也不要太短，太短的话，key的可读性会降低；
    - 在一个项目中，key最好使用统一的命名模式，例如user:10000:passwd；

# 2 应用场景
- 缓存（数据查询、短连接等）
- 分布式集群架构中的session分离
- 任务队列（抢购、秒杀、12306等）
- 网站访问统计
- 数据过期处理（精确到毫秒）

# 3 安装部署
- Redis从3.0开始增加了集群功能。

- [Redis下载](http://download.redis.io)
- [Redis3.0稳定版](http://download.redis.io/releases/redis-3.0.0.tar.gz)

- 部署
```shell
wget http://download.redis.io/releases/redis-3.0.0.tar.gz -P /usr/local/src/

cd /usr/local/src/
tar -zxvf redis-3.0.0.tar.gz -C /usr/local/
cd /usr/local/redis-3.0.0

# 编译安装
make PREFIX=/usr/local/redis install
# redis.conf是redis的配置文件，redis.conf在redis源码目录
cd /usr/local/redis
mkdir conf
cp /usr/local/redis-3.0.0/redis.conf  /usr/local/redis/bin
```

- redis/bin目录

命令 | 说明
---|---
redis-benchmark | redis性能测试工具
redis-check-aof | AOF文件修复工具
redis-check-rdb | RDB文件修复工具
redis-check-dump | dump.rdb文件修复工具
redis-cli | redis命令行客户端
redis.conf | redis配置文件
redis-sentinal | redis集群管理工具
redis-server | redis服务进程


# 4 Redis常用操作
## 4.1 前端模式启动(不推荐)
- 启动命令
`bin/redis-server`

## 4.2 后端模式启动

- 修改配置文件redis.conf
```shell
vim /usr/local/redis/conf/reids.conf
daemonize yes
```

- 启动命令

```shell
cd /usr/local/redis
./bin/redis-server ./redis.conf
```


## 4.3 连接Redis
- 连接redis
`/usr/local/redis/bin/redis-cli`

## 4.4 关闭Redis
- 强制终止Redis进程会导致Redis持久化数据丢失。
```shell
pkill redis-server
pkill -9 redis-server
```

- 正确停止Redis应该向服务端发送SHUTDOWN命令。
```shell
cd /usr/local/redis
./bin/redis-cli shutdown
```

## 4.5 开机自启动
```shell
vim /etc/rc.local
# 添加
/usr/local/redis/bin/redis-server /usr/local/redis/etc/redis-conf
```