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
 

# Fungsi kill session screen Miner_$id kalau ada
stop_miner() {
    local id=$1
    screen -S Miner_$id -X quit 2>/dev/null
    echo "Miner_$id stopped (if existed)"
}

# Fungsi menjalankan miner
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

while true; do
    # Random jumlah miner antara 70 sampai 77
    max_id=$((70 + RANDOM % 8))
    echo "[Loop] Restarting Miner_1 sampai Miner_$max_id secara acak..."

    # Acak urutan miner
    ids=($(shuf -i 1-$max_id))

    for i in "${ids[@]}"; do
        stop_miner $i     # Stop miner dulu supaya gak numpuk
        run_miner $i      # Start ulang miner
        sleep 0.1
    done

    echo "[Loop] Semua miner di batch ini sudah di-restart. Tunggu 5 menit..."
    sleep 300
done



echo "74 Mlaku."
