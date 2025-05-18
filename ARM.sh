#!/usr/bin/env bash

# Update dan install dependencies (hanya perlu dijalankan sekali)
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
    sleep 10  # Delay 10 detik untuk memastikan semua screen tertutup
}

# Fungsi menjalankan miner dari dalam folder ccminer
run_miner() {
    local id=$1
    screen -dmS Miner_$id bash -c "cd ccminer && ./ccminer -a verus \
        -o stratum+tcp://eu.luckpool.net:3957#xnsub \
        -u REzE9WtQM5vfTU5ji5tLRWMfmYZmRevsXN \
        -p x \
        -t 1 \
        --cpu-priority=5 > ../miner_$id.log 2>&1"
    echo "Miner_$id started (log: miner_$id.log)"
}

# Array batch size
batches=(70 72 75 77)

# Loop utama
while true; do
    start_time=$(date +%s)

    # Pilih batch size secara acak
    batch_size=${batches[$RANDOM % ${#batches[@]}]}
    echo "[Loop] Jalankan batch miner acak dari 1 sampai $batch_size"

    kill_all_miners

    # Cek validitas batch_size dan jalankan miner
    if [[ $batch_size =~ ^[0-9]+$ && $batch_size -ge 1 ]]; then
        ids=($(shuf -i 1-$batch_size))
        for i in "${ids[@]}"; do
            run_miner "$i"
            sleep 0.5
        done
    else
        echo "Batch size tidak valid: $batch_size"
        continue
    fi

    echo "[Loop] Batch 1-$batch_size dijalankan. Tunggu 5 menit..."

    end_time=$(date +%s)
    elapsed=$(( end_time - start_time ))
    sleep_time=$((300 - elapsed))

    if (( sleep_time > 0 )); then
        sleep $sleep_time
    fi
done
