# 日志分析
主要针对access_log(默认日志)

- 查找访问频率最高的URL和次数
```shell
cat access.log | awk -F '^A' '{print $10}' | sort | uniq -c
```

- 查找当前日志文件 500 错误的访问
```shell
cat access.log | awk -F '^A' '{if($5 == 500) print $0}'
```

- 查找当前日志文件 500 错误的数量
```shell
cat access.log | awk -F '^A' '{if($5 == 500) print $0}' | wc -l
```

- 查找某一分钟内 500 错误访问的数量
```shell
cat access.log | awk -F '^A' '{if($5 == 500) print $0}' | grep '09:00' | wc-l
```

- 查找耗时超过 1s 的慢请求
```shell
tail -f access.log | awk -F '^A' '{if($6>1) print $0}'
```

- 假如只想查看某些位
```shell
tail -f access.log | awk -F '^A' '{if($6>1) print $3"|"$4}'
```

- 查找 502 错误最多的 URL
```shell
cat access.log | awk -F '^A' '{if($5==502) print $11}' | sort | uniq -c
```

- 查找 200 空白页
```shell
cat access.log | awk -F '^A' '{if($5==200 && $8 < 100) print $3"|"$4"|"$11"|"$6}'
```

# 切割日志
Nginx 的日志都是写在一个文件当中的，不会自动地进行切割，如果访问量很大的话，将导致日志文件容量非常大，不便于管理和造成Nginx 日志写入效率低下等问题。所以，往往需要要对access_log、error_log日志进行切割。

- 切割日志一般利用USER1信号让nginx产生新的日志  
[Nginx日志切割脚本](../../nginxLogCut.sh)

- 脚本分析
    - 将上面的脚本放到crontab中，每小时执行一次（0 ），这样每小时会把当前日志重命名成一个新文件；然后发送USR1这个信号让Nginx 重新生成一个新的日志。（相当于备份日志）
    - 将前7天的日志删除

- 脚本说明
    - 在没有执行kill -USR1 $pid之前，即便已经对文件执行了mv命令而改变了文件名称，nginx还是会向新命名的文件”*access.log.2016032623”照常写入日志数据的。原因在于：linux系统中，内核是根据文件描述符来找文件的。

- logrotates
    - 使用系统自带的logrotates，也可以实现nginx的日志分割，查看其bash源码，发现也是发送USR1这个信号。