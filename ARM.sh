#!/usr/bin/env bash

# Update dan install dependencies (jalankan sekali saja, bisa dipisah)
sudo apt update
sudo apt upgrade -y
sudo apt install cpulimit screen -y
sudo apt-get install libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential -y

# Clone dan build ccminer jika belum ada
if [ ! -d "ccminer" ]; then
    git clone --single-branch -b ARM https://github.com/monkins1010/ccminer.git
    cd ccminer || exit
    chmod +x build.sh configure.sh autogen.sh
    ./build.sh
    cd ..
fi

# Fungsi kill semua miner screen
kill_all_miners() {
    echo "Killing all Miner screens..."
    screen -ls | grep Miner_ | awk '{print $1}' | while read -r session; do
        screen -S "$session" -X quit
        echo "Killed screen session: $session"
    done
    sleep 3  # Delay 3 detik untuk memastikan semua screen tertutup
}

# Fungsi menjalankan miner dengan logging
run_miner() {
    local id=$1
    screen -dmS Miner_$id bash -c "./ccminer -a verus \
        -o stratum+tcp://eu.luckpool.net:3957#xnsub \
        -u REzE9WtQM5vfTU5ji5tLRWMfmYZmRevsXN \
        -p x \
        -t 1 \
        --cpu-priority=5 > miner_$id.log 2>&1"
    echo "Miner_$id started (log: miner_$id.log)"
}

# Array pilihan batch miner
batches=(70 72 75 77)

while true; do
    start_time=$(date +%s)

    batch_size=${batches[$RANDOM % ${#batches[@]}]}
    echo "[Loop] Restart batch miner 1 sampai $batch_size secara acak"

    kill_all_miners

    ids=($(shuf -i 1-$batch_size))
    for i in "${ids[@]}"; do
        run_miner "$i"
        sleep 0.5
    done

    echo "[Loop] Batch 1-$batch_size dijalankan, tunggu sampai 5 menit sebelum batch berikutnya..."

    end_time=$(date +%s)
    elapsed=$(( end_time - start_time ))

    sleep_time=$((300 - elapsed))
    if (( sleep_time > 0 )); then
        sleep $sleep_time
    fi
done
