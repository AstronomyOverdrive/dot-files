export LC_ALL=en_US.UTF-8
xsetroot -solid "#171717" &
xterm -bg black -fg dodgerblue +sb -fa 'Source Code Pro Medium' -fs 12  -geometry 137x2+0--27 -class sttsbar -xrm 'XTerm.vt100.allowTitleOps: false' -T sttsbar -e ksh -c 'sh $HOME/Scripts/sttsbar.sh' &
setxkbmap -option "caps:swapescape" &
xbacklight -set 50 &
xset b off &
xset b 0 0 0 &
parcellite &
rm $HOME/*core &
#xconsole -bg black -fg white -saveLines 1 -geometry 1379X40-0--25 &
#i3
cwm

