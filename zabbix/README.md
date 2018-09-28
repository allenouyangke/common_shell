# zabbix

[zabbix官网](https://www.zabbix.com/download)

[七牛CDN](https://www.qiniu.com/?hmsr=biaoti&hmpl=pinzhuan&hmcu=biaoti&hmkw=&hmci=)

# zabbix-server
- [zabbix-3.4.10.tar.gz](http://ogpr96vps.bkt.clouddn.com/zabbix/packages/zabbix-3.4.10.tar.gz)

# zabbix-agent
- [zabbix_agents_3.2.7.linux2_6.amd64.tar](http://ogpr96vps.bkt.clouddn.com/zabbix/packages/zabbix_agents_3.2.7.linux2_6.amd64.tar.gz)



zabbix更新很快，从2009年到现在已经更新多个版本，为了使用更多zabbix的新特性，随之而来的便是升级版本，zabbix版本兼容性是必须优先考虑的一点

客户端AGENT兼容
zabbix1.x到zabbix2.x的所有agent都兼容zabbix server2.4：如果你升级zabbix server，客户端是可以不做任何改变，除非你想使用agent的一些新特性。

Zabbix代理（proxy）兼容
zabbix proxy很挑剔，2.4版本的proxy必须和2.4版本的server配套使用。其他zabbix1.x到2.2的proxy都不能与2.4的server配套。也就是说，如果你升级zabbix server，那么zabbix proxy也要同步升级。

XML文件兼容
zabbix 1.8、2.0、2.2导出的xml文件都可以导入到zabbix2.4中。曾经在zabbix 2.4上辛辛苦苦做好了一个模板，结果无法导入到2.2版本中，想想就觉得苦。