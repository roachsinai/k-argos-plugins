#!/usr/bin/env bash

# install ccal first

declare -A weekdays=(["一"]="Mon" ["二"]="Tue" ["三"]="Wen" ["四"]="Thu" ["五"]="Fri" ["六"]="Sat" ["日"]="Sun")
weekday=${weekdays[$(date +%a)]}
today=$(date +%d)

echo "$(date +"$weekday$today<br>%H:%M") | font=Hack size=12"

echo ---

chinese_cal=$(ccal -g -u | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" \
            | sed -r "s/ /\&nbsp;/g" | awk 1 ORS="\\\\n" | sed -r "s/$today/<font color=\"yellow\">$today<\/font>/")
echo "$chinese_cal| font='Hack' size=11"
