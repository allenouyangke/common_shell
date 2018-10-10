[TOC]

# 1 度量单位
1 k  =  1000 bytes  
1 kb =  1024 bytes  
1 m  =  1000000 bytes  
1 mb =  1024 * 1024 bytes  
1 g  =  1000000000 bytes  
1 gb =  1024 * 1024 * 1024 bytes  

- redis配置中对单位的大小写不敏感，1GB、1Gb和1gB都是相同的
- redis只支持bytes，不支持bit单位

# 2 配置文件
- 支持“主配置文件中引入外部配置文件”
`include conf/*.conf`

-  配置文件几大块
    - 通用（general）
    - 快照（snapshotting）
    - 复制（replication）
    - 安全（security）
    - 限制（limits）
    - 追加模式（append only mode）
    - LUA脚本（lua scripting）
    - 慢日志（slow log）
    - 事件通知（event notification）

# 2.1 通用（general）
- 默认情况下，不以daemon形式运行。
`daemonize no|yes`

- 以daemon模式运行时，会生成一个pid文件，默认`/var/run/redis.pid`
重新指定pid文件位置：`pidfile /tmp/redis.pid`

- 默认情况下，redis会响应本机所有可用网络的连接请求；可用`bind`配置来指定要绑定的IP
`bind 172.16.12.13 10.8.4.2`

- 默认端口为6379，通过`port`进行修改，o表示不监听端口

- redis接收请求的方式
    - 监听端口
    - 通过socket方式

- 通过unixsocket配置项来指定unix socket文件的路径，并通过unixsocketperm来指定文件的权限
```shell
unixsocket /tmp/redis.sock
unixsocketperm 755
```

- 当一个redis-client一直没有请求发向server端，那么server端有权主动关闭这个连接，可以通过timeout来设置“空闲超时时限”，0表示永不关闭。

- loglevel设置日志等级
    - debug
    - verbose
    - notice
    - warning

- logfile指定日志位置

- 将日志打印到syslog
`syslog-ident redis`

- 指定syslog设备
`syslog-facility local0`

- 设置数据库总数（编号从0开始到NUM）
`databases NUM`

## 2.2 快照（snapshotting）
- 主要涉及的是RDB持续化相关配置

- 将数据保存到磁盘上通过`save`
```shell
# 每15分钟且至少有1个key改变，就触发一次持久化
save 900 1 

# 每5分钟且至少有10个key改变，就触发一次持久化
save 300 10

# 每60秒至少有10000个key改变，就触发一次持久化
save 60 10000
```

- 禁用RDB持久化的策略，只要不设置任何save指令就可以，或者给save传入一个空字符串参数也可以达到相同效果

- 如果用户开启了RDB快照功能，那么在redis持久化数据到磁盘时如果出现失败，默认情况下，redis会停止接受所有的写请求;如果下一次RDB持久化成功，redis会自动恢复接受写请求。
关闭持久化失败停止写请求：`stop-writes-on-bgsave-error yes`

- 采用LZF算法进行压缩压缩快照（会消耗CPU），不压缩持续化数据会很大
`rdbcompression yes`

- 存储快照后，我们还可以让redis使用CRC64算法来进行数据校验，但是这样做会增加大约10%的性能消耗
`rdbchecksum yes`

- 设置快照文件的名称，默认配置如下
`dbfilename dump.rdb`

- 设置快照存放路径
`dir ./`

## 2.3 复制（replication）
- 通过slaveof配置项可以控制某一个redis作为另一个redis的从服务器，通过指定IP和端口来定位到主redis的位置
`slaveof`

- 如果主redis设置了验证密码的话（使用requirepass来设置），则在从redis的配置中要使用masterauth来设置校验密码，否则的话，主redis会拒绝从redis的访问请求
`masterauth`

- 当从redis失去了与主redis的连接，或者主从同步正在进行中时，redis该如何处理外部发来的访问请求呢？这里，从redis可以有两种选择：
    - 第一种选择：如果`slave-serve-stale-data`设置为yes（默认），则从redis仍会继续响应客户端的读写请求
    - 第二种选择：如果slave-serve-stale-data设置为no，则从redis会对客户端的请求返回“SYNC with master in progress”，当然也有例外，当客户端发来INFO请求和SLAVEOF请求，从redis还是会进行处理

