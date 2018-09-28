#-*- coding:utf-8 -*-

import requests
import json

#初始化参数
server_url = ""
header = {"Content-Type": "application/json"}
username = "Admin"
password = "passwd123"

#登录zabbix并获取auth的token
login = {
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        'user': ""+username+"",
        'password': ""+password+"",
    },
    "auth": None,
    "id": 0,
}
auth = requests.post(server_url, data=json.dumps(login), headers=(header))
auth = auth.json()

#跟进ip地址获取主机的hostid
host_get = {
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
        "output": ["hostid", "name"],
        "filter": {"ip": ["192.168.5.1", "192.168.5.2"]}
    },
    "auth": ""+auth['result']+"",
    "id": 1,
}
hostid_get = requests.post(
    server_url, data=json.dumps(host_get), headers=(header))
hostid_get = hostid_get.json()
hostid = hostid_get['result'][0]['hostid']
print hostid, hostid_get['result'][1]['hostid']

#根据组名获取groupid
group_get = {
    "jsonrpc": "2.0",
    "method": "hostgroup.get",
    "params": {
        "output": "extend",
        "filter": {
            "name": [
                "测试组"
            ]
        }
    },
    "auth": ""+auth['result']+"",
    "id": 1
}
groupid_get = requests.post(
    server_url, data=json.dumps(group_get), headers=(header))
groupid_get = groupid_get.json()
groupid = groupid_get['result'][0]['groupid']
print groupid

#跟进模板名来获取templateid
template_get = {
    "jsonrpc": "2.0",
    "method": "template.get",
    "params": {
        "output": "extend",
        "filter": {
            "host": [
                "Template OS Linux",
            ]
        }
    },
    "auth": ""+auth['result']+"",
    "id": 1
}
templateid_get = requests.post(
    server_url, data=json.dumps(template_get), headers=(header))
templateid_get = templateid_get.json()
templateid = templateid_get['result'][0]['templateid']
print templateid

#跟进proxy名获取proxyid
proxy_get = {
    "jsonrpc": "2.0",
    "method": "proxy.get",
    "params": {
        "output": "extend",
        "selectInterface": "extend",
        "filter": {
            "host": [
                "Zabbix-proxy-test",
            ]
        }
    },
    "auth": ""+auth['result']+"",
    "id": 1
}
proxy_get_id = requests.post(
    server_url, data=json.dumps(proxy_get), headers=(header))
proxy_get_id = proxy_get_id.json()
proxyid = proxy_get_id['result'][0]['proxyid']
print proxyid

#定义并添加一个主机到zabbix，指定组，模板，host和name名不支持中文
host_create = {
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": "192.168.5.1",
        "name": "this is a test-192.168.5.1",
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": "192.168.5.1",
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": ""+groupid+""
            }
        ],
        "templates": [
            {
                "templateid": ""+templateid+""
            }
        ],
        "proxy_hostid": ""+proxyid+"",
        "inventory_mode": 0
    },
    "auth": ""+auth['result']+"",
    "id": 1
}
host_create_id = requests.post(
    server_url, data=json.dumps(host_create), headers=(header))
host_create_id = host_create_id.json()
print host_create_id

#跟进hostid删除主机
host_delete = {
    "jsonrpc": "2.0",
    "method": "host.delete",
    "params": [hostid],
    "auth": ""+auth['result']+"",
    "id": 1
}
delete_id = requests.post(
    server_url, data=json.dumps(host_delete), headers=(header))
deleteid = delete_id.json()
print deleteid
