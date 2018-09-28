#列出所有目录使用量，并按大小排序
ls | xargs du -h | sort -rn
#不递归下级目录
du -sh

#查看文件排除以#开关和空白行，适合查看配置文件
egrep -v "^#|^$" filename
sed '/#.*$/d;/^ *$/d'

#删除空格和空行
sed '/^$/d' filename
sed 's/ //g' filename
sed 's/[[:space:]]//g' filename

#删除#后的注释
sed -i 's/#.*$//g' filename

#踢出登录的用户，用who查看终端
pkill -KILL -t pts/0

#删除空文件
find ／ -type f -size 0 -exec rm -rf {} \;

#查找进程pid并kill
pgrep nginx | xargs kill
pidof nginx | xargs kill

#获取当前ip地址
ifconfig | awk -F "[ ]+[:]" 'NR==2{print $4}'

#以文本的方式查看wtmp日志
utmpdump /var/log/wtmp

#以内存大小排序列出进程
ps aux --sort=rss | sort -k 6 -rn

#用管道输入方式修改用户密码
echo "password" | passwd -stdin root

#生成ssh证书，并发送到远端服务器上
ssh-keygen -y -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub | ssh root@host "cat - >> ~/.ssh/authorized_keys"

#新建文件夹，并进入（需要添加到bashrc文件中才能生效）
mkcd() {mkdir $1 cd $1}

#通过ssh快速备份
tar zcvf - back/ | ssh root@host tar xzf - -C /root/back/

#下载整个网站
wget -r -p -np -k http://domain.com

#kill整个进程树
pstree -ap pid | grep -oP '[0-9]{4,6}' | xargs kill -9

#生成随机字符
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
