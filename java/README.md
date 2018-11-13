- [java下载地址](http://www.oracle.com/technetwork/cn/java/javase/downloads/jdk8-downloads-2133151-zhs.html)

# 1 清理系统Java
- 检查系统自带的JDK
```shell
rpm -qa|grep java

# 如果已安装，先卸载
rpm -e --allmatches --nodeps jdk*
```
# 2 查找Java安装包
```shell
yum -y list java*

yum search jdk
```

# 3 安装需要的JDK包
```shell
yum install java-*
```

# 4 安装测试
```shell
java -version
```

# 5默认安装的路径
```shell
/usr/lib/jvm
```

如果机器上同时安装了多个jdk的话，java命令只能指向一个版本的jdk，为了在全局中方便修改jdk版本/etc/alternatives 的目录下面会有个java链接，指向默认需要执行的版本的jdk的bin/java 命令

# 6 将jdk的安装路径加入到JAVA_HOME
- 方法一
```shell
vi /etc/profile

#set java environment
JAVA_HOME=/usr/lib/jvm/jre-1.6.0-openjdk.x86_64
PATH=$PATH:$JAVA_HOME/bin
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_HOME CLASSPATH PATH

. /etc/profile
```

- 方法二
```shell
# 安装上面创建java命令的形式，以方便修改
cd /etc/alternatives
ln -s /usr/lib/jvm/jre-1.6.0-openjdk.x86_64/ java_home
```

创建一个/etc/alternatives/java_home的软连接，将该连接指向到当前Jdk的根目录，然后将改连接的路径加进去

```shell
#set java environment
JAVA_HOME=/etc/alternatives/java_home
PATH=$PATH:$JAVA_HOME/bin
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_HOME CLASSPATH PATH
```

- 检查环境变量
```shell
export |grep JAVA_HOME
```