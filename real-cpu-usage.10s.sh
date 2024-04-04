#!/bin/bash
# https://unix.stackexchange.com/a/89843/232089
# https://unix.stackexchange.com/a/167059/232089
# https://stackoverflow.com/a/29903172/6074780
# https://xbarapp.com/docs/plugins/System/copy-to-clipboard.sh.html
# https://github.com/matryer/xbar-plugins/blob/main/System/clipboard-history.3s.sh

# <xbar.title>Real CPU Usage</xbar.title>
# <xbar.author>Mat Ryer and Tyler Bunnell</xbar.author>
# <xbar.author.github>matryer</xbar.author.github>
# <xbar.desc>Calcualtes and displays real CPU usage stats.</xbar.desc>
# <xbar.version>1.0</xbar.version>

if [ "$1" == "activitymonitor" ]; then
	open -a "Activity Monitor"
	exit
fi

IDLE=$(top -F -R -l3 | grep "CPU usage" | tail -1 | egrep -o '[0-9]{0,3}\.[0-9]{0,2}% idle' | sed 's/% idle//')

USED=$(echo "(100 - $IDLE) / 1" | bc)

echo "CPU: $USED%"
echo "---"
echo "Open Activity Monitor| bash='$0' param1=activitymonitor terminal=false"

# Hack for language not being set properly and unicode support
export LANG="${LANG:-en_US.UTF-8}"

# Write the list of Text you want enabled
COPY_LIST="
vscode settings.json 位置;/Users/tal/Library/Application\\\ Support/Code/User/settings.json
vscode keybindings.json 位置;/Users/tal/Library/Application\\\ Support/Code/User/keybindings.json
Karabiner-Elements;Karabiner-Elements

"
LIST="
command + \`           : 在当前桌面的同一个 App 的不同窗口切换
command + shift  + .   : finder 中显示隐藏文件
command + option + v   : finder 中剪切文件文件
command + option + 0   : VSCode 切换垂直/水平编辑器布局
ctrl    + option + ->  : 将 App 移动到屏幕下方
"

echo "---"
echo "📋"
echo "---"
while read -r line; do
  if ! [ "$line" == "" ]; then
    to_show=$(echo $line | cut -d ";" -f 1)
    to_copy=$(echo $line | cut -d ";" -f 2)
    echo "$to_show | bash='/bin/bash' param1='-c' param2='/bin/echo $to_copy | pbcopy' terminal=false"
  fi
done <<< "$COPY_LIST"
echo "---"
while read -r line; do
  if ! [ "$line" == "" ]; then
    echo "$line | font=IosevkaNerdFontMono-Regular"
  fi
done <<< "$LIST"
