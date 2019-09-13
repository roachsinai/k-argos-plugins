#!/usr/bin/env bash

#based on: https://github.com/kotelnik/plasma-applet-thermal-monitor: ui/config/ConfigTemperatures.qml

#Do this first if you use archlinux-like distros:
#   sudo pacman -S lm_sensors
#   sudo sensors-detect

bitbar="|font=iosevka size=14 color=white"
temp=$(sensors | grep -oP 'Package.*?\+\K[0-9.]+')
fan_speed=$(sensors | grep -oP 'cpu_fan.*?\K[0-9.]+')
if [ -d "/proc/driver/nvidia" ]; then
    gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
    echo "<u>${temp%%.*}</u>°<u>${fan_speed}</u>&nbsp;<u>${gpu_temp}</u>°$bitbar"
else
    echo "${temp%%.*}°${fan_speed}$bitbar"
fi

# https://stackoverflow.com/a/32029995/6074780
echo "---"
cpu_usage=$(grep 'cpu ' /proc/stat | awk '{printf "%0.1f", ($2+$4)*100/($2+$4+$5)}')
cpu_output_count=0
cpu_usage=$(
    while sleep 1
    do
        grep -w cpu /proc/stat
        ((cpu_output_count++))
        if [[ $cpu_output_count -eq 2 ]]; then
            ((cpu_output_count++))
            break
        fi
    done | \
        awk '{
            printf "%0.1f", (o2+o4-$2-$4)*100/(o2+o4+o5-$2-$4-$5) "%"
            o2=$2;o4=$4;o5=$5
        }'
)
echo "CPU: ${cpu_usage:4}% $bitbar"

# memfree=`cat /proc/meminfo | grep MemFree | awk '{print $2}'`;
memava=`cat /proc/meminfo | grep MemAvailable | awk '{print $2}'`;
memtotal=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`;
printf "MEM: %s%s $bitbar" `bc <<< "scale=1; ($memtotal-$memava)*100/$memtotal"` %
