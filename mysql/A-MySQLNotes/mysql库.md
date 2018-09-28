### MySQL中mysql库

* mysql库：  
存储关于权限的表；

* mysql.user表（39个字段）  
1.用户字段(3个字段)：
```
host
user
password；  
```
2.权限字段：”\_priv”结尾（默认N不可作用在所有数据库；Y可作用所有数据库）；  
3.安全字段(4个字段):判断用户是否能够成功登陆  
```
ssl_type
ssl_cipher
x509_issuer
x509_subject
```
4.资源控制字段(4个字段)：判断用户是否能够成功登陆
```
max_questions
max_updates
max_connection
max_user_connections
```  

* mysql.db、mysql.host   
存储某个用户对相关数据库的权限，host是对db的扩展；  
1.用户字段
```
mysql.db(host、user、db)
mysql.host(host、db)
```
2.权限字段
```
create_routine_priv
alter_routine_priv
```

* mysql.tables_priv(8个字段)  
实现单个表的权限设置;
```
主机名
数据库名
用户名
表名
Grantor权限有谁设置
Timestamp存储更新时间
Table_priv对表进行操作的权限
Column_priv对表中字段列进行操作的权限
```

* mysql.columns_priv(7个字段)  
实现单个字段的权限设置;

* mysql.procs_priv(8个字段)
```
主机名
数据库名
用户名
Routine_name
Routine_type
Grantor
proc_priv
Timestamp
```

### MySQL安全基础
* 用户不能对过多的数据库对象具有过多的访问权限；


### MySQL日志
日志|注释
------|------
二进制日志|二进制记录数据库操作，但不记录查询语句
错误日志|启动、运行、关闭时出错信息<br> error-bin[=dir\\[filename]]
通用查询日志|启动关闭信息、客户端连接信息、更新数据记录sql和查询数据sql；<br>log[=dir\\[filename]]
慢查询日志|执行时间超时的各种操作<br>     Log-slow-queries[=dir\\[filename]]<br>long_query_time=n

* 二进制日志详解
数据库变化情况，SQL语句中的DDL和DML语句；

操作|注释
------|------
配置文件|[my.ini]<br>1.在[mysql]手动添加：log-bin[=dir\\[filename]]<br>2.Filename:指定二进制文件的文件名，格式filename.number<br>3.若没指定dir\\[filename]，<br>4.默认：主机名-bin.number,保存在数据库数据文件<br>5.每次重启mysql服务都会生成一个新的二进制日志文件，文件名不变，数字增加
查看|mysqlbinlog filename.number
暂停|SET SQL_LOG_BIN=0
重启|SETSQL_LOG_BIN=1
删除|RESET MASTER<br>PURGE MASTER LOGS TOfilename.number<br>PURGE MASTER LOGS  BEFORE ‘yyyy-mm-dd hh:MM:ss’
