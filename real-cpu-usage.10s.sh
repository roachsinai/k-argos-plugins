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
    echo "--$line | bash='/bin/bash' param1='-c' param2='$ECHO -e \"for item in http_proxy https_proxy ftp_proxy all_proxy; set -gx \\\$item http://$line; end\" | $HEAD -c -1 | pbcopy' terminal=false"
  fi
done <<< "$COPY_LIST"
# "\""\\"\"""\"" gets "
# "\"" gets " in normal shell
echo "--reset | bash='/bin/bash' param1='-c' param2='$ECHO -e \"for item in http_proxy https_proxy ftp_proxy all_proxy; set -gx \\\$item "\""\\"\"""\"""\""\\"\"""\""; end\" | $HEAD -c -1 | pbcopy' terminal=false"

# /Users/tal/office/android/DINet/app/src/main/cpp;/Users/tal/office/android/DINet/app/src/main/cpp
# /Users/tal/office/ios/dinet_project/DINet/DINet;/Users/tal/office/ios/dinet_project/DINet/DINet
FISH_CONTENT='H4sIAAAAAAAAA7VWWXPbNhB+56/Y0KwltQPJTpx2Eh9Tj+NrxtfYSqYZy6OBQJBERYEsAepInP/eXZCi5SNN+1A9iMDuhz0+LBZYe9UbKd0bcZN4ayC4hUilEu4h/qJy/KBC/roFbAYbnmekBTaXnqcieAUim0y4DoFNcY1JYH0PeqGc9nSZpttgE6k9wJ8USQb+ESFMItMUlAGdWVDaWJ6mMuzCVSrRzVJSWYtUYWzXr0zMlYVNL1Ked3B5cXR6PDw6PTvc9YOTy/PDXldkOlJxj5b1qnGXxn6Dxk//8KK/G7QpwZ0daB1eHrU8nipuQIBvJGbxBVqmN9CDoNdrYeILrsd+DclnIaLwHxhxInwigHJAb5Zj2MAY1MGkmeApcQrB1X7/xMXveIvnQILv4aQOa4IR+On05uP+GUzVpBY5ToZjuRjiilDp2FSSqXok9GgAbAy4B8CFkLllvLSZKeNYGqsyjVxKUVrcwwp6TqzLwsJARBBlxYwXIZtlRfhcP8JiEON/ACQPAJHw4jkgbTy8rB9DoozNigUzkhciYUt7z6F/PoXWlp8jiwaZFzJS8x8u4DCSsdIaCWVZxFKl5XOQBNywZ+pQRrxMLUxBhsoO6xMyHJVRJAvPi0ot3CbMEiUSVxpVgeFxK2QOfjULeBFPq8rPCuCjUfEAoAnjrt4eoZam69VLca80hTvgziOtfKS2i1zWEld/TYBTjCTkVg5dN2AslEYUKne61qdaCQYpQrXDoJFyIrVtOdt4PiwWHLRFVmpbuegAk3/BxjY5psPjAKz2f7t55xbSr5C2LDQeeHf2Ma6mjTTQx9GKSfj2aZAHPBVlSlGef3gL1KechQQbHdisaV6i1ZxQl0b7ceZV4Eu6XF00YVaN7aPhsXxfhbBDa/b87yfS+EL0sJCGaqWNY1NOIKDFnZVcHzAvCqkRlUhg2IIWsGiT5k95KSRPnxJzjO5JnnObPPDyf1DivP87TpqAgvr6qVLBNu11vMpq8LiZ+7D3IKPrANv9ZByqgnr00x774rXRaHtVr//BbbG2clMqnZcWAe7C9IPffehUsnYHvkJeKG0j+Mmgykl92P7mjXU2006/cnH6wSYm0lybhJvwxUg6nFtRQdbXwVlCZpw7xOGmTF/COf2Kydd765uE96rzRsD++cc/HNb5Ajsp55BmPGRVowK2Cv5wenN1tv/Z4Z1PmCcZKnH6FfeuMjE3EgtNARvB/f1SJlJ8QjDSCA/9V7QMsRZ57gLH1TjZDagW1uAiAy3pNeDC4SmWRLgAU+Z5VlgDynYd7GkWLKOr2w++9g+vz9fWsNCl1D9/c+GSdX+w8ebNFdncplGAMvoOBlSS9U75JPUpxlRq2tYl1zMBTMCyAj9jmWDHwxDmFrIIEBxTyeIXut0uIO34BLKT3BUU1ldM74TbWwo3uLk5GR6cnWJhEUNLSb//eXWKpXdxeNA/vbwgaUApDa+uL4+v989d85wakYUS7u6a99WEz3d/23r3bgvHjhoXDYtxgCpHQnV6Nt7XWeHzK2i3wcFoOXQ6MFrgWuwBGZaBjjGP9dcNO/WGgSPy7u3rbbG9wlCCu0QcOW/Nc/EeLFZRCK1BMdAt6Ay4T6+3/3acRTLJQvhlDqti728/B/4xsQoAAA=='
COPY_LIST="
set fish shell; echo $FISH_CONTENT \| base64 -d \| gunzip \| bash
np.set_printoptions(suppress=True);np.set_printoptions\(suppress=True\)
tmux mouse 2.1; tmux set -g mouse on
cmake set compile mode; cmake -DCMAKE_BUILD_TYPE=Release ..
cmake grep compile mode;grep CMAKE_BUILD_TYPE CMakeCache.txt
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
