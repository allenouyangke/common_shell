#Author: AllenKe.
#Description: Ping the network.

echo "Please input the ip:(ex>172.16.60.*)"
read sip
#以上两行可以用$1(位置参数1取代)，将下文中的$sip更改为¥1；

for i in `seq 1 254`;do
{
    ping -c1 -w1 $1$i &>/dev/null && echo "$sip$i is up" || echo "$sip$i is down"
}&
done

wait