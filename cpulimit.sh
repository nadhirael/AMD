#!/bin/bash

# Nama proses ccminer
TARGET="ccminer"

# Fungsi untuk menghentikan cpulimit yang aktif
kill_old_cpulimit() {
    pkill -f "cpulimit -e $TARGET"
}

# Loop tanpa henti
while true; do
    # Acak limit antara 500 - 700
    LIMIT=$(( RANDOM % 201 + 500 ))  # 500 sampai 700

    echo "[$(date)] Mengatur cpulimit: $LIMIT% untuk $TARGET"

    # Hentikan cpulimit yang sudah berjalan (jika ada)
    kill_old_cpulimit

    # Jalankan cpulimit dengan limit baru, di background
    cpulimit -e "$TARGET" -l "$LIMIT" &

    # Tunggu 5 menit (300 detik)
    sleep 300
done
