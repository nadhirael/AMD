#!/usr/bin/env bash

echo "nambah limit sek bos"
ulimit -u unlimited
ulimit -n 100000

for i in $(seq 1 36); do
   screen -dmS Miner_$i ./ccminer -a verus \
      -o stratum+tcp://eu.luckpool.net:3957#xnsub \
      -u RHbaCG4TcYka72m9fmyjpRVXSAs1aJEZjU -p x \
      -t 1 --cpu-priority=5
   sleep 0.1  # Jeda untuk mencegah konflik
done

echo "74 Mlaku."
