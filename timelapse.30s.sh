#!/usr/bin/env bash

# Your time elapsed of this day, month, year and this time you boot your System.
#
# by RoachHao (https://github.com/roachsinai)

# https://raw.githubusercontent.com/matryer/bitbar-plugins/master/Time/progress.1h.sh
# https://gist.github.com/aurorabbit/7fa0e4d76c97a85f7b0a7318f870ce64
# https://github.com/KittyKatt/screenFetch/blob/master/screenfetch-dev#L1240

width=20
fill_char="▄"
empty_char="▁"

bitbar="size=14 color=black font='mononoki'"

now=$(date +%s)
now_F=$(date -d @$now +%F)

now_d=$(date -d @$now +%d)
d_start=$(date -d $now_F +%s)
d_end=$(date -d "$now_F+1 days" +%s)
d_progress=$(
    echo "($now - $d_start) * 100 / ($d_end - $d_start)" | bc -l
)

now_Y=$(date -d @$now +%Y)
now_m=$(date -d @$now +%m)
m_start=$(date -d $now_Y-$now_m-01 +%s)
m_end=$(date -d "$now_Y-$now_m-01+1 months" +%s)
m_progress=$(
    echo "($now - $m_start) * 100 / ($m_end - $m_start)" | bc -l
)

Y_start=$(date -d $now_Y-01-01 +%s)
((now_Y+=1))
Y_end=$(date -d $now_Y-01-01 +%s)
Y_progress=$(
    echo "($now - $Y_start) * 100 / ($Y_end - $Y_start)" | bc -l
)

detectuptime () {
	unset uptime
	if [[ -f /proc/uptime ]]; then
		uptime=$(</proc/uptime)
		uptime=${uptime//.*}
	fi

	if [[ -n ${uptime} ]]; then
		mins=$((uptime/60%60))
		hours=$((uptime/3600%24))
		days=$((uptime/86400))
		uptime="${mins}m"
		if [ "${hours}" -ne "0" ]; then
			uptime="${hours}h ${uptime}"
		fi
		if [ "${days}" -ne "0" ]; then
			uptime="${days}d ${uptime}"
		fi
    fi

    echo $uptime
}

round() { printf %.0f "$1"; }

progress() {
    filled=$(round "$(echo "$1 * $width / 100" | bc -l)")
    empty=$((width - filled))
    # repeat the characters using printf
    printf "$fill_char%0.s" $(seq "$filled")
    printf "$empty_char%0.s" $(seq "$empty")
}

echo "ღ $(round "$Y_progress")%"
echo ---

# Uptime
echo "Uptime: $(detectuptime)   | $bitbar"

echo ---
# day + progress bar
echo "Day: $(round "$d_progress")%   | $bitbar"
echo "$(progress "$d_progress")      | $bitbar"

# month + progress bar
echo " | $bitbar"
echo "Month: $(round "$m_progress")%   | $bitbar"
echo "$(progress "$m_progress")        | $bitbar"

# year + progress bar"
echo " | $bitbar"
echo "Year: $(round "$Y_progress")%, $(date -d @$now +%j) days.   | $bitbar"
echo "$(progress "$Y_progress")       | $bitbar"
