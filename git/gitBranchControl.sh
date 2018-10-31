#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : gitBranchControl.sh
# Revision     : 1.0
# Date         : 2018/10/30
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  :
# -------------------------------------------------------------------------------



BRANCHNAME=${1}

function RemoteToLocal
{
    git checkout master
    git pull origin master
    git checkout ${BRANCHNAME}
    git merge master
}

function LocalToRemote
{
    git checkout ${BRANCHNAME}
    git status
    git add .
    git commit -m "$1"
    git push origin ${BRANCHNAME}
}

function Main
{
    case ${1} in
        gitpull) RemoteToLocal;;
        gitpush) LocalToRemote;; 
    esac
}

Main