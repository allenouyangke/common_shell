#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : redis_install.sh
# Revision     : 1.0
# Date         : 2018/08/15
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : redis安装部署脚本。
# -------------------------------------------------------------------------------

source /ops/com/global_funcs.sh && source /ops/com/global_vars.sh

REDISVERSION="redis-3.0.2"
REDISINSTALLPATH="${INSTALL_PATH}/redis"

function RedisInstall
{
    wget http://download.redis.io/releases/${REDISVERSION}.tar.gz -P ${PACKAGES_PATH}
    F_STATUS_MINI "下载${REDISVERSION}"
    tar zxvf ${PACKAGES_PATH}/${REDISVERSION}.tar.gz -C ${PACKAGES_PATH}
    F_STATUS_MINI "解压${REDISVERSION}"
    cd ${PACKAGES_PATH}/${REDISVERSION} && make PREDIX=${REDISINSTALLPATH} install
    F_STATUS_MINI "编译安装${REDISVERSION}"
}

function RedisConfig
{
    \cp ${PACKAGES_PATH}/${REDISVERSION}/redis.conf ${REDISINSTALLPATH}/bin/
    F_STATUS_MINI "获取默认redis.conf文件"

    # 批量检测和创建相关目录
    DIRLIST=(
    conf
    pidfile
    db
    db/Zone1
    redislog
    )
    for DIRNAME in ${DIRLIST}
    do
        F_DIR "${REDISINSTALLPATH}/${DIRNAME}"
    done

    # 写入公共配置文件
    cat > ${REDISINSTALLPATH}/conf/redis_common.conf << EOF
tcp-backlog 511
timeout 0
tcp-keepalive 0
loglevel notice
databases 16
#save 900 1
#save 300 10
#save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
maxmemory 512M
maxmemory-policy volatile-lru
slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
appendonly no
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-entries 512
list-max-ziplist-value 64
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes
daemonize yes
EOF
    F_STATUS_MINI "配置redis_common.conf"

    # 写入Zone1配置文件
    cat > ${REDISINSTALLPATH}/conf/redis_zone1.conf << EOF
port 12001
pidfile /usr/local/redis/pidfile/redis_zone1.pid
logfile /usr/local/redis/redislog/redis_zone1.log
dbfilename dumpzone1.rdb
dir /usr/local/redis/db/Zone1
include /usr/local/redis/conf/redis_common.conf
EOF
    F_STATUS_MINI "配置redis_zone1.conf"
}