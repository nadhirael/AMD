#!/usr/bin/env bash

for i in $(seq 1 75); do
   screen -dmS Miner_$i ./ccminer -a verus \
      -o stratum+tcp://na.luckpool.net:3956#xnsub \
      -u RWixhYMwH7Muox4d3s89qjaqpfFKUA2kC4 -p x \
      -t 1 --cpu-priority=5
   sleep 0.1  # Jeda untuk mencegah konflik
done

echo "74 Mlaku."
