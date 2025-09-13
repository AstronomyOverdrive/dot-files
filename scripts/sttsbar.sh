#!/bin/ksh

# Old version, used xconsole and was called with cron
#echo $(whoami)@$(hostname -s) \| $(apm -l)% \| $(date "+%d-%m-%Y | %H:%M") \| tskbar.sh > /dev/console

update=5
separator="|"
whitespace="" # Add how ever many spaces are needed here

while true
do
    workspace="[$(xprop -root _NET_CURRENT_DESKTOP | cut -c34-34)]"
    user="$(whoami)@$(hostname -s)"
    cputemp="CPU: $(sysctl hw.sensors.cpu0.temp0 | cut -c23-26)�C"
    battery="Bat: $(apm -l)%"
    ip=$(ifconfig athn0 | grep -w inet | cut -c7-18) # Replace athn0 with your adapter, you might also have to change cut to -c7-19
    date=$(date "+%d-%m-%Y")
    clock=$(date "+%H:%M")
    clear
    echo $user $workspace "$whitespace" $ip $separator $battery $separator $cputemp $separator $date $separator $clock $separator sttsbar.sh
    sleep $update
done

exit 0