- 控制一个从redis是否可以接受写请求。将数据直接写入从redis，一般只适用于那些生命周期非常短的数据，因为在主从同步时，这些临时数据就会被清理掉。自从redis2.6版本之后，默认从redis为只读
`slave-read-only yes`

- 只读的从redis并不适合直接暴露给不可信的客户端。为了尽量降低风险，可以使用rename-command指令来将一些可能有破坏力的命令重命名，避免外部直接调用
`rename-command CONFIG b840fc02d524045429941cc15f59e41cb7be6c52`

- 从redis会周期性的向主redis发出PING包。你可以通过repl_ping_slave_period指令来控制其周期。默认是10秒
`repl-ping-slave-period 10`

- 主从同步出现超时的情况
    用户可以设置超时的时限，不过要确保这个时限比repl-ping-slave-period的值要大，否则每次主redis都会认为从redis超时
    - 以从redis的角度来看，当有大规模IO传输时。
    - 以从redis的角度来看，当数据传输或PING时，主redis超时
    - 以主redis的角度来看，在回复从redis的PING时，从redis超时
`repl-timeout 60`

- 如果开启TCP_NODELAY，那么主redis会使用更少的TCP包和更少的带宽来向从redis传输数据。但是这可能会增加一些同步的延迟，大概会达到40毫秒左右。如果你关闭了TCP_NODELAY，那么数据同步的延迟时间会降低，但是会消耗更多的带宽
`repl-disable-tcp-nodelay no`

- 队列长度（backlog)是主redis中的一个缓冲区，在与从redis断开连接期间，主redis会用这个缓冲区来缓存应该发给从redis的数据。这样的话，当从redis重新连接上之后，就不必重新全量同步数据，只需要同步这部分增量数据即可
`repl-backlog-size 1mb`

- 如果主redis等了一段时间之后，还是无法连接到从redis，那么缓冲队列中的数据将被清理掉。我们可以设置主redis要等待的时间长度。如果设置为0，则表示永远不清理。默认是1个小时
`repl-backlog-ttl 3600`

- 在主redis持续工作不正常的情况，优先级高的从redis将会升级为主redis。而编号越小，优先级越高。比如一个主redis有三个从redis，优先级编号分别为10、100、25，那么编号为10的从redis将会被首先选中升级为主redis。当优先级被设置为0时，这个从redis将永远也不会被选中。默认的优先级为100
`slave-priority 100`

- 假如主redis发现有超过M个从redis的连接延时大于N秒，那么主redis就停止接受外来的写请求。这是因为从redis一般会每秒钟都向主redis发出PING，而主redis会记录每一个从redis最近一次发来PING的时间点，所以主redis能够了解每一个从redis的运行情况
- 假如有大于等于3个从redis的连接延迟大于10秒，那么主redis就不再接受外部的写请求。上述两个配置中有一个被置为0，则这个特性将被关闭。默认情况下min-slaves-to-write为0，而min-slaves-max-lag为10
```shell
min-slaves-to-write 3
min-slaves-max-lag 10
```

## 2.4 安全（security）
- 要求redis客户端在向redis-server发送请求之前，先进行密码验证。当你的redis-server处于一个不太可信的网络环境中时，相信你会用上这个功能。由于redis性能非常高，所以每秒钟可以完成多达15万次的密码尝试，所以你最好设置一个足够复杂的密码，否则很容易被黑客破解  
`requirepass STRONGPASSORD`

- 对redis指令进行更名；例如可以把CONFIG命令改成一个很复杂的名字，这样可以避免外部的调用
```shell
rename-command CONFIG b840fc02d524045429941cc15f59e41cb7be6c89

# 设为空 
rename-command CONFIG ""
```

## 2.5 限制（limits）
- 设置redis同时可以与多少个客户端进行连接。默认情况下为10000个客户端

- 无法设置进程文件句柄限制时，redis会设置为当前的文件句柄限制值减去32，因为redis会为自身内部处理逻辑留一些句柄出来。如果达到了此限制，redis则会拒绝新的连接请求，并且向这些连接请求方发出“max number of clients reached”以作回应  
`maxclients 10000`

