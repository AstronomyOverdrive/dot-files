alias pmi="doas pacman -S"
alias pmr="doas pacman -Rs"
alias pmu="doas paccache -rk1 && doas paccache -ruk0 && doas pacman -Syu"
alias lock="brightnessctl -s && brightnessctl s 0 && swaylock -i /usr/share/backgrounds/wallpaper.png && brightnessctl -r && exit"
alias se="sway input type:keyboard xkb_layout se"
alias us="sway input type:keyboard xkb_layout us"
alias ..="cd .."
alias :q="exit"
alias rss="newsboat"
alias tn="tmux"
alias ta="tmux attach"
export PS1="\e[0;35m\w\e[0m\e[1;35m>\e[0m "

ytrss () {
    echo http://www.youtube.com/feeds/videos.xml?channel_id=$(curl $1 | grep -m 1 -o /channel/[^\"]* | head -n 1 | cut -d "/" -f 3)
}

mkcd () {
    mkdir $1 && cd $1
}

swallow () {
    $@ > /dev/null 2>&1 & disown && exit
}

bright () {
    if test $1 -lt 101 && test $1 -gt -1; then
        max_bright=$(cat /sys/class/backlight/amdgpu_bl0/max_brightness)
        echo $(( $1 * $max_bright / 100 )) | doas tee -a /sys/class/backlight/amdgpu_bl0/brightness
    fi
}

hour=$(date +"%H")
if [ $hour -gt 3 ] && [ $hour -lt 11 ]; then
    time="morning"
elif [ $hour -gt 10 ] && [ $hour -lt 17 ]; then
    time="day"
elif [ $hour -gt 16 ] && [ $hour -lt 24 ]; then
    time="evening"
else
    time="night"
fi
user=$(whoami)
name=$(echo $user|cut -c1|tr [a-z] [A-Z])$(echo $user|cut -c2-)
printf "Good $time, $name!
 \e[1;34m      /\\\        \e[0m\e[1;35m _-----_     \e[0m\e[1;31m  _____    \e[0m\e[1;33m      _____      \e[0m\e[1;32m       .:'    \e[0m
 \e[1;34m     /  \\\       \e[0m\e[1;35m(       \\\    \e[0m\e[1;31m /  __ \\\   \e[0m\e[1;33m    \\\-     -/    \e[0m\e[1;32m    _ :'_     \e[0m
 \e[1;34m    /\`'.,\\\      \e[0m\e[1;35m\\\    0   \\\   \e[0m\e[1;31m|  /    |  \e[0m\e[1;33m \\\_/         \\\   \e[0m\e[1;32m .'\`_\`-'_\`\`.  \e[0m
 \e[1;34m   /     ',     \e[0m\e[1;35m \\\        )  \e[0m\e[1;31m|  \\\___-   \e[0m\e[1;33m |        O O |  \e[0m\e[1;33m:________.-'  \e[0m
 \e[1;34m  /      ,\`\\\    \e[0m\e[1;35m /      _/   \e[0m\e[1;31m-_         \e[0m\e[1;33m |_  <   )  3 )  \e[0m\e[1;31m:_______:     \e[0m
 \e[1;34m /   ,.'\`.  \\\   \e[0m\e[1;35m(     _-     \e[0m\e[1;31m  --_      \e[0m\e[1;33m / \\\         /   \e[0m\e[1;35m :_______\`-;  \e[0m
 \e[1;34m/.,'\`     \`'.\\\  \e[0m\e[1;35m\\\____-       \e[0m\e[1;31m Welcome   \e[0m\e[1;33m    /-_____-\\\    \e[0m\e[1;34m  \`._.-._.'   \e[0m
 $(date "+%d-%m-%Y, %H:%M")\n"
