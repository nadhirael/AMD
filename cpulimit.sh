#!/bin/bash

# Nama proses ccminer
TARGET_NAME="ccminer"

while true; do
    # Ambil PID dari ccminer (gunakan yang pertama jika ada banyak)
    PID=$(pgrep -f "$TARGET_NAME" | head -n 1)

    # Cek apakah proses ccminer ditemukan
    if [[ -z "$PID" ]]; then
        echo "Proses $TARGET_NAME tidak ditemukan. Cek kembali..."
        sleep 60
        continue
    fi

    # Random CPU limit: 800 - 1400 (karena kamu punya 16 core = 1600%)
    LIMIT=$((RANDOM % 601 + 800))  # 800 sampai 1400

    echo "$(date): Membatasi $TARGET_NAME (PID: $PID) ke ${LIMIT}% CPU..."

    # Hentikan proses cpulimit sebelumnya untuk PID ini
    pkill -f "cpulimit -p $PID"

    # Jalankan cpulimit untuk PID ini
    cpulimit -p "$PID" -l "$LIMIT" -b

    # Tunggu 5 menit
    sleep 300
done
