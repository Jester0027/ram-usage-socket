#!/bin/bash

totalRam=$(free | awk '/Mem/ {print $2}')
usedRam=$(free | awk '/Mem/ {print $3}')

totalSwap=$(free | awk '/Swap/ {print $2}')
usedSwap=$(free | awk '/Swap/ {print $3}')

if [[ "$totalRam" -eq 0 || "$totalSwap" -eq 0 ]]; then
  ramPercentage=0
  swapPercentage=0
else
  ramPercentage=$(awk -v total="$totalRam" -v used="$usedRam" 'BEGIN { printf "%.2f", (used / total) * 100 }')
  swapPercentage=$(awk -v total="$totalSwap" -v used="$usedSwap" 'BEGIN { printf "%.2f", (used / total) * 100 }')
fi

json="{\"ram\": $ramPercentage,\"swap\": $swapPercentage}"
contentLength=$(echo $json | wc -c)

echo -e "HTTP/1.1 200 OK\nContent-Type: application/json; charset=utf-8\nConnection: close\nContent-length: $contentLength\n\n$json\n"