#安装pyenv for MacOS
## 安装pyenv-virtualenv插件

## 创建虚拟环境

## 激活虚拟环境
[github 官档](https://github.com/pyenv/pyenv-virtualenv)

注意安装好后，需要将以下配置到`~/.bash_profile`(如果使用zsh等需要配置对应的文件),否则激活会报错
```
$ echo  'eval "$(pyenv init -)"' >> ~/.bash_profile
$ echo  'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
$ source ~/.bash_profile
```
## 其他问题
####[安装问题] ERROR: The Python ssl extension was not compiled. Missing the OpenSSL lib?
```
CFLAGS="-I$(brew --prefix openssl)/include" \
LDFLAGS="-L$(brew --prefix openssl)/lib" \
pyenv install -v 3.5.2
```
[参考-github 对应wiki有说明解决方案](https://github.com/pyenv/pyenv/wiki/Common-build-problems)

--- 
## Linux已安装pyenv，安装某py版本时候报错
```
/home/core/.pyenv/plugins/python-build/bin/python-build: line 1464: patch: command not found

BUILD FAILED (CoreOS 766.5.0 using python-build 20160602)

```
这个报错是因为
>patch is a command to apply some changes to files from input; typically which is provided as a package named "patch" by Linux distributions. It is a requirement of pyenv.

解决办法：
```
yum install patch
```