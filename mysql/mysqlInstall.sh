#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : mysql_install.sh
# Revision     : 1.0
# Date         : 2018/08/14
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : mysql5.6部署脚本。
# -------------------------------------------------------------------------------

source /ops/com/global_vars.sh && source /ops/com/global_funcs.sh

#!/bin/bash
# 查看CPU核数
cpu=`grep processor /proc/cpuinfo|awk '{print$NF}'|wc -l`

# 安装依赖文件
yum -y install gcc gcc-c++ automake autoconf libtool make ncurses-devel libxml2 libxml2-devel cmake svn bison wget

# 下载源码包
wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.17.tar.gz
wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.40.tar.gz
#wget http://mirrors.neusoft.edu.cn/mariadb/mariadb-galera-5.5.39/bintar-linux-x86_64/mariadb-galera-5.5.39-linux-x86_64.tar.gz
#wget http://downloads.mysql.com/archives/get/file/mysql-5.5.30.tar.gz

# 解压安装包
tar xf mysql-5.6.17.tar.gz
cd mysql-5.6.17

# 创建相关用户、用户组核目录，并设置权限
groupadd mysql
useradd -g mysql -s /sbin/nologin mysql
mkdir -p /usr/local/mysql
mkdir -p /export/mysql
mkdir -p /export/mysql/logs
mkdir -p /export/logs
chown -R mysql.mysql /export/mysql
chown -R mysql.mysql /export/logs


# 配置、编译、安装
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_UNIX_ADDR=/home/mysql/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS:STRING=utf8,gbk -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 -DMYSQL_DATADIR=/export/mysql/ -DMYSQL_USER=mysql -DMYSQL_TCP_PORT=3306
make -j$cpu
make install
chmod 755 scripts/mysql_install_db
scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/export/mysql/
/bin/cp -f my.cnf /etc/my.cnf
/bin/cp -f support-files/mysql.server /etc/init.d/mysqld

chmod 755 /etc/init.d/mysqld
chkconfig mysql on
echo 'export PATH=/usr/local/mysql/bin:$PATH' >> /root/.bashrc
echo "/usr/local/mysql/lib" >> /etc/ld.so.conf
source /root/.bashrc
ldconfig
