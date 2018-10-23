#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : apacheInstall.sh
# Revision     : 1.0
# Date         : 2018/10/23
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------

function ApacheYumInstall
{
    yum install httpd -y
}

function ApacheSourceInstall
{
    wget http://archive.apache.org/dist/httpd/httpd-2.2.25.tar.gz
    tar -xvf httpd-2.2.25.tar.gz
    cd httpd-2.2.25.tar.gz
}