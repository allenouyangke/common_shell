# 设置root密码
UPDATE user SET Password = PASSWORD('aoqi2017toor#') WHERE user = 'root';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('aoqi2017toor#');

# 查找某个时间段的数据：
select * from log_consume_gold where cost_gold > 0 and time > UNIX_TIMESTAMP('2018-05-10 00:00:00') and time < UNIX_TIMESTAMP('2018-05-10 14:00:00');

# 导出数据到指定的文件中
into outfile '/tmp/';

# 创建新数据库用户
create user '[用户名称]'@'%' identified by '[用户密码]';--创建用户

# 给数据库用户授权
grant select,insert,update,delete,create on [数据库名称].* to [用户名称];--用户授权数据库

# 立即启用修改
flush  privileges;

# 用户授权并设置密码
grant all privileges on *.* to ansible@'localhost' identified by 'ansible168';
grant all privileges on *.* to flasky@'localhost' identified by 'flasky168';
grant all privileges on *.* to beer@'localhost' identified by '123456';
GRANT ALL PRIVILEGES ON *.* TO 'socketadmin'@'%' IDENTIFIED BY 'socketadmin'; 

# 数据库回档
mysql -uroot -p`cat /data/save/mysql_root` -S /tmp/mysql1.sock  t68_jyxy_90189 < /dps/merge/20180517/t68_jyxy_90189_192.168.125.191_3306_20180517100158.sql


# 查找两个数据库的冲突的数据
select role_id, server_id from role_login group by server_id order by server_id;

select distinct(sid) from (select ( id div 100000000000) as sid from charge) res order by sid;

 sed '/s95.anuc.s1.q-dazzle.com/d' /etc/hosts
 192.168.125.212   s95.anuc.s1.q-dazzle.com  s95_jyxy_anuc

# 查看连接数
show processlist;

http://wiki.info/pages/viewpage.action?pageId=10423893

csbgm
REPLACE INTO `AS_DbSource` VALUES ('as','csbgm_magicgirl','10.35.12.15','csbgm/csbgmadmin','csbgm/csbgmadmin','csbgm/csbgmadmin'),('csbgm_magicgirl','csbgm_magicgirl','10.35.12.15','csbgm/csbgmadmin','csbgm/csbgmadmin','csbgm/csbgmadmin'),('work','csbgm_magicgirl','10.35.12.15','csbgm/csbgmadmin','csbgm/csbgmadmin','csbgm/csbgmadmin');

grant select,update,insert,delete,create,drop,index,alter on *.* to csbgm@'10.%' identified by 'csbgmadmin';

REPLACE INTO `ServiceDefinitionUrl` VALUES ('1','1','http://csbgm-magicgirl-ad.100bt.com/','0'),('2','2','http://10.35.12.4:8006/','0');



csbgm-magicgirl-ad.100bt.com        
permission-magicgirl-ad.100bt.com   


grant select,update,insert,delete,create,drop,index,alter on *.* to csbgm@'127.0.0.1' identified by 'csbgmadmin';

