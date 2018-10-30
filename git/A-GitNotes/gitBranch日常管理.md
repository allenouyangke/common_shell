# 上班第一件事
remote master上的内容merge 到自己的开发分支上 

```shell
# 切换到master分支
git checkout master

# 将remote master同步到local master
git pull origin master

# 切换到的local开发分支
git checkout dev_xxx

# 合并 local master 到 local的开发分支
git merge master

# 推送更新到gitlab，使gitlab同步更新显示
git push origin dev_xxx
```

　　
# 下班最后一件事
将自己分支的内容merge到remote master上

```shell
# 切换到 local 开发分支, 并提交到 local  开发分支
git checkout dev_xxx
git status
git add .
git commit -m "@@@"

# 将remote master 的更新下载到本地
git checkout master
git pull origin masterr 

# 将 local  开发分支merge到 local master
git merge dev_xxx

# 将 local master  推送更新到gitlab，使gitlab  remote master同步更新显示
git push origin master

# 将 local dev_xxx  推送更新到gitlab，使gitlab  remote dev_xxx同步更新显示
git checkout dev_xxx
git push origin dev_xxx
```