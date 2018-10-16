awk工作流程是这样的：读入有'\n'换行符分割的一条记录，然后将记录按指定的域分隔符划分域，填充域，$0则表示所有域,$1表示第一个域,$n表示第n个域。默认域分隔符是"空白键" 或 "[tab]键",所以$1表示登录用户，$3表示登录用户ip,以此类推。

这种是awk+action的示例，每行都会执行action{print $1},-F指定域分隔符为':'。
```
#cat /etc/passwd |awk  -F ':'  '{print $1}'  
root
daemon
bin
sys
```
命令之间用管道符
```
#cat /etc/passwd |awk  -F ':'  '{print $1"\t"$7}'
root    /bin/bash
daemon  /bin/sh
bin     /bin/sh
sys     /bin/sh
```

如果只是显示/etc/passwd的账户和账户对应的shell,而账户与shell之间以逗号分割,而且在所有行添加列名name,shell,在最后一行添加"blue,/bin/nosh"。
```
cat /etc/passwd |awk  -F ':'  'BEGIN {print "name,shell"}  {print $1","$7} END {print "blue,/bin/nosh"}'
name,shell
root,/bin/bash
daemon,/bin/sh
bin,/bin/sh
sys,/bin/sh
....
blue,/bin/nosh
```
搜索/etc/passwd有root关键字的所有行
```
#awk -F: '/root/' /etc/passwd
root:x:0:0:root:/root:/bin/bash
```

搜索/etc/passwd有root关键字的所有行，并显示对应的shell
```
# awk -F: '/root/{print $7}' /etc/passwd             
/bin/bash
```

#### 参考资料
* [来源资料](https://www.cnblogs.com/ggjucheng/archive/2013/01/13/2858470.html)