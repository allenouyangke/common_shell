#使用pwd 命令获取的是执行该命令的当前工作目录，当在其他目录调用一个脚本时会发现脚本中使用的pwd命令获取的结果不是脚本所在的绝对路径

this_dir=`pwd`
echo "$this_dir ,this is pwd"
echo "$0 ,this is \$0"
dirname $0 | grep "^/" >/dev/null
if [ $? -eq 0 ];then
  this_dir=`dirname $0`
else
  dirname $0 | grep "^\." >/dev/null
  retval=$?
  if [ $retval -eq 0 ];then
    this_dir=`dirname $0 | sed "s#^.#$this_dir#"`
  else
    this_dir=`dirname $0 | sed "s#^#$this_dir/#"`
  fi
fi
 echo $this_dir

#base_dir=$(cd "$(dirname "$0")";pwd)
