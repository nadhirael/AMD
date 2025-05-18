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
 

# Fungsi kill semua miner screen
kill_all_miners() {
    echo "Killing all Miner screens..."
    # List semua screen yang namanya Miner_XX, lalu quit
    screen -ls | grep Miner_ | awk '{print $1}' | while read session; do
        screen -S "$session" -X quit
        echo "Killed screen session: $session"
    done
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

# Array pilihan batch miner
batches=(70 72 75 77)

while true; do
    # Pilih batch secara random dari array batches
    batch_size=${batches[$RANDOM % ${#batches[@]}]}
    echo "[Loop] Pilih batch miner 1 sampai $batch_size secara acak"

    # Kill semua miner dulu supaya bersih
    kill_all_miners

    # Acak urutan miner
    ids=($(shuf -i 1-$batch_size))
    for i in "${ids[@]}"; do
        run_miner $i
        sleep 0.1
    done

    echo "[Loop] Selesai jalankan batch 1-$batch_size. Tunggu 5 menit..."
    sleep 300
done


echo "74 Mlaku."
