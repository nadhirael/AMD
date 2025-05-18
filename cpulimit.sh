#!/bin/bash

# Nama proses ccminer
TARGET="ccminer"

# Array limit CPU yang ingin digunakan secara bergantian (dalam %)
LIMITS=(1450 1350 1250 1150 1050)

# Fungsi untuk menghentikan cpulimit yang aktif
kill_old_cpulimit() {
    pkill -f "cpulimit -e $TARGET"
}

# Loop tanpa henti
while true; do
    # Acak urutan LIMITS
    SHUFFLED_LIMITS=($(shuf -e "${LIMITS[@]}"))

    # Iterasi limit yang sudah diacak
    for LIMIT in "${SHUFFLED_LIMITS[@]}"; do
        echo "[$(date)] Mengatur cpulimit: $LIMIT% untuk $TARGET"

        # Hentikan cpulimit yang sudah berjalan (jika ada)
        kill_old_cpulimit

        # Jalankan cpulimit dengan limit baru, di background (&)
        cpulimit -e "$TARGET" -l "$LIMIT" &

        # Tunggu 5 menit (300 detik)
        sleep 300
    done
done
