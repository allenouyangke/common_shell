#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name : gitInstallNoRely.sh
# Revision : 1.0
# Date : 2018/11/09
# Author : AllenKe
# Email : allenouyangke@icloud.com
# Description :
# -------------------------------------------------------------------------------

if [ $? == 0 ];then yum remove git -y;fi

yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel asciidoc gcc perl-ExtUtils-MakeMaker -y

wget https://github.com/git/git/archive/v2.2.1.tar.gz -C /usr/local/src/

tar zxcf /usr/local/src/v2.2.1.tar.gz -P /usr/local/src/

cd /usr/local/src/ && cd `find ./ -name git -type d`

make configure

./configure --prefix=/usr/local/git --with-iconv=/usr/local/libiconv

make install 

echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc

source /etc/bashrc