#!/usr/bin/env bash
# Firstly, install ccal

declare -A birthdays=(["0101"]="Year's")
# chinese_cal=$(ccal -u | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" \
chinese_cal=$(ccal | sed -r "s/ /\&nbsp;/g" | awk 1 ORS="\\\\n" | sed -r "s/\x1B\[7m/<font color=\"blue\">/" \
            | sed -r "s/\x1B\[0m/<\/font>/")

search_string="\]Y"
search_result=${chinese_cal%$search_string*}
chinese_month=$(echo $search_result|grep -Eo '[0-9]+$')
search_string="&nbsp;\["
first_day_of_this_chinese_month=$(echo ${search_result%$search_string*}|grep -Eo '[0-9]+$')
search_string="<\/font>"
chinese_day=$(echo ${chinese_cal%$search_string*}|sed 's/\(.*\)\[//'|grep -Eo '[0-9]+')
#day=${chinese_cal%$search_string*}

today=$(date +%d)
if [ "$today" -lt "$first_day_of_this_chinese_month" ]; then
    ((chinese_month++))
elif [ "$today" -eq "$first_day_of_this_chinese_month" ]; then
    chinese_day=1
fi

printf -v chinese_month "%02d" $chinese_month
printf -v chinese_day "%02d" $chinese_day

chinese_today="$chinese_month$chinese_day"

declare -A weekdays=(["一"]="Mon" ["二"]="Tue" ["三"]="Wen" ["四"]="Thu" ["五"]="Fri" ["六"]="Sat" ["日"]="Sun")
weekday=${weekdays[$(date +%a)]}
if [[ -v birthdays[$chinese_today] ]]; then
    echo "$(date +"${birthdays[$chinese_today]}🎂,%H:%M") | font=Hack size=14 color=black"
else
    if [ ! -z "$weekday" ]; then
        echo "$(date +"$weekday$today,%H:%M") | font=Hack size=14 color=black"
    else # Lang == en_US
        echo "$(date +"%a$today,%H:%M") | font=Hack size=14 color=black"
    fi
    # echo "<font size=2 face=Hack color=black>$(date +"$weekday$today&thinsp;%H:%M")</font>"
fi

echo ---

bitbar="size=11 color=black font='Hack'"
echo " | $bitbar"

echo "$chinese_cal| font='Hack' size=11 color=black"
