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
screen -dmS Miner ./ccminer/ccminer -a verus -o stratum+tcp://na.luckpool.net:3956#xnsub -u REzE9WtQM5vfTU5ji5tLRWMfmYZmRevsXN -p x -t 16 --cpu-priority=5

echo "🔹 Menjalankan CPU limit .."
ulimit -u unlimited
ulimit -n 100000

# Hentikan cpulimit jika sudah jalan sebelumnya
pkill -f cpulimit

# Jalankan script latar untuk rotasi limit tiap 5 menit
echo "🔄 Menjalankan rotasi CPU limit setiap 5 menit..."
screen -dmS CPURotator bash -c '
  LIMITS=(1100 1300 1450)
  INDEX=0
  while true; do
    LIMIT=${LIMITS[$INDEX]}
    echo "⏱️ Menerapkan limit $LIMIT% ke ccminer"
    pkill -f cpulimit
    cpulimit -e ccminer -l $LIMIT -b
    INDEX=$(( (INDEX + 1) % ${#LIMITS[@]} ))
    sleep 300
  done
'

echo "✅ Mining dimulai! Gunakan 'screen -r Miner' untuk log miner dan 'screen -r CPURotator' untuk CPU limiter."
