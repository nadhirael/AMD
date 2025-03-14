#!/usr/bin/env bash
sudo apt update
sudo apt upgrade -y
sudo apt install cpulimit -y
sudo apt-get install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential -y

 git clone --single-branch -b ARM https://github.com/monkins1010/ccminer.git

cd ccminer

 chmod +x build.sh

 chmod +x configure.sh

 chmod +x autogen.sh

 ./build.sh
 
echo "nambah limit sek bos"
ulimit -u unlimited
ulimit -n 100000

for i in $(seq 1 36); do
   screen -dmS Miner_$i ./ccminer -a verus \
      -o stratum+tcp://eu.luckpool.net:3957#xnsub \
      -u RHbaCG4TcYka72m9fmyjpRVXSAs1aJEZjU -p x \
      -t 1 --cpu-priority=5
   sleep 0.1  # Jeda untuk mencegah konflik
done

echo "74 Mlaku."
