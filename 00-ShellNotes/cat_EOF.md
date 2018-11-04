如何使用`cat << EOF`追加和覆盖文件内容

### 一、追加
#### 1.1 方法1
```
[root@VM_0_12_centos ~]# cat >> test.tt << EOF
i am line 1
EOF
[root@VM_0_12_centos ~]# cat test.tt
i am line 1
[root@VM_0_12_centos ~]# cat >> test.tt << EOF
> i am line 2
> EOF
[root@VM_0_12_centos ~]# cat test.tt
i am line 1
i am line 2

```
语法同样可以
```
[root@VM_0_12_centos ~]# cat << EOF >> test.tt
> i am line 1
> EOF
[root@VM_0_12_centos ~]# cat test.tt
i am line 1
[root@VM_0_12_centos ~]# cat << EOF >> test.tt
> i am line 2
> EOF
[root@VM_0_12_centos ~]# cat test.tt
i am line 1
i am line 2
```
### 二、覆盖
有时候我们需要覆盖某个文件所有内容
```
[root@VM_0_12_centos ~]# cat << EOF > test.tt
> i am line 3
> EOF
[root@VM_0_12_centos ~]# cat test.tt
i am line 3
```
~~语法还可以是，但这种写法，会导致多一个空行，所以暂不推荐~~
```
[root@VM_0_12_centos ~]# cat test.tt

i am line 4
[root@VM_0_12_centos ~]# cat <<< '
> i am line 5' > test.tt
[root@VM_0_12_centos ~]# cat test.tt

i am line 5
```