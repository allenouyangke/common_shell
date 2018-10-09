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
### test01