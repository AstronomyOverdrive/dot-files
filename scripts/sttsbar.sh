#!/bin/sh

update=1
separator="|"
whitespace="" # Add however many spaces are needed here
system=$(uname)

tput civis
tput sc
while true
do
	date=$(date "+%d-%m-%Y")
	clock=$(date "+%H:%M")
	user="$(whoami)@$(hostname -s)"
	workspace="[$(xprop -root _NET_CURRENT_DESKTOP | sed -E 's/[^0-9]+//')]"
	if [ "$system" = "Linux" ]; then
		ipaddr=$(ip addr | grep 192.168.0.255 | cut -d " " -f 6 | cut -d "/" -f 1)
		bigtemp=$(cat /sys/class/thermal/thermal_zone*/temp 2> /dev/null | head -n1)
		cputemp="CPU: $((bigtemp/1000))°C"
		batinfo=$(upower -e | grep BAT | head -n1)
		batper=$(upower -i $batinfo | grep percentage | sed -E 's/[^0-9]+//' | sed -E 's/%//')
	elif [ "$system" = "OpenBSD" ]; then
		ipaddr=$(ifconfig | grep 192.168.0.255 | cut -d " " -f 2)
		cputemp="CPU: $(sysctl hw.sensors.cpu0.temp0 | cut -d "=" -f 2 | cut -d "." -f 1)°C"
		batper=$(apm -l)
	fi
	battery="Bat: $(echo "$batper  " | cut -c1-3)%" # Pad to prevent text shifting
	ip=$(echo "$ipaddr............." | cut -c1-13) # Pad, assumes max length of: 192.168.0.255
	display="$user $workspace $whitespace $ip $separator $battery $separator $cputemp $separator $date $separator $clock $separator sttsbar.sh"
	tput rc
	echo "$display"
	sleep $update
done
tput cvvis

exit 0
