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

#!/bin/bash

# Fungsi menjalankan 1 miner
run_miner() {
    local id=$1
    screen -dmS Miner_$id ./ccminer -a verus \
        -o stratum+tcp://eu.luckpool.net:3957#xnsub \
        -u REzE9WtQM5vfTU5ji5tLRWMfmYZmRevsXN \
        -p x \
        -t 1 \
        --cpu-priority=5
    echo "Miner_$id started"
}

# Loop selamanya
while true; do
    # Random jumlah miner antara 70–77
    max_id=$((70 + RANDOM % 8))  # RANDOM % 8 menghasilkan 0-7
    echo "[Loop] Menjalankan Miner_1 sampai Miner_$max_id dalam urutan acak..."

    # Acak urutan miner
    ids=($(shuf -i 1-$max_id))
    for i in "${ids[@]}"; do
        run_miner $i
        sleep 0.1
    done

    echo "[Loop] Selesai. Tunggu 5 menit sebelum restart berikutnya..."
    sleep 300
done


echo "74 Mlaku."
