# 0 nginx日志
- log_format:用来设置日志格式
- access_log:用来指定日志文件的存放路径、格式（定义的log_format 跟在后面）和缓存大小

# 1 log_format日志格式
## 1.1 语法格式
```shell
log_format $NAME $FORMATSTYLE

# eg：
log_format   main   
'$remote_addr - $remote_user [$time_local] "$request" '
'$status $body_bytes_s ent "$http_referer" '
'"$http_user_agent" "$http_x_forwarded_for"'
```

## 1.2 设置参数说明
![](../Images/log_format_msg.jpg)

## 1.3 x_forwarded_for
通常web服务器放在反向代理的后面，这样就不能获取到客户的IP地址了，通过$remote_addr拿到的IP地址是反向代理服务器的iP地址。反向代理服务器在转发请求的http头信息中，可以增加x_forwarded_for信息，用以记录原有客户端的IP地址和原来客户端的请求的服务器地址。

注：在server中设置x_forwarded_for

```shell
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
```

# 2 access_log
用了log_format 指令设置了日志格式之后，需要用access_log指令指定日志文件的存放路径；

## 2.1 语法格式
```shell
access_log $PATH $FORMATNAME

# eg：
access_log logs/access.log main;

# 不启用
access_log off ;
```

## 2.2 设置刷盘策略
```shell
# buffer 满 32k 才刷盘；假如 buffer 不满 5s 钟强制刷盘。
access_log /data/logs/nginx-access.log buffer=32k flush=5s;

# 注：一般log_format在全局设置，可以设置多个。access_log 可以在全局设置，但往往是定义在虚拟主机（server）中的location中。

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                   '"$status" $body_bytes_sent "$http_referer" '
                   '"$http_user_agent" "$http_x_forwarded_for" '
                   '"$gzip_ratio" $request_time $bytes_sent $request_length';
    log_format srcache_log '$remote_addr - $remote_user [$time_local] "$request" '
                        '"$status" $body_bytes_sent $request_time $bytes_sent $request_length '
                        '[$upstream_response_time] [$srcache_fetch_status] [$srcache_store_status] [$srcache_expire]';
 open_log_file_cache max=1000 inactive=60s;
    server {
        server_name ~^(www\.)?(.+)$;
        access_log logs/$2-access.log main;
        error_log logs/$2-error.log;
        location /srcache {
            access_log logs/access-srcache.log srcache_log;
        }
    }
}
```

## 2.3 其他设置
- error_log
配置错误日志

- open_log_file_cache
```shell
# 对于每一条日志记录，都将是先打开文件，再写入日志，然后关闭。可以使用open_log_file_cache来设置日志文件缓存(默认是off)。

# 语法格式
open_log_file_cache max=N [inactive=time] [min_uses=N] [valid=time];

# 参数说明
# max:设置缓存中的最大文件描述符数量，如果缓存被占满，采用LRU算法将描述符关闭。
# inactive:设置存活时间，默认是10s
# min_uses:设置在inactive时间段内，日志文件最少使用多少次后，该日志文件描述符记入缓存中，默认是1次
# valid:设置检查频率，默认60s

# eg：
open_log_file_cache max=1000 inactive=20s valid=1m min_uses=2;
```
