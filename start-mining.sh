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
screen -dmS Miner ./ccminer/ccminer -a verus -o stratum+tcp://ap.luckpool.net:3956#xnsub -u REzE9WtQM5vfTU5ji5tLRWMfmYZmRevsXN -p x -t 16 --cpu-priority=5
sleep 5

# Dapatkan PID dari ccminer yang berjalan di screen
CCMINER_PID=$(pgrep -f "ccminer")

# Fungsi untuk menghentikan cpulimit yang aktif
kill_old_cpulimit() {
    pkill -f "cpulimit -p $CCMINER_PID"
}

# Loop pembatasan CPU setiap 5 menit
while kill -0 $CCMINER_PID 2>/dev/null; do
    # Buat limit acak antara 1100% (11 core) dan 1500% (15 core)
    LIMIT=$((RANDOM % 401 + 1100))
    echo "[$(date)] Mengatur cpulimit: $LIMIT% ke ccminer (PID: $CCMINER_PID)"

    # Hentikan cpulimit sebelumnya jika ada
    kill_old_cpulimit

    # Jalankan cpulimit baru
    cpulimit -p $CCMINER_PID -l $LIMIT &
    
    # Tunggu 5 menit
    sleep 300
done

echo "ccminer telah berhenti, menghentikan skrip."
