#!/bin/bash
# -------------------------------------------------------------------------------
# Script_name  : gitBranchControl.sh
# Revision     : 1.0
# Date         : 2018/10/30
# Author       : AllenKe
# Email        : allenouyangke@icloud.com
# Description  : Git上下班操作脚本pull/push
# -------------------------------------------------------------------------------

REPO_PATH="/e/GithubRepositories/MyRepositories"

function F_RED
{
    echo -e "\033[31m ${1} \033[0m"
}

function F_GREEN
{
    echo -e "\033[32m ${1} \033[0m"
}

function NextStep
{
    if [ "${1}" == "n" -o "${1}" == "N" ];then 
        break 
    fi
}

function RepoList
{
    ls -F ${REPO_PATH} | grep '/$' |tr -d /
}

function GitPull
{
    if [ $# != 2 ];then F_RED "Usage: Please enter [pull|push|list] <[RepoName]> <[BranchName]>";exit 65;fi
    cd ${REPO_PATH}/${1}
    F_GREEN "进入common_shell目录"
    sleep 1
    git checkout master
    F_GREEN "切换到master分支"
    sleep 1
    git pull origin master
    F_GREEN "从origin master更新local master"
    sleep 1

    git checkout ${2}
    F_GREEN "切换到win_shell分支"
    sleep 1
    git merge master
    F_GREEN "将master分支合并更新到win_shell分支"
    sleep 1
    git push origin ${2}
    F_GREEN "更新origin win_shell分支"
    sleep 1
}

function GitPush
{
    if [ $# != 2 ];then F_RED "Usage: Please enter [pull|push|list] <[RepoName]> <[BranchName]>";exit 65;fi
    cd ${REPO_PATH}/${1}
    F_GREEN "进入common_shell目录"
    sleep 1
    git checkout master
    F_GREEN "切换到master分支"
    sleep 1
    git pull origin master
    F_GREEN "更新local master分支"
    sleep 1
    git merge ${2}
    F_GREEN "将win_shell分支合并更新到master分支"
    sleep 1
    git push origin master
    F_GREEN "更新origin master分支"
    git checkout ${2}
    F_GREEN "切换到win_shell分支"
    sleep 1
    git push origin ${2}
    F_GREEN "更新origin win_shell分支"
    sleep 1
}


case ${1} in
    pull) 
        GitPull ${2} ${3} ;;
    push)
        F_RED "Warning:Execute push to determine if the change commit has been made."
        echo -n "是否继续添加/删除: [y/n]:" 
        read OPTION
        NextStep ${OPTION} 
        GitPush ${2} ${3} ;;
    list) 
        RepoList ;;
    *) 
        F_RED "Usage: Please enter [pull|push] [RepoName] [BranchName]" && exit 65 ;;
esac

exit 0