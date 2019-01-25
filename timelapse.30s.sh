#!/usr/bin/env bash

# Your time elapsed of this day, month, year and this time you boot your System.

# https://gist.github.com/aurorabbit/7fa0e4d76c97a85f7b0a7318f870ce64
# https://github.com/KittyKatt/screenFetch/blob/master/screenfetch-dev#L1240

width=25
fill_char="▄"
empty_char="▁"

bitbar="size=14 color=silver font='mononoki'"

# Add your Birthday here
# Format: 'YYYY-MM-DD [hh:mm (optional)] [UTC Offset (optional)]'
BIRTHDAY="1949-10-01 00:00 +08:00"

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

round() { printf %.2f "$1"; }

# repeat the characters using printf
progress() {
    filled=$(printf %.0f "$(echo "$1 * $width / 100" | bc -l)")
    empty=$((width - filled))
    # filled is 0, also printf one ▄
    # printf %"$filled"s|tr \  "▄"
    # could use the statement above repalce the if statement below if the $fill_char is a alphabeta char not ▄
    # as ▄ will turn to a garbled
    if (($filled != 0)); then
        printf "$fill_char%0.s" $(seq "$filled")
    fi
    printf "$empty_char%0.s" $(seq "$empty")
}

time_on_earth() {
    # echo $(date -d $BIRTHDAY +%s)
    seconds=$(( $now-$(date -d "$BIRTHDAY" +%s) ))
    minutes=$(( $seconds/60 ))
    hours=$(( $minutes/60 ))
    days=$(( $hours/24 ))

    printf "$days days on 🗺️, %sh,   | $bitbar\n" $hours 
    printf "%smin, %ssec.   | $bitbar" $minutes $seconds
}

# echo "<font size='1'>ღ $(round "$d_progress")%</font><br><font size='1'>ღ $(round "$d_progress")%</font>"
# echo "ღ$(round "$d_progress")% | size=16 font=Hack"
echo "⚡$(round "$d_progress")% | size=16 font=Hack"
echo ---

# Uptime
echo "Uptime: $(detectuptime)   | $bitbar"

# day + progress bar
echo " | $bitbar"
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

echo " | $bitbar"
echo "$(time_on_earth)"
