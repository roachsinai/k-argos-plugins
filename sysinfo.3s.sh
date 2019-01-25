#!/usr/bin/env bash

#install lm-sensors first
#sudo sensors-detect then press Enter till the end

temp=$(sensors | grep -oP 'Package.*?\+\K[0-9.]+')
fan_speed=$(sensors | grep -oP 'cpu_fan.*?\K[0-9.]+')
if [ -d "/proc/driver/nvidia" ]; then
    gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)
    # https://stackoverflow.com/a/41859700/6074780
    # echo "<font size='2'>CPU&nbsp;&nbsp;Fan&nbsp;GPU</font><br><font face='Hack' size='2'>&nbsp;${temp%%.*}°&nbsp;${fan_speed}°&nbsp;${gpu_temp}°</font>"
    echo "CPU&nbsp;Fan&nbsp;&nbsp;GPU<br>${temp%%.*}°&nbsp;${fan_speed}&nbsp;${gpu_temp}°| font=Hack size=12"
else
    echo "CPU&nbsp;Fan<br>${temp%%.*}°&nbsp;${fan_speed}| font=Hack size=12"
fi
