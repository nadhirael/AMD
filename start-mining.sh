#!/bin/bash

echo "🔹 Mengupdate dan menginstal dependencies..."
sudo apt update && sudo apt upgrade -y
sudo apt install cpulimit screen git build-essential libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev -y

echo "🔹 Mengunduh CCMiner..."
git clone --single-branch -b Verus2.2 https://github.com/monkins1010/ccminer.git
cd ccminer || { echo "Gagal masuk ke direktori ccminer!"; exit 1; }

echo "🔹 Memberikan izin eksekusi pada script build..."
chmod +x build.sh configure.sh autogen.sh

echo "🔹 Memulai proses build CCMiner..."
./build.sh || { echo "❌ Build gagal!"; exit 1; }
cd ..

echo "🔹 Menjalankan ulimit..."
ulimit -u unlimited
ulimit -n 100000

# Jalankan ccminer via screen
echo "🔹 Memulai miner via screen..."
screen -dmS Miner ./ccminer/ccminer -a verus -o stratum+tcp://ap.luckpool.net:3956#xnsub -u REzE9WtQM5vfTU5ji5tLRWMfmYZmRevsXN -p x -t 15 --cpu-priority=5
sleep 5

echo "ccminer telah berhenti, menghentikan skrip."
