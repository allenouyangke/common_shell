### svn命令行常用

### 获取远程仓库到本地
```
svn checkout svn://[ip|domain] --username=**
或者
svn co svn://username@[ip|domain] 
```
### 增
```
添加指定文件或目录
svn add 'file'或'dir'

添加所有目录文件
svn add *

创建纳入版本目录
svn mkdir -m 'commit message' 'url/dir'
```

### 提交|更新
```
更新指定文件
svn update 'file'

更新所有文件
svn update
```
### 删
```
删除指定文件
svn delete 'file'
推荐组合
svn delete 'file name'
svn commit -m 'delete file name'
```
### 改
```
提交指定文件
svn commit -m 'commit message' 'file'

提交所有文件
svn commit -m 'commit message'
简写
svn ci -m    
```
### 查
```
查看指定文件日志
svn log 'file'
查看指定文件详细信息
svn info 'file'
查看指定目录文件列表
svn list 'dir'
查看文件或目录状态
svn status 'file'或'dir'
简写
svn st 'file'或'dir'
```
* 正常状态不显示
* ?：不在svn的控制中
* M：内容被修改
* C：发生冲突
* A：预定加入到版本库
* K：被锁定

### 锁定
```
加锁指定文件
svn lock -m 'commit message' 'file' 

解锁指定文件
svn unlock 'file' 
```
### 比较差异
```
比较指定文件差异
svn diff 'file'  
对指定文件的版本1和版本2比较差异
svn diff -r version1:version2 'file'  
```
### 分支
```
从分支A新建出一个分支B
svn copy branchA branchB -m 'commit message'   
```
### 解决冲突
```
svn resolved
```