- 如果redis无法根据移除规则来移除内存中的数据，或者我们设置了“不允许移除”，那么redis则会针对那些需要申请内存的指令返回错误信息，比如SET、LPUSH等。但是对于无内存申请的指令，仍然会正常响应，比如GET等  
`maxmemory`

- 如果你的redis是主redis（说明你的redis有从redis），那么在设置内存使用上限时，需要在系统中留出一些内存空间给同步队列缓存，只有在你设置的是“不移除”的情况下，才不用考虑这个因素  
`maxmemory-policy volatile-lru`

- redis内存移除规则（6种）
    - volatile-lru：使用LRU算法移除过期集合中的key
    - allkeys-lru：使用LRU算法移除key
    - volatile-random：在过期集合中移除随机的key
    - allkeys-random：移除随机的key
    - volatile-ttl：移除那些TTL值最小的key，即那些最近才过期的key
    - noeviction：不进行移除。针对写操作，只是返回错误信息

- LRU算法和最小TTL算法都并非是精确的算法，而是估算值。所以你可以设置样本的大小。假如redis默认会检查三个key并选择其中LRU的那个，那么你可以改变这个key样本的数量
`maxmemory-samples 3`

- redis支持的写命令
```
set setnx setex append

incr decr rpush lpush rpushx lpushx linsert lset rpoplpush sadd

sinter sinterstore sunion sunionstore sdiff sdiffstore zadd zincrby

zunionstore zinterstore hset hsetnx hmset hincrby incrby decrby

getset mset msetnx exec sort
```

## 2.6 追加模式（append only mode）
- 开启追加模式
`appendonly no`

- 设置aof文件的名称
`appendfilename "appendonly.aof"`

- fsync()调用，用来告诉操作系统立即将缓存的指令写入磁盘  
支持三种不同的模式
    - no：不调用fsync()。而是让操作系统自行决定sync的时间。这种模式下，redis的性能会最快
    - always：在每次写请求后都调用fsync()。这种模式下，redis会相对较慢，但数据最安全
    - everysec：每秒钟调用一次fsync()。这是性能和安全的折中  
`appendfsync everysec`

- 如果你的redis有时延问题，那么请将下面的选项设置为yes。否则请保持no，因为这是保证数据完整性的最安全的选择
`no-appendfsync-on-rewrite no`

## 2.7 LUA脚本（lua scripting）
- Lua脚本的最大运行时间是需要被严格限制的，要注意单位是毫秒（ms）,设置为0或负数，则既不会有报错也不会有时间限制
`lua-time-limit 5000`

## 2.8 慢日志（slow log）
- 是指一个系统进行日志查询超过了指定的时长。这个时长不包括IO操作，比如与客户端的交互、发送响应内容等，而仅包括实际执行查询命令的时间

- 针对慢日志，可以设置两个参数
    - 执行时长，单位是微秒，
    - 慢日志的长度
- 当一个新的命令被写入日志时，最老的一条会从命令日志队列中被移除

- 单位是微秒，即1000000表示一秒。负数则会禁用慢日志功能，而0则表示强制记录每一个命令。  
`slowlog-log-slower-than 10000`

- 慢日志最大长度，可以随便填写数值，没有上限，但要注意它会消耗内存。使用SLOWLOG RESET来重设这个值  
`slowlog-max-len 128`

## 2.8 事件通知（event notification）

# 3 高级配置
- 哈希数据结构相关配置
```
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
```

- 列表数据结构相关配置
```
list-max-ziplist-entries 512
list-max-ziplist-value 64
```

- 集合数据结构相关配置
```
set-max-intset-entries 512
```

- 有序集合数据结构的配置项
```
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
```

- 是否需要哈希的配置项
```
activerehashing yes
```

- 客户端输出缓冲的控制项
```
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
```

- 频率的配置项
```
hz 10
```

- 重写aof的配置项
```
aof-rewrite-incremental-fsync yes
```

# 4 相关资料
[超详细Redis入门教程](https://www.jianshu.com/p/19cfc2343121)

后续需要学习了解redis集群、redis工作原理、redis源码、redis相关LIB库等内容