alias pmi="doas pkg_add"
alias pmu="doas pkg_add -u"
alias pmr="doas pkg_delete"
alias pmc="doas pkg_delete -a -c"
alias getpatch="doas syspatch -c"
alias syspatch="doas syspatch"
alias wifi="doas sh /etc/netstart otus0"
alias sway="sh /usr/local/bin/startsway.sh"
alias ..="cd .."
alias :q="exit"

mkcd () {
    mkdir $1 && cd $1
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
