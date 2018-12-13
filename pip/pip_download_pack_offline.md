## 利用pip安装离线python包
当需要在没有网络的机器上安装python的包，而此机器有没有python源的时候，可以通过以下方式：

#### 情况1：如果online和offline的机器架构完全一样：OS一样、Python版本一样
现在online机器执行download，下载所有依赖package到当前目录
```
pip download fabric==1.14.0
```
将目录内容拷贝到目标offline机器（比如/offline_package_dir），并目标offline机器执行
```
pip install --no-index --find-links /offline_package_dir tensorflow fabric
```
#### 情况2：如果online和offline架构不一样
可以先尝试用download指定参数试一下是否能成功下载，如果不能再考虑下面的做法。
1、如果os一样，python版本不一样
通过pyenv制定版本，然后按情况1
2、如果os不一样，python不一样
通过docker安装跟目标一致的os版本，同时安装同样的python版本，然后步骤通情况1

* [参考材料](http://imshuai.com/python-pip-install-package-offline-tensorflow/)