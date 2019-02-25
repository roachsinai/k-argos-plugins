#!/usr/bin/env bash
# Firstly, install ccal

year=$(date +%Y)
declare -A birthdays=(["${year}0102"]="Som")
chinese_cal=$(ccal -u -g | sed -r "s/ /\&nbsp;/g" | awk 1 ORS="\\\\n" | sed -r "s/\x1B\[7m/<font color=\"blue\">/" \
            | sed -r "s/\x1B\[0m/<\/font>/")

declare -A weekdays=(["一"]="Mon" ["二"]="Tue" ["三"]="Wen" ["四"]="Thu" ["五"]="Fri" ["六"]="Sat" ["日"]="Sun")
weekday=${weekdays[$(date +%a)]}

source <( python /home/roach/.config/argos/LunarSolarConverter.py ${!birthdays[@]} )
#eval "$( python /home/roach/.config/argos/LunarSolarConverter.py ${!birthdays[@]} )"

#gap_string=`/home/roach/.config/argos/LunarSolarConverter.py ${!birthdays[@]}`
#if [ $? -eq 0 ]; then
#    `$gap_string`
#else
#    declare -A gaps
#fi
#for lunar in "${!birthdays[@]}"; do
#    solar=`/home/roach/.config/argos/LunarSolarConverter.py $lunar`
#    gap=$((($(date +%s --date $solar)-$(date -d 'today 00:00:00' '+%s'))/(3600*24)))
#    ((gap>=0 && gap<=4)) && gaps["$lunar"]=$gap
#done
declare -A gap_numbers=([0]=! [1]=\' [2]=╎ [3]=┆ [4]=┊)

echo ---

bitbar="font=mononoki size=14 color=black dropdown=false"
if [ "${#gaps[@]}" -ne 0 ]; then
    for gap in "${!gaps[@]}"; do
        echo "$(date +"${birthdays[$gap]}🎂${gap_numbers[${gaps[$gap]}]}%H:%M") | $bitbar"
    done
elif [ ! -z "$weekday" ]; then
    echo "$(date +"$weekday%d⸾%H:%M") | $bitbar"
else # Lang == en_US
    echo "$(date +"%a%d⸾%H:%M") | $bitbar"
fi

echo "|size=11 color=black font='Hack'"

echo "$chinese_cal| font='Hack' size=11 color=black"
