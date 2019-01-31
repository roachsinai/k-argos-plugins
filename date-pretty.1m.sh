#!/usr/bin/env bash

# declare -A weekdays=(["一"]="Mon" ["二"]="Tue" ["三"]="Wen" ["四"]="Thu" ["五"]="Fri" ["六"]="Sat" ["日"]="Sun")
# weekday=${weekdays[$(date +%a)]}
today=$(date +%d)
echo "周$(date +"%a$today,%H:%M") | font=Hack size=12 color=black"
# echo "<font size=2 face=Hack color=black>$(date +"$weekday$today&thinsp;%H:%M")</font>"

echo ---

bitbar="size=11 color=black font='Hack'"
echo " | $bitbar"

# chinese_cal=$(ccal -u | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" \
chinese_cal=$(ccal | sed -r "s/ /\&nbsp;/g" | awk 1 ORS="\\\\n" | sed -r "s/\x1B\[7m/<font color=\"blue\">/" \
            | sed -r "s/\x1B\[0m/<\/font>/")
echo "$chinese_cal| font='Hack' size=11 color=black"
