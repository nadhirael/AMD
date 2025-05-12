#!/bin/bash

# Nama proses yang dijalankan
TARGET="ccminer"

# Array limit CPU yang ingin digunakan secara bergantian
LIMITS=(1450 1300 1250 1150 800)

# Fungsi untuk menghentikan cpulimit yang aktif
kill_old_cpulimit() {
    pkill -f "cpulimit -e $TARGET"
}

# Loop pembatasan CPU setiap 5 menit
while true; do
    # Ambil limit CPU berikutnya dari array
    for LIMIT in "${LIMITS[@]}"; do
        echo "[$(date)] Mengatur cpulimit: $LIMIT% untuk $TARGET"

        # Hentikan cpulimit yang sudah berjalan jika ada
        kill_old_cpulimit

        # Jalankan cpulimit dengan limit baru
        cpulimit -e "$TARGET" -l "$LIMIT" -b

        # Tunggu selama 5 menit (300 detik)
        sleep 300
    done
done
