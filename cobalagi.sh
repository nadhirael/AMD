#!/usr/bin/env bash

for i in $(seq 1 37); do
   screen -dmS Miner_$i ./ccminer -a verus \
      -o stratum+tcp://na.luckpool.net:3956#xnsub \
      -u REzE9WtQM5vfTU5ji5tLRWMfmYZmRevsXN -p x \
      -t 1 --cpu-priority=5
   sleep 0.1  # Jeda untuk mencegah konflik
done

echo "74 Mlaku."
