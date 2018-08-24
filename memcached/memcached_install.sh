#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : memcached_install.sh
# Revision     : 1.0
# Date         : 2018/08/15
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : memcached安装部署脚本。
# -------------------------------------------------------------------------------

source /ops/com/global_funcs.sh && source /ops/com/global_vars.sh

 MCVERSION="memcached-1.5.10"
 MCINSTALLPATH="${INSTALL_PATH}/memcached"

function MemcachedInstall
{   
    wget http://memcached.org/files/${MCVERSION}.tar.gz -P ${PACKAGES_PATH}
    F_STATUS_MINI "下载${MCVERSION}"
    tar zxvf ${PACKAGES_PATH}/${MCVERSION}.tar.gz -C ${PACKAGES_PATH}
    F_STATUS_MINI "解压${MVVERSION}"
    yum install gcc libevent libevent-devel -y
    F_STATUS_MINI "安装相关依赖包"
    cd ${PACKAGES_PATH}/${MCVERSION} && ./configure --prefix=${INSTALL_PATH}/memcached
    F_STATUS_MINI "配置memcached"
    make
    F_STATUS_MINI "编译"
    make install
    F_STATUS_MINI "安装"
}

function MemcachedScript
{
    
    mkdir ${MCINSTALLPATH}/pid
    F_STATUS_MINI "创建pid目录"
    mkdir ${MCINSTALLPATH}/script
    F_STATUS_MINI "创建script目录"

    cat > ${MCINSTALLPATH}/script/startOnlineStat.sh <<EOF
#!/bin/bash
/home/memcached/bin/memcached -d -P /home/memcached/pid/onlinestat.pid -u root -m 4096 -l 192.168.176.130 -p 23060 -c 4096 -t 16
EOF
    F_STATUS_MINI "创建启动脚本"
}

function MemcachedUsage
{
    F_PRINT_WARN "Usage: $0 install|script"
}

