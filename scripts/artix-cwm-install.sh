#!/bin/sh

read -p "What is the root password? (will echo): " rootpass
read -p "Install Xorg packages(and slock)? (Y/n): " xorg
read -p "Install parcellite? (y/N): " parcellite
mkdir -p $HOME/.pkgs

# Install needed packages
echo "$rootpass" | su -p -c "pacman -S git base-devel" root

# Install Xorg packages
if [ "$xorg" != "n" ] && [ "$xorg" != "N" ]; then
	echo "$rootpass" | su -p -c "pacman -S xorg-server xorg-xset xorg-xrandr xorg-xinput xorg-setxkbmap xorg-xinit xorg-xsetroot xterm slock" root
fi

# Setup xsession for LightDM
echo "$rootpass" | su -p -c "mkdir -p /usr/share/xsessions" root
echo "$rootpass" | su -p -c "printf '[Desktop Entry]\nName=Startx\nExec=dbus-run-session startx\n' > /usr/share/xsessions/startx.desktop" root
# Install CWM
rm -rf $HOME/.pkgs/cwm
echo "$rootpass" | su -p -c "rm -rf /usr/bin/cwm" root
cd $HOME/.pkgs
git clone https://github.com/leahneukirchen/cwm.git
cd $HOME/.pkgs/cwm
make
echo "$rootpass" | su -p -c "ln -s $HOME/.pkgs/cwm/cwm /usr/bin/cwm" root

# Install parcellite
if [ $parcellite = "y" ] ||  [ $parcellite = "Y" ]; then
	echo "$rootpass" | su -p -c "pacman -S xclip" root
	rm -rf $HOME/.pkgs/parcellite
	cd $HOME/.pkgs
	git clone https://gitlab.archlinux.org/archlinux/packaging/packages/parcellite.git
	cd $HOME/.pkgs/parcellite
	makepkg -sirc
fi

printf "\n
CWM is now installed and can be added to your \$HOME/.xsession

For example .cwmrc, .xsession or other config files, see:
https://github.com/AstronomyOverdrive/dot-files/
\n"

exit 0
