## 安装pyenv

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
[github 对应wiki有说明解决方案](ERROR: The Python ssl extension was not compiled. Missing the OpenSSL lib?)