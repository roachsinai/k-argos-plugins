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

COPY_LIST='
10.202.0.54:3128
10.8.24.50:7880
10.202.196.9:3128
10.202.1.3:18000
'
echo "---"
echo "bash proxy"
while read -r line; do
  if ! [ "$line" == "" ]; then
    echo "--$line | bash='/bin/bash' param1='-c' param2='$ECHO -e \"for item in {http,https,ftp,all}_proxy; do export \\\$item=http://$line; done\" | $HEAD -c -1 | pbcopy' terminal=false"
  fi
done <<< "$COPY_LIST"
echo "--reset | bash='/bin/bash' param1='-c' param2='$ECHO -e \"for item in {http,https,ftp,all}_proxy; do export \\\$item="\""\\"\"""\"""\""\\"\"""\""; done\" | $HEAD -c -1 | pbcopy' terminal=false"

echo "fish proxy"
while read -r line; do
  if ! [ "$line" == "" ]; then
    echo "--$line | bash='/bin/bash' param1='-c' param2='$ECHO -e \"for item in {http,https,ftp,all}_proxy; set -gx \\\$item http://$line; end\" | $HEAD -c -1 | pbcopy' terminal=false"
  fi
done <<< "$COPY_LIST"
# "\""\\"\"""\"" gets "
# "\"" gets " in normal shell
echo "--reset | bash='/bin/bash' param1='-c' param2='$ECHO -e \"for item in {http,https,ftp,all}_proxy; set -gx \\\$item "\""\\"\"""\"""\""\\"\"""\""; end\" | $HEAD -c -1 | pbcopy' terminal=false"

COPY_LIST="
set Release mode; cmake -DCMAKE_BUILD_TYPE=Release ..
set RelWithDebInfo mode; cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
grep compile mode;grep CMAKE_BUILD_TYPE CMakeCache.txt
"
echo "cmake"
while read -r line; do
  if ! [ "$line" == "" ]; then
    to_show=$(echo $line | cut -d ";" -f 1)
    to_copy=$(echo $line | cut -d ";" -f 2)
    echo "--$to_show | bash='/bin/bash' param1='-c' param2='$ECHO -e $to_copy | $HEAD -c -1 | pbcopy' terminal=false"
  fi
done <<< "$COPY_LIST"

# /Users/tal/office/android/DINet/app/src/main/cpp;/Users/tal/office/android/DINet/app/src/main/cpp
# /Users/tal/office/ios/dinet_project/DINet/DINet;/Users/tal/office/ios/dinet_project/DINet/DINet
FISH_CONTENT='H4sIAHdElGgAA7VWbVPjNhD+7l+xZ1yStKMEOGjnjpcpwwXIDAEGwk1vCJNRZNlWY8uuJefl4P57V7JjAuF67YfmQyztPtqXR6uVNt51xkJ2xlRFzgYwqiEQMYcnCL+KDD+o4L/uApnBluMoroHMueOIAN4BS5OESh/IFNeoCDaPoOPzaUcWcbwPOuLSAfxxFqXgnhqEingcg1AgUw1CKk3jmPttuI45ullKSmuByJVuu6WJudCw7QTCcU6uLk97Z6PT3kX30PXOr/rdTpulMhBhxyzrlOO2Gbs1Gj+D7uXg0GuaBA8OoNG9Om04NBZUAQNXccziKzRUZyiHXqfTwMQXVE7cCpLNfEThP5BrVDHXEGByQG+aYthACFTBxCmjseEUvOvjwbmN3/IWzsEIvofj0q8IRuDn3u3d8QVMRVKJLCejCV+McIUvZKhKyVS8EDpmAGQCuAdAGeOZJrTQqSrCkCstUolcclZo3MMS2jes81zDkAUQpPmM5j6Zpbm/rh9jMbDJPwCiZwCLaL4OiGsPb+snEAml03xBFKc5i8jS3jr0z9fQyvI6Mq+RWc4DMf/hAgpjHgopkVCSBiQWkq+DOOCGral9HtAi1jAF7gs9qk7IaFwEAc8dJygks5swiwSLbGmUBYbHLecZuOXMo3k4LSs/zYGOx/kzwEwItfX2ArU0Xa1eijuFyu0Btx7Nyhdqvch4JbH1Vwc4xUh8qvnIdgNCfK5YLjKra3yulKCQIlRbDBopEi51w9rG86Gx4KDJ0kLq0kULCP8LtvaNY3N4LIBU/u+3H+xC88u5LnKJB96efYyrbiM19GW0LPH3Xgd5QmNWxCbK/qc9MH3KWoiw0YFO6+bFGvUJtWk0X2ZeBr6ky9ZFHWbZ2O4UDfnHMoQDs+bI/X4itS9Ej3KuTK00cayKBDyzuLWS6zPmTaFpRAUS6DegASTYNvPXvOScxq+JOUP3Rp5RHT3z8n9QYr3/O07qgLzq+ilTwTbttJzSqveymbtw9Cwz1wG2+2TiCzwe2VqPffPaqLWdstf/4LbYWLkphcwKjQB7Ybre7y60SlmzBY+Q5ULqAH5SqLJSF/a/OROZzqTVr1ycrreNidTXpsEldDHmFmdXlJDNTbCWkBnrDnG4KdO3cFa/YnLnaHPb4J3yvBngoH/3h8VaX6CTYg5xSn1SNiogq+BPvdvri+MvFm99wjxKUYnTR9y70sRccSw0AWQMT09LGYvxCUGMhjnov6RlhLVIMxs4rsbJoWdqYQMuU5DcvAZsODTGkvAXoIosS3OtQOi2hb3OgqTm6na9x0H3pr+xgYXOufz5mw3XWHeHW+/fXxub+2bkocx8h0NTktVOuUbqmhhjLs22LrmeMSAMlhX4BcsEOx6GMNeQBoDg0JQsfqHdbgPSjk8gnWS2oLC+QvNOuL834Xq3t+ejk4seFpZhaCkZDL6sTrH0Lrsng97VpZF6JqXR9c3V2c1x3zbPqWKpz+HhoX5fJXR++Nvuhw+7OLbU2GhIiANUWRLK07P1scoKn19eswkWZpZDqwXjBa7FHpBiGcgQ89jcqdmpNgwskQ97O/tsf4WhCHfJcGS91c/FJ9BYRT40hvlQNqA1pK55vf2348yiJPXhlzmsip2/AXGyrTmxCgAA'
COPY_LIST="
set fish shell; echo $FISH_CONTENT \| base64 -d \| gunzip \| bash
np.set_printoptions(suppress=True);np.set_printoptions\(suppress=True\)
tmux mouse 2.1; tmux set -g mouse on
docker remove cache; \"rm -r /root/.cache/pip && rm -rf /var/lib/apt/lists/*\"
strace open; \"strace -e trace=open,openat binary_file args 2>deps.txt\"
get container ID; \"basename \\\$(cat /proc/1/cpuset) | head -c 12 | c\"
"
# vscode settings.json 位置;/Users/tal/Library/Application\\\ Support/Code/User/settings.json
# vscode keybindings.json 位置;/Users/tal/Library/Application\\\ Support/Code/User/keybindings.json
# Karabiner-Elements;Karabiner-Elements

echo "---"
while read -r line; do
  if ! [ "$line" == "" ]; then
    to_show=$(echo $line | cut -d ";" -f 1)
    to_copy=$(echo $line | cut -d ";" -f 2)
    echo "$to_show | bash='/bin/bash' param1='-c' param2='$ECHO -e $to_copy | $HEAD -c -1 | pbcopy' terminal=false"
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
