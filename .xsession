export LC_ALL=en_US.UTF-8
xsetroot -solid '#171717' &
xterm -bg black -fg dodgerblue +sb -fa 'Source Code Pro Medium' -fs 16  -geometry 148x2+0--32 -class sttsbar -xrm 'XTerm.vt100.allowTitleOps: false' -T sttsbar -e sh -c 'sh /home/leo/.scripts/sttsbar.sh' &
#xterm -bg black -fg dodgerblue +sb -fa 'Source Code Pro Medium' -fs 12  -geometry 137x2+0--27 -class sttsbar -xrm 'XTerm.vt100.allowTitleOps: false' -T sttsbar -e ksh -c 'sh /home/leo/Scripts/sttsbar.sh' &
setxkbmap us -option 'caps:swapescape' &
# To get device name/props, use: xinput list -> xinput list-props [DEVICE NAME]
xinput set-prop 'ELAN0001:00 04F3:31AD Touchpad' 'libinput Tapping Enabled' 1 &
xinput set-prop 'ELAN0001:00 04F3:31AD Touchpad' 'libinput Natural Scrolling Enabled' 1 &
xinput set-prop 'ELAN0001:00 04F3:31AD Touchpad' 'libinput Disable While Typing Enabled' 0 &
xbacklight -set 50 &
xset b off &
xset b 0 0 0 &
parcellite &
flameshot &
mako &
/usr/bin/wireplumber &
/usr/bin/pipewire-pulse &
/usr/bin/pipewire &
rm -f $HOME/*core &
cwm
