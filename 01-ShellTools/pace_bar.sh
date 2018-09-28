function dots(){
seconds=${1:-5}
while true; do
  sleep $seconds
  echo -n '.'
done
}

dots 10 &
BG_PID=$!
trap "kill -9 $BG_PID" INF

sleep 150
kill $BG_PID
echo
