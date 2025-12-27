#!/bin/sh

read -p "What is the root password? (linux only, will echo): " rootpass
mkdir -p $HOME/.pkgs
system=$(uname)

# Install needed packages
if [ "$system" = "Linux" ]; then
	echo "$rootpass" | su -p -c "pacman -S git base-devel" root
elif [ "$system" = "OpenBSD" ]; then
	doas pkg_add git
fi

# Prepare st
rm -rf $HOME/.pkgs/st
cd $HOME/.pkgs
git clone https://git.suckless.org/st
cd $HOME/.pkgs/st
cp config.def.h config.h

# Set font
original=$(grep "static char \*font" config.h | cut -d "\"" -f 2)
ogfont=$(echo $original | cut -d ":" -f 1)
ogsize=$(echo $original | cut -d ":" -f 2)
sed -i "s/$ogfont/Source Code Pro Medium/g" config.h
sed -i "s/$ogsize/pixelsize=24/g" config.h

# Set colours
colours='
[0] = "#171717",
[1] = "#C75A4C",
[2] = "#3F9E3F",
[3] = "#FA8916",
[4] = "#01C0FB",
[5] = "#D47FD4",
[6] = "#8EDBD7",
[7] = "#E5E5E5",
[8] = "#7F7F7F",
[9] = "#FF0000",
[10] = "#00FF00",
[11] = "#FFFF00",
[12] = "#5C5CFF",
[13] = "#FF00FF",
[14] = "#00FFFF",
[15] = "#EBEBEB",
[255] = 0,
[256] = "#EBEBEB",
[257] = "#171717",
[258] = "#EBEBEB",
[259] = "#171717",
'
toln=$(grep -n "8 normal colors" config.h | cut -d ":" -f 1)
filehead=$(head -n$((toln-1)) config.h)
fromln=$(grep -n "default background colour" config.h | cut -d ":" -f 1)
filetail=$(tail -n+$((fromln+1)) config.h)
# Will cause errors on OpenBSD
if [ "$system" = "Linux" ]; then
	echo "$filehead$colours$filetail" > config.h
fi

# Install st
if [ "$system" = "Linux" ]; then
	echo "$rootpass" | su -p -c "make clean install" root
elif [ "$system" = "OpenBSD" ]; then
	lrt=$(grep -n "lrt" config.mk | cut -d ":" -f 1)
	sed -i -e "$((lrt))s/^/#/" config.mk
	sed -i -e "$((lrt+1))s/^/#/" config.mk
	sed -i -e "$((lrt+2))s/^/#/" config.mk
	line=$(grep -n "OpenBSD" config.mk | cut -d ":" -f 1)
	sed -i "$((line+1))s/#//" config.mk
	sed -i "$((line+2))s/#//" config.mk
	sed -i "$((line+3))s/#//" config.mk
	sed -i "$((line+4))s/#//" config.mk
	sed -i "$((line+5))s/#//" config.mk
	doas make clean install
	printf "\n\nOpenBSD install detected, st compiled without custom colours.\n"
fi

exit 0
