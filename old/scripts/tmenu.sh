#!/bin/bash

# , = reset search
# . = start program
# > = select next program
# < = select previous program
#
# Usage examples:
# Read programs from /usr/bin
#     tmenu.sh
#     tmenu.sh 0
#
# Read programs from the scripts "custom" variable
#      tmenu.sh 1
#
# Read programs from argument
#      tmenu.sh "firefox;chromium;epiphany"

search=""
programs=""
usecustom=false
custom="krita;gimp-2.10;inkscape"

if [ $# -eq 0 ] || [ $1 = "0" ]; then
    usecustom=false
elif [ $1 = "1" ]; then
    usecustom=true
else
    usecustom=true
    custom=$1
fi

custom=$(echo "$custom" | tr ";" "\n")

stop=false
num=0
while [ $stop = false ]; do
    clear
    if [ $usecustom = true ]; then
        programs=$(echo "$custom" | grep -i "$search")
    else
        programs=$(ls /usr/bin/ | grep -i "$search")
    fi
    p1=$(echo $programs | cut -d " " -f $(($num+1)))
    p2=$(echo $programs | cut -d " " -f $(($num+2)))
    p3=$(echo $programs | cut -d " " -f $(($num+3)))
    p4=$(echo $programs | cut -d " " -f $(($num+4)))
    p5=$(echo $programs | cut -d " " -f $(($num+5)))
    read -p "$search: $p1 $p2 $p3 $p4 $p5" -n1 char
    if [ $char = "." ]; then
        stop=true
        $p1 > /dev/null 2>&1 & disown
    elif [ $char = "," ]; then
        search=""
    elif [ $char = ">" ]; then
        num=$(($num+1))
    elif [ $char = "<" ]; then
        num=$(($num-1))
        if [ $num -eq -1 ]; then
            num=0
        fi
    else
        num=0
        search="$search$char"
    fi
done

exit 0
