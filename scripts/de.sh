#!/bin/sh

choose () {
    printf "What DE do you want to start?\n1 = i3(default)\n2 = XFCE\n3 = Cinnamon\n4 = GNOME\n5 = KDE\n"
    read -p "Choose: " launch
    start $launch
}

start () {
    if [ $# -eq 0 ] || [ $1 = "1" ]; then
        exec startx /usr/bin/i3
    elif [ $1 = "2" ]; then
        exec startx /usr/bin/startxfce4
    elif [ $1 = "3" ]; then
        exec startx /usr/bin/cinnamon-session
    elif [ $1 = "4" ]; then
        export XDG_SESSION_TYPE=x11
        export GDK_BACKEND=x11
        exec startx /usr/bin/gnome-session
    elif [ $1 = "5" ]; then
        exec startx /usr/bin/startplasma-x11
    else
        clear
        printf "Invalid choice!\n\n"
        choose
    fi
}

clear

choose

exit 0
