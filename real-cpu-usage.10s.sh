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

IDLE=$(top -F -R -l2 | grep "CPU usage" | tail -1 | egrep -o '[0-9]{0,3}\.[0-9]{0,2}% idle' | sed 's/% idle//')

USED=$(echo "(100 - $IDLE) / 1" | bc)

echo "CPU: $USED%"
echo "---"
echo "Open Activity Monitor| bash='$0' param1=activitymonitor terminal=false"

# Hack for language not being set properly and unicode support
export LANG="${LANG:-en_US.UTF-8}"

# Max OS /bin/echo not support option -e
ECHO=/opt/homebrew/opt/coreutils/libexec/gnubin/echo
# Max OS /bin/head not support option -c -1
HEAD=/opt/homebrew/opt/coreutils/libexec/gnubin/head

# Write the list of Text you want enabled
# /Users/tal/office/android/DINet/app/src/main/cpp;/Users/tal/office/android/DINet/app/src/main/cpp
# /Users/tal/office/ios/dinet_project/DINet/DINet;/Users/tal/office/ios/dinet_project/DINet/DINet
COPY_LIST='
hzq_group;/mnt/cephfs/workspace/speech/hzq_group/projects
3w.xueersi.com!;3w.xueersi.com!
np.set_printoptions(suppress=True);np.set_printoptions\(suppress=True\)
tmux mouse 2.1; tmux set -g mouse on
cmake; cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
docker remove cache; "rm -r /root/.cache/pip && rm -rf /var/lib/apt/lists/*"
strace open; "strace -e trace=open,openat binary_file args 2>deps.txt"
'
# vscode settings.json 位置;/Users/tal/Library/Application\\\ Support/Code/User/settings.json
# vscode keybindings.json 位置;/Users/tal/Library/Application\\\ Support/Code/User/keybindings.json
# Karabiner-Elements;Karabiner-Elements
# 56;10.19.102.56
# 57;10.19.102.57

echo "---"
echo "📋"
echo "---"
while read -r line; do
  if ! [ "$line" == "" ]; then
    to_show=$(echo $line | cut -d ";" -f 1)
    to_copy=$(echo $line | cut -d ";" -f 2)
    echo "$to_show | bash='/bin/bash' param1='-c' param2='$ECHO -e $to_copy | $HEAD -c -1 | pbcopy' terminal=false"
  fi
done <<< "$COPY_LIST"

COPY_LIST='
10.202.0.54:3128
10.202.1.3:18000
10.202.196.9:3128
'
echo "---"
echo "bash proxy"
while read -r line; do
  if ! [ "$line" == "" ]; then
    echo "--$line | bash='/bin/bash' param1='-c' param2='$ECHO -e export http_proxy=http://$line \&\& export https_proxy=http://$line | $HEAD -c -1 | pbcopy' terminal=false"
  fi
done <<< "$COPY_LIST"

echo "fish proxy"
while read -r line; do
  if ! [ "$line" == "" ]; then
    echo "--$line | bash='/bin/bash' param1='-c' param2='$ECHO -e x http_proxy http://$line \&\& x https_proxy http://$line | $HEAD -c -1 | pbcopy' terminal=false"
  fi
done <<< "$COPY_LIST"

LIST="
command + \`           : 在当前桌面的同一个 App 的不同窗口切换
command + shift  + .   : finder 中显示隐藏文件
command + option + v   : finder 中剪切文件文件
command + option + 0   : VSCode 切换垂直/水平编辑器布局
ctrl    + option + ->  : 将 App 移动到屏幕下方
"
echo "---"
# echo "$line | font=IosevkaNerdFontMono-Regular"
while read -r line; do
  if ! [ "$line" == "" ]; then
    operation=$(echo $line | cut -d ":" -f 2)
    shortkeys=$(echo $line | cut -d ":" -f 1)
    echo $operation
    echo --$shortkeys
  fi
done <<< "$LIST"
