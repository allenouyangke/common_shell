./src/redis-cli -c  -h  10.10.1.10 -p 6379   cluster meet  10.10.1.10 6380
./src/redis-cli -c  -h  10.10.1.10 -p 6379   cluster meet  10.10.1.10 6381
./src/redis-cli -c  -h  10.10.1.10 -p 6379   cluster meet  10.10.1.10 6382


./src/redis-cli -c  -h  10.10.1.10 -p 6379   cluster addslots {0..5461}
./src/redis-cli -c  -h  10.10.1.10 -p 6380   cluster addslots {5462..10922}
./src/redis-cli -c  -h  10.10.1.10 -p 6381   cluster addslots {10923..16383}
