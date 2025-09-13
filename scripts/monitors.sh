#!/bin/sh

sleep 1
xrandr --output DP-2 --mode 1920x1080 --rate 144 --primary
sleep 2
xrandr --output HDMI-0 --mode 1920x1080 --rate 60 --left-of DP-2

exit 0
