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
FISH_CONTENT='H4sIAAAAAAAAA5VVbW/bNhD+rl9xlbU43kArSdMNXZpgQeY0BvKGxB0W1IFBU5TEWiY1kvJLk/73HinbceJsxfzBIu+ee+Fzd2TjTTwUMh5SkwcNYNRCKgoOj5B9FSV+UMF/3QcyhZ0gMNwCmfEgECm8AabGYyoTIBO0MTlsHUGc8Eksq6I4AJtzGQD+OMsVhKcOYXJeFCAMSGVBSGNpUfCkDdcFxzBLSe0tFdrYdli7mAkLu0EqguDk6vK0+3Fw2j3vHIbR2dVFJ24zJVORxc4srtdttw5XaPz0Ope9w2jbHfDDB2h2rk6bAS0ENcAgNBxP8RWaJu7LfhTHTTz4nMpRuICU0wRR+A/EccJCR4A7A0azFNMGQmCRTKEYLRynEF0f9858/p63bAZO8G84LpMFwQj8q3v76fgcJmK8EHlOBiM+H6BFImRmaslEPBMGbgFkBFgDoIzx0hJaWWWqLOPGCiWRS84qizWsoReOda4t9FkKqdJTqhMyVTrZ1A+xGdjoPwD5E4DlVG8CilWE1/UjyIWxSs+J4VSznCz9bUK/vIQuPG8i9QpZap6K2Q8NKAx5JqREQolKSSEk3wRxwIJtqBOe0qqwMAGeCDtYTMhgWKUp10GQVpL5IkxzwXLfGnWD4bhpXkJY7yKqs0nd+UoDHQ71E8BtCPX99gy1dL2wXorjymg/4D6is3ymtvOSLySu/3AqglZQD2z0fHZCOHqSuenD6RqPEqHdSLxs6VendKWN69H6wXA21i4mIcvKIsDfT2H0RwitWrbdggcotZA2hZ8Mqrw0hINvwUiqqfT6tXsqjHbxIKtbyuHGdD7kHuctasjWFnhPyLsPhzgszeQ1nNevudw72tp1+MDiwAFxwN7Fp7891scCO65mUCiakLovgKyD/+zeXp8f33m8jwmzXKEStw9YttrFzPACiAAyhMfHpYwVeGMTp2EBxq9pGXDDaOkTR2vcHEa7uGjApQLJ3eXr06GF5jSZg6nKUmlrQNi2h708BVHupgyjh17n5qLRMExzLn/+5tN13sP+ztu3187ngVtFKHPfft916qJSoZOGLseCS1fWJddTBoTBsgPvsE1wBjGFmQWVAoIzm0OEX2i324C044tjx6VvKOyvzF3Lnz+7dKPb27PByXkXG8sxtJT0enfrW2y9y85Jr3t16aSRO9Lg+ubq483xBRD+D0wMUwmH+/vVczams8Pf9t+/38e1p8ZnQzJcoMqTUE/Pzu+LU+FrF21vg4c5c2i1YDhHW7BKYRvIDM+xtbdiZ1Ew8ETev9s7YAdrDOVYJceRj7Z6nR/BYhcl0OzrvmxCq09D91j+v3Fm+Vgl8MsM1sXBdy5NQmogCAAA'
COPY_LIST="
set fish shell; echo $FISH_CONTENT \| base64 -d \| gunzip \| bash
np.set_printoptions(suppress=True);np.set_printoptions\(suppress=True\)
tmux mouse 2.1; tmux set -g mouse on
cmake; cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..
docker remove cache; \"rm -r /root/.cache/pip && rm -rf /var/lib/apt/lists/*\"
strace open; \"strace -e trace=open,openat binary_file args 2>deps.txt\"
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
