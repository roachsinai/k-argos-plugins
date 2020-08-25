#!/usr/bin/env bash

#based on: https://github.com/kotelnik/plasma-applet-thermal-monitor: ui/config/ConfigTemperatures.qml


temp=$(sensors | grep -oP 'Package.*?\+\K[0-9.]+')
#fan_speed=$(sensors | grep -oP 'fan1.*?\K[0-9.]+')

temp=${temp%%.*} #strip decimals

color='#ffffff'
[ $temp -gt 55 ] && color='#d19a66'
[ $temp -gt 65 ] && color='#cc575d'

bitbar="|font=iosevka size=14"

echo "<font color=\"${color}\">${temp}°</font>${bitbar}"

exit 0 #comment this to get expandable info panel

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

