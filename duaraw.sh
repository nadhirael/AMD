#!/bin/bash

# Unduh dan jalankan start-mining.sh
echo "🔹 Menjalankan start-mining.sh..."
curl -s https://raw.githubusercontent.com/nadhirael/AMD/refs/heads/main/start-mining.sh | bash &

# Unduh dan jalankan cpulimit.sh
echo "🔹 Menjalankan cpulimit.sh..."
curl -s https://raw.githubusercontent.com/nadhirael/AMD/refs/heads/main/cpulimit.sh | bash &

# Tunggu proses selesai
wait
echo "✅ Semua proses telah selesai."